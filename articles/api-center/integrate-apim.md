---
title: Integrate an API Management instance with Azure API Center
description: Integrate an Azure API Management instance so its APIs are continuously synchronized into an API Center inventory.
author: ProfessorKendrick
ms.author: kkendrick
ms.service: azure-api-center
ms.topic: tutorial
ms.date: 10/01/2025
customer_intent: "As an API program manager, I want to integrate my Azure API Management instance with my API center and synchronize API Management APIs to my inventory."

---
# Tutorial: Integrate an API Management instance with Azure API Center

This tutorial shows how to integrate an Azure API Management (APIM) instance with an Azure API Center so that the APIM instance's APIs and optional API definitions are continuously synchronized into your API Center inventory.

In this tutorial, you:

> [!div class="checklist"]
>
> * Enable and configure the API Center managed identity and grant it the API Management Service Reader role
> * Integrate an API Management instance using the Azure portal
> * Integrate an API Management instance using the Azure CLI
> * Verify that APIs are synchronized and learn how to clean up the integration

If you don't have an Azure subscription, create a free trial account before you begin.

## Prerequisites

* An Azure subscription.  If you don't have one, you can [create a free trial](https://azure.microsoft.com/free).

* An API center in your Azure subscription. If you haven't created one, see [Quickstart: Create your API center](set-up-api-center.md).

* An Azure API Management instance in the same directory (tenant). The instance can be in the same or a different subscription.

## Open Azure Cloud Shell

Use Azure Cloud Shell in the [Azure portal](https://portal.azure.com).

## 1. Enable managed identity and assign the API Management Service Reader role

Azure API Center uses a managed identity to read APIs from your API Management instance. If your API Center doesn't already have a managed identity with the required permissions, you can configure one during integration or manually.

1. If you need guidance to enable a managed identity, see: [!INCLUDE [enable-managed-identity](includes/enable-managed-identity.md)]

2. Assign the managed identity the Service Reader role for the API Management instance.

## 2. Integrate an API Management instance

You can integrate an API Management instance from the Azure portal or with the Azure CLI. Integration creates an environment in your API center and synchronizes APIs (and optionally API definitions) from APIM into your API center inventory.

1. In the [Azure portal](https://portal.azure.com), open your API center.

1. Under **Platforms**, select **Integrations**.

1. Select **+ New integration** > **From Azure API Management**.

1. On the **Integrate your Azure API Management Service** page:

   1. Choose whether to synchronize all APIs from the API Management instance or only APIs in a specific API Management workspace.

   1. Select the **Subscription**, **Resource group**, and **Azure API Management service** to integrate. If you choose to synchronize only a workspace, select it in **Choose a workspace**.

   1. In **Integration details**, provide an identifier (integration name). If you haven't configured a managed identity with access to the API Management instance, enable **Automatically configure managed identity and assign permissions** to let API Center configure the system-assigned managed identity and assign the required role automatically.

   1. In **Environment details**, enter an **Environment title**, set **Environment type** to **Azure API Management**, and optionally add a **Description**.

   1. In **API Details**, choose a **Lifecycle** for the synchronized APIs and optionally select **Include API definitions** to also synchronize API specs.

1. Select **Create**.

After creation, the APIM instance is represented as an environment in your API center and its APIs are added to the inventory.


>[!NOTE]
>
> * Provide the APIM instance name when it's in the same resource group as the API center; otherwise provide the full resource ID for the APIM instance.
>
> * To include API definitions during integration, add the appropriate CLI flag as documented in the apic CLI reference.

## 3. Verify synchronization

After integration, APIs from the integrated APIM instance appear in your API center inventory. Synchronization is one-way from APIM to API Center. Changes in APIM—such as new APIs, updated APIs, or deleted APIs—are synchronized to your API center automatically. Synchronization usually completes within minutes but can take up to 24 hours.

To verify:

* In the API center portal, open **Inventory** and filter by the environment you created for the APIM integration.

* Make a small change in the APIM instance (for example, create or update an API) and confirm the change appears in the API center inventory after synchronization.

## Clean up resources

If you want to remove the integration and stop synchronization, delete the integration from your API center. 

## Related content

* [Import APIs from API Management to your Azure API center (one-time import)](import-api-management-apis.md)

* [Azure API Management documentation](../api-management/index.yml)

