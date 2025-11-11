---
title: Exchange B2B Messages Using Workflows
description: Learn to exchange messages between partners in workflows with Azure Logic Apps and the Enterprise Integration Pack.
services: logic-apps
ms.suite: integration
author: divyaswarnkar
ms.author: divswa
ms.reviewers: estfan, azla
ms.topic: how-to
ms.date: 11/06/2025
#Customer intent: As an integration developer who works with Azure Logic Apps, I want to exchange messages between trading partners in B2B workflows.
---

# Exchange B2B messages between partners using workflows in Azure Logic Apps

[!INCLUDE [logic-apps-sku-consumption-standard](../../includes/logic-apps-sku-consumption-standard.md)]

When you have an integration account that defines trading partners and agreements, you can create an automated business-to-business (B2B) workflow that exchanges messages between trading partners by using Azure Logic Apps. Your workflow can use connectors that support industry-standard protocols, such as AS2, X12, EDIFACT, and RosettaNet. You can also include operations provided by other [connectors in Azure Logic Apps](/connectors/connector-reference/connector-reference-logicapps-connectors), such as Office 365 Outlook, SQL Server, and Salesforce.

This article creates an example logic app workflow that can receive HTTP requests by using a **Request** trigger, decode message content by using the **AS2 Decode** and **Decode X12** actions, and return a response by using the **Response** action. The example uses the workflow designer in the Azure portal. You can follow similar steps for the workflow designer in Visual Studio Code.

If you're new to logic apps, see [What is Azure Logic Apps](logic-apps-overview.md)? For more information about B2B enterprise integration, see [B2B enterprise integration workflows and Enterprise Integration Pack](logic-apps-enterprise-integration-overview.md).

## Prerequisites

- An Azure account and subscription. If you don't have a subscription, [sign up for a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- An [integration account resource](logic-apps-enterprise-integration-create-integration-account.md) where you define and store artifacts for use in your enterprise integration and B2B workflows. Artifacts include trading partners, agreements, and certificates. This resource has to meet the following requirements:

  - Is associated with the same Azure subscription as your logic app resource.

  - Exists in the same location or Azure region as your logic app resource.

  - If you're using a [Consumption Logic App](logic-apps-overview.md#resource-environment-differences), link it to your [integration account](logic-apps-enterprise-integration-create-integration-account.md#link-account).

  - If you're using a [Standard Logic App](logic-apps-overview.md#resource-environment-differences), your integration account doesn't need a link to your logic app resource. You still need one to store other artifacts, such as partners, agreements, and certificates, along with using the [AS2](logic-apps-enterprise-integration-as2.md), [X12](logic-apps-enterprise-integration-x12.md), or [EDIFACT](logic-apps-enterprise-integration-edifact.md) operations. Your integration account has to meet other requirements, such as using the same Azure subscription and existing in the same location as your logic app resource.

  > [!NOTE]
  >
  > Currently, only Consumption logic apps support [RosettaNet](logic-apps-enterprise-integration-rosettanet.md) operations.

- At least two [trading partners](logic-apps-enterprise-integration-partners.md) in your integration account. The definitions for both partners must use the same *business identity* qualifier, which is AS2, X12, EDIFACT, or RosettaNet.

- An [AS2 agreement and X12 agreement](logic-apps-enterprise-integration-agreements.md) for the partners that you're using in this workflow. Each agreement requires a host partner and a guest partner.

- A logic app resource with a blank workflow where you can add the [Request](../connectors/connectors-native-reqres.md) trigger and the following actions:

  - [AS2 Decode](../logic-apps/logic-apps-enterprise-integration-as2.md)

  - [Condition](../logic-apps/logic-apps-control-flow-conditional-statement.md), which sends a [Response](../connectors/connectors-native-reqres.md) based on whether the AS2 Decode action succeeds or fails

  - [Decode X12 message](../logic-apps/logic-apps-enterprise-integration-x12.md)

<a name="add-request-trigger"></a>

## Add the Request trigger

To start the workflow in this example, add the request trigger.

