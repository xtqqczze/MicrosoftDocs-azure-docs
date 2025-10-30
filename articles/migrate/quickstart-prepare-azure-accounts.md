---
title: Quickstart to prepare Azure accounts using built-in roles for Azure Migrate
description: In this quickstart, you learn how to set up Azure Role-based access control for Azure Migrate projects
author: molishv
ms.author: molir
ms.service: azure-migrate
ms.topic: how-to
ms.date: 28/10/2025
ms.custom: engagement-fy25
# Customer intent: "As a cloud architect, I want to prepare Azure accounts and assign Azure Migrate built-in roles to provide secure, least-privileged access for Azure Migrate projects. 
---

# Quickstart: Prepare Azure accounts for Azure Migrate using built-in roles

A typical customer's migration journey includes three phases: the Decide phase to discover the workloads, plan phase to assess the Azure readiness of workloads, right size the Azure targets and execute phase to migrate and modernize the workloads. In this article, you learn how to implement Azure Role-based access control to grant least privileged Azure access in Azure Migrate using built-in roles. The built-in roles are purposefully mapped to the Decide, Plan, and Execute phases, so users have only the permissions needed for that phase of the migration journey. 

Using built-in roles enables you to enforce the principle of least privilege, grant granular access, and ensure compliance with regulatory requirements. Assigning built-in roles is recommended over granting broad Owner or Contributor access to users at the subscription or resource group level.

## Azure Migrate built-in roles

| S.no. | Built-in role | Description | ID | Scope |
|-------|---------------|-------------|-----|-------|
| 1 | Azure Migrate Owner | Grants **full access** to **create** and manage **Azure Migrate projects** including appliance/import based discovery, creation of business case & assessment report and execution of migrations; Also grants ability to assign Azure Migrate specific roles in Azure Role-Based Access Control (or RBAC). | fd8ea4d5-6509-4db0-bada-356ab233b4fa | Scope is Resource Group or subscription where **Azure Migrate Project is created**. |
| 2 | Azure Migrate Decide and Plan Expert | Grants **restricted access on an Azure Migrate project** to only **perform planning operations** including appliance/import-based discovery, managing inventory, identifying server dependencies, creation of business case & assessment reports. | 7859c0b0-0bb9-4994-bd12-cd529af7d646 | Scope is Resource Group or subscription where **Azure Migrate Project is created**. |
| 3 | Azure Migrate Execute expert | Grants **restricted access on an Azure Migrate project** to only perform **migration related operations**, including replication, execution of test migrations, tracking and monitoring of migration progress, and initiation of agentless and agent-based migrations. | 1cfa4eac-9a23-481c-a793-bfb6958e836b | Source Resource Group or subscription where Azure Migrate Project is created; **Target Resource Group or subscription** where servers and workloads are migrated to. |

## Azure Migrate Owner
The Azure Migrate Owner role provides a superset of permissions to perform end-to-end operations across all migration phases (Decide, Plan, and Execute). A user must be part of Azure Migrate owner or a higher privileged role to create an Azure Migrate project.  
### Scope: 
Resource group or subscription where the Azure Migrate project is set up.

### Role assignment: 
Users with the Azure Migrate Owner role can assign or remove the **Azure Migrate Decide and Plan Expert and Azure Migrate Execute Expert roles** for other users or groups. The role doesn't grant permissions to assign or remove non-Azure Migrate built-in roles.
## Azure Migrate Decide and Plan expert
Azure Migrate Decide and Plan Expert provides limited permissions to perform scoped operations in the Decide and Plan phases. The role includes permissions to discover IT estate using an appliance or inventory import, manage & review discovered inventory, identify server dependencies, create business case, waves, and assessment reports. The role doesn't grant permissions to create Migrate project or perform role assignments. 
### Scope: 
Resource group or subscription where the Azure Migrate project is set up.
## Azure Migrate Execute expert
Azure Migrate Execute Expert provides limited permissions to only perform scoped operations in the Execute phase of migration journey. The role includes permissions to perform migration related operations including replication, execution of waves, execution of test migrations, tracking and monitoring the progress of migration and performing agentless and agent-based migrations. The role doesn't grant permissions to create Migrate project or perform role assignments. 
### Scope: 
Source resource group or subscription where the Azure Migrate project is set up.
If the migration target is a different resource group or subscription, assign the role in the target resource group or subscription where the servers and workloads are migrated to.
## Operations allowed per user role: 

