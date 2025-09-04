---
title: Configure Private Link Service Direct Connect
author: altheapm
contributors:
ms.topic: concept-article
ms.date: 07/08/2025
ms.author: altheabata
ms.reviewer: altheabata
---
# Create a Private Link Service Direct Connect

Customers can now connect any IP-based targets to Private Link Service without needing to use a standard load balancer.
Azure Private Link Service allows service providers to make their applications available to their customers privately and securely. The current setup procedure requires service providers to configure their private link service and place their applications behind a standard internal load balancer. Private Link Service Direct Connect removes this limitation and allows customers to directly connect a private link service to any IP based target within your virtual network. This configuration is particularly useful for scenarios where you need to provide private connectivity to applications that require direct IP-based routing, such as database connections or custom applications.

In this article, you'll learn how to create a Private Link Service Direct Connect using Azure PowerShell, Azure CLI, and Terraform.

> [!NOTE]
> This feature is currently in public preview and available in select regions. We recommend reviewing all considerations before enabling it for your subscription

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free).
- Azure PowerShell installed locally or use Azure Cloud Shell. For more information, see [Install Azure PowerShell](/powershell/azure/install-azure-powershell).
- Azure CLI installed locally or use Azure Cloud Shell. For more information, see [Install the Azure CLI](/cli/azure/install-azure-cli).
- For Terraform: [Install and configure Terraform](/azure/developer/terraform/quickstart-configure).
- Feature flag Microsoft.Network/AllowPrivateLinkServiceUDR enabled in current subscription, see [Enable Azure preview features](https://review.learn.microsoft.com/en-us/azure/azure-resource-manager/management/preview-features).
- A virtual network with a subnet
- A routable IP address to set as the destination IP address

## What is Private Link Service Direct Connect?

Private Link Service Direct Connect allows you to:

- **Route traffic directly** to a specific routable IP address within your virtual network
- **Bypass load balancer requirements** for scenarios that need direct IP connectivity
- **Support custom routing scenarios** where you need precise control over traffic destination
- **Configure expanded scenarios** such as secure access to on-premises resources, third-party SaaS, and virtual appliances

### Key requirements

When creating a Private Link Service Direct Connect, you must:

1. **Provide a minimum of 2 IP configurations** - For this feature, at least 2 IP configurations in multiples of 2 are required for high availability
1. **Specify a static destination IP address** - The target IP must be reachable within your virtual network
1. **Disable Private Link Service network policies** on the subnet
1. **Ensure no IP forwarding conflicts** - The destination IP cannot be behind NAT or load balancer forwarding

### Common use cases

- Direct database connectivity for applications requiring static IP connections
- Custom application scenarios that don't work with load balancer forwarding
- Legacy applications that need direct IP-based routing
- Scenarios requiring user-defined routing (UDR) with Private Link
- On-premises connectivity

## Limitations and considerations

Be aware of these limitations when using Private Link Service Direct Connect:

- **Minimum 2 IP configurations required** - A minimum of 2 IP addresses or in multiples of 2 are required to deploy a PLS Direct Connect.
- **IP forwarding is enabled** - If there is a policy on the subscription that disables IP forwarding, the policy must be disabled to allow proper configuration.
- **Static IP requirement** - The destination IP must be static and directly reachable, dynamically changing IPs are not supported
- **Cross region limitation** - This feature currently requires that the source private endpoint and the private link service must both be in the same region, with this restriction to be removed when the feature is generally available
- **No migration support** - Using this feature requires the deployment of a new Private Link Service and migration of existing private link services is not supported
- **Subscription feature flag enablement is required** - Register the feature flag Microsoft.Network/AllowPrivateLinkServiceUDR through this link: [Set up preview features in Azure subscription - Azure Resource Manager | Microsoft Learn](https://review.learn.microsoft.com/en-us/azure/azure-resource-manager/management/preview-features?branch=main&tabs=azure-portal)
- **Available client support** - You will need to use PowerShell, CLI, or Terraform to deploy this new Private Link Service, Portal client support is pending.
- **Regional availability** - This feature is currently available in limited regions (North Central US, East US 2, Central US, South Central US, West US, West US 2, West US 3, Asia Southeast, Australia East, Spain Central)

## Create a Private Link Service Direct Connect

# [PowerShell](#tab/powershell)

Use the following script to create a Private Link Service Direct Connect using Azure PowerShell:

```powershell
# Define variables
$resourceGroupName = "rg-pls-directconnect"
$location = "westus"
$vnetName = "pls-vnet"
$subnetName = "pls-subnet"
$plsName = "pls-directconnect "
$destinationIP = "10.0.1.100"

# Create resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create virtual network (corrected parameter name)
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.1.0/24" -PrivateLinkServiceNetworkPoliciesFlag "Disabled"
$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix "10.0.0.0/16" -Subnet $subnet

# Get subnet reference
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName

# Create IP configurations for Private Link Service (minimum 2 required for destination IP)
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

# Create Private Link Service Direct Connect
$pls = New-AzPrivateLinkService `
    -Name $plsName `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -IpConfiguration @($ipConfig1, $ipConfig2) `
    -DestinationIPAddress $destinationIP

Write-Output "Private Link Service created successfully!"
Write-Output "Private Link Service ID: $($pls.Id)"
Write-Output "Destination IP Address: $destinationIP"
```

# [Azure CLI](#tab/cli)

Use the following script to create a Private Link Service Direct Connect using Azure CLI:

```azurecli
# Define variables
resourceGroupName="rg-pls-directconnect"
location="westus"
vnetName="pls-vnet"
subnetName="pls-subnet"
plsName="pls-directconnect "
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

# Create Private Link Service Direct Connect
az network private-link-service create \
    --resource-group $resourceGroupName \
    --name $plsName \
    --destination-ip-address $destinationIP \
    --location $location \
    --ip-configurations '[
      {
        "name": "ipconfig1",
        "primary": true,
        "private-ip-allocation-method": "Static",
        "private-ip-address": "10.0.1.10",
        "subnet": {
          "id": "/subscriptions/<subscription-id>/resourceGroups/'$resourceGroupName'/providers/Microsoft.Network/virtualNetworks/'$vnetName'/subnets/'$subnetName'"
        }
      },
      {
        "name": "ipconfig2", 
        "primary": false,
        "private-ip-allocation-method": "Static",
        "private-ip-address": "10.0.1.11",
        "subnet": {
          "id": "/subscriptions/<subscription-id>/resourceGroups/'$resourceGroupName'/providers/Microsoft.Network/virtualNetworks/'$vnetName'/subnets/'$subnetName'"
        }
      }
    ]'

echo "Private Link Service created successfully!"
echo "Destination IP Address: $destinationIP"
```

# [Terraform](#tab/terraform)

Use the following Terraform configuration to create a Private Link Service Direct Connect:

```hcl
# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
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
  location = "REGION"
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

  # Required for Private Link Service Direct Connect
  private_link_service_network_policies_enabled = false
}