1. In the [Azure portal](https://portal.azure.com), open your logic app resource and workflow in the designer.

1. Add the **When an HTTP request is received** trigger to your workflow. To add a trigger, see [Add a trigger to start your workflow](add-trigger-action-workflow.md#add-a-trigger-to-start-your-workflow).

1. In the trigger, leave the **Request Body JSON Schema** box empty, because the trigger receives an X12 message in flat file format.

   :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/request-trigger.png" alt-text="Screenshot showing multi-tenant designer and Request trigger properties." lightbox="./media/logic-apps-enterprise-integration-b2b/request-trigger.png":::

1. When you're done, on the designer toolbar, select **Save**.

   This step generates the **HTTP POST URL** that you later use to send a request that triggers logic app workflow.

   :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/request-trigger-generated-url.png" alt-text="Screenshot showing multi-tenant designer and generated URL for Request trigger." lightbox="./media/logic-apps-enterprise-integration-b2b/request-trigger-generated-url.png":::

1. Copy and save the URL to use later.

<a name="add-decode-as2-trigger"></a>

## Add the decode AS2 action

Now add the B2B actions for this example, which uses the AS2 and X12 actions.

1. Under the trigger, follow these [general steps](add-trigger-action-workflow.md#add-action) to add the action **AS2 Decode**.

1. In the action's **Message to decode** property, enter the input that you want the AS2 action to decode, which is the `body` output from the Request trigger. You can specify this content as the action's input either by selecting from the dynamic content list or as an expression:

   - To select from a list that shows the available trigger outputs, select inside the **Message to decode** box. Then select the lightning icon to open the dynamic content list. Under **When an HTTP request is received**, select **Body** property value:

     :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/select-trigger-output-body.png" alt-text="Screenshot showing multi-tenant designer with dynamic content list and Body property selected." lightbox="./media/logic-apps-enterprise-integration-b2b/select-trigger-output-body.png":::

     > [!TIP]
     >
     > If no trigger outputs appear, in the dynamic property list, under **When an HTTP request is received**, select **See more**.

   - To enter an expression that references the trigger's `body` output, select inside the **Message to decode** box. Then select the expression icon. In the expression editor, enter the following expression, and select **Add**:

     `triggerOutputs()['body']`

     Or, in the **Message to decode** box, directly enter the following expression:

     `@triggerBody()`

1. In the action's **Message headers** property, enter any headers required for the AS2 action, which are in the `headers` output from the request trigger.

   1. To enter an expression that references the trigger's `headers` output, select **Switch Message headers to text mode**.

      :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/switch-text-mode.png" alt-text="Screenshot showing multi-tenant designer with Switch Message headers to text mode selected." lightbox="./media/logic-apps-enterprise-integration-b2b/switch-text-mode.png":::

   1. Select inside the **Message headers** box. Select the Expression icon. In the expression editor, enter the following expression, and select **Add**:

      `triggerOutputs()['Headers']`

      :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/header-expression.png" alt-text="Screenshot showing multi-tenant designer and the Message headers box with the @triggerOutputs()['Headers'] token." lightbox="./media/logic-apps-enterprise-integration-b2b/header-expression.png":::

   1. To get the expression token to resolve into the Headers token, in the designer menu, select **Code view**, then select **Designer**.

<a name="add-response-action"></a>

## Add the Response action as a message receipt

You can notify the trading partner that the message was received. Return a response that contains an AS2 Message Disposition Notification (MDN) by using the Condition and Response actions. If you add these actions immediately after the AS2 action, the logic app workflow can continue processing if the AS2 action succeeds. Otherwise, if the AS2 action fails, the logic app workflow stops processing.

1. On the workflow designer, under the **AS2 Decode** action, follow these [general steps](add-trigger-action-workflow.md#add-action) to add the built-in **Condition** action.

   The condition shape appears, including the paths that determine whether the condition is met.

   :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/added-condition-action.png" alt-text="Screenshot showing multi-tenant designer and the condition shape with empty paths.":::

1. Specify the condition to evaluate. In the **Choose a value** box, enter the following expression:

   `@body('AS2_Decode')?['AS2Message']?['MdnExpected']`

   In the middle box, make sure the comparison operation is set to `=` (the equal sign). In the right-side box, enter the value `Expected`.

1. Save your logic app workflow.

   :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/evaluate-condition-expression.png" alt-text="Screenshot showing multi-tenant designer and the condition shape with an operation.":::

1. Specify the responses to return based on whether the **AS2 Decode** action succeeds or not.

   1. For the case when the **AS2 Decode** action succeeds, in the **True** shape, select **Add an action**. Under the **Choose an operation** search box, enter `response`, and select **Response**.

   1. To access the AS2 MDN from the **AS2 Decode** action's output, specify the following expressions:

      - In the **Response** action's **Headers** property, enter the following expression:

        `@body('AS2_Decode')?['OutgoingMdn']?['OutboundHeaders']`

      - In the **Response** action's **Body** property, enter the following expression:

        `@body('AS2_Decode')?['OutgoingMdn']?['Content']`

      :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/response-success-resolved-expression.png" alt-text="Screenshot showing multi-tenant designer and resolved expression to access AS2 MDN.":::

   1. For the case when the **AS2 Decode** action fails, in the **False** shape, select **Add an action**. Under the **Choose an operation** search box, enter `response`, and select **Response**. Set up the **Response** action to return the status and error that you want.

1. Save your logic app workflow.

<a name="add-decode-x12-action"></a>

## Add the decode X12 message action

Now add the **Decode X12 message** action.

1. On the workflow designer, under the **Response** action, follow these [general steps](add-trigger-action-workflow.md#add-action) to add the **Decode X12 message** action.

1. If the X12 action prompts you for connection information, provide the name for the connection, select the integration account you want to use, and then select **Create**.

1. Specify the input for the X12 action. This example uses the output from the AS2 action, which is the message content but note that this content is in JSON object format and is base64 encoded. You have to convert this content to a string.

   In the **X12 Flat file message to decode** box, enter the following expression to convert the AS2 output:

   `@base64ToString(body('AS2_Decode')?['AS2Message']?['Content'])`

1. Save your logic app workflow.

   To get the expression to resolve as this token, switch between code view and designer view. In the designer menu, select **Code view**, then select **Designer**.

If you need more steps for this logic app workflow, for example, to decode the message content and output that content in JSON object format, continue adding the necessary actions to your logic app workflow.

You're done setting up your B2B logic app workflow. In a real world app, you might want to store the decoded X12 data in a line-of-business (LOB) app or data store. For example, review the following documentation:

- [Connect to SAP systems from Azure Logic Apps](logic-apps-using-sap-connector.md)
- [Monitor, create, and manage SFTP files by using SSH and Azure Logic Apps](../connectors/connectors-sftp-ssh.md)

To connect your own LOB apps and use these APIs in your logic app, you can add more actions or [write custom APIs](logic-apps-create-api-app.md).

## Related content

- [Receive and respond to incoming HTTPS calls](../connectors/connectors-native-reqres.md)
- [Exchange AS2 messages for B2B enterprise integration](../logic-apps/logic-apps-enterprise-integration-as2.md)
- [Exchange X12 messages for B2B enterprise integration](../logic-apps/logic-apps-enterprise-integration-x12.md)
- Learn more about the [Enterprise Integration Pack](../logic-apps/logic-apps-enterprise-integration-overview.md)
