---
title: Encode or Decode Flat Files
description: Learn how to exchange XML content in a business-to-business context in workflows for Azure Logic Apps.
services: logic-apps
ms.suite: integration
author: divyaswarnkar
ms.author: divswa
ms.reviewers: estfan, azla
ms.topic: how-to
ms.date: 01/10/2024
ms.custom: sfi-image-nochange
#Customer intent: As an integration developer who works with Azure Logic Apps, I want to exchange XML content between trading partners in B2B workflows.
---

# Encode and decode flat files in Azure Logic Apps

[!INCLUDE [logic-apps-sku-consumption-standard](../../includes/logic-apps-sku-consumption-standard.md)]

Before you send XML content to a business partner in a business-to-business (B2B) scenario, you might want to encode that content. If you receive encoded XML content, you need to decode that content. When you build a logic app workflow in Azure Logic Apps, you can encode and decode flat files by using the **Flat File** built-in connector actions and a flat file schema for encoding and decoding. You can use **Flat File** actions in multitenant Consumption logic app workflows and single-tenant Standard logic app workflows.

There are no **Flat File** triggers are available. You can use any trigger or action to feed the source XML content into your workflow. For example, you can use a built-in connector trigger, a managed or Azure-hosted connector trigger available for Azure Logic Apps, or even another app.

This article shows how to add the **Flat File** encoding and decoding actions to your workflow.

- Add a **Flat File** encoding or decoding action to your workflow.
- Select the schema that you want to use.

For more information, see:

