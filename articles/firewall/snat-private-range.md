---
title: Azure Firewall SNAT private IP address ranges
description: You can configure IP address ranges for SNAT. 
services: firewall
author: duongau
ms.service: azure-firewall
ms.topic: how-to
ms.date: 03/17/2025
ms.author: duau
ms.custom: devx-track-azurepowershell, devx-track-azurecli, devx-track-arm-template
# Customer intent: "As a network administrator, I want to configure SNAT private IP address ranges in Azure Firewall, so that I can control how outbound traffic is translated to public IP addresses and optimize security for my network setup."
---

# Azure Firewall SNAT private IP address ranges

Azure Firewall provides SNAT capability for all outbound traffic to public IP addresses. By default, Azure Firewall doesn't SNAT with Network rules when the destination IP address is in a private IP address range per [IANA RFC 1918](https://tools.ietf.org/html/rfc1918) or shared address space per [IANA RFC 6598](https://tools.ietf.org/html/rfc6598). Application rules are always SNATed using a [transparent proxy](https://wikipedia.org/wiki/Proxy_server#Transparent_proxy) regardless of the destination IP address.

This default behavior is suitable when routing traffic directly to the Internet. However, there are scenarios where you may need to override the default SNAT behavior:

- If you've enabled [forced tunneling](forced-tunneling.md), Internet-bound traffic is SNATed to one of the firewall's private IP addresses in AzureFirewallSubnet, hiding the source from your on-premises firewall.
- If your organization uses registered IP address ranges outside of IANA RFC 1918 or IANA RFC 6598 for private networks, Azure Firewall SNATs the traffic to one of the firewall's private IP addresses in AzureFirewallSubnet. You can configure Azure Firewall to **not** SNAT your public IP address range. For example, specify an individual IP address as `x.x.x.x` or a range of IP addresses as `x.x.x.x/24`.

You can change Azure Firewall SNAT behavior in the following ways:

- To configure Azure Firewall to **never** SNAT traffic processed by network rules regardless of the destination IP address, use **0.0.0.0/0** as your private IP address range. With this configuration, Azure Firewall can't route traffic directly to the Internet.
- To configure the firewall to **always** SNAT traffic processed by network rules regardless of the destination address, use **255.255.255.255/32** as your private IP address range.
- Azure Firewall can be configured to [autolearn](#auto-learn-snat-routes-preview) registered and private ranges every hour and use the learned routes for SNAT. This preview capability requires [Azure Route Server](../route-server/overview.md) deployed in the same virtual network as the Azure Firewall.

> [!IMPORTANT]
> - The private address range configuration only applies to network rules. Application rules always SNAT.
> - If you want to specify your own private IP address ranges and keep the default IANA RFC 1918 address ranges, ensure your custom list still includes the IANA RFC 1918 range.

You can configure the SNAT private IP addresses using the following methods. Use the method appropriate for your configuration. Firewalls associated with a firewall policy must specify the range in the policy and not use `AdditionalProperties`.

| Method            | Using classic rules  | Using firewall policy  |
|-------------------|----------------------|------------------------|
| Azure portal      | [supported](#classic-rules-3) | [supported](#firewall-policy-1) |
| Azure PowerShell  | [configure `PrivateRange`](#classic-rules) | currently unsupported |
| Azure CLI         | [configure `--private-ranges`](#classic-rules-1) | currently unsupported |
| ARM template      | [configure `AdditionalProperties` in firewall property](#classic-rules-2) | [configure `snat/privateRanges` in firewall policy](#firewall-policy) |


## Configure SNAT private IP address ranges - Azure PowerShell

### Classic rules

You can use Azure PowerShell to specify private IP address ranges for the firewall.

> [!NOTE]
> The firewall `PrivateRange` property is ignored for firewalls associated with a Firewall Policy. You must use the `SNAT` property in `firewallPolicies` as described in [Configure SNAT private IP address ranges - ARM template](#firewall-policy).

#### New firewall

For a new firewall using classic rules, use the following Azure PowerShell cmdlet:

```azurepowershell
$azFw = @{
   Name               = '<fw-name>'
   ResourceGroupName  = '<resourcegroup-name>'
   Location           = '<location>'
   VirtualNetworkName = '<vnet-name>'
   PublicIpName       = '<public-ip-name>'
   PrivateRange       = @("IANAPrivateRanges", "192.168.1.0/24", "192.168.1.10")
}

New-AzFirewall @azFw
```

> [!NOTE]
> - Deploying Azure Firewall using `New-AzFirewall` requires an existing virtual network and Public IP address. See [Deploy and configure Azure Firewall using Azure PowerShell](deploy-ps.md) for a full deployment guide.
> - `IANAPrivateRanges` is expanded to the current defaults on Azure Firewall while the other ranges are added to it. To keep the `IANAPrivateRanges` default in your private range specification, it must remain in your `PrivateRange` specification as shown in the example.

For more information, see [New-AzFirewall](/powershell/module/az.network/new-azfirewall).

#### Existing firewall

To configure an existing firewall using classic rules, use the following Azure PowerShell cmdlets:

```azurepowershell
$azfw = Get-AzFirewall -Name '<fw-name>' -ResourceGroupName '<resourcegroup-name>'
$azfw.PrivateRange = @("IANAPrivateRanges", "192.168.1.0/24", "192.168.1.10")
Set-AzFirewall -AzureFirewall $azfw
```

## Configure SNAT private IP address ranges - Azure CLI

### Classic rules

You can use Azure CLI to specify private IP address ranges for the firewall using classic rules.

#### New firewall

For a new firewall using classic rules, use the following Azure CLI command:

```azurecli-interactive
az network firewall create \
-n <fw-name> \
-g <resourcegroup-name> \
--private-ranges 192.168.1.0/24 192.168.1.10 IANAPrivateRanges
```

> [!NOTE]
> - Deploying Azure Firewall using the Azure CLI command `az network firewall create` requires extra configuration steps to create public IP addresses and IP configuration. See [Deploy and configure Azure Firewall using Azure CLI](deploy-cli.md) for a full deployment guide.
> - `IANAPrivateRanges` is expanded to the current defaults on Azure Firewall while the other ranges are added to it. To keep the `IANAPrivateRanges` default in your private range specification, it must remain in your `private-ranges` specification as shown in the example.

#### Existing firewall

To configure an existing firewall using classic rules, use the following Azure CLI command:

```azurecli-interactive
az network firewall update \
-n <fw-name> \
-g <resourcegroup-name> \
--private-ranges 192.168.1.0/24 192.168.1.10 IANAPrivateRanges
```

## Configure SNAT private IP address ranges - ARM template

### Classic rules

To configure SNAT during ARM Template deployment, add the following to the `additionalProperties` property:

```json
"additionalProperties": {
   "Network.SNAT.PrivateRanges": "IANAPrivateRanges, IPRange1, IPRange2"
},
```
### Firewall policy

Azure Firewalls associated with a firewall policy supports SNAT private ranges since API version 2020-11-01. You can use a template to update the SNAT private range on the Firewall Policy. The following sample configures the firewall to **always** SNAT network traffic:

```json
{
   "type": "Microsoft.Network/firewallPolicies",
   "apiVersion": "2020-11-01",
   "name": "[parameters('firewallPolicies_DatabasePolicy_name')]",
   "location": "eastus",
   "properties": {
      "sku": {
         "tier": "Standard"
      },
      "snat": {
         "privateRanges": "[255.255.255.255/32]"
      }
   }
}
```

## Configure SNAT private IP address ranges - Azure portal

### Classic rules

You can use the Azure portal to specify private IP address ranges for the firewall.

1. Select your resource group, and then select your firewall.
2. On the **Overview** page, **Private IP Ranges**, select the default value **IANA RFC 1918**.

   The **Edit Private IP Prefixes** page opens:

3. By default, **IANAPrivateRanges** is configured.
4. Edit the private IP address ranges for your environment and then select **Save**.

### Firewall policy

1. Select your resource group, and then select your firewall policy.
2. Select **Private IP ranges (SNAT)** in the **Settings** column.
3. Select the conditions to perform SNAT for your environment under **Perform SNAT** to customize the SNAT configuration.
4. Select **Apply**.

## Auto-learn SNAT routes (preview)

You can configure Azure Firewall to autolearn both registered and private ranges every 30 minutes. These learned address ranges are considered to be internal to the network, so traffic to destinations in the learned ranges isn't SNATed. Auto-learn SNAT ranges requires Azure Route Server to be deployed in the same virtual network as the Azure Firewall. The firewall must be associated with the Azure Route Server and configured to autolearn SNAT ranges in the Azure Firewall Policy. You can currently use an ARM template, Azure PowerShell, or the Azure portal to configure autolearn SNAT routes.

> [!NOTE]
> Auto-learn SNAT routes is available only on virtual network deployments (hub virtual network). It isn't available on VWAN deployments (secured virtual hub). For more information about Azure Firewall architecture options, see [What are the Azure Firewall Manager architecture options?](../firewall-manager/vhubs-and-vnets.md)

### Configure using an ARM template

You can use the following JSON to configure autolearn. Azure Firewall must be associated with an Azure Route Server.

```json
{
   "type": "Microsoft.Network/firewallPolicies",
   "apiVersion": "2022-11-01",
   "name": "[parameters('firewallPolicies_DatabasePolicy_name')]",
   "location": "eastus",
   "properties": {
      "sku": {
         "tier": "Standard"
      },
      "snat": {
         "autoLearnPrivateRanges": "Enabled"
      }
   }
}
```

Use the following JSON to associate an Azure Route Server:

```json
{
   "type": "Microsoft.Network/azureFirewalls",
   "apiVersion": "2022-11-01",
   "name": "[parameters('azureFirewalls_testFW_name')]",
   "location": "eastus",
   "properties": {
      "sku": {
         "name": "AZFW_VNet",
         "tier": "Standard"
      },
      "threatIntelMode": "Alert",
      "additionalProperties": {
         "Network.RouteServerInfo.RouteServerID": "[parameters('virtualHubs_TestRouteServer_externalid')]"
      }
   }
}
```

### Configure using Azure PowerShell

- Create a new firewall with a RouteServerId.

   ```azurepowershell
   # specify RouteServerId Uri
   $routeServerId="/subscriptions/your_sub/resourceGroups/testRG/providers/Microsoft.Network/virtualHubs/TestRS"
 
   # Create AzureFirewall 
   $azureFirewall = New-AzFirewall -Name $azureFirewallName -ResourceGroupName `
    $rgname -Location $location -RouteServerId $routeServerId 

   # Get firewall and confirm if RouteServerId is included on the response under additional properties (Network.RouteServerInfo.RouteServerID) 
   Get-AzFirewall -Name $azureFirewallName -ResourceGroupName $rgname 
   ```

- Update an existing firewall with RouteServerId

   ```azurepowershell
   # specify RouteServerId Uri 
   $routeServerId="/subscriptions/your_sub/resourceGroups/testRG/providers/Microsoft.Network/virtualHubs/TestRS"
 
   # Get firewall 
   $azFirewall = Get-AzFirewall -Name $azureFirewallName -ResourceGroupName $rgname 
       
   # Update the response with RouteServerId and do firewall SET 
   $azFirewall.RouteServerId = $routeServerId 
   Set-AzFirewall -AzureFirewall $azFirewall

   # Do firewall Get and confirm if routeServerId is updated 
   Get-AzFirewall -Name $azureFirewallName -ResourceGroupName $rgname
   ```

- Create new firewall policy with SNAT parameter provided

   ```azurepowershell
   # If AutoLearnPrivateRange parameter is provided, auto learn will be enabled, if not it will be disabled 
   $snat = New-AzFirewallPolicySnat -PrivateRange $privateRange -AutoLearnPrivateRange

   # Create AzureFirewallPolicy (with SNAT) 
   $azureFirewallPolicy = New-AzFirewallPolicy -Name $azureFirewallPolicyName `
    -ResourceGroupName $rgname -Location $location -Snat $snat

   # Get AzureFirewallPolicy and verify 
   Get-AzFirewallPolicy -Name $azureFirewallPolicyName -ResourceGroupName $rgname 
   ```

- Update an existing firewall policy with SNAT

   ```azurepowershell
   $snat = New-AzFirewallPolicySnat -PrivateRange $privateRange2 
   
   # Set AzureFirewallPolicy 
   $azureFirewallPolicy.Snat = $snat 
   Set-AzFirewallPolicy -InputObject $azureFirewallPolicy 
         
   # Do Get and Verify 
   Get-AzFirewallPolicy -Name $azureFirewallPolicyName -ResourceGroupName $rgname 
   ```

- Get Firewall Learned Prefixes

   ```azurepowershell
   Get-AzFirewallLearnedIpPrefix -Name $azureFirewallName -ResourceGroupName $rgname 
   ```

### Configure using the Azure portal

To configure autolearn SNAT routes (preview) using the Azure portal, follow these steps:

1. **Add a subnet**:
   - Add a subnet named **RouteServerSubnet** to your existing firewall virtual network.
   - Ensure the subnet size is at least /27.

2. **Deploy a Route Server**:
   - Deploy a Route Server into the existing firewall virtual network.
   - For detailed steps, see [Quickstart: Create and configure Route Server using the Azure portal](../route-server/quickstart-configure-route-server-portal.md).

3. **Associate the Route Server**:
   - On the firewall's **Learned SNAT IP Prefixes (preview)** page, add the route server.

4. **Modify firewall policy**:
   - Enable **Auto-learn IP prefixes (preview)** in the **Private IP ranges (SNAT)** section of your firewall policy.

5. **View learned routes**:
   - Check the learned routes on the **Learned SNAT IP Prefixes (preview)** page.

## Next steps

- Learn about [Azure Firewall forced tunneling](forced-tunneling.md).