| Operations | Azure Migrate Owner | Azure Migrate Decide and Plan Expert | Azure Migrate Execute Expert |
|------------|---------------------|-----------------------------------|------------------------------|
| Create, manage, and delete a Migrate project | Yes | No | No |
| Generate project key | Yes | Yes | No |
| Deploy VMware, Hyper-V, physical, or Azure Site Recovery appliance for discovery | Yes | Yes | No |
| Register Migrate appliance* | Yes | Yes | No |
| Use Inventory import for discovery | Yes | Yes | No |
| Explore inventory | Yes | Yes | Yes |
| View, add & import tags | Yes | Yes | Yes |
| View and export server dependencies | Yes | Yes | Yes |
| View security insights | Yes | Yes | No |
| Create business case | Yes | Yes | No |
| View and export business case | Yes | Yes | Yes |
| Create assessment reports | Yes | Yes | No |
| View and export assessment reports | Yes | Yes | Yes |
| Create waves | Yes | Yes | Yes |
| View and manage waves | Yes | Yes | Yes |
| Execute waves | Yes | No | Yes |
| Execute replications | Yes | No | Yes |
| Test migrations | Yes | No | Yes |
| Perform agentless and agent-based migrations | Yes | No | Yes |
| Create support incidents | Yes | Yes | Yes |

