---
title: Manage Artifact Metadata in Integration Accounts
description: You can add metadata to an integration account artifact. Learn how to use that metadata in an Azure Logic App workflow.
services: logic-apps
ms.suite: integration
author: divyaswarnkar
ms.author: divswa
ms.reviewers: estfan, azla
ms.topic: how-to
ms.date: 11/12/2025
ms.custom: sfi-image-nochange
#Customer intent: As an Azure Logic Apps developer, I want to define custom metadata for integration account artifacts so that my logic app workflow can use that metadata.
---

# Manage artifact metadata in integration accounts for Azure Logic Apps

[!INCLUDE [logic-apps-sku-consumption-standard](../../includes/logic-apps-sku-consumption-standard.md)]

You can define custom metadata for artifacts in integration accounts. Your Azure Logic Apps workflows can use that metadata at runtime. For example, you can provide metadata for artifacts, such as partners, agreements, schemas, and maps. These artifact types store metadata as key-value pairs. 

This article shows you how to add metadata to an integration account artifact and how to use these values in a workflow.

## Prerequisites

- An Azure account and subscription. If you don't have a subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- An [integration account](logic-apps-enterprise-integration-create-integration-account.md) that has the artifacts where you want to add metadata. The artifacts can be the following types:

  - [Partner](logic-apps-enterprise-integration-partners.md)
  - [Agreement](logic-apps-enterprise-integration-agreements.md)
  - [Schema](logic-apps-enterprise-integration-schemas.md)
  - [Map](logic-apps-enterprise-integration-maps.md)

- The logic app workflow where you want to use the artifact metadata. Your workflow must have a trigger, such as the **Request** or **HTTP** trigger, and an action to use for working with artifact metadata.

  This article uses the **Request** trigger named **When an HTTP request is received**.   For more information, see:

  - [Create a Consumption logic app workflow in Azure Logic Apps](quickstart-create-example-consumption-workflow.md)
  - [Create a Standard logic app workflow in Azure Logic Apps](create-single-tenant-workflows-azure-portal.md)

- Link your integration account to your [Consumption logic app resource](logic-apps-enterprise-integration-create-integration-account.md?tabs=azure-portal%2Cconsumption#link-account) or to your [Standard logic app workflow](logic-apps-enterprise-integration-create-integration-account.md?tabs=azure-portal%2Cstandard#link-account).

## Add metadata to artifacts

1. In the [Azure portal](https://portal.azure.com), go to your integration account.

1. Select the artifact where you want to add metadata, and then select **Edit**. 

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/edit-partner-metadata.png" alt-text="Screenshot of Azure portal, integration account, and Partners page with TradingPartner1 and Edit button selected.":::

1. Enter the metadata details for that artifact, and then select **OK**. The following screenshot shows three metadata key-value pairs:

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/add-partner-metadata.png" alt-text="Screenshot of the Edit pane for TradingPartner1, with three key-value pairs highlighted and OK selected.":::

1. To view this metadata in JavaScript Object Notation (JSON) definition, select **Edit as JSON**.

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/partner-metadata.png" alt-text="Screenshot of the JSON code that contains information about TradingPartner1, with three key-value pairs highlighted.":::

## Use artifact metadata

1. In the [Azure portal](https://portal.azure.com), open your logic app resource and workflow in the designer. This logic app resource is linked to your integration account.

1. In the designer, follow these [general steps](create-workflow-with-trigger-or-action.md#add-action) to add the **Integration Account Artifact Lookup** action to get the metadata.

1. Provide the following information for the artifact that you want to find:

   | Property | Required | Value | Description |
   |----------|----------|-------|-------------|
   | **artifactName** | Yes | <*artifact-name*> | The name for the artifact you want to get |
   | **artifactType** | Yes | **Schema**, **Map**, **Partner**, **Agreement**, or a custom type | The type for the artifact you want to get |

   This example gets the metadata for a trading partner artifact.

1. For **artifactName**, select inside the edit box. Select the lightning icon to open the dynamic content list. Then select the **Name** output from the trigger.

1. For **artifactType**, select **Partner**.

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/artifact-lookup-information.png" alt-text="Screenshot of the Integration Account Artifact Lookup action with the artifact type and artifact name properties highlighted.":::

1. Use the same [general steps](create-workflow-with-trigger-or-action.md#add-action) to add an action to use the metadata. This example continues with the built-in **HTTP** action.

1. Provide the following information for the artifact metadata that you want the HTTP action to use.

   For example, suppose you want to get the `routingUrl` metadata that you added earlier. Here are the property values that you might specify: 

   | Property | Required | Value | Description | Example value |
   |----------|----------|-------|-------------|---------------|
   | **URI** | Yes | <*metadata-location*> | The endpoint where you want to send the outgoing request. | To refer to the `routingUrl` metadata value from the artifact that you retrieved, follow these steps: <br><br>1. Select inside the **URI** box. <br><br>2. Select the expressions icon. <br><br>3. In the expression editor, enter an expression like the following example:<br><br>`outputs('Integration_Account_Artifact_Lookup')['properties']['metadata']['routingUrl']` <br><br>4. When you're done, select **Add**. |
   | **Method** | Yes | <*operation-to-run*> | The HTTP operation to run on the artifact. | Use the **GET** method for this HTTP action. |
   | **Headers** | No | <*header-values*> | Any header outputs from the trigger that you want to pass to the HTTP action. | To pass in the `Content-Type` value from the trigger header, follow these steps for the first row under **Headers**: <br><br>1. In the first column, enter `Content-Type` as the header name. <br><br>2. In the second column, use the expression editor to enter the following expression as the header value: <br><br>`triggeroutputs()['headers']['Content-Type']` <br><br>To pass in the `Host` value from the trigger header, follow these steps for the second row under **Headers**: <br><br>1. In the first column, enter `Host` as the header name. <br><br>2. In the second column, use the expression editor to enter the following expression as the header value: <br><br>`triggeroutputs()['headers']['Host']` |
   | **Body** | No | <*body-content*> | Any other content that you want to pass through the HTTP action's `body` property. | To pass the artifact's `properties` values to the HTTP action: <br><br>1. Select inside the **Body** box and then select the lightning icon to open the dynamic content list. If no properties appear, select **See more**. <br><br>2. From the dynamic content list, under **Integration Account Artifact Lookup**, select **Properties**. |

   The following screenshot shows the example values:

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/add-http-action-values.png" alt-text="Screenshot of the designer with an HTTP action, with some property values highlighted and the dynamic content list open with Properties highlighted.":::

1. To check the information that you provided for the HTTP action, you can view your workflow's JSON definition. On the designer toolbar, select **Code view**.

   The workflow's JSON definition appears, as shown in the following example:

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/finished-http-action-definition.png" alt-text="Screenshot of the HTTP action's JSON definition with the body, headers, method, and URI properties highlighted.":::

1. On the code view toolbar, select **Designer**.

   Any expressions that you entered in the designer now appear resolved.

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/resolved-expressions.png" alt-text="Screenshot of the designer with the URI, Headers, and Body expressions now resolved.":::

## Related content

- [Add agreements between partners](logic-apps-enterprise-integration-agreements.md)
