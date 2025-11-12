---
title: Integrate Healthcare Systems with HL7 in Standard Workflows
description: Learn to create healthcare integration solutions using Health Level 7 (HL7) connector operations with Standard workflows in Azure Logic Apps.
ms.service: azure-logic-apps
author: haroldcampos
ms.author: hcampos
ms.topic: how-to
ms.date: 11/18/2025
#Customer intent: As an integration developer who works with Azure Logic Apps, I want to create healthcare integrations using HL7 connector operations in Standard workflows.
---

# Build HL7 <!--and MLLP-->healthcare integrations with Standard workflows in Azure Logic Apps (preview)

[!INCLUDE [logic-apps-sku-standard](../../../includes/logic-apps-sku-standard.md)]

> [!IMPORTANT]
>
> This capability is in preview and is subject to the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Health care organizations are intricate businesses made up of different departments that work together. In hospitals, these can include areas like Admissions, laboratories, nursing stations, doctors, and billing—each producing and using various types of data. This information might cover patients, charges, medical procedures, or medications, and frequently needs to be shared among several departments. One major challenge health care organizations face is finding efficient ways to exchange this data between departments.

This article describes the following aspects about the Logic Apps healthcare capabilities:

* Scenarios for using the healthcare features in Azure Logic Apps
* Prerequisites and setup for using the HL7 and MLLP connectors
* Steps for adding HL7 and MLLP connector actions to your Standard logic app workflows

## Why healthcare with Azure Logic Apps

Microsoft has provided support for healthcare scenarios since the first releases of BizTalk Server. Using the Microsoft BizTalk Accelerator for HL7 (BTAHL7), BizTalk allowed to develop business processes across health care computer systems, using the Health Level 7 (HL7) standard and the Minimal Lower Layer Protocol (MLLP) messaging protocol.
 
The purpose of the HL7 standard is to facilitate communication in health care environments. Its primary goal is to provide standards for the exchange of data among health care applications that eliminate or substantially reduce the custom interface programming and program maintenance that may otherwise be required. The following diagram depict some of the most common HL7 message types:

:::image type="content" source="media/integrate-healthcare-systems/hl7messages.png" alt-text="Conceptual diagram shows how the HL7 messages." lightbox="media/integrate-healthcare-systems/hl7-messages.png":::

1. EPR: Electronic patient record
1. ADT: Admits, Discharge, and Transfer message
1. ORM: General order message
1. ORU: Unsolicited observation results message
1. DFT: Detailed financial transaction

While MLLP is considered a legacy protocol, it remains highly relevant because it is the de facto transport protocol for HL7 v2.x messaging, which is still widely used in healthcare systems worldwide. Despite the rise of modern standards like Fast Healthcare Interoperability Resources (FHIR), HL7 v2.x continues to dominate for real-time clinical workflows such as admissions, discharge, transfer (ADT), lab results, and billing. Key reasons:

1. Interoperability Backbone: HL7 v2.x is deeply embedded in EHRs, LIS, RIS, and HIS systems. MLLP provides a simple, reliable framing mechanism for these messages over TCP/IP.
1. Acknowledgment Support: MLLP ensures delivery confirmation through ACK/NACK, which is critical for patient safety and compliance.
1. Low Complexity: Its simplicity makes it easy to implement and maintain compared to more complex web service protocols.

## HL7 Connector

As we continue supporting our customers migrating from BizTalk Server to Azure Logic Apps, we are introducing an HL7 connector. This connector will allow customers to leverage their existing healthcare solutions, and also bring new healthcare scenarios to Azure Logic Apps. While BizTalk uses a disassembler pipeline to split HL7 messages into header, body, and custom segments, Logic Apps exposes these as fixed outputs, avoiding the complexity of multipart message handling unless the number of parts is variable, as in AS2 processing. This greatly simplifies using HL7 messages.

Logic Apps requires uploading BizTalk schemas into the integration accounts. The HL7 connector is supported in Logic Apps Standard and the Hybrid deployment model.

## Connector technical reference

The connector supports the following:

1. V2.X message handling (validated up to V2.6 version – BizTalk schema releases up to 2.6)
1. Processing of individual messages
1. Acknowledgment parsing supported for V2.4/2.5/2.6.
1. Only message schema need to be uploaded.
1. Z Segments are supported only by schema updates (adding Z segments node).

The connector does not support the following. We will gradually add support for these features:

1. Batch messages processing
1. ACK generation and ACK versions support for V<2.4.
1. MSH overrides and partner specific configuration.
1. Z Segments out of the box support.


Currently, there are two operations available for the HL7 connector: **Encode** and **Decode**. The **Decode** action should be used to convert flat files to the XML format, and the **Encode** should be used to convert XML to a flat file. The following table summarizes the usage for each action:

### Encode action

| Parameter | Required | Type | Description |
|-----------|----------|-------|-------------|
| **Message to encode** | Yes | String | The HL7 message to encode. |
| **Header to encode** | Yes | String | The HL7 header to encode. |


### Decode action

| Parameter | Required | Type | Description |
|-----------|----------|-------|-------------|
| **Message to decode** | Yes | String | The HL7 message to decode. |

