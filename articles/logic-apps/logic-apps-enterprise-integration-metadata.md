---
title: Manage Metadata for B2B Artifacts
description: Learn to add metadata for B2B artifacts such as trading partners and agreements in integration accounts. Learn to use this metadata with workflows in Azure Logic Apps.
services: logic-apps
ms.suite: integration
author: divyaswarnkar
ms.author: divswa
ms.reviewers: estfan, azla
ms.topic: how-to
ms.date: 12/03/2025
ms.custom: sfi-image-nochange
#Customer intent: As an integration developer who works with Azure Logic Apps, I want to define custom metadata for B2B artifacts in an integration account so my workflow can more easily identify and find the correct artifacts using this metadata.
---

# Manage and use B2B artifact metadata in workflows for Azure Logic Apps

[!INCLUDE [logic-apps-sku-consumption-standard](../../includes/logic-apps-sku-consumption-standard.md)]

To help workflows quickly find the correct business-to-business (B2B) artifacts to use at runtime, you can add custom metadata as key-value pairs to artifacts such as trading partners, agreements, schemas, and maps. Custom metadata for artifacts help accomplish the following goals or tasks:

- Enforce naming conventions.
- Support reuse and avoid duplicate definitions.
- Route payloads to the correct encode or decode steps.
- Provide more control over moving artifacts through development, test, and production.
- Apply the correct validation or transformation without harcoded logic.
- Facilitate tracking, traceability, governance, and auditing.
- Ease migration from BizTalk Server to Azure Logic Apps.

The following list describes example useful metadata, based on artifact type:

| Artifact | Metadata |
|----------|----------|
| Partner | - Business identity such as AS2, X12, or EDIFACT <br>- Trading name <br>- Contact and support information <br>- Certificate thumbprints <br>- Allowed protocols <br>- Expected acknowledgments such as MDN, TA1, or 997 |
| Agreement | - Host and guest partners <br>- Encryption or signature policies <br>- Retry and timeout rules <br>- Content type <br>- Batching settings <br>- Acknowledgment behavior |
| Schemas and maps | - Message type <br>- Version <br>- Namespace <br>- Source control URL <br>- Change notes <br>- Compatibility matrix for which agreements or workflows consume these artifacts |

For tracking purposes and feeding B2B tracking tables or dashboards, useful metadata includes correlation properties such as interchange number, group number, transaction set ID as well as workflow run ID, partner and agreement IDs, status, and timestamps.

This guide shows how to add metadata to an artifact and get that metadata for your workflow by using the **Integration Account Artifact Lookup** built-in action.

## Prerequisites

- An Azure account and subscription. [Get a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- The logic app resource and workflow where you want to get and use the artifact metadata.

  Your workflow can start with any trigger and needs an action that works with the metadata after retrieval. This example uses the **Request** trigger named **When an HTTP request is received**.
  
  For more information, see:

  - [Create a Consumption workflow in Azure Logic Apps](quickstart-create-example-consumption-workflow.md)

  - [Create a Standard workflow in Azure Logic Apps](create-single-tenant-workflows-azure-portal.md)

- An [integration account resource](enterprise-integration/create-integration-account.md) that contains the artifacts where you want to add metadata.

  - Both your integration account and logic app resource must exist in the same Azure subscription and Azure region.

  You can add custom metadata to the following artifacts:

  - [Partner](logic-apps-enterprise-integration-partners.md)
  - [Agreement](logic-apps-enterprise-integration-agreements.md)
  - [Schema](logic-apps-enterprise-integration-schemas.md)
  - [Map](logic-apps-enterprise-integration-maps.md)

  - Before you start working with the **Integration Account Artifact Lookup** action, you must [link your Consumption logic app](enterprise-integration/create-integration-account.md?tabs=consumption#link-account) or [link your Standard logic app](enterprise-integration/create-integration-account.md?tabs=standard#link-account) to the integration account. You can link an integration account to multiple Consumption or Standard logic app resources to share the same artifacts.

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

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/artifact-lookup-information.png" alt-text="Screenshot of the Integration Account Artifact Lookup action with the artifact type and artifact name properties highlighted." lightbox="media/logic-apps-enterprise-integration-metadata/artifact-lookup-information.png":::

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

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/add-http-action-values.png" alt-text="Screenshot of the designer with an HTTP action, with some property values highlighted and the dynamic content list open with Properties highlighted." lightbox="media/logic-apps-enterprise-integration-metadata/add-http-action-values.png":::

1. To check the information that you provided for the HTTP action, you can view your workflow's JSON definition. On the designer toolbar, select **Code view**.

   The workflow's JSON definition appears, as shown in the following example:

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/finished-http-action-definition.png" alt-text="Screenshot of the HTTP action's JSON definition with the body, headers, method, and URI properties highlighted." lightbox="media/logic-apps-enterprise-integration-metadata/finished-http-action-definition.png":::

1. On the code view toolbar, select **Designer**.

   Any expressions that you entered in the designer now appear resolved.

   :::image type="content" source="media/logic-apps-enterprise-integration-metadata/resolved-expressions.png" alt-text="Screenshot of the designer with the URI, Headers, and Body expressions now resolved.":::

## Related content

- [Add agreements between partners](logic-apps-enterprise-integration-agreements.md)