- [Consumption versus Standard logic apps](logic-apps-overview.md#resource-environment-differences)
- [Integration account built-in connectors](../connectors/built-in.md#b2b-built-in-operations)
- [Built-in connectors overview for Azure Logic Apps](../connectors/built-in.md)
- [Managed or Azure-hosted connectors in Azure Logic Apps](/connectors/connector-reference/connector-reference-logicapps-connectors)

## Prerequisites

- An Azure account and subscription. If you don't have a subscription, [sign up for a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- Your logic app resource and workflow. **Flat File** operations don't offer any triggers. Your workflow has to include a trigger. This article uses the **Request** trigger. For more information, see:

  - [Create a Consumption logic app workflow using the Azure portal](quickstart-create-example-consumption-workflow.md)

  - [Create a Standard logic app workflow using the Azure portal](create-single-tenant-workflows-azure-portal.md)

- A flat file schema for encoding and decoding the XML content. For more information, [Add schemas to use with workflows with Azure Logic Apps](logic-apps-enterprise-integration-schemas.md).

- Based on whether you're working on a Consumption or Standard logic app workflow, you need an [integration account resource](logic-apps-enterprise-integration-create-integration-account.md). Usually, you need this resource when you want to define and store artifacts for use in enterprise integration and B2B workflows.

  > [!IMPORTANT]
  >
  > To work together, both your integration account and logic app must exist in the same Azure subscription and Azure region.

  - If you're working on a Consumption logic app workflow, your logic app resource requires a [link to your integration account](logic-apps-enterprise-integration-create-integration-account.md?tabs=consumption#link-account).

  - If you're working on a Standard logic app workflow, you can link your logic app resource to your integration account, upload schemas directly to your logic app, or both:

    - If you already have an integration account with the artifacts to use, you can link your integration account to multiple Standard logic app resources where you want to use the artifacts. That way, you don't have to upload schemas to each individual logic app. For more information, see [Link your logic app resource to your integration account](logic-apps-enterprise-integration-create-integration-account.md?tabs=standard#link-account).

    - The **Flat File** built-in connector lets you select a schema that you previously uploaded to your logic app or to a linked integration account, but not both. You can then use this artifact across all child workflows in the same logic app.

    If you don't have or need an integration account, you can use the upload option. Otherwise, you can use the linking option. Either way, you can use these artifacts across all child workflows in the same logic app resource.

[!INCLUDE [api-test-http-request-tools-bullet](../../includes/api-test-http-request-tools-bullet.md)]

## Limitations

- XML content that you want to decode must be encoded in UTF-8 format.

- In your flat file schema, make sure the contained XML groups don't have excessive numbers of the `max count` property set to a value *greater than 1*. Avoid nesting an XML group with a `max count` property value greater than 1 inside another XML group with a `max count` property greater than 1.

- When Azure Logic Apps parses the flat file schema, and whenever the schema allows the choice of the next fragment, Azure Logic Apps generates a *symbol* and a *prediction* for that fragment. If the schema allows too many constructs, for example, more than 100,000, the schema expansion becomes very large, which consumes too much resources and time.

## Upload schema

After you create your schema, upload the schema based on the following scenario:

- If you're working on a Consumption logic app workflow, [add your schema to your integration account](logic-apps-enterprise-integration-schemas.md?tabs=consumption#add-schema).

- If you're working on a Standard logic app workflow, you can [add your schema to your integration account](logic-apps-enterprise-integration-schemas.md?tabs=consumption#add-schema), or [add your schema to your logic app resource](logic-apps-enterprise-integration-schemas.md?tabs=standard#add-schema).

## Add a flat file encoding action

1. In the [Azure portal](https://portal.azure.com), open your logic app resource and workflow in the designer.

1. If your workflow doesn't have a trigger or any other actions that your workflow needs, add those operations first. Flat file operations don't have any triggers available.

   This example uses the **Request** trigger named **When an HTTP request is received**. To add a trigger, see [Add a trigger to start your workflow](/add-trigger-action-workflow.md#add-a-trigger-to-start-your-workflow).

1. On the workflow designer, follow these [general steps](add-trigger-action-workflow.md#add-action) to add the built-in action **Flat File Encoding**.

1. In the action's **Content** property, provide the output from the trigger or a previous action that you want to encode by following these steps:

   1. Select inside the **Content** box, then select the lightning icon to open the dynamic content list.

   1. From the dynamic content list, select the flat file content that you want to encode.
   
      For this example, from the dynamic content list, under **When an HTTP request is received**, select the **Body** token, which is the body content output from the trigger.

   :::image type="content" source="./media/logic-apps-enterprise-integration-flatfile/select-content-to-encode-consumption.png" alt-text="Screenshot showing the workflow designer and Content property with dynamic content list and content selected for encoding.":::

   > [!NOTE]
   >
   > If the **Body** property doesn't appear in the dynamic content list, select **See more** next to the **When an HTTP request is received** section label. You can also directly enter the content to encode in the **Content** box.

1. From the **Schema Name** list, select your schema.

   :::image type="content" source="./media/logic-apps-enterprise-integration-flatfile/select-encoding-schema-consumption.png" alt-text="Screenshot showing Consumption workflow designer and opened "Schema Name" list with selected schema for encoding.":::

   > [!NOTE]
   >
   > If the schema list is empty, the cause might be:
   >
   > - Your logic app resource isn't linked to your integration account.
   > - Your integration account doesn't contain any schema files.
   > - Your logic app resource doesn't contain any schema files (Standard Logic Apps only).

1. To add other optional parameters to the action, select those parameters from the **Advanced parameters** list.

   | Parameter | Value | Description |
   |-----------|-------|-------------|
   | **Mode of empty node generation** | **ForcedDisabled** or **HonorSchemaNodeProperty** or **ForcedEnabled** | The mode to use for empty node generation with flat file encoding. <br><br>For BizTalk, the flat file schema has a property that controls empty node generation. You can follow the empty node generation property behavior for your flat file schema. Alternatively, you can use this setting to have Azure Logic Apps generate or omit empty nodes. For more information, see [Tags for empty elements](https://www.w3.org/TR/xml/#dt-empty). |
   | **XML Normalization** | **Yes** or **No** | The setting to enable or disable XML normalization in flat file encoding. For more information, see [XmlTextReader.Normalization](/dotnet/api/system.xml.xmltextreader.normalization). |

1. Save your workflow. On the designer toolbar, select **Save**.

## Add a flat file decoding action

1. In the [Azure portal](https://portal.azure.com), open your logic app resource and workflow in the designer.

1. If your workflow doesn't have a trigger or any other actions that your workflow needs, add those operations first. Flat file operations don't have any triggers available.

   This example uses the **Request** trigger named **When an HTTP request is received**. To add a trigger, see [Add a trigger to start your workflow](/add-trigger-action-workflow.md#add-a-trigger-to-start-your-workflow).

1. On the workflow designer, follow these [general steps](add-trigger-action-workflow.md#add-action) to add the built-in action **Flat File Decoding**.

1. In the action's **Content** property, provide the output from the trigger or a previous action that you want to decode by following these steps:

   1. Select inside the **Content** box, then select the lightning icon to open the dynamic content list.

   1. From the dynamic content list, select the flat file content that you want to decode.
   
      For this example, from the dynamic content list, under **When an HTTP request is received**, select the **Body** token, which represents the body content output from the trigger.

   :::image type="content" source="./media/logic-apps-enterprise-integration-flatfile/select-content-to-decode-consumption.png" alt-text="Screenshot showing the Consumption workflow designer and "Content" property with dynamic content list and content selected for decoding.":::

   > [!NOTE]
   >
   > If the **Body** property doesn't appear in the dynamic content list, select **See more** next to the **When an HTTP request is received** section label. You can also directly enter the content to encode in the **Content** box.

1. From the **Schema Name** list, select your schema.

   :::image type="content" source="./media/logic-apps-enterprise-integration-flatfile/select-decoding-schema-consumption.png" alt-text="Screenshot showing Consumption workflow designer and opened "Schema Name" list with selected schema for decoding.":::

   > [!NOTE]
   >
   > If the schema list is empty, the cause might be:
   >
   > - Your logic app resource isn't linked to your integration account.
   > - Your integration account doesn't contain any schema files.
   > - Your logic app resource doesn't contain any schema files (Standard Logic Apps only).

1. Save your workflow. On the designer toolbar, select **Save**.

You're now done with setting up your flat file decoding action. In a real world app, you might want to store the decoded data in a line-of-business (LOB) app, such as Salesforce. Or, you can send the decoded data to a trading partner. To send the output from the decoding action to Salesforce or to your trading partner, use the other connectors available in Azure Logic Apps:

- [Managed connectors in Azure Logic Apps](../connectors/managed.md)
- [Built-in connectors in Azure Logic Apps](../connectors/built-in.md)

## Test your workflow

To trigger your workflow, follow these steps:

1. In the **Request** trigger, find the **HTTP POST URL** property, and copy the URL.

1. Open your HTTP request tool and use its instructions to send an HTTP request to the copied URL, including the method that the **Request** trigger expects.

   This example uses the `POST` method with the URL.

1. Include the XML content that you want to encode or decode in the request body.

1. After your workflow finishes running, go to the workflow's run history, and examine the **Flat File** action's inputs and outputs.

## Related content

- Learn more about the [Enterprise Integration Pack](logic-apps-enterprise-integration-overview.md)
