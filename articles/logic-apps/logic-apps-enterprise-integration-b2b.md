---
title: Automate B2B Messages Between Partners
description: Learn to exchange business-to-business (B2B) messages between trading partners using workflows in Azure Logic Apps. Follow protocols like AS2, X12, EDIFACT, and RosettaNet.
services: logic-apps
ms.suite: integration
author: divyaswarnkar
ms.author: divswa
ms.reviewers: estfan, azla
ms.topic: how-to
ms.date: 12/02/2025
#Customer intent: As an integration developer who works with Azure Logic Apps, I want to exchange messages between trading partners in B2B workflows.
---

# Automate B2B messages between trading partners using workflows in Azure Logic Apps

[!INCLUDE [logic-apps-sku-consumption-standard](../../includes/logic-apps-sku-consumption-standard.md)]

For business-to-business (B2B) integrations, you can automate communication between trading partners by building workflows with B2B artifacts and industry-standard protocols in Azure Logic Apps.

For example, you can create an integration account to define artifacts such as trading partners, agreements, maps, and schemas. Workflows support protocols such as AS2, X12, EDIFACT, and RosettaNet. Create end-to-end integrations by combining these B2B capabilities with [1,400+ connectors available in Azure Logic Apps](/connectors/connector-reference/connector-reference-logicapps-connectors), such as Office 365 Outlook, SQL Server, and Salesforce.

This guide shows how to create an example B2B workflow that can complete the following tasks:

- Receive HTTPS requests with the **Request** trigger named **When an HTTP request is received**.
- Decode incoming message content with the **AS2 (v2)** decode action and the **X12** decode action.
- Return a response to the caller with the **Response** action.

## Prerequisites