## Pre-requisites

* An Azure account and subscription. If you don't have an Azure subscription, [sign up for a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

* Access to the health system to integrate.

* An [integration account resource](enterprise-integration/create-integration-account.md) where you define and store artifacts, such as trading partners, agreements, certificates, and so on, for use in your enterprise integration and B2B workflows. This resource has to meet the following requirements:

  * Is associated with the same Azure subscription as your logic app resource.

  * Exists in the same location or Azure region as your logic app resource where you plan to use the **Encode** or **Decode** actions.

  * If you're working on a [Standard logic app resource and workflow](logic-apps-overview.md#resource-environment-differences), you can link your integration account to your logic app resource, upload XSD schemas directly to your logic app resource, or both, based on the following scenarios: 

    * If you already have an integration account with the artifacts that you need or want to use, you can link your integration account to multiple Standard logic app resources where you want to use the artifacts. That way, you don't have to upload XSD schemas to each individual logic app. For more information, review [Link your logic app resource to your integration account](enterprise-integration/create-integration-account.md?tabs=standard#link-account).


* The HL7 flat-file schema. You also need the schemas your HL7 schemas has references to as well. They all have to be uploaded to the Integration account.

* The Standard logic app workflow where you want to integrate with the health system.

  The HL7 connector doesn't have triggers, so use any trigger to start your workflow, such as the **MLLP** trigger or **Request** trigger. You can then add the HL7 connector actions. To get started, create a blank workflow in your Standard logic app resource.

### Limitations

* Currently, the HL7 connector requires that you upload your schemas directly into an integration account.
* Current implementation supports only single message processing, with batching as a possible future enhancement based on customer feedback

## Upload the HL7 schemas

Follow these steps to add an schema:

1. Upload the HL7 schemas in the Integration account. Unlike BizTalk Server, where you needed to upload the common schemas for message headers (MSH_25_GLO_DEF.xsd) and acknowledgments (ACK_24_GLO_DEF.xsd) and (ACK_25_GLO_DEF.xsd), you don't need to upload them in Azure Logic Apps.

   This example shows the schema **ADT_A01_231_GLO_DEF** schema and dependencies: **datatypes_21.xsd**, **segments_21.xsd** and **tablevalues_21.xsd**.:

   :::image type="content" source="media/integrate-healthcare-systems/IntegrationSchemas.png" alt-text="Screenshot shows integration account with HL7 schemas." lightbox="media/integrate-healthcare-systems/integration-schemas.png"::: 

1. Obtain the Integration Account callback URL. Go to Integration account and select **Callback URL**.

1. The Integration Account callback URL should be added as an environment variable in the Logic App. The name of the variable should be **WORKFLOW_INTEGRATION_ACCOUNT_CALLBACK_URL**

## Add an Encode action

Follow these steps to add an Encode action and configure the necessary parameters:

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource and workflow in the designer.
1. If you don't have a trigger to start your workflow, follow [these general steps to add the trigger that you want](../logic-apps/create-workflow-with-trigger-or-action.md?tabs=standard#add-trigger).

   This example continues with the **Request** trigger named **When a HTTP request is received**:

   :::image type="content" source="media/integrate-healthcare-systems/request-trigger.png" alt-text="Screenshot shows Azure portal, Standard workflow designer, and Request trigger." lightbox="media/integrate-healthcare-systems/request-trigger.png":::

