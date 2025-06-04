---
<<<<<<< Updated upstream
<<<<<<< Updated upstream
title: Configure mutual authentication on Azure Application Gateway through PowerShell
description: Learn how to configure an Application Gateway to have mutual authentication through PowerShell
services: application-gateway
author: greg-lindsay
ms.service: azure-application-gateway
ms.topic: how-to
ms.date: 02/18/2022
ms.author: greglin 
ms.custom: devx-track-azurepowershell
---

# Configure mutual authentication strict mode with Application Gateway through PowerShell
This article describes how to use the PowerShell to configure mutual authenticationstrict mode on your Application Gateway. Mutual authentication means Application Gateway authenticates the client sending the request using the client certificate you upload onto the Application Gateway. 

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

[!INCLUDE [updated-for-az](~/reusable-content/ce-skilling/azure/includes/updated-for-az.md)]

This article requires the Azure PowerShell module version 1.0.0 or later. Run `Get-Module -ListAvailable Az` to find the version. If you need to upgrade, see [Install Azure PowerShell module](/powershell/azure/install-azure-powershell). If you're running PowerShell locally, you also need to run `Login-AzAccount` to create a connection with Azure.

## Before you begin

To configure mutual authentication with an Application Gateway, you need a client certificate to upload to the gateway. The client certificate will be used to validate the certificate the client will present to Application Gateway. For testing purposes, you can use a self-signed certificate. However, this is not advised for production workloads, because they're harder to manage and aren't completely secure.

