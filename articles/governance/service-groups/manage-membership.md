---
title: "Manage Service Group membership at scale" 
description: "Learn how to create, manage, and update membership at scale"
author: kenieva
ms.author: kenieva
ms.service: azure-service-groups 
ms.topic: how-to
ms.date: 10/28/2025

---

# Manage Service Group Membership at scale

Azure **Service Groups** provide a flexible way to organize and manage resources. Membership for Service Groups are managed via the 'Microsoft.Relationship/serviceGroupMember' extension resource, which follows the lifecycle of the resource that is a member, and points to the desired Service Group via the `targetId` property. You can review the [available rest APIs](manage-service-groups.md#create-a-service-group-member) or follow the [quickstart to adding members in portal](#create-service-group-member-portal).

By automating membership and deploying service groups with defined memberships, organizations can streamline scenarios built on Service Groups. This guide provides a starting point to ease of management of memberships for one or multiple groups. 

## Sample consolidated template for creating Service Group and Members 

For organizations that deploy and managing resource lifecycles in a CI/CD fashion, it would be ideal to couple the service group and/or membership creation within the same template. This Bicep template shows the deployment of two storage accounts, a new Service Group, and adds those resources as members to the Service Group. 

>[!Note]
> To run this template, the user must have Service Group Administrator role on the parent Service Group and have storage account creation permissions at the desired scope. 

```bicep 
param serviceGroupId string = 'SGID'
param parentServiceGroupId string = 'SGParent'
//Must be owner on parentServiceGroupId to run this bicep successfully in one run
param storageCount int = 2

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' =  [for i in range(0, storageCount): {
  name: '${serviceGroupId}num${i}'
  location: 'eastus2'
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    allowSharedKeyAccess: false
  }
}]


resource sg1 'Microsoft.Management/serviceGroups@2024-02-01-preview' = {
  scope: tenant()
  name: serviceGroupId
  properties: {
    displayName: serviceGroupId
    parent: {
      resourceId: '/providers/Microsoft.Management/serviceGroups/${parentServiceGroupId}'
    }
  }
}

resource rel0 'Microsoft.Relationships/serviceGroupMember@2023-09-01-preview' = [for i in range(0, storageCount): {
  scope: storage[i]
  name: 'rel-${i}'
  properties: {
    targetId: sg1.id
  }
}]

```
 

## Using Azure Policy for automatic membership 

Often Service Group membership can be defined by a rule. Common examples are resources following a naming convention that contains `appCode` or resource having a tag with a specific `costCode` values. 

To automate the creation of service group membership, you can define an Azure Policy definition that can deploy the Service Group memberships relationships based on the rule. 

>[!Note]
> Azure Policy will not delete relationships for resources that do not meet the rule. 

```json 
{
  "properties": {
    "displayName": "Deploy Memberships for Tagged Resources",
    "policyType": "Custom",
    "mode": "Indexed",
    "description": "Deploy Microsoft.Relationships/serviceGroupMember for resources with specific tag.",
    "parameters": {
      "tagName": {
        "type": "String",
        "metadata": {
          "description": "Name of the tag to check."
        }
      },
      "tagValue": {
        "type": "String",
        "metadata": {
          "description": "Value of the tag to match."
        }
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "equals": "[parameters('tagValue')]"
          }
        ]
      },
      "then": {
        "effect": "deployIfNotExists",
        "details": {
          "type": "Microsoft.Relationships/serviceGroupMember",
          "roleDefinitionIds": [
            "/providers/Microsoft.Management/serviceGroups/{Insert SG ID}/providers/Microsoft.Authorization/roleDefinitions/32e6a4ec-6095-4e37-b54b-12aa350ba81f",
			"/subscriptions/{Insert Subscription}/providers/Microsoft.Authorization/roleDefinitions/05b1aaf9-00c9-477b-b0e8-2da660b78c51"
          ],
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
				"parameters": {
					"fullName": {
					  "type": "string"
					},
					"fullType": {
					  "type": "string"
					}
				  },
                "resources": [
                  {
                    "type": "Microsoft.Relationships/serviceGroupMember",
                    "apiVersion": "2023-09-01-preview",
                    "name": "[concat('sgm-', parameters('fullName'))]",
                    "scope": "[resourceId(subscription().subscriptionId, resourceGroup().name, parameters('fullType'), parameters('fullName'))]",
                    "properties": {
                      "targetId": "/providers/Microsoft.Management/serviceGroups/{SG-ID}",
                      "targetTenant": "{TenantID}"
                    }
                  }
                ]
              },
			  "parameters": {
				  "fullName": {
					"value": "[field('name')]"
				  },
				  "fullType": {
					"value": "[field('type')]"
				  }
				}
            }
          }
        }
      }
    }
  }
}
```


## Creating memberships based on a Resource Graph query 






## Related content
* [What are Azure Service Groups?](overview.md)
* [Review available rest APIs for Service Group Members](manage-service-groups.md#create-a-service-group-member)
* [Quickstart: Create a service group (preview) with REST API](create-service-group-rest-api.md)
* [Quickstart: Connect resources or resource containers to service groups with Service Group Member Relationships](create-service-group-member-rest-api.md)
