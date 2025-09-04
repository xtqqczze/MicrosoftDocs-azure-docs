---
title: Create a Standard V2 Azure NAT Gateway
titlesuffix: Azure NAT Gateway
description: This quickstart shows how to create a Standard V2 NAT gateway by using the Azure portal.
author: asudbring
ms.author: allensu
ms.service: azure-nat-gateway
ms.topic: quickstart 
ms.date: 08/12/2025
ms.custom: template-quickstart, FY23 content-maintenance, linux-related-content
# Customer intent: As a cloud engineer, I want to create a NAT gateway using various deployment methods, so that I can facilitate outbound internet connectivity for virtual machines in Azure.
---

# Quickstart: Create a Standard V2 NAT gateway

In this quickstart, learn how to create a Standard V2 NAT gateway by using the Azure portal, PowerShell. The NAT Gateway service provides scalable outbound connectivity for virtual machines in Azure.

> [!NOTE]
> Azure CLI is currently unavailable for this quickstart.

## Prerequisites

### [Portal](#tab/portal)

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).

### [PowerShell](#tab/powershell)

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).

- Azure Cloud Shell or Azure PowerShell.

  The steps in this quickstart run the Azure PowerShell cmdlets interactively in [Azure Cloud Shell](/azure/cloud-shell/overview). To run the commands in the Cloud Shell, select **Open Cloud Shell** at the upper-right corner of a code block. Select **Copy** to copy the code and then paste it into Cloud Shell to run it. You can also run the Cloud Shell from within the Azure portal.

  You can also [install Azure PowerShell locally](/powershell/azure/install-azure-powershell) to run the cmdlets. The steps in this article require Azure PowerShell module version 5.4.1 or later. Run `Get-Module -ListAvailable Az` to find your installed version. If you need to upgrade, see [Update the Azure PowerShell module](/powershell/azure/install-Az-ps#update-the-azure-powershell-module).

---

## Create a resource group

Create a resource group to contain all resources for this quickstart.

### [Portal](#tab/portal)

1. In the search box at the top of the portal enter **Resource group**. Select **Resource groups** in the search results.

1. Select **+ Create**.

1. In the **Basics** tab of **Create a resource group**, enter or select the following information.

    | Setting | Value |
    | ------- | ----- |
    | Subscription | Select your subscription|
    | Resource group | test-rg |
    | Region | East US |

1. Select **Review + create**.

1. Select **Create**.

### [PowerShell](#tab/powershell)

Create a resource group with [New-AzResourceGroup](/powershell/module/az.resources/new-azresourcegroup). An Azure resource group is a logical container into which Azure resources are deployed and managed.

The following example creates a resource group named **test-rg** in the **eastus** location:

```azurepowershell-interactive
$rsg = @{
    Name = 'test-rg'
    Location = 'eastus'
}
New-AzResourceGroup @rsg
```

---

## Create the NAT gateway

In this section, create the NAT gateway and supporting resources.

Azure NAT Gateway supports multiple deployment options for IP addresses and redundancy configurations to meet your connectivity and availability requirements.

- [Zone redundant IPv4 address](#zone-redundant-ipv4-address)
- [Zone redundant IPv4 prefix](#zone-redundant-ipv4-prefix)
- [Zone redundant virtual network level](#zone-redundant-virtual-network-level)

### Zone redundant IPv4 address

### [Portal](#tab/portal)

1. In the search box at the top of the portal enter **Public IP address**. Select **Public IP addresses** in the search results.

1. Select **+ Create**.



### [PowerShell](#tab/powershell)

Use [New-AzPublicIpAddress](/powershell/module/az.network/new-azpublicipaddress) to create a zone redundant IPv4 public IP address for the NAT gateway.

```azurepowershell-interactive
## Create public IP address for NAT gateway ##
$ip = @{
    Name = 'public-ip-nat'
    ResourceGroupName = 'test-rg'
    Location = 'eastus'
    Sku = 'StandardV2'
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
    Zone = 1,2,3
}
$publicIPIPv4 = New-AzPublicIpAddress @ip
```

Use [New-AzNatGateway](/powershell/module/az.network/new-aznatgateway) to create the NAT gateway resource.

```azurepowershell
## Create NAT gateway resource ##
$nat = @{
    ResourceGroupName = 'test-rg'
    Name = 'nat-gateway'
    IdleTimeoutInMinutes = '4'
    Sku = 'StandardV2'
    Location = 'eastus'
    PublicIpAddress = $publicIPIPv4
    Zone = 1,2,3
}
$natGateway = New-AzNatGateway @nat
```

---

### Zone redundant IPv4 prefix

### [Portal](#tab/portal)

### [PowerShell](#tab/powershell)

Use [New-AzPublicIpPrefix](/powershell/module/az.network/new-azpublicipprefix) to create a zone redundant IPv4 public IP prefix for the NAT gateway.

```azurepowershell
## Create public IP prefix for NAT gateway ##
$ip = @{
    Name = 'public-ip-prefix-nat'
    ResourceGroupName = 'test-rg'
    Location = 'eastus'
    Sku = 'StandardV2'
    PrefixLength = `31`
    IpAddressVersion = 'IPv4'
    Zone = 1,2,3
}
$publicIPIPv4prefix = New-AzPublicIpPrefix @ip
```

Use [New-AzNatGateway](/powershell/module/az.network/new-aznatgateway) to create the NAT gateway resource.

```azurepowershell
## Create NAT gateway resource ##
$nat = @{
    ResourceGroupName = 'test-rg'
    Name = 'nat-gateway'
    IdleTimeoutInMinutes = '4'
    Sku = 'StandardV2'
    Location = 'eastus'
    PublicIpPrefix = $publicIPIPv4prefix
    Zone = 1,2,3
}
$natGateway = New-AzNatGateway @nat
```

---

#### Zone redundant virtual network level

Standard V2 NAT Gateway has a feature that allows you to associate the NAT gateway resource with a virtual network instead of the subnet level. Each subnet contained within the virtual network can then use the NAT gateway for outbound internet connectivity.

Create a public IP address or prefix to your preference from the previous steps, then proceed to create the NAT gateway.

### [Portal](#tab/portal)

### [PowerShell](#tab/powershell)

Use [New-AzVirtualNetworkSubnetConfig](/powershell/module/az.network/new-azvirtualnetworksubnetconfig) to create the subnet configurations. Use [New-AzVirtualNetwork](/powershell/module/az.network/new-azvirtualnetwork) to create the virtual network.

```azurepowershell
## Create subnet config ##
$subnet = @{
    Name = 'subnet-1'
    AddressPrefix = '10.0.0.0/24'
}
$subnetConfig = New-AzVirtualNetworkSubnetConfig @subnet 

## Create Azure Bastion subnet ##
$bastsubnet = @{
    Name = 'AzureBastionSubnet' 
    AddressPrefix = '10.0.1.0/26'
}
$bastsubnetConfig = New-AzVirtualNetworkSubnetConfig @bastsubnet

## Create the virtual network ##
$net = @{
    Name = 'vnet-1'
    ResourceGroupName = 'test-rg'
    Location = 'eastus'
    AddressPrefix = '10.0.0.0/16'
    Subnet = $subnetConfig,$bastsubnetConfig
}
$vnet = New-AzVirtualNetwork @net
```

Use [New-AzNatGateway](/powershell/module/az.network/new-aznatgateway) to create the NAT gateway resource.

```azurepowershell
## Create NAT gateway resource ##
$nat = @{
    ResourceGroupName = 'test-rg'
    Name = 'nat-gateway'
    IdleTimeoutInMinutes = '4'
    Sku = 'StandardV2'
    Location = 'eastus'
    SourceVirtualNetwork = $vnet
    Zone = 1,2,3
}
$natGateway = New-AzNatGateway @nat
```

---

## Create virtual network and subnet configurations

Create the virtual network and subnets needed for this quickstart. You can skip this section if you created a network level NAT gateway from the previous step.

### [Portal](#tab/portal)

Continue with the portal steps from the first section. The virtual network creation is included in the portal include file.

### [PowerShell](#tab/powershell)

Use [New-AzVirtualNetworkSubnetConfig](/powershell/module/az.network/new-azvirtualnetworksubnetconfig) to create the subnet configurations. Use [New-AzVirtualNetwork](/powershell/module/az.network/new-azvirtualnetwork) to create the virtual network.

```azurepowershell
## Create subnet config and associate NAT gateway to subnet ##
$subnet = @{
    Name = 'subnet-1'
    AddressPrefix = '10.0.0.0/24'
    NatGateway = $natGateway
}
$subnetConfig = New-AzVirtualNetworkSubnetConfig @subnet 

## Create Azure Bastion subnet ##
$bastsubnet = @{
    Name = 'AzureBastionSubnet' 
    AddressPrefix = '10.0.1.0/26'
}
$bastsubnetConfig = New-AzVirtualNetworkSubnetConfig @bastsubnet

## Create the virtual network ##
$net = @{
    Name = 'vnet-1'
    ResourceGroupName = 'test-rg'
    Location = 'eastus'
    AddressPrefix = '10.0.0.0/16'
    Subnet = $subnetConfig,$bastsubnetConfig
}
$vnet = New-AzVirtualNetwork @net
```

---

## Create Azure Bastion host

Create an Azure Bastion host to securely connect to the virtual machine.

### [Portal](#tab/portal)

Continue with the portal steps from the first section. The Azure Bastion creation is included in the portal include file.

### [PowerShell](#tab/powershell)

Use [New-AzBastion](/powershell/module/az.network/new-azbastion) to create the Azure Bastion host.

```azurepowershell
## Create public IP address for bastion host ##
$ip = @{
    Name = 'public-ip-bastion'
    ResourceGroupName = 'test-rg'
    Location = 'eastus'
    Sku = 'Standard'
    AllocationMethod = 'Static'
    Zone = 1,2,3
}
$publicipbastion = New-AzPublicIpAddress @ip

## Create bastion host ##
$bastion = @{
    Name = 'bastion'
    ResourceGroupName = 'test-rg'
    PublicIpAddressRgName = 'test-rg'
    PublicIpAddressName = 'public-ip-bastion'
    VirtualNetworkRgName = 'test-rg'
    VirtualNetworkName = 'vnet-1'
    Sku = 'Basic'
}
New-AzBastion @bastion
```

---

The bastion host can take several minutes to deploy. Wait for the bastion host to deploy before moving on to the next section.

## Create virtual machine

In this section, you create a virtual machine to test the NAT gateway and verify the public IP address of the outbound connection. The following command creates SSH keys for authentication. The private key is needed later to sign in to the virtual machine through Azure Bastion. The username and password credential is required for the command. The password isn't used to sign in to the virtual machine.

### [Portal](#tab/portal)

[!INCLUDE [create-test-virtual-machine-linux.md](~/reusable-content/ce-skilling/azure/includes/create-test-virtual-machine-linux.md)]

### [PowerShell](#tab/powershell)

Use [Get-Credential](/powershell/module/microsoft.powershell.security/get-credential) to create a username and password for the virtual machine. Use [New-AzNetworkInterface](/powershell/module/az.network/new-aznetworkinterface) to create a network interface for the virtual machine. Use [New-AzVMConfig](/powershell/module/az.compute/new-azvmconfig) to create the virtual machine configuration. Use [New-AzVM](/powershell/module/az.compute/new-azvm) to create the virtual machine.

```azurepowershell-interactive
## Get credentials for virtual machine ##
$cred = Get-Credential

## Create network interface for virtual machine ##
$nic = @{
    Name = "nic-1"
    ResourceGroupName = 'test-rg'
    Location = 'eastus'
    Subnet = $vnet.Subnets[0]
}
$nicVM = New-AzNetworkInterface @nic

## Create a virtual machine configuration ##
$vmsz = @{
    VMName = 'vm-1'
    VMSize = 'Standard_DS1_v2'  
}
$vmos = @{
    ComputerName = 'vm-1'
    Credential = $cred
    DisablePasswordAuthentication = $true
}
$vmimage = @{
    PublisherName = 'Canonical'
    Offer = '0001-com-ubuntu-server-jammy'
    Skus = '22_04-lts-gen2'
    Version = 'latest'     
}
$vmConfig = New-AzVMConfig @vmsz `
    | Set-AzVMOperatingSystem @vmos -Linux `
    | Set-AzVMSourceImage @vmimage `
    | Add-AzVMNetworkInterface -Id $nicVM.Id

## Create the virtual machine ##
$vm = @{
    ResourceGroupName = 'test-rg'
    Location = 'eastus'
    VM = $vmConfig
    SshKeyName = 'ssh-key'
}
New-AzVM @vm -GenerateSshKey
```

---

Wait for the virtual machine creation to complete before moving on to the next section.

> [!IMPORTANT]
> Ensure that you download the SSH private key to the virtual machine. You need the private key to sign in to the virtual machine through Azure Bastion.


## Test NAT gateway

In this section, you test the NAT gateway. You first discover the public IP of the NAT gateway. You then connect to the test virtual machine and verify the outbound connection through the NAT gateway public IP.
    
1. In the search box at the top of the portal, enter **NAT gateway**. Select **NAT gateways** in the search results.

1. Select **nat-gateway**.

1. Expand **Settings**, then select **Outbound IP**.

1. Make note of the IP address deployed for the outbound IP address. Individual Public IPs and Public IP Prefixes configured for the NAT gateway are listed here.

1. In the search box at the top of the portal, enter **Virtual machine**. Select **Virtual machines** in the search results.

1. Select **vm-1**.

1. On the **Overview** page, select **Connect**, then select **Connect via Bastion**.

1. In the **Authentication** pull-down, select **SSH Private Key From Local File**.

1. In **Username**, enter the username you entered during virtual machine creation.

1. In **Local File**, select the SSH private key file you downloaded earlier.

1. Select **Connect**.

1. In the bash prompt, enter the following command:

    ```bash
    curl ifconfig.me
    ```
    
1. Verify the IP address returned by the command matches the public IP address of the NAT gateway you noted earlier.

    ```output
    azureuser@vm-1:~$ curl ifconfig.me
    203.0.113.0.25
    ```

## Clean up resources

### [Portal](#tab/portal)

[!INCLUDE [portal-clean-up.md](~/reusable-content/ce-skilling/azure/includes/portal-clean-up.md)]

### [PowerShell](#tab/powershell)

If you're not going to continue to use this application, delete the virtual network, virtual machine, and NAT gateway with the following command:

```azurepowershell-interactive
Remove-AzResourceGroup -Name 'test-rg' -Force
```

---

## Next steps

For more information on Azure NAT Gateway, see:
> [!div class="nextstepaction"]
> [Azure NAT Gateway overview](nat-overview.md)
> [Azure NAT Gateway resource](nat-gateway-resource.md)