> [!Note]
> To register Azure Migrate appliance or ASR replication appliance users must have additional [Application Developer role](../active-directory/roles/permissions-reference.md#application-developer) at Microsoft Entra ID level. 
## Role assignment and access management:
In this section, you learn how to grant access to users by assigning Azure Migrate built-in roles. A subscription or resource group Owner can assign the Azure Migrate Owner role to the user who create and manage the Azure Migrate project. The user part of Azure Migrate Owner role can then assign the Azure Migrate Decide and Plan Expert and Azure Migrate Execute Expert roles to other users or user groups.
### Assigning Azure Migrate Owner
1.	Select the resource group where the Migrate project is created.
2.	In the navigation menu, select Access control (IAM)
3.	Select Add > Add role assignment
4.	On the privileged administrator roles tab, select Azure Migrate Owner role.
5.	On the members tab, select the user or group.
6.	Select the preferred assignment type and duration. The recommended approach is to choose eligible type and time-bound assignment duration. Select next and review + assign to complete the role assignment. 
### Assigning Decide & Plan Expert and Execute Expert role
Azure Migrate owner can grant a user access to Azure Migrate Decide and Plan Expert and Azure Migrate Execute Expert roles.  
1.	Select the resource group where the Migrate project is set up.
2.	In the navigation menu, select Access control (IAM)
3.	Select Add > Add role assignment
4.	Select the role you want to assign. The Azure Migrate Decide and Plan Expert role appears under Job function roles, and the Azure Migrate Execute Expert role appears under Privileged administrator roles. 
5.	After selecting the role, on the members tab, select the user or group.
6.	Select the preferred assignment type and duration. The recommended approach is to choose eligible type and time-bound assignment duration. 
7.	Select next and review + assign to complete the role assignment. 
### Check access and verify Role assignment: 
1.	From the resource group/subscription, select Access control (IAM) and view my access.
2.	Verify if the role assignment is successful.
3.	To check access for a user or group, select check access. Enter the user or group details and verify role assignment. 

### Remove access: 
1.	Azure Migrate owner can only remove Azure Migrate Decide and Plan Expert and Azure Migrate Execute Expert role assignments. Subscription or resource group owners can remove the Azure Migrate owner role assignment. 
2.	Open Access control (IAM) at scope subscription or resource group. 
3.	Select on role assignments
4.	Select the role assignment that you would like to remove
5.	Select Remove.
## Guidance for role assignments at the resource group scope
We recommend performing role assignments at resource group to operate in a least privilege access model. The following scenarios should be noted when the role assignments are done at resource group scope.
### 1. Register the Resource providers in advance: 
To enable all capabilities of Azure Migrate, you must register the required resource providers at the subscription where the Azure Migrate project is created. The Azure Migrate Owner and Azure Migrate Decide and Plan Expert roles have permissions to automatically register resource providers if the role assignment is done at the subscription scope. However, if these roles are assigned at the resource group level, project key generation could fail if the resource provider isn't already registered on the subscription. In such cases, the subscription owner should manually register the listed resource providers as a prerequisite.

## Required Resource Providers

| Resource Provider |
|-------------------|
| Microsoft.OffAzure |
| Microsoft.Migrate |
| Microsoft.MySQLDiscovery |
| Microsoft.DependencyMap |
| Microsoft.ApplicationMigration |
| Microsoft.Insights |
| Microsoft.KeyVault |
| Microsoft.Network |
| Microsoft.GuestConfiguration |
| Microsoft.Compute |
| Microsoft.HybridConnectivity |
| Microsoft.RecoveryServices |
| Microsoft.DataReplication |
| Microsoft.KeyVault |
| Microsoft.AzureArcData |
| Microsoft.ContainerInstance |

Refer to this [link](../azure-resource-manager/management/resource-providers-and-types.md#register-resource-provider)  for guidance on registering resource providers. 
### 2. Support requests
If the role assignment is done at resource group scope, users can't create support requests.
### 3. Registration of Azure Site Recovery Replication appliance
If the role assignment is done at resource group scope, users won't be able to register Azure Site Recovery Replication appliance. The Azure Migrate Decide & Plan Expert role must be assigned to subscription scope to register Azure Site Recovery Replication appliance. This restriction only applies to Azure Site Recovery appliance and not to VMware, Hyper-V, and Physical stack of Azure Migrate appliance. 
## Azure Migrate built-in roles permissions (JSON)
The complete Azure Resource Manager (ARM) role definitions in JSON format are documented below for programmatic use.
# 1. Azure Migrate Owner

```json
{
    "id": "/providers/Microsoft.Authorization/roleDefinitions/fd8ea4d5-6509-4db0-bada-356ab233b4fa",
    "properties": {
        "roleName": "Azure Migrate Owner",
        "description": "Grants full access to create and manage Azure Migrate projects including appliance-based discovery, creation of business case & assessment report and execution of migrations; Also grants ability to assign Azure Migrate specific roles in Azure RBAC.",
        "assignableScopes": [
            "/"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.Resources/subscriptions/resourceGroups/read",
                    "Microsoft.Resources/deployments/*",
                    "Microsoft.Resources/subscriptions/resourceGroups/write",
                    "Microsoft.Resources/subscriptions/read",
                    "Microsoft.Resources/subscriptions/locations/read",
                    "Microsoft.Resources/checkResourceName/action",
                    "Microsoft.Resources/deploymentScripts/write",
                    "Microsoft.Resources/deploymentScripts/read",
                    "Microsoft.Resources/links/write",
                    "Microsoft.Authorization/*/read",
                    "Microsoft.Authorization/locks/write",
                    "Microsoft.Authorization/locks/delete",
                    "Microsoft.Insights/alertRules/*",
                    "Microsoft.Migrate/*",
                    "Microsoft.ApplicationMigration/*",
                    "Microsoft.OffAzure/*",
                    "Microsoft.Support/*",
                    "Microsoft.MySQLDiscovery/*",
                    "Microsoft.DependencyMap/*",
                    "Microsoft.KeyVault/vaults/*",
                    "Microsoft.KeyVault/checkNameAvailability/read",
                    "Microsoft.HybridCompute/machines/read",
                    "Microsoft.HybridCompute/machines/write",
                    "Microsoft.HybridCompute/machines/delete",
                    "Microsoft.HybridCompute/register/action",
                    "Microsoft.Network/networkInterfaces/read",
                    "Microsoft.Network/networkInterfaces/write",
                    "Microsoft.Network/networkInterfaces/delete",
                    "Microsoft.Network/virtualNetworks/read",
                    "Microsoft.Network/virtualNetworks/subnets/write",
                    "Microsoft.Network/virtualNetworks/subnets/join/action",
                    "Microsoft.Network/networkSecurityGroups/join/action",
                    "Microsoft.Network/virtualNetworks/join/action",
                    "Microsoft.Network/privateEndpoints/read",
                    "Microsoft.Network/privateEndpoints/write",
                    "Microsoft.Network/privateEndpoints/privateDnsZoneGroups/write",
                    "Microsoft.Network/privateDnsZones/write",
                    "Microsoft.Network/privateDnsZones/virtualNetworkLinks/write",
                    "Microsoft.Network/privateDnsZones/join/action",
                    "Microsoft.Network/privateDnsZones/A/write",
                    "Microsoft.Network/register/action",
                    "Microsoft.Network/virtualNetworks/subnets/read",
                    "Microsoft.Network/privateEndpoints/privateDnsZoneGroups/read",
                    "Microsoft.Storage/storageAccounts/*",
                    "Microsoft.GuestConfiguration/register/action",
                    "Microsoft.Compute/register/action",
                    "Microsoft.Compute/availabilitySets/read",
                    "Microsoft.Compute/availabilitySets/vmSizes/read",
                    "Microsoft.Compute/diskEncryptionSets/read",
                    "Microsoft.Compute/skus/read",
                    "Microsoft.Compute/disks/read",
                    "Microsoft.Compute/disks/write",
                    "Microsoft.Compute/disks/delete",
                    "Microsoft.Compute/virtualMachines/read",
                    "Microsoft.Compute/virtualMachines/write",
                    "Microsoft.Compute/virtualMachines/delete",
                    "Microsoft.HybridConnectivity/register/action",
                    "Microsoft.RecoveryServices/vaults/*",
                    "Microsoft.RecoveryServices/register/action",
                    "Microsoft.RecoveryServices/operations/read",
                    "Microsoft.DataReplication/*/read",
                    "Microsoft.DataReplication/register/action",
                    "Microsoft.DataReplication/replicationVaults/write",
                    "Microsoft.KeyVault/register/action",
                    "Microsoft.AzureArcData/register/action",
                    "Microsoft.Resources/links/read"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": []
            },
            {
                "actions": [
                    "Microsoft.Authorization/roleAssignments/write",
                    "Microsoft.Authorization/roleAssignments/delete"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": [],
                "conditionVersion": "2.0",
                "condition": "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals{7859c0b0-0bb9-4994-bd12-cd529af7d646, 1cfa4eac-9a23-481c-a793-bfb6958e836b, 17d1049b-9a84-46fb-8f53-869881c3d3ab, ba92f5b4-2d11-453d-a403-e96b0029c9fe, ba480ccd-6499-4709-b581-8f38bb215c63})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals{7859c0b0-0bb9-4994-bd12-cd529af7d646, 1cfa4eac-9a23-481c-a793-bfb6958e836b, 17d1049b-9a84-46fb-8f53-869881c3d3ab, ba92f5b4-2d11-453d-a403-e96b0029c9fe, ba480ccd-6499-4709-b581-8f38bb215c63}))"
            }
        ]
    }
}
```
# 2. Azure Migrate Decide and Plan Expert

```json
{
    "id": "/providers/Microsoft.Authorization/roleDefinitions/7859c0b0-0bb9-4994-bd12-cd529af7d646",
    "properties": {
        "roleName": "Azure Migrate Decide and Plan Expert",
        "description": "Grants restricted access on Azure Migrate project to only perform planning operations including appliance-based discovery, managing inventory, identifying server dependencies, creation of business case & assessment reports.",
        "assignableScopes": [
            "/"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.Resources/subscriptions/resourceGroups/read",
                    "Microsoft.Resources/subscriptions/read",
                    "Microsoft.Resources/deployments/*",
                    "Microsoft.Resources/subscriptions/locations/read",
                    "Microsoft.Resources/checkResourceName/action",
                    "Microsoft.Resources/deploymentScripts/write",
                    "Microsoft.Resources/deploymentScripts/read",
                    "Microsoft.Resources/links/write",
                    "Microsoft.Authorization/*/read",
                    "Microsoft.Authorization/locks/write",
                    "Microsoft.Authorization/locks/delete",
                    "Microsoft.Insights/alertRules/*",
                    "Microsoft.Migrate/*",
                    "Microsoft.ApplicationMigration/*",
                    "Microsoft.OffAzure/*",
                    "Microsoft.MySQLDiscovery/*",
                    "Microsoft.Support/*",
                    "Microsoft.DependencyMap/*",
                    "Microsoft.KeyVault/vaults/*",
                    "Microsoft.KeyVault/checkNameAvailability/read",
                    "Microsoft.HybridCompute/machines/read",
                    "Microsoft.HybridCompute/machines/write",
                    "Microsoft.HybridCompute/machines/delete",
                    "Microsoft.HybridCompute/register/action",
                    "Microsoft.Network/virtualNetworks/subnets/write",
                    "Microsoft.Network/virtualNetworks/subnets/join/action",
                    "Microsoft.Network/networkSecurityGroups/join/action",
                    "Microsoft.Network/virtualNetworks/join/action",
                    "Microsoft.Network/privateEndpoints/read",
                    "Microsoft.Network/privateEndpoints/write",
                    "Microsoft.Network/privateEndpoints/privateDnsZoneGroups/write",
                    "Microsoft.Network/privateDnsZones/write",
                    "Microsoft.Network/privateDnsZones/virtualNetworkLinks/write",
                    "Microsoft.Network/privateDnsZones/join/action",
                    "Microsoft.Network/privateDnsZones/A/write",
                    "Microsoft.Network/register/action",
                    "Microsoft.Network/virtualNetworks/subnets/read",
                    "Microsoft.Network/privateEndpoints/privateDnsZoneGroups/read",
                    "Microsoft.Storage/storageAccounts/*/read",
                    "Microsoft.Storage/storageAccounts/*/write",
                    "Microsoft.Storage/storageAccounts/listKeys/action",
                    "Microsoft.GuestConfiguration/register/action",
                    "Microsoft.HybridConnectivity/register/action",
                    "Microsoft.DataReplication/*/read",
                    "Microsoft.DataReplication/register/action",
                    "Microsoft.DataReplication/replicationVaults/write",
                    "Microsoft.RecoveryServices/vaults/*",
                    "Microsoft.RecoveryServices/register/action",
                    "Microsoft.KeyVault/register/action",
                    "Microsoft.AzureArcData/register/action",
                    "Microsoft.Resources/links/read"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": []
            }
        ]
    }
}
```

# 3. Azure Migrate Execute Expert

```json
{
    "id": "/providers/Microsoft.Authorization/roleDefinitions/1cfa4eac-9a23-481c-a793-bfb6958e836b",
    "properties": {
        "roleName": "Azure Migrate Execute Expert",
        "description": "Grants restricted access on an Azure Migrate project to only perform migration related operations, including replication, execution of test migrations, tracking and monitoring of migration progress, and initiation of agentless and agent-based migrations.",
        "assignableScopes": [
            "/"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.Resources/subscriptions/resourceGroups/read",
                    "Microsoft.Resources/subscriptions/read",
                    "Microsoft.Resources/deployments/*",
                    "Microsoft.Resources/subscriptions/resourceGroups/write",
                    "Microsoft.Resources/subscriptions/locations/read",
                    "Microsoft.Resources/checkResourceName/action",
                    "Microsoft.Resources/deploymentScripts/write",
                    "Microsoft.Resources/deploymentScripts/read",
                    "Microsoft.Resources/links/write",
                    "Microsoft.Authorization/*/read",
                    "Microsoft.Authorization/locks/write",
                    "Microsoft.Authorization/locks/delete",
                    "Microsoft.Insights/alertRules/*",
                    "Microsoft.Migrate/*/read",
                    "Microsoft.ApplicationMigration/*/read",
                    "Microsoft.OffAzure/*/read",
                    "Microsoft.MySQLDiscovery/*/read",
                    "Microsoft.Support/*",
                    "Microsoft.Network/networkInterfaces/read",
                    "Microsoft.Network/networkInterfaces/write",
                    "Microsoft.Network/networkInterfaces/delete",
                    "Microsoft.Network/virtualNetworks/read",
                    "Microsoft.Network/virtualNetworks/subnets/read",
                    "Microsoft.Storage/storageAccounts/*/read",
                    "Microsoft.Storage/storageAccounts/*/write",
                    "Microsoft.Storage/storageAccounts/listKeys/action",
                    "Microsoft.Compute/register/action",
                    "Microsoft.Compute/availabilitySets/read",
                    "Microsoft.Compute/availabilitySets/vmSizes/read",
                    "Microsoft.Compute/diskEncryptionSets/read",
                    "Microsoft.Compute/skus/read",
                    "Microsoft.Compute/disks/read",
                    "Microsoft.Compute/disks/write",
                    "Microsoft.Compute/disks/delete",
                    "Microsoft.Compute/virtualMachines/read",
                    "Microsoft.Compute/virtualMachines/write",
                    "Microsoft.Compute/virtualMachines/delete",
                    "Microsoft.RecoveryServices/vaults/*",
                    "Microsoft.RecoveryServices/register/action",
                    "Microsoft.RecoveryServices/operations/read",
                    "Microsoft.Resources/links/read",
                    "Microsoft.DependencyMap/*/read",
                    "Microsoft.DependencyMap/maps/*/action"
                ],
                "notActions": [
                    "Microsoft.OffAzure/hypervSites/machines/inventoryinsights/pendingupdates/*",
                    "Microsoft.OffAzure/hypervSites/machines/inventoryinsights/vulnerabilities/*",
                    "Microsoft.OffAzure/serverSites/machines/inventoryinsights/pendingupdates/*",
                    "Microsoft.OffAzure/serverSites/machines/inventoryinsights/vulnerabilities/*",
                    "Microsoft.OffAzure/vmwareSites/machines/inventoryinsights/vulnerabilities/*",
                    "Microsoft.OffAzure/vmwareSites/machines/inventoryinsights/pendingupdates/*"
                ],
                "dataActions": [],
                "notDataActions": []
            },
            {
                "actions": [
                    "Microsoft.Authorization/roleAssignments/write",
                    "Microsoft.Authorization/roleAssignments/delete"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": [],
                "conditionVersion": "2.0",
                "condition": "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals{17d1049b-9a84-46fb-8f53-869881c3d3ab, ba92f5b4-2d11-453d-a403-e96b0029c9fe})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals{17d1049b-9a84-46fb-8f53-869881c3d3ab, ba92f5b4-2d11-453d-a403-e96b0029c9fe}))"
            }
        ]
    }
}
```
