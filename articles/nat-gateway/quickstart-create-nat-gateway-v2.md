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

In this quickstart, learn how to create a Standard V2 NAT gateway by using the Azure portal, Azure CLI, and PowerShell. The NAT Gateway service provides scalable outbound connectivity for virtual machines in Azure.

:::image type="content" source="./media/quickstart-create-nat-gateway-portal/nat-gateway-qs-resources.png" alt-text="Diagram of resources created in nat gateway quickstart." lightbox="./media/quickstart-create-nat-gateway-portal/nat-gateway-qs-resources.png":::

## Prerequisites

### [Portal](#tab/portal)

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).

### [PowerShell](#tab/powershell)

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).

- Azure Cloud Shell or Azure PowerShell.

  The steps in this quickstart run the Azure PowerShell cmdlets interactively in [Azure Cloud Shell](/azure/cloud-shell/overview). To run the commands in the Cloud Shell, select **Open Cloud Shell** at the upper-right corner of a code block. Select **Copy** to copy the code and then paste it into Cloud Shell to run it. You can also run the Cloud Shell from within the Azure portal.

  You can also [install Azure PowerShell locally](/powershell/azure/install-azure-powershell) to run the cmdlets. The steps in this article require Azure PowerShell module version 5.4.1 or later. Run `Get-Module -ListAvailable Az` to find your installed version. If you need to upgrade, see [Update the Azure PowerShell module](/powershell/azure/install-Az-ps#update-the-azure-powershell-module).

### [CLI](#tab/cli)

[!INCLUDE [quickstarts-free-trial-note](~/reusable-content/ce-skilling/azure/includes/quickstarts-free-trial-note.md)]

[!INCLUDE [azure-cli-prepare-your-environment-no-header.md](~/reusable-content/azure-cli/azure-cli-prepare-your-environment-no-header.md)]

---

## Create a resource group

Create a resource group to contain all resources for this quickstart.

### [Portal](#tab/portal)

1. In the search box at the top of the portal enter **Resource group**. Select **Resource groups** in the search results.

1. Select **+ Create**.

1. In the **Create a resource group** page, enter a name for the resource group (for example, **test-rg**) and select a region (for example, **East US**).

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

### [CLI](#tab/cli)

Create a resource group with [az group create](/cli/azure/group#az-group-create). An Azure resource group is a logical container into which Azure resources are deployed and managed.

```azurecli-interactive
az group create \
    --name test-rg \
    --location eastus
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

### [CLI](#tab/cli)

### Create public IP address

To access the internet, you need one or more public IP addresses for the NAT gateway. Use [az network public-ip create](/cli/azure/network/public-ip#az-network-public-ip-create) to create a public IP address resource.

```azurecli-interactive
az network public-ip create \
    --resource-group test-rg \
    --name public-ip-nat \
    --sku StandardV2 \
    --allocation-method Static \
    --location eastus \
    --zone 1 2 3
```

### Create NAT gateway resource

Create a NAT gateway resource using [az network nat gateway create](/cli/azure/network/nat#az-network-nat-gateway-create). The NAT gateway uses the public IP address created in the previous steps. The idle time-out is set to 10 minutes.

```azurecli-interactive
az network nat gateway create \
    --resource-group test-rg \
    --name nat-gateway \
    --public-ip-addresses public-ip-nat \
    --idle-timeout 10
    --zones 1 2 3
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

### [CLI](#tab/cli)

Use [az network public-ip prefix create](/cli/azure/network/public-ip/prefix#az-network-public-ip-prefix-create) to create a public IP prefix resource.

```azurecli-interactive
az network public-ip prefix create \
    --resource-group test-rg \
    --name public-ip-prefix-nat \
    --location eastus \
    --prefix-length 31 \
    --sku StandardV2 \
    --zone 1 2 3
```

Use [az network nat gateway create](/cli/azure/network/nat#az-network-nat-gateway-create) to create the NAT gateway resource.

```azurecli-interactive
az network nat gateway create \
    --resource-group test-rg \
    --name nat-gateway \
    --public-ip-prefixes public-ip-prefix-nat \
    --idle-timeout 10
    --zones 1 2 3
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

### [CLI](#tab/cli)

Create a virtual network named **vnet-1** with a subnet named **subnet-1** using [az network vnet create](/cli/azure/network/vnet#az-network-vnet-create). The IP address space for the virtual network is **10.0.0.0/16**. The subnet within the virtual network is **10.0.0.0/24**.

```azurecli-interactive
az network vnet create \
    --resource-group test-rg \
    --name vnet-1 \
    --address-prefix 10.0.0.0/16 \
    --subnet-name subnet-1 \
    --subnet-prefixes 10.0.0.0/24
```

Create an Azure Bastion subnet named **AzureBastionSubnet** using [az network vnet subnet create](/cli/azure/network/vnet/subnet#az-network-vnet-subnet-create):

```azurecli-interactive
az network vnet subnet create \
    --name AzureBastionSubnet \
    --resource-group test-rg \
    --vnet-name vnet-1 \
    --address-prefix 10.0.1.0/26
```

Create a NAT gateway resource using [az network nat gateway create](/cli/azure/network/nat#az-network-nat-gateway-create). The NAT gateway uses the public IP address or public IP prefix created in the previous steps. The idle time-out is set to 10 minutes.

#### Public IP

```azurecli-interactive
az network nat gateway create \
    --resource-group test-rg \
    --name nat-gateway \
    --public-ip-addresses public-ip-nat \
    --idle-timeout 10
    --zones 1 2 3
``` 

#### Public IP Prefix

```azurecli-interactive
az network nat gateway create \
    --resource-group test-rg \
    --name nat-gateway \
    --public-ip-prefixes public-ip-prefix-nat \
    --idle-timeout 10
    --zones 1 2 3
```

Associate the NAT gateway to the subnet using [az network vnet subnet update](/cli/azure/network/vnet/subnet#az-network-vnet-subnet-update):

```azurecli-interactive
az network vnet subnet update \
    --resource-group test-rg \
    --vnet-name vnet-1 \
    --name subnet-1 \
    --nat-gateway nat-gateway \
    --source-vnet vnet-1 \
    --zone 1 2 3
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

### [CLI](#tab/cli)

Create a virtual network named **vnet-1** with a subnet named **subnet-1** using [az network vnet create](/cli/azure/network/vnet#az-network-vnet-create). The IP address space for the virtual network is **10.0.0.0/16**. The subnet within the virtual network is **10.0.0.0/24**.

```azurecli-interactive
az network vnet create \
    --resource-group test-rg \
    --name vnet-1 \
    --address-prefix 10.0.0.0/16 \
    --subnet-name subnet-1 \
    --subnet-prefixes 10.0.0.0/24
```

Create an Azure Bastion subnet named **AzureBastionSubnet** using [az network vnet subnet create](/cli/azure/network/vnet/subnet#az-network-vnet-subnet-create):

```azurecli-interactive
az network vnet subnet create \
    --name AzureBastionSubnet \
    --resource-group test-rg \
    --vnet-name vnet-1 \
    --address-prefix 10.0.1.0/26
```

Associate the NAT gateway to the subnet using [az network vnet subnet update](/cli/azure/network/vnet/subnet#az-network-vnet-subnet-update):

```azurecli-interactive
az network vnet subnet update \
    --resource-group test-rg \
    --vnet-name vnet-1 \
    --name subnet-1 \
    --nat-gateway nat-gateway
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

### [CLI](#tab/cli)

Create a public IP address for the Bastion host using [az network public-ip create](/cli/azure/network/public-ip#az-network-public-ip-create):

```azurecli-interactive
az network public-ip create \
    --resource-group test-rg \
    --name public-ip \
    --sku Standard \
    --location eastus \
    --zone 1 2 3
```

Create the Azure Bastion host using [az network bastion create](/cli/azure/network/bastion#az-network-bastion-create):

```azurecli-interactive
az network bastion create \
    --name bastion \
    --public-ip-address public-ip \
    --resource-group test-rg \
    --vnet-name vnet-1 \
    --location eastus \
    --sku Developer
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

### [CLI](#tab/cli)

Use [az vm create](/cli/azure/vm#az-vm-create) to create a virtual machine named **vm-1** in the resource group **test-rg**. The virtual machine is created in the subnet **subnet-1** of the virtual network **vnet-1**. The command also creates SSH keys for authentication. The private key is needed later to sign in to the virtual machine through Azure Bastion. The username credential is required for the command. The password isn't used to sign in to the virtual machine.

```azurecli-interactive
az vm create \
    --resource-group test-rg \
    --name vm-1 \
    --image Ubuntu2204 \
    --admin-username azureuser \
    --authentication-type ssh \
    --generate-ssh-keys \
    --public-ip-address "" \
    --subnet subnet-1 \
    --vnet-name vnet-1
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

### [CLI](#tab/cli)

If you're not going to continue to use this application, delete the virtual network, virtual machine, and NAT gateway with the following command:

```azurecli-interactive
az group delete \
    --name test-rg \
    --yes
```

---

## Next steps

For more information on Azure NAT Gateway, see:
> [!div class="nextstepaction"]
> [Azure NAT Gateway overview](nat-overview.md)
> [Azure NAT Gateway resource](nat-gateway-resource.md)
