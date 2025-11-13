---
title: Import an A2A Agent API (Preview) - Azure API Management
description: TBD.
ms.service: azure-api-management
author: dlepow
ms.author: danlep
ms.topic: how-to
ms.date: 11/12/2025
ms.update-cycle: 180-days
ms.collection: ce-skilling-ai-copilot
ms.custom: template-how-to
---

# Import an A2A agent API (preview)

[!INCLUDE [api-management-availability-basicv2-standardv2-premiumv2](../../includes/api-management-availability-basicv2-standardv2-premiumv2.md)]

API Management provides support for managing AI agent APIs compatible with the [Agent2Agent (A2A) protocol specification](https://a2a-protocol.org/dev/specification/). The A2A protocol is an open client-server standard that enables different AI agent systems to communicate and work together using a shared interaction model. With the A2A agent API support in API Management, organizations can manage and govern agent APIs alongside other API types, including AI model APIs, Model Context Protocol (MCP) tools, and traditional APIs such as REST, SOAP, and GraphQL.  

> [!NOTE]
> This feature is in preview and has some [limitations](#limitations). 

Learn more about managing AI APIs in API Management:

* [AI gateway capabilities in Azure API Management](genai-gateway-capabilities.md)

## Key capabilities

By importing an A2A agent API, API Management mediates runtime operations to the A2A backend with the following capabilities:
* Exposes the [agent card](https://a2a-protocol.org/dev/specification/#5-agent-discovery-the-agent-card) as an operation within the same API with the following transformations:  
    * The hostname is replaced with API Management instance's hostname.
    * The preferred transport protocol is set to JSON-RPC.
    * All other interfaces in `additionalInterfaces` are removed.    
    * Security requirements are rewritten to represent the subscription key. 
* Governs API runtime with policies.
* Adds the following A2A-specific attributes in Application Insights logs (when configured) to comply with the [OpenTelemetry GenAI semantic convention](https://opentelemetry.io/docs/specs/semconv/registry/attributes/gen-ai/):
    * `genai.agent.id` - Set to the agent ID configured in the API settings
    * `genai.agent.name`- Set to the API name in the API settings 
    
### Limitations

* This feature is currently available only in API Management instances in the v2 tiers.
* Only JSON-RPC-based A2A agent APIs are supported.
* Deserialization of outgoing response bodies isn't supported.

## Prerequisites

- An existing API Management instance. [Create one if you haven't already](get-started-create-service-instance.md).

- A URL to an A2A agent card JSON document that you want to import. The agent card must be accessible from the public internet.

## Import A2A agent API using the portal

Use the following steps to import an AI API to API Management. 

1. In the [Azure portal](https://portal.azure.com), navigate to your API Management instance.
1. In the left menu, under **APIs**, select **APIs** > **+ Add API**.
1. Select the **A2A Agent** tile.

    :::image type="content" source="media/agent-to-agent-api/agent-to-agent-tile.png" alt-text="Screenshot of selecting A2A agent API tile in the portal." :::

1. Under **Agent card**, enter the **URL** that points to the agent card JSON document. Select **Next**.
1. On the **Create an A2A agent API** page, configure the API settings.
    1. Under **Agent card**, values for **Protocol**, **Runtime URL**, and **Agent ID** are populated from the agent card. You can add or edit these values if needed. If you want to review the agent card JSON document, select the **View agent card** button.
    2. Under **General API settings**, enter a **Display name** of your choice in the API Management instance, and optionally enter a **Description**.
    1. Under **URL**, enter a **Base path** that your API Management instance uses to access the A2A agent API. API Management displays a **Base URL** that clients can use to access the API, and an **Agent card URL** to access the agent card through API Management.
1. Select **Create** to create the API.

:::image type="content" source="media/agent-to-agent-api/create-agent-api.png" alt-text="Screenshot of creating an A2A agent-compatible API in the portal." lightbox="media/agent-to-agent-api/create-agent-api.png":::

## Configure policies for the A2A agent API

Configure one or more API Management [policies](api-management-howto-policies.md) to help manage the A2A agent API.an be used to control access, authentication, and other aspects of the A2A agent.

Learn more about configuring policies:

* [Policies in API Management](api-management-howto-policies.md)
* [Transform and protect your API](transform-api.md)
* [Set and edit policies](set-edit-policies.md)


To call your A2A agent API through API Management

1. In the [Azure portal](https://portal.azure.com), navigate to your API Management instance.
1. In the left-hand menu, under **APIs**, select your A2A agent API.
1. In the left menu, under **A2A**, select **Policies**.
1. In the policy editor, add or edit the policies you want to apply to the A2A agent API. The policies are defined in XML format. 

    For example, you can add a policy to limit calls to the A2A agent API (in this example, 5 calls per 30 seconds per client IP address).

    ```xml
    <rate-limit-by-key calls="5" renewal-period="30" counter-key="@(context.Request.IpAddress)" remaining-calls-variable-name="remainingCallsPerIP" />
    ```

> [!NOTE]
> Policies configured at the global (all APIs) scope are evaluated before policies at the A2A agent API scope.


## Configure subscription key authentication

In the A2A API settings, you can optionally configure subscription key authentication through API Management. [Learn more about subscription key authentication](api-management-subscriptions.md).

1. Select the API you created in the previous step.
1. On the **Settings** page, under **Subscription**, select (enable) **Subscription required**.

If you enable subscription key authentication, clients must include a valid subscription key in the `Ocp-Apim-Subscription-Key` header or `subscription-key` query parameter when calling the A2A agent API.

## Test the A2A agent API

To ensure that your A2A agent API is working as expected, you can call it through API Management:

1. Select the API you created in the previous step.
1. On the **Overview** page, copy the **Runtime base URL**. This URL is used to call the A2A agent API through API Management.
1. Configure a test client or a tool such as [curl](https://curl.se/) to make a POST request to the agent.


[!INCLUDE [api-management-define-api-topics.md](../../includes/api-management-define-api-topics.md)]
