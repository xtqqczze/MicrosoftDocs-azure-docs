---
title: Configure Private Link Service Direct Connect
author: altheapm
contributors:
ms.topic: concept-article
ms.date: 07/08/2025
ms.author: altheabata
ms.reviewer: altheabata
---
# Configure Private Link Service Direct Connect

Customers can now connect any IP-based targets to Private Link Service
without needing to use a standard load balancer.

Azure Private Link Service allows service providers to make their
applications available to their customers privately and securely. The
current setup procedure requires service providers to configure their
private link service and place their applications behind a standard
internal load balancer. Private Link Service Direct Connect removes this
limitation and allows customers to directly connect a private link
service to any IP based target.

Note: This feature is currently in public preview and available in
select regions. We recommend reviewing all considerations before
enabling it for your subscription

### Prerequisites

- An active Azure account with a subscription. [Create an account for free](https://azure.microsoft.com/free/).

- Feature flag Microsoft.Network/AllowPrivateLinkServiceUDR enabled in
  current subscription, see [Enable Azure preview
  features](https://learn.microsoft.com/azure/azure-resource-manager/management/preview-features).

- A virtual network with a subnet

- A routable IP address to set as the destination IP address

### Enable Private Link Service Direct Connect

# [PowerShell](#tab/powershell)

Use the following script to create a Private Link Service with destination IP using Azure PowerShell:

```powershell
# Define variables
$resourceGroupName = "rg-pls-destinationip"
$location = "East US"
$vnetName = "pls-vnet"
$subnetName = "pls-subnet"
$plsName = "pls-with-destinationip"
$destinationIP = "10.0.1.100"

# Create resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create virtual network (corrected parameter name)
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.1.0/24" -PrivateLinkServiceNetworkPoliciesFlag "Disabled"
$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix "10.0.0.0/16" -Subnet $subnet

# Get subnet reference
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName

# Create IP configurations for Private Link Service (minimum 3 required for destination IP)
$ipConfig1 = @{
    Name = "ipconfig1"
    PrivateIpAllocationMethod = "Dynamic"
    Subnet = $subnet
    Primary = $true
}

$ipConfig2 = @{
    Name = "ipconfig2"
    PrivateIpAllocationMethod = "Dynamic"
    Subnet = $subnet
    Primary = $false
}

$ipConfig3 = @{
    Name = "ipconfig3"
    PrivateIpAllocationMethod = "Dynamic"
    Subnet = $subnet
    Primary = $false
}

# Create Private Link Service with destination IP
$pls = New-AzPrivateLinkService `
    -Name $plsName `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -IpConfiguration @($ipConfig1, $ipConfig2, $ipConfig3) `
    -DestinationIPAddress $destinationIP

Write-Output "Private Link Service created successfully!"
Write-Output "Private Link Service ID: $($pls.Id)"
Write-Output "Destination IP Address: $destinationIP"
```

# [Azure CLI](#tab/cli)

Use the following script to create a Private Link Service with destination IP using Azure CLI:

```azurecli
# Define variables
resourceGroupName="rg-pls-destinationip"
location="eastus"
vnetName="pls-vnet"
subnetName="pls-subnet"
plsName="pls-with-destinationip"
destinationIP="10.0.1.100"

# Create resource group
az group create --name $resourceGroupName --location $location

# Create virtual network and subnet
az network vnet create \
    --resource-group $resourceGroupName \
    --name $vnetName \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $subnetName \
    --subnet-prefix 10.0.1.0/24

# Disable Private Link Service network policies on subnet
az network vnet subnet update \
    --resource-group $resourceGroupName \
    --vnet-name $vnetName \
    --name $subnetName \
    --disable-private-link-service-network-policies true

# Create Private Link Service with destination IP
az network private-link-service create \
    --resource-group $resourceGroupName \
    --name $plsName \
    --vnet-name $vnetName \
    --subnet $subnetName \
    --lb-frontend-ip-configs ipconfig1 ipconfig2 ipconfig3 \
    --destination-ip-address $destinationIP \
    --location $location

echo "Private Link Service created successfully!"
echo "Destination IP Address: $destinationIP"
```

# [Terraform](#tab/terraform)

Use the following Terraform configuration to create a Private Link Service with destination IP:

```hcl
# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a random pet name for unique resource naming
resource "random_pet" "rg_name" {
  prefix = "rg"
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg_name.id
  location = "East US"
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${random_pet.rg_name.id}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create subnet for Private Link Service
resource "azurerm_subnet" "pls_subnet" {
  name                 = "pls-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  # Required for Private Link Service with destination IP
  private_link_service_network_policies_enabled = false
}

# Create Private Link Service with destination IP
resource "azurerm_private_link_service" "pls" {
  name                = "${random_pet.rg_name.id}-pls"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Destination IP address for direct routing
  destination_ip_address = "10.0.1.100"

  # Minimum 3 IP configurations required for destination IP
  nat_ip_configuration {
    name     = "ipconfig1"
    primary  = true
    subnet_id = azurerm_subnet.pls_subnet.id
  }

  nat_ip_configuration {
    name     = "ipconfig2"
    primary  = false
    subnet_id = azurerm_subnet.pls_subnet.id
  }

  nat_ip_configuration {
    name     = "ipconfig3"
    primary  = false
    subnet_id = azurerm_subnet.pls_subnet.id
  }
}

# Output the Private Link Service details
output "private_link_service_id" {
  description = "ID of the Private Link Service"
  value       = azurerm_private_link_service.pls.id
}

output "private_link_service_alias" {
  description = "Alias of the Private Link Service"
  value       = azurerm_private_link_service.pls.alias
}

output "destination_ip_address" {
  description = "Destination IP address"
  value       = azurerm_private_link_service.pls.destination_ip_address
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}
```

---

### Validate Configuration

- Portal

  - In the Resource JSON pane, select the latest API version

  - Validate that the “destinationIPAddress” is correct

- PowerShell

  - Use Private Link Get Commands and verify that the destination IP
    address is correct, and the IP Configuration has a provisioning
    state of “Succeeded”

### Limitations

| Limit | Description |
|-------|-------------|
| Only Static IP is supported | Dynamically changing IPs as a destination target aren't supported with this feature |
| Using this feature requires the deployment of a new Private Link Service | Migration of existing private link services is not supported |
| This feature currently requires that the source private endpoint and the private link service must both be in the same region | This restriction will be removed when the feature is generally available |
| Currently available in limited regions | West Central US<br>UK South<br>East Asia<br>East US |

## PLS Direct Connect Integration

Private Link Service Direct Connect allows you to privately and securely
connect a private link service to any destination IP address. This
article describes configuration scenarios.

### PLS Direct Connect scenarios

There are various ways to utilize this feature, such as:

1. External SaaS connectivity to on-premises

1. Secure access to resources hosted by 3P providers

1. VNet integration

### External SaaS Connectivity to On-premises

Application Gateway can be used to control access to 3P SaaS Provider
connectivity to customer environment. Customer VNET is exposed to the
provider using a Private Endpoint which is attached to Application
Gateway. SaaS Provider then uses this to connect to Application Gateway,
which will then allow SaaS provider to access on-premises resources such
as SQL Database and other resources.

:::image type="content" source="media/pls-direct-connect-microsoft-learn-documentation/image2.png" alt-text="Screenshot of a diagram showing external SaaS connectivity to on-premises resources through Application Gateway and Private Endpoint.":::

### Secure Access to Resources Hosted by 3P Providers

Resources hosted by third party providers can be made accessible. In
this an Application Gateway Proxy is used to secure access to Storage
Accounts and SQL resources hosted by a 3rd party provider.

:::image type="content" source="media/pls-direct-connect-microsoft-learn-documentation/image3.png" alt-text="Screenshot of a diagram showing secure access to third-party hosted resources through Application Gateway Proxy.":::

### VNet Integration

This feature allows for VNet Integrated workloads like APIM, SQLMI, App
Service.