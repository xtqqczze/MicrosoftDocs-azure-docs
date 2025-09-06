---
title: Migrate from Standard to StandardV2 NAT Gateway - Guidance    
description: Upgrade guidance for migrating Standard NAT Gateway to StandardV2 NAT Gateway.
author: alittleton    
ms.author: aimee-littleton
ms.service: azure-nat-gateway
ms.topic: concept-article 
ms.date: 09/05/2025
# Customer intent: "As a cloud engineer with Standard NAT Gateway, I need guidance and direction on migrating my workloads off Standard to StandardV2 SKUs"
---

# Migrate from Standard to StandardV2 NAT Gateway 

## Overview

StandardV2 NAT Gateway offers enhanced data processing limits and high availability through zone redundancy. StandardV2 NAT Gateway is recommended for production workloads requiring resiliency to zonal outages.  

In this article, we discuss guidance for how to migrate your subnets from Standard NAT Gateway to StandardV2 NAT Gateway manually. In place migration support is not available. 

> [!IMPORTANT]
> Migration from Standard to StandardV2 NAT Gateway involves **downtime** and **impact to existing connections**. It also requires the use of new StandardV2 Public IPs. Existing Standard SKU Public IPs will not work with StandardV2 NAT Gateway. Please plan accordingly. 

## Pre-migration steps

We recommend the following pre-migration steps to prepare for the migration.
* StandardV2 NAT Gateway requires the use of StandardV2 public IPs. Existing Standard SKU public IPs don’t work with StandardV2 NAT Gateway. Make sure you’re able to re-IP to StandardV2 Public IPs before you create StandardV2 NAT Gateway. 

* Check if you have any allow listing requirements at specific destination endpoints since you will have to re-IP to StandardV2 public IPs in order to use StandardV2 NAT Gateway.  

* Plan for application downtime during the migration. Existing connections with Standard NAT Gateway will be impacted when migrating to StandardV2 NAT Gateway. 

* Confirm which subnets in your virtual network need to be migrated to StandardV2 NAT Gateway. 

## Unsupported scenarios
* Azure Kubernetes Service (AKS) managed NAT gateway does not support StandardV2 NAT Gateway deployment. To use a StandardV2 NAT gateway with AKS, StandardV2 NAT Gateway must be deployed as user-assigned. 

* StandardV2 NAT Gateway and Basic SKU Load balancer or Basic SKU public IPs are not supported. 

* StandardV2 NAT Gateway does not support the use of custom public IPs (BYOIP) 

* The following regions do not support StandardV2 NAT Gateway:  

    * Canada East  
    * Central India  
    * Chile Central  
    * Indonesia Central  
    * Israel Northwest  
    * Jio India West  
    * Malaysia West  
    * Qatar Central  
    * Sweden South  
    * UAE Central 

## Guidance for manual migration 

### Migration using the portal

Below is the suggested order of operations for manually migrating from a Standard SKU NAT Gateway to a StandardV2 SKU NAT Gateway using the Portal.

1. Create a new **StandardV2 SKU NAT Gateway**. Make sure to select StandardV2 as the SKU.
2. Create a new **StandardV2 SKU Public IP** or **StandardV2 SKU Public IP Prefix** resource during the create experience for the StandardV2 NAT Gateway. Select IPv4 for IP version. Note that IPv6 public IPs are in **public preview** and are not recommended for production workloads.
> [!IMPORTANT]
> StandardV2 NAT Gateway requires the use of StandardV2 public IPs. Existing Standard SKU public IPs don’t work with StandardV2 NAT Gateway. Make sure you’re able to re-IP to StandardV2 Public IPs before you create StandardV2 NAT Gateway. 
3. **Skip the subnet configuration step** during the portal create experience for StandardV2 NAT Gateway. You will attach subnets in a later step.
4. **Create** the StandardV2 NAT Gateway.
5. From your resource group, navigate to the **subnet** you want to migrate from Standard NAT Gateway to StandardV2 NAT Gateway.
6. **Update** the subnet configuration to use the new StandardV2 NAT Gateway.
7. **Save** the subnet configuration.
> [!IMPORTANT]
> Existing connections with Standard NAT Gateway will be impacted when migrating to StandardV2 NAT Gateway. Please plan for application downtime during the migration. It is advised to migrate one subnet at a time and validate connectivity before proceeding to the next subnet. Also consider performing this step during a maintenance window in order to minimize impact to your applications.
8. Repeat steps 5-7 for each subnet you want to migrate to StandardV2 NAT Gateway.

> [!NOTE]
> This migration process does not delete your existing Standard NAT Gateway or Standard SKU public IP resources. 

### Migration using PowerShell
Below is the suggested order of operations for manually migrating from a Standard SKU NAT Gateway to a StandardV2 SKU NAT Gateway using PowerShell.

Before you begin, ensure you have the following:

- Azure PowerShell installed locally or use Azure Cloud Shell.

  If you choose to install and use PowerShell locally, this article requires the Azure PowerShell module version 5.4.1 or later. Run `Get-Module -ListAvailable Az` to find the installed version. If you need to upgrade, see [Install Azure PowerShell module](/powershell/azure/install-azure-powershell).

  If you run PowerShell locally, you also need to run `Connect-AzAccount` to create a connection with Azure.