To learn more, especially about what kind of client certificates you can upload, see [Overview of mutual authentication with Application Gateway](./mutual-authentication-overview.md#certificates-supported-for-mutual-authentication).

## Create a resource group

First create a new resource group in your subscription. 

```azurepowershell
$resourceGroup = New-AzResourceGroup -Name $rgname -Location $location -Tags @{ testtag = "APPGw tag"}
```
## Create a virtual network

Deploy a virtual network for your Application Gateway to be deployed in.

```azurepowershell
$gwSubnet = New-AzVirtualNetworkSubnetConfig -Name $gwSubnetName -AddressPrefix 10.0.0.0/24
$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgname -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $gwSubnet
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgname
$gwSubnet = Get-AzVirtualNetworkSubnetConfig -Name $gwSubnetName -VirtualNetwork $vnet
```

## Create a public IP

Create a public IP to use with your Application Gateway. 

```azurepowershell
$publicip = New-AzPublicIpAddress -ResourceGroupName $rgname -name $publicIpName -location $location -AllocationMethod Static -sku Standard
```

## Create the Application Gateway IP configuration

Create the IP configurations and frontend port. 

```azurepowershell
$gipconfig = New-AzApplicationGatewayIPConfiguration -Name $gipconfigname -Subnet $gwSubnet
$fipconfig = New-AzApplicationGatewayFrontendIPConfig -Name $fipconfigName -PublicIPAddress $publicip
$port = New-AzApplicationGatewayFrontendPort -Name $frontendPortName  -Port 443
```

## Configure frontend SSL 

Configure the SSL certificates for your Application Gateway.

```azurepowershell
$password = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
$sslCertPath = $basedir + "/ScenarioTests/Data/ApplicationGatewaySslCert1.pfx"
$sslCert = New-AzApplicationGatewaySslCertificate -Name $sslCertName -CertificateFile $sslCertPath -Password $password
```

## Configure client authentication 

Configure client authentication on your Application Gateway. For more information on how to extract trusted client CA certificate chains to use here, see [how to extract trusted client CA certificate chains](./mutual-authentication-certificate-management.md).

> [!IMPORTANT]
> Please ensure that you upload the entire client CA certificate chain in one file, and only one chain per file.  

> [!NOTE]
> We recommend using TLS 1.2 with mutual authentication as TLS 1.2 will be mandated in the future. 

```azurepowershell
$clientCertFilePath = $basedir + "/ScenarioTests/Data/TrustedClientCertificate.cer"
$trustedClient01 = New-AzApplicationGatewayTrustedClientCertificate -Name $trustedClientCert01Name -CertificateFile $clientCertFilePath
$sslPolicy = New-AzApplicationGatewaySslPolicy -PolicyType Predefined -PolicyName "AppGwSslPolicy20170401S"
$clientAuthConfig = New-AzApplicationGatewayClientAuthConfiguration -VerifyClientCertIssuerDN
$sslProfile01 = New-AzApplicationGatewaySslProfile -Name $sslProfile01Name -SslPolicy $sslPolicy -ClientAuthConfiguration $clientAuthConfig -TrustedClientCertificates $trustedClient01
$listener = New-AzApplicationGatewayHttpListener -Name $listenerName -Protocol Https -SslCertificate $sslCert -FrontendIPConfiguration $fipconfig -FrontendPort $port -SslProfile $sslProfile01
```

## Configure the backend pool and settings

Set up backend pool and settings for your Application Gateway. Optionally, set up the backend trusted root certificate for end-to-end SSL encryption.  

```azurepowershell
$certFilePath = $basedir + "/ScenarioTests/Data/ApplicationGatewayAuthCert.cer"
$trustedRoot = New-AzApplicationGatewayTrustedRootCertificate -Name $trustedRootCertName -CertificateFile $certFilePath
$pool = New-AzApplicationGatewayBackendAddressPool -Name $poolName -BackendIPAddresses www.microsoft.com, www.bing.com
$poolSetting = New-AzApplicationGatewayBackendHttpSettings -Name $poolSettingName -Port 443 -Protocol Https -CookieBasedAffinity Enabled -PickHostNameFromBackendAddress -TrustedRootCertificate $trustedRoot
```

## Configure the rule

Set up a rule on your Application Gateway.

```azurepowershell
$rule = New-AzApplicationGatewayRequestRoutingRule -Name $ruleName -RuleType basic -BackendHttpSettings $poolSetting -HttpListener $listener -BackendAddressPool $pool
```

## Set up default SSL policy for future listeners

You've set up a listener specific SSL policy while setting up mutual authentication. In this step, you can optionally set the default SSL policy for future listeners you create. 

```azurepowershell
$sslPolicyGlobal = New-AzApplicationGatewaySslPolicy -PolicyType Predefined -PolicyName "AppGwSslPolicy20170401"
```

## Create the Application Gateway

Using everything we created above, deploy your Application Gateway.

```azurepowershell
$sku = New-AzApplicationGatewaySku -Name Standard_v2 -Tier Standard_v2
$appgw = New-AzApplicationGateway -Name $appgwName -ResourceGroupName $rgname -Zone 1,2 -Location $location -BackendAddressPools $pool -BackendHttpSettingsCollection $poolSetting -FrontendIpConfigurations $fipconfig -GatewayIpConfigurations $gipconfig -FrontendPorts $port -HttpListeners $listener -RequestRoutingRules $rule -Sku $sku -SslPolicy $sslPolicyGlobal -TrustedRootCertificate $trustedRoot -AutoscaleConfiguration $autoscaleConfig -TrustedClientCertificates $trustedClient01 -SslProfiles $sslProfile01 -SslCertificates $sslCert
```

## Clean up resources

When no longer needed, remove the resource group, application gateway, and all related resources using [Remove-AzResourceGroup](/powershell/module/az.resources/remove-azresourcegroup).

```azurepowershell
Remove-AzResourceGroup -Name $rgname
```
=======
=======
>>>>>>> Stashed changes
title: Configure mutual authentication passthrough on Azure Application Gateway through arm
description: Learn how to configure an Application Gateway to have mutual authentication through arm
services: application-gateway
author: Rajesh Nautiyal
ms.service: azure-application-gateway
ms.topic: how-to
ms.date: 06-04-25
ms.author: rnautiyal
---

# Configure mutual authentication with Application Gateway through portal 

This article describes how to use the Azure portal to configure mutual authentication on your Application Gateway. Mutual authentication means Application Gateway authenticates the client sending the request using the client certificate you upload onto the Application Gateway. 

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

## Before you begin

To configure mutual authentication with an Application Gateway, you need a client certificate to upload to the gateway. The client certificate will be used to validate the certificate the client will present to Application Gateway. For testing purposes, you can use a self-signed certificate. However, this is not advised for production workloads, because they're harder to manage and aren't completely secure. 

To learn more, especially about what kind of client certificates you can upload, see [Overview of mutual authentication with Application Gateway](./mutual-authentication-overview.md#certificates-supported-for-mutual-authentication).

## Create a new Application Gateway

First create a new Application Gateway as you would usually through the portal - there are no additional steps needed in the creation to enable mutual authentication. For more information on how to create an Application Gateway in portal, check out our [portal quickstart tutorial](./quick-create-portal.md).

## Configure mutual authentication 

To configure an existing Application Gateway with mutual authentication, you'll need to first go to the **SSL settings** tab in the Portal and create a new SSL profile. When you create an SSL profile, you'll see two tabs: **Client Authentication** and **SSL Policy**. The **Client Authentication** tab is where you'll upload your client certificate(s). The **SSL Policy** tab is to configure a listener specific SSL policy - for more information, check out [Configuring a listener specific SSL policy](./application-gateway-configure-listener-specific-ssl-policy.md).

> [!IMPORTANT]
> Please ensure that you upload the entire client CA certificate chain in one file, and only one chain per file.

1. Search for **Application Gateway** in portal, select **Application gateways**, and click on your existing Application Gateway.

2. Select **SSL settings** from the left-side menu.

3. Click on the plus sign next to **SSL Profiles** at the top to create a new SSL profile.

4. Enter a name under **SSL Profile Name**. In this example, we call our SSL profile *applicationGatewaySSLProfile*. 

5. Stay in the **Client Authentication** tab. Upload the PEM certificate you intend to use for mutual authentication between the client and the Application Gateway using the **Upload a new certificate** button. 

    For more information on how to extract trusted client CA certificate chains to upload here, see [how to extract trusted client CA certificate chains](./mutual-authentication-certificate-management.md).

   > [!NOTE]
   > If this isn't your first SSL profile and you've uploaded other client certificates onto your Application Gateway, you can choose to reuse an existing certificate on your gateway through the dropdown menu. 

6. Check the **Verify client certificate issuer's DN** box only if you want Application Gateway to verify the client certificate's immediate issuer Distinguished Name. 

7. Consider adding a listener specific policy. See instructions at [setting up listener specific SSL policies](./application-gateway-configure-listener-specific-ssl-policy.md).

8. Select **Add** to save.
    > [!div class="mx-imgBorder"]
    > ![Add client authentication to SSL profile](./media/mutual-authentication-portal/mutual-authentication-portal.png)

## Associate the SSL profile with a listener

Now that we've created an SSL profile with mutual authentication configured, we need to associate the SSL profile to the listener to complete the set up of mutual authentication. 

1. Navigate to your existing Application Gateway. If you just completed the steps above, you don't need to do anything here. 

2. Select **Listeners** from the left-side menu. 

3. Click on **Add listener** if you don't already have an HTTPS listener set up. If you already have an HTTPS listener, click on it from the list. 

4. Fill out the **Listener name**, **Frontend IP**, **Port**, **Protocol**, and other **HTTPS Settings** to fit your requirements.

5. Check the **Enable SSL Profile** checkbox so that you can select which SSL Profile to associate with the listener. 

6. Select the SSL profile you just created from the dropdown list. In this example, we choose the SSL profile we created from the earlier steps: *applicationGatewaySSLProfile*. 

7. Continue configuring the remainder of the listener to fit your requirements. 

8. Click **Add** to save your new listener with the SSL profile associated to it. 

    > [!div class="mx-imgBorder"]
    > ![Associate SSL profile to new listener](./media/mutual-authentication-portal/mutual-authentication-listener-portal.png)
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

## Renew expired client CA certificates

In the case that your client CA certificate has expired, you can update the certificate on your gateway through the following steps: 

<<<<<<< Updated upstream
<<<<<<< Updated upstream
1. Sign in to Azure
    ```azurepowershell
    Connect-AzAccount
    Select-AzSubscription -Subscription "<sub name>"
    ```
2. Get your Application Gateway configuration
    ```azurepowershell
    $gateway = Get-AzApplicationGateway -Name "<gateway-name>" -ResourceGroupName "<resource-group-name>"
    ```
3. Remove the trusted client certificate from the gateway 
    ```azurepowershell
    Remove-AzApplicationGatewayTrustedClientCertificate -Name "<name-of-client-certificate>" -ApplicationGateway $gateway
    ``` 
4. Add the new certificate onto the gateway 
    ```azurepowershell
    Add-AzApplicationGatewayTrustedClientCertificate -ApplicationGateway $gateway -Name "<name-of-new-cert>" -CertificateFile "<path-to-certificate-file>"
    ```
5. Update the gateway with the new certificate 
    ```azurepowershell
    Set-AzApplicationGateway -ApplicationGateway $gateway
    ```
=======
=======
>>>>>>> Stashed changes
1. Navigate to your Application Gateway and go to the **SSL settings** tab in the left-hand menu. 
 
1. Select the existing SSL profile(s) with the expired client certificate. 
 
1. Select **Upload a new certificate** in the **Client Authentication** tab and upload your new client certificate. 
 
1. Select the trash can icon next to the expired certificate. This will remove the association of that certificate from the SSL profile. 

1. Repeat steps 2-4 above with any other SSL profile that was using the same expired client certificate. You will be able to choose the new certificate you uploaded in step 3 from the dropdown menu in other SSL profiles.
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

## Next steps

- [Manage web traffic with an application gateway using the Azure CLI](./tutorial-manage-web-traffic-cli.md)
