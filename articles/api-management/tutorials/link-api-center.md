---
title: Create or link an API Center from the Azure portal
description: "How to create a new API Center or link an existing API Center to an API Management service from the Azure portal."
author: ProfessorKendrick
ms.author: kkendrick
ms.service: api-management
ms.topic: tutorial  
ms.date: 10/20/2025

#customer intent: As an API Management administrator, I want to create or link an API Center so that I can discover, reuse, and govern APIs across linked services.

---

# Tutorial: Create or link an API Center to API Management

This tutorial shows how to integrate an Azure API Management (APIM) instance with an Azure API Center. When linked, the APIM instance's APIs — and optional API definitions — are continuously synchronized into the API Center inventory.

If you do not have an Azure subscription, create a free trial account before you begin. If you do not have an API Center, see the API Center quickstart.

In this tutorial, you:

> [!div class="checklist"]
> * Create a new API Center and link it to an API Management instance
> * Link an existing API Center and synchronize APIs
> * View synchronized APIs and remove the link if needed

## Prerequisites

- An Azure subscription
- An existing API Management service in the subscription and region where you want to manage APIs
- Contributor (or Owner) permissions on the API Management resource and permission to create resources in a resource group

## Create a new API Center and link your APIs

1. From the [Azure portal](https://portal.azure.com), open your API Management service.
1. In the left-hand menu, expand the APIs section and select **API Center**.
1. In the center pane, under Use API Center for API discovery, reuse, and governance, select **Create new**.
1. On the Create API Center page, select Create new link.
1. Provide values for the following fields:

| Field | Details |
|---|---|
| Resource group | Select an existing resource group or create a new one. |
| Instance details — Location | Choose a region. Regions available for API Center may differ from the region of your API Management instance. |
| Instance details — Name | Provide a unique name for the API Center instance. |
| Instance details — Pricing plan | Select a plan. |
| API details — Lifecycle | Select the lifecycle state to associate with APIs when they are synchronized. This metadata can be changed later. |

1. Select Create. 

    - The API Center is created and the API Management service starts synchronizing APIs with the linked API Center.
    - When the operation finishes, you should see a *Request succeeded* message and a confirmation that your API Management service and API Center are synchronized.

Discover, reuse, or govern APIs in the linked API Center service.

> [!NOTE]
> 
> A 1:1 relationship exists — only one API Center can be linked to a single API Management instance.

## Use an existing API Center

1. From the API Center section of your API Management service, select **Use existing API Center**.
1. From the dropdown, choose the API Center you want to link.
1. Select **Synchronize APIs** to start synchronization between the API Management service and the selected API Center.

## View linked API Center and synchronized APIs

1. In the [Azure portal](https://portal.azure.com), open the API Center resource.
2. In the API Center left-hand menu, go to **Platforms** > **Integrations**. The state for the integration with API Management should say *Linked and syncing*. 
3. To view synchronized APIs, go to **Assets** > **APIs**.

## Remove a linked API Center

1. In the API Center resource or from the API Management > API Center page, find the linked API Center.
2. Select the trash can icon to delete the link (or delete the API Center resource if you no longer need it).

## Clean up resources

If you created an API Center for this tutorial and no longer need it, delete the API Center resource and any resource group you created to avoid charges.

## Next steps