- Ensure that your `Az.Network` module is 7.17.0 or later. To verify the installed module, use the command `Get-InstalledModule -Name "Az.Network"`. If the module requires an update, use the command `Update-Module -Name Az.Network`.

- Sign in to Azure PowerShell and select the subscription that you want to use. For more information, see [Sign in with Azure PowerShell](/powershell/azure/authenticate-azureps).

The following steps should be taken to migrate from Standard NAT Gateway to StandardV2 NAT Gateway using PowerShell:
1. Create a new **StandardV2 SKU Public IP** or **StandardV2 SKU Public IP Prefix** resource using the `New-AzPublicIpAddress` or `New-AzPublicIpPrefix` cmdlet. Select IPv4 for IP version. Note that IPv6 public IPs are in **public preview** and are not recommended for production workloads.

```powershell
$publicIp = New-AzPublicIpAddress -ResourceGroupName <your-resource-group> -Name <your-public-ip-name> -Location <your-location> -Sku StandardV2 -AllocationMethod Static -IpVersion IPv4 -Zone 1,2,3
```

or

```powershell    
$publicIpPrefix = New-AzPublicIpPrefix -ResourceGroupName <your-resource-group> -Name <your-public-ip-prefix-name> -Location <your-location> -Sku StandardV2 -PrefixLength 28 -Zone 1,2,3
```

2. Create a new **StandardV2 SKU NAT Gateway** using the `New-AzNatGateway` cmdlet. Make sure to select StandardV2 as the SKU.

```powershell
$natGateway = New-AzNatGateway -ResourceGroupName <your-resource-group> -Name <your-nat-gateway-name> -Location <your-location> -Sku StandardV2, -PublicIpAddress $publicIp
```

or

```powershell
$natGateway = New-AzNatGateway -ResourceGroupName <your-resource-group> -Name <your-nat-gateway-name> -Location <your-location> -Sku StandardV2 -PublicIpPrefix $publicIpPrefix
```

3. From your resource group, retrieve the **subnet** you want to migrate from Standard NAT Gateway to StandardV2 NAT Gateway using the `Get-AzVirtualNetwork` cmdlet.

```powershell
$subnet = Get-AzVirtualNetwork -ResourceGroupName <your-resource-group> -Name <your-vnet-name> | Get-AzVirtualNetworkSubnetConfig -Name <your-subnet-name>
```

4. **Update** the subnet configuration to use the new StandardV2 NAT Gateway using the `Set-AzVirtualNetworkSubnetConfig` cmdlet.

```powershell
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name <your-subnet-name> -NatGateway $natGateway
```

5. **Save** the subnet configuration using the `Set-AzVirtualNetwork` cmdlet.

```powershell
Set-AzVirtualNetwork -VirtualNetwork $vnet
```        
6. Repeat steps 3-5 for each subnet you want to migrate to StandardV2 NAT Gateway.

> [!NOTE]
> This migration process does not delete your existing Standard NAT Gateway or Standard SKU public IP resources. 

## Post-migration steps
After you have migrated your subnets to StandardV2 NAT Gateway, we recommend the following post-migration steps.
* Validate outbound connectivity to the internet from your virtual machines in the subnets that were migrated to StandardV2 NAT Gateway.
* Monitor your applications for any issues related to connectivity or performance after the migration.

## Common questions

### Can I use my existing Standard SKU public IPs with StandardV2 NAT Gateway?
No, StandardV2 NAT Gateway requires the use of StandardV2 public IPs. Existing Standard SKU public IPs are not compatible with StandardV2 NAT Gateway.

### Will there be downtime during the migration?
Yes, migrating from Standard NAT Gateway to StandardV2 NAT Gateway will cause downtime and impact existing connections. It is recommended to plan for application downtime during the migration and perform the migration during a maintenance window.    

### How long is the expected downtime?
The duration of downtime will depend on the number of subnets being migrated and the complexity of your network configuration. It is advisable to migrate one subnet at a time and validate connectivity before proceeding to the next subnet to minimize downtime.

### Can I automate the migration process?
Yes, you can use PowerShell or Azure CLI scripts to automate the migration process. The steps provided in this article can be adapted into scripts for automation.

### How do I revert back to Standard NAT Gateway if needed?
To revert back to Standard NAT Gateway, you will need to reattach the subnets to the existing Standard NAT Gateway and reassign the original Standard SKU public IPs. This process will also involve downtime and impact existing connections.

### Is my Standard NAT Gateway deleted after migration?
No, migrating to StandardV2 NAT Gateway does not delete your existing Standard NAT Gateway or Standard SKU public IP resources. You will need to manually delete these resources if they are no longer needed. Don't delete these resources until you have fully validated that your workloads are functioning as expected with StandardV2 NAT Gateway and you no longer need the Standard NAT Gateway or Standard SKU public IPs.

### How do I validate that the migration is successful?
After migrating your subnets to StandardV2 NAT Gateway, you can validate the migration by checking outbound connectivity to the internet from your virtual machines in the migrated subnets. You can also monitor your applications for any connectivity or performance issues. Follow guidance on how to test NAT Gateway connectivity in the [Create StandardV2 NAT Gateway](./quickstart-create-nat-gateway-v2.md) article.