1. To add the Encode action, follow [these general steps to add the **HL7** built-in connector action named **Encode**](../logic-apps/create-workflow-with-trigger-or-action.md?tabs=standard#add-trigger).


1. Provide the following information:

   | Parameter | Required | Value | Description |
   |-----------|----------|-------|-------------|
   | **Message to encode** | Yes | <*message-to-encode*> | The Message content to encode. |
   | **Header to encode** | Yes | <*header-to-encode*> | The message Header to encode. |

   For example:

:::image type="content" source="media/integrate-healthcare-systems/EncodeHL7.png" alt-text="Screenshot shows HL7 action's connection properties." lightbox="media/integrate-healthcare-systems/encode-hl7.png":::

1. When you're done, save your workflow. On the designer toolbar, select **Save**.


## Add a Decode action

Follow these steps to add a Decode action and configure the necessary parameters:

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource and workflow in the designer.
1. If you don't have a trigger to start your workflow, follow [these general steps to add the trigger that you want](../logic-apps/create-workflow-with-trigger-or-action.md?tabs=standard#add-trigger).

   This example continues with the **Request** trigger named **When a HTTP request is received**:

   :::image type="content" source="media/integrate-healthcare-systems/request-trigger.png" alt-text="Screenshot shows Azure portal, Standard workflow designer, and Request trigger." lightbox="media/integrate-healthcare-systems/request-trigger.png":::

1. To add the Decode action, follow [these general steps to add the **HL7** built-in connector action named **Decode**](../logic-apps/create-workflow-with-trigger-or-action.md?tabs=standard#add-trigger).


1. Provide the following information:

   | Parameter | Required | Value | Description |
   |-----------|----------|-------|-------------|
   | **Message to decode** | Yes | <*message-to-decode*> | The Message content to decode. |
   

   For example:

:::image type="content" source="media/integrate-healthcare-systems/DecodeHL7.png" alt-text="Screenshot shows HL7 action's connection properties." lightbox="media/integrate-healthcare-systems/decode-hl7.png":::

1. When you're done, save your workflow. On the designer toolbar, select **Save**. 

## MLLP connector

We are introducing support for the Minimum Lower Layer Protocol (MLLP). Because MLLP is a raw TCP protocol and not HTTP-based, it requires custom TCP/IP ports to be opened and a dedicated TCP listener on a configurable port. For this reason, MLLP is available exclusively in Logic Apps Hybrid. It includes both a trigger and an action.

## Connector technical reference

Currently, there is a trigger and an operation available for the MLLP connector: **Receive MLLP** and **Send MLLP**. The following table summarizes the usage for each action:

## MLLP Trigger

The MLLP Trigger doesnt use any parameters.


## Send action

| Parameter | Required | Type | Description |
|-----------|----------|-------|-------------|
| **Message to send** | Yes | String | The HL7 message to be sent. |



## Pre-requisites

* An Azure account and subscription. If you don't have an Azure subscription, [sign up for a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

* Access to the health system to integrate.

* A logic app created using the Hybrid deployment model.

* The logic app workflow where you want to integrate with the health system.


## Limitations

Currently, the MLLP trigger only works in the hybryd Logic Apps deployment model.

<a name="add-trigger"></a>

## Add an MLLP trigger (Hybrid deployment model only)

The following steps apply only to the hybrid deployment model of Logic Apps.

These steps use the Azure portal, but with the appropriate Azure Logic Apps extension, you can also use [Visual Studio Code](../logic-apps/create-single-tenant-workflows-visual-studio-code.md) to create a Standard logic app workflow.

1. In the [Azure portal](https://portal.azure.com), open your blank logic app workflow in the designer.

1. [Follow these general steps to add the MLLP built-in trigger](../logic-apps/create-workflow-with-trigger-or-action.md?tabs=standard#add-trigger). For more information, see [MLLP built-in connector triggers](/azure/logic-apps/connectors/built-in/reference/mllp/#triggers).

1. Provide the following information:

   | Parameter | Required | Value | Description |
   |-----------|----------|-------|-------------|
   | **Connection name** | Yes | <*connection-name*> | The name of the connection. |
   | **Host** | Yes | <*mllp-host*> | The MLLP host. |
   | **Port** | Yes | <*mllp-port*> | The MLLP TCP/IP port. |
   

   For example:

:::image type="content" source="media/integrate-healthcare-systems/MLLPTriggerConnection.png" alt-text="Screenshot shows MLLP trigger." lightbox="media/integrate-healthcare-systems/connection-receive-message-mllp.png":::

1. When you're done, save your workflow. On the designer toolbar, select **Save**. 

<a name="add-action"></a>

## Add an MLLP action

Follow these steps to add a MLLP send action and configure the necessary parameters:

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource and workflow in the designer.
1. If you don't have a trigger to start your workflow, follow [these general steps to add the trigger that you want](../logic-apps/create-workflow-with-trigger-or-action.md?tabs=standard#add-trigger).

   This example continues with the **Request** trigger named **When a HTTP request is received**:

   :::image type="content" source="media/integrate-healthcare-systems/request-trigger.png" alt-text="Screenshot shows Azure portal, Standard workflow designer, and Request trigger." lightbox="media/integrate-healthcare-systems/request-trigger.png":::

1. To add the MLLP Send action, follow [these general steps to add the **MLLP** built-in connector action named **Send**](../logic-apps/create-workflow-with-trigger-or-action.md?tabs=standard#add-trigger).

1. After the connection details pane appears, provide the following information, such as the host name and port information:

   | Parameter | Required | Value | Description |
   |-----------|----------|-------|-------------|
   | **Connection name** | Yes | <*connection-name*> | The name of the connection. |
   | **Host** | Yes | <*mllp-host*> | The MLLP host. |
   | **Port** | Yes | <*mllp-port*> | The MLLP TCP/IP port. |

For example:

   :::image type="content" source="media/integrate-healthcare-systems/MLLPTriggerConnection.png" alt-text="Screenshot shows MLLP connection properties." lightbox="media/integrate-healthcare-systems/connection-send-message-mllp.png":::

1. When you're done, select **Create New**.

1. After the action details pane appears, provide the required information:

   | Parameter | Required | Value | Description |
   |-----------|----------|-------|-------------|
   | **Input message** | Yes | <*input-message*> | The HL7 input Message. |
   

For example:

   :::image type="content" source="media/integrate-healthcare-systems/SendMLLP.png" alt-text="Screenshot shows MLLP connection properties." lightbox="media/integrate-healthcare-systems/mllp-send-message.png":::

1. When you're done, save your workflow. On the designer toolbar, select **Save**. 

## Next step


> [!div class="nextstepaction"]
> [Create Standard logic app workflows for hybrid deployment on your own infrastructure](create-standard-workflows-hybrid-deployment.md)