- An Azure account and subscription. [Get a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- The logic app resource and blank workflow where you want to build the B2B integration in this example.

  The **AS2 (v2)** and **X12** operations don't include any triggers. Your workflow can start with any trigger or use any action to receive messages.

  The examples in this article use the **Request** trigger named **When an HTTP request is received**.

  For more information, see:

  - [Create a Consumption logic app workflow using the Azure portal](quickstart-create-example-consumption-workflow.md)

  - [Create a Standard logic app workflow using the Azure portal](create-single-tenant-workflows-azure-portal.md)

- An [integration account resource](enterprise-integration/create-integration-account.md) to define and store artifacts for enterprise integration and B2B workflows.

  - Both the integration account and logic app resource must exist in the same Azure subscription and Azure region.

  - Defines at least two [trading partners](logic-apps-enterprise-integration-partners.md) in your integration account. The definitions for both partners must use the same *business identity* qualifier, such as AS2, X12, EDIFACT, or RosettaNet.

  - Defines an [AS2 agreement and X12 agreement](logic-apps-enterprise-integration-agreements.md) between the trading partners that participate in your workflow. Each agreement requires a host partner and a guest partner.

    The content in the messages between the partners must match the agreement type. For information about agreement settings to use when receiving and sending messages, see:
    
    - [AS2 message settings](logic-apps-enterprise-integration-as2-message-settings.md)
    - [X12 message settings](logic-apps-enterprise-integration-x12-message-settings.md)

- Before you start working with the AS2 and X12 operations, you must [link your Consumption logic app](enterprise-integration/create-integration-account.md?tabs=consumption#link-account) or [link your Standard logic app](enterprise-integration/create-integration-account.md?tabs=standard#link-account) to the integration account so you can work with artifacts such as trading partners and agreements. You can link an integration account to multiple Consumption or Standard logic app resources to share the same artifacts.

  When you add the AS2 and X12 operations, you might have to create a connection to the integration account:

  | Logic app workflow | Connection required? |
  |--------------------|----------------------|
  | Consumption | - AS2 (v2) connector: No connection required <br><br>- X12 connector: Connection required |
  | Standard | - AS2 (v2) connector: No connection required <br><br>- X12 connector: Connection required | 

<a name="add-request-trigger"></a>

## Add the Request trigger

To start the workflow in this example, add the [**Request** trigger](../connectors/connectors-native-reqres.md).

1. In the [Azure portal](https://portal.azure.com), open your logic app resource.

1. In the designer, open your workflow. Follow these [general steps](add-trigger-action-workflow.md#add-trigger) to add the **Request** built-in trigger named **When an HTTP request is received** to your workflow.

   The trigger information pane opens with the **Parameters** tab selected.

1. Leave the trigger's **Request Body JSON Schema** parameter empty because the trigger receives X12 messages in flat file format.

   :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/request-trigger.png" alt-text="Screenshot shows Azure portal, workflow designer, and Request trigger parameters." lightbox="./media/logic-apps-enterprise-integration-b2b/request-trigger.png":::

1. Save your workflow. On the designer toolbar, select **Save**.

   This step generates the **HTTP POST URL**, which you later use to send a request that triggers the workflow.

   :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/request-trigger-generated-url.png" alt-text="Screenshot shows workflow designer, Request trigger parameters, and generated URL for Request trigger." lightbox="./media/logic-apps-enterprise-integration-b2b/request-trigger-generated-url.png":::

1. Copy and save the URL for later use.

<a name="add-decode-as2-trigger"></a>

## Add the decode AS2 action

Follow these steps to add the [**AS2 Decode** action](logic-apps-enterprise-integration-as2.md).

1. Under the **Request** trigger, follow these [general steps](add-trigger-action-workflow.md#add-action) to add the following **AS2 (v2)** built-in action, based on your workflow type:

   | Workflow | Action name |
   |----------|-------------|
   | Consumption | **AS2 Decode** |
   | Standard | **Decode AS2** |

1. In the action's **Message to decode** parameter, provide the message content to decode.

   This example specifies the body content from the **Request** trigger output. You can provide this content either by selecting from the dynamic content list or entering an expression:

   - To choose output from previous operations, follow these steps for the dynamic content list:
   
     1. Select inside the **Message to decode** box, then select the lightning icon to open the dynamic content list.

     1. Under **When an HTTP request is received**, select **Body**, for example:

        :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/select-trigger-output-body.png" alt-text="Screenshot shows workflow designer, Request trigger parameters, and dynamic content list with Body parameter selected." lightbox="./media/logic-apps-enterprise-integration-b2b/select-trigger-output-body.png":::

        > [!NOTE]
        >
        > If **Body** doesn't appear in the dynamic property list, next to the **When an HTTP request is received** section label, select **See more**.

   - To enter an expression that references the content in the `body` property from the **Request** trigger output, follow these steps:
   
     1. Select inside the **Message to decode** box, then select the function icon to open the expression editor.

     1. In the editor box, enter the following expression, and select **Add**:

        `triggerOutputs()['body']`

1. In the action's **Message headers** parameter, enter any headers that the AS2 action requires. You can find these values in the `headers` property from the **Request** trigger output by following these steps:

   1. In the **Message headers** section, select **Switch Message headers to text mode**:

      :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/switch-text-mode.png" alt-text="Screenshot shows AS2 decode action with Switch Message headers to text mode selected." lightbox="./media/logic-apps-enterprise-integration-b2b/switch-text-mode.png":::

   1. Select inside the **Message headers** box, then select the function icon to open the expression editor.
   
   1. In the editor box, enter the following expression, and select **Add**:

      `triggerOutputs()['Headers']`

      :::image type="content" source="./media/logic-apps-enterprise-integration-b2b/header-expression.png" alt-text="Screenshot shows the Message headers box with an expression that references the headers in trigger output." lightbox="./media/logic-apps-enterprise-integration-b2b/header-expression.png":::

   1. To resolve the expression into `Headers` token, on the designer toolbar, select **Code view** > **Designer**.

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
