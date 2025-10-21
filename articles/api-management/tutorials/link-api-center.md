---
title: Create or link an API Center from the Azure portal
description: "How to create a new API Center or link an existing API Center to an API Management service from the Azure portal."
author: ProfessorKendrick
ms.author: kkendrick
ms.service: azure-api-management
ms.topic: tutorial  
ms.date: 10/20/2025

#customer intent: As an API Management administrator, I want to create or link an API Center so that I can discover, reuse, and govern APIs across linked services.

---

# Tutorial: Create or link an API Center to API Management

This tutorial shows how to integrate an Azure API Management (APIM) instance with an Azure API Center. When linked, the APIM instance's APIs — and optional API definitions — are continuously synchronized into the API Center inventory.

> [!NOTE]
> 
> Only one API Center can be linked to a single API Management instance.

In this tutorial, you:

> [!div class="checklist"]
> * Create a new API Center and link it to an API Management instance
> * Link an existing API Center and synchronize APIs
> * View synchronized APIs and remove the link if needed

## Prerequisites

- An Azure account with an active subscription is required. If you don't already have one, you can [create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account).
- An existing API Management service in the subscription where you want to manage APIs
- Contributor (or Owner) permissions on the API Management resource and permission to create resources in a resource group

## Create a new API Center and link your APIs

1. From the [Azure portal](https://portal.azure.com), open your API Management service.
1. In the left-hand menu, go to **APIs** > **API Center**.
1. In the center pane, under *Use API Center for API discovery, reuse, and governance*, select **Create new**.
1. On the *Create* API Center* page, select **Create new link**.
1. Provide values for the following fields:

    | Field | Details |
    |---|---|
    | Resource group | Select an existing resource group or create a new one. |
    | Location | Choose a region. Regions available for API Center may differ from the region of your API Management instance. |
    | Name | Provide a unique name for the API Center instance. |
    | Pricing plan | Select a plan. |
    | Lifecycle | Select the lifecycle state to associate with APIs when they're synchronized. This metadata can be changed later. |

1. Select Create. 

    - When the operation finishes, you should see a *Request succeeded* message and a confirmation that your API Management service and API Center are synchronized.

## Use an existing API Center

1. From the API Center section of your API Management service, select **Use existing API Center**.
1. From the dropdown, choose the API Center you want to link.
1. Select **Synchronize APIs** to start synchronization between the API Management service and the selected API Center.

## View linked API Center and synchronized APIs

1. In the [Azure portal](https://portal.azure.com), open the API Center resource.
2. In the API Center left-hand menu, go to **Platforms** > **Integrations**. 
    The state for the integration with API Management should say *Linked and syncing*. 
1. To view synchronized APIs, go to **Assets** > **APIs**.

## Remove a linked API Center

1. In the API Center resource, find the linked API Management instance.
1. In the left-hand menu, go to **Platforms** > **Integrations**.
2. Select the trash can icon to delete the link.

## Clean up resources

If you created an API Center for this tutorial and no longer need it, delete the API Center resource and any resource group you created to avoid charges.