# Create Private Link Service Direct Connect
resource "azurerm_private_link_service" "pls" {
  name                = "${random_pet.rg_name.id}-pls"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Destination IP address for direct routing
  destination_ip_address = "10.0.1.100"

  # Minimum 2 IP configurations required for destination IP
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

## Create a Private Endpoint to test connectivity

After creating your Private Link Service Direct Connect, you can create a Private Endpoint to test the connectivity:

# [PowerShell](#tab/powershell-pe)

```powershell
# Variables for Private Endpoint
$peResourceGroupName = "rg-pe-test"
$peVnetName = "pe-vnet"
$peSubnetName = "pe-subnet"
$privateEndpointName = "pe-to-pls"
$privateLinkServiceId = "/subscriptions/your-subscription-id/resourceGroups/rg-pls-destinationip/providers/Microsoft.Network/privateLinkServices/pls-with-destinationip"

# Create resource group for PE
New-AzResourceGroup -Name $peResourceGroupName -Location $location

# Create VNet for Private Endpoint (corrected parameter name)
$peSubnet = New-AzVirtualNetworkSubnetConfig -Name $peSubnetName -AddressPrefix "10.1.1.0/24" -PrivateEndpointNetworkPoliciesFlag "Disabled"
$peVnet = New-AzVirtualNetwork -Name $peVnetName -ResourceGroupName $peResourceGroupName -Location $location -AddressPrefix "10.1.0.0/16" -Subnet $peSubnet

# Get subnet reference for Private Endpoint
$peSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $peVnet -Name $peSubnetName

# Create Private Endpoint (corrected approach)
$privateEndpoint = New-AzPrivateEndpoint -Name $privateEndpointName -ResourceGroupName $peResourceGroupName -Location $location -Subnet $peSubnet -PrivateLinkServiceId $privateLinkServiceId

Write-Output "Private Endpoint created: $($privateEndpoint.Name)"
```

# [Azure CLI](#tab/cli-pe)

```azurecli
# Variables for Private Endpoint
peResourceGroupName="rg-pe-test"
peVnetName="pe-vnet" 
peSubnetName="pe-subnet"
privateEndpointName="pe-to-pls"
privateLinkServiceId="/subscriptions/your-subscription-id/resourceGroups/rg-pls-destinationip/providers/Microsoft.Network/privateLinkServices/pls-with-destinationip"

# Create resource group for PE
az group create --name $peResourceGroupName --location $location

# Create VNet for Private Endpoint
az network vnet create \
    --resource-group $peResourceGroupName \
    --name $peVnetName \
    --address-prefix 10.1.0.0/16 \
    --subnet-name $peSubnetName \
    --subnet-prefix 10.1.1.0/24

# Disable Private Endpoint network policies
az network vnet subnet update \
    --resource-group $peResourceGroupName \
    --vnet-name $peVnetName \
    --name $peSubnetName \
    --disable-private-endpoint-network-policies true

# Create Private Endpoint
az network private-endpoint create \
    --resource-group $peResourceGroupName \
    --name $privateEndpointName \
    --vnet-name $peVnetName \
    --subnet $peSubnetName \
    --private-connection-resource-id $privateLinkServiceId \
    --connection-name "connection-to-pls"

echo "Private Endpoint created: $privateEndpointName"
```

# [Terraform](#tab/terraform-pe)

```hcl
# Create Private Endpoint to test PLS connectivity
resource "azurerm_resource_group" "pe_rg" {
  name     = "${random_pet.rg_name.id}-pe"
  location = "westus"
}

resource "azurerm_virtual_network" "pe_vnet" {
  name                = "${random_pet.rg_name.id}-pe-vnet"
  location            = azurerm_resource_group.pe_rg.location
  resource_group_name = azurerm_resource_group.pe_rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "pe_subnet" {
  name                 = "pe-subnet"
  resource_group_name  = azurerm_resource_group.pe_rg.name
  virtual_network_name = azurerm_virtual_network.pe_vnet.name
  address_prefixes     = ["10.1.1.0/24"]

  private_endpoint_network_policies_enabled = false
}

resource "azurerm_private_endpoint" "pe" {
  name                = "${random_pet.rg_name.id}-pe"
  location            = azurerm_resource_group.pe_rg.location
  resource_group_name = azurerm_resource_group.pe_rg.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "connection-to-pls"
    private_connection_resource_id = azurerm_private_link_service.pls.id
    is_manual_connection           = false
  }
}

output "private_endpoint_ip" {
  description = "IP address of the Private Endpoint"
  value       = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
}
```

---

## Verify the configuration

After creating both the Private Link Service and Private Endpoint, verify the configuration:

### Check Private Link Service status

# [PowerShell](#tab/verify-powershell)

```powershell
# Get Private Link Service details
$pls = Get-AzPrivateLinkService -Name $plsName -ResourceGroupName $resourceGroupName

Write-Output "Private Link Service: $($pls.Name)"
Write-Output "Provisioning State: $($pls.ProvisioningState)"
Write-Output "Destination IP: $($pls.DestinationIPAddress)"
Write-Output "IP Configurations: $($pls.IpConfigurations.Count)"

# Check Private Endpoint connections
$connections = $pls.PrivateEndpointConnections
foreach ($connection in $connections) {
    Write-Output "PE Connection: $($connection.Name) - Status: $($connection.PrivateLinkServiceConnectionState.Status)"
}
```

# [Azure CLI](#tab/verify-cli)

```azurecli
# Get Private Link Service details
az network private-link-service show \
    --name $plsName \
    --resource-group $resourceGroupName \
    --query "{name:name, provisioningState:provisioningState, destinationIpAddress:destinationIpAddress, ipConfigCount:length(ipConfigurations)}"

# Check Private Endpoint connections
az network private-link-service show \
    --name $plsName \
    --resource-group $resourceGroupName \
    --query "privateEndpointConnections[].{name:name, status:privateLinkServiceConnectionState.status}"
```

---

## Troubleshooting

### Common issues and solutions

**Issue**: "You must include a minimum of 2 IP configurations in multiples of 2"

**Solution**: Ensure you configure at least 2 IP configurations when configuring PLS Direct Connect.

**Issue**: "Cannot reach destination IP address"

**Solution**: Verify that:

- The destination IP is reachable within the virtual network
- There's no IP forwarding or NAT between the PLS and destination IP
- Network security groups allow the required traffic

## Clean up resources

When you're finished testing, clean up the resources to avoid ongoing charges:

# [PowerShell](#tab/cleanup-powershell)

```powershell
# Remove resource groups (this deletes all resources within them)
Remove-AzResourceGroup -Name $resourceGroupName -Force
Remove-AzResourceGroup -Name $peResourceGroupName -Force
```

# [Azure CLI](#tab/cleanup-cli)

```azurecli
# Remove resource groups (this deletes all resources within them)
az group delete --name $resourceGroupName --yes --no-wait
az group delete --name $peResourceGroupName --yes --no-wait
```

# [Terraform](#tab/cleanup-terraform)

```bash
# Destroy all Terraform-managed resources
terraform destroy -auto-approve
```

---

## Next steps

- [Azure Private Link overview](/azure/private-link/private-link-overview)
- [Azure Private Link Service overview](/azure/private-link/private-link-service-overview)
- [Create a private endpoint using Terraform](/azure/private-link/create-private-endpoint-terraform)
- [Troubleshoot Azure Private Link connectivity problems](/azure/private-link/troubleshoot-private-link-connectivity)
