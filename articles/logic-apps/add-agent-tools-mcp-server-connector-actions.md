---
title: Add Agent Tools Backed by Connector Actions
description: Learn to add tools for agents in Microsoft Foundry by creating Model Context Protocol (MCP) servers powered by connector actions in Azure Logic Apps.
services: logic-apps, azure-ai-foundry
author: ecfan
ms.suite: integration
ms.reviewers: estfan, divswa, azla
ms.topic: how-to
ms.collection: ce-skilling-ai-copilot
ms.date: 11/18/2025
ms.update-cycle: 180-days
# Customer intent: As an AI integration developer working in Microsoft Foundry, I want to add agent tools by creating MCP servers powered by workflow connector actions in Azure Logic Apps.
---

# Add agent tools in Foundry with MCP servers powered by connector actions in Azure Logic Apps (preview)

[!INCLUDE [logic-apps-sku-consumption](includes/logic-apps-sku-consumption.md)]

> [!NOTE]
>
> This capability is in preview, might incur charges, and is subject to the
> [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

This guide shows how to add tools to your agents in Microsoft Foundry by creating Model Content Protocol (MCP) servers that provide tools powered by Azure Logic Apps. You build these MCP servers and tools by selecting connector actions that run in Azure Logic Apps. These tools let you integrate your agents with specific Microsoft and non-Microsoft services, systems, apps, and data sources - without having to write any code. Tools can include single or multiple actions provided by the connector you choose from supported available connectors.

For more information, see:

- [What is Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro)?
- [What is Foundry](/azure/ai-foundry/what-is-azure-ai-foundry)?
- [What is Azure Logic Apps](/azure/logic-apps/logic-apps-overview)?

## Prerequisites

- An Azure account and subscription. [Get a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- The following Foundry assets that you can create with the classic Foundry experience:

  - A [Foundry resource](/azure/ai-services/multi-service-resource?pivots=azportal)

    You need the **Owner** role in your subscription to create this resource.

  - A [Foundry project for your Foundry resource](/azure/ai-foundry/how-to/create-projects?tabs=ai-foundry)

  - An [agent for your project](/azure/ai-foundry/agents/quickstart?context=%2Fazure%2Fai-foundry%2Fcontext%2Fcontext&pivots=ai-foundry-portal)
  
  - A [Foundry model deployed for your agent](/azure/ai-foundry/foundry-models/how-to/create-model-deployments?pivots=ai-foundry-portal).

## Limitations and known issues

- Microsoft Foundry

  - The experience to add an agent tool powered by Azure Logic Apps is currently available only in the preview Foundry experience, not in classic Foundry experience.

  - This release supports only managed connectors for Microsoft and non-Microsoft services and products that don't use OAuth 2.0 authentication.
  
    [*Managed* connectors](/azure/connectors/managed) are hosted and run on shared clusters in multitenant Azure.

  - After you select a You can't clear connector search filters after you select a filter. To clear the filters, return to the **Tools** page and start over with **Connect your first tool**.

- Azure portal

  - Some connectors that you select might not show any available actions.

  - In the MCP server registration wizard, after you select a connector and the actions you want, you can't change or delete the selected connector to choose a different one.

## 1: Add tools for your agent

Follow these steps to add one or multiple tools for your agent in Microsoft Foundry. These tools are provided by an MCP server that you create.

1. In the classic [Foundry portal](https://ai.azure.com/), open your project, and go to your agent.

1. On the Foundry title bar, select **New Foundry**.

   :::image type="content" source="media/add-agent-tools-mcp-server-connector-actions/new-foundry.png" alt-text="Screenshot shows classic Foundry title bar with unselected New Foundry option." lightbox="media/add-agent-tools-mcp-server-connector-actions/new-foundry.png":::

   The classic Foundry portal changes to the preview Foundry portal.

   :::image type="content" source="media/add-agent-tools-mcp-server-connector-actions/preview-foundry.png" alt-text="Screenshot shows preview Foundry experience." lightbox="media/add-agent-tools-mcp-server-connector-actions/preview-foundry.png":::

1. Under **Your recent work**, select your agent.

   :::image type="content" source="media/add-agent-tools-mcp-server-connector-actions/my-agent.png" alt-text="Screenshot shows Your recent work section with selected agent." lightbox="media/add-agent-tools-mcp-server-connector-actions/my-agent.png":::

1. On the Foundry sidebar, select **Tools**.

   :::image type="content" source="media/add-agent-tools-mcp-server-connector-actions/foundry-sidebar-tools.png" alt-text="Screenshot shows Foundry sidebar with Tools selected." lightbox="media/add-agent-tools-mcp-server-connector-actions/foundry-sidebar-tools.png":::

1. On the **Tools** page, select **Connect a tool**.

1. In the **Select a tool** window, select **Catalog**.

   :::image type="content" source="media/add-agent-tools-mcp-server-connector-actions/select-catalog.png" alt-text="Screenshot shows Select a tool window with Catalog tab selected." lightbox="media/add-agent-tools-mcp-server-connector-actions/select-catalog.png":::

1. On the **Catalog** tab, select **Registry** > **Logic app connectors**.

   :::image type="content" source="media/add-agent-tools-mcp-server-connector-actions/registry-logic-app-connectors.png" alt-text="Screenshot shows Catalog tab with Registry list open and Logic app connectors selected." lightbox="media/add-agent-tools-mcp-server-connector-actions/registry-logic-app-connectors.png":::

1. Select the connector you want by following these steps:

   1. In the search box, enter the name for the connector with the actions you want.

      This example selects the **RSS** connector.

   1. From the results, select the matching connector, then select **Create**.

   For example:

   :::image type="content" source="media/add-agent-tools-mcp-server-connector-actions/select-connector.png" alt-text="Screenshot shows search box with rss entered with RSS connector and Create button selected." lightbox="media/add-agent-tools-mcp-server-connector-actions/select-connector.png":::

   The Azure portal opens and shows the home page for the **Register an MCP server with Azure Logic Apps** wizard.

1. Continue in the Azure portal by using the wizard to create your MCP server and tools.

## 2: Create the MCP server and tools for your agent

You can continue with these steps only after you finish the steps in the preceding section.

1. In the Azure portal, on the **Register an MCP server with Azure Logic Apps** wizard home page, in the **Project details** section, provide the following information:

   | Property | Required | Value | Description |
   |----------|----------|-------|-------------|
   | **MCP server name** | Yes | <*mcp-server-name*> | The name to use for the MCP server. |
   | **Description** | Yes | <*mcp-server-description*> | The description about the MCP server's role, purpose, and tasks that the server can perform. This description helps your agent more accurately identify and choose the appropriate server and tools to use. |
   | **Logic app** | Yes* | <*Standard-logic-app-resource*> | *This property value depends on whether you have any Standard logic app resources linked to Foundry resources. <br><br>- **None**: The Azure portal creates a Standard logic app for your MCP server to use. <br><br>- **One**: The Azure portal automatically selects this Standard logic app for your MCP server to use. <br><br>- **Multiple**: Open the list, and select a logic app for your MCP server to use. |

1. In the **Tools** section, set up the connection for the connector you chose:

   1. In the **Connectors** section, on the connector row, select the edit button (pencil icon).

   1. On the **Edit connection** pane, follow the prompt, which varies based on the connector, for example:

      1. For connectors that don't require authentication, select **Create new**.

      1. For connectors that require authentication, select **Sign in**.

      For the example RSS connector, you're prompted to select **Create new**.

   After you complete the connection, the **Add actions** pane appears.

1. On the **Add actions** pane, find and select the connector actions to include in your MCP server.

   This example uses the **RSS** connector and the action named **List all RSS feed items**.

1. When you're ready, select **Next**.

1. If the Azure portal prompts you to sign in for authentication, sign in now.




## Related content

- [What is Azure AI Foundry](/ai-foundry/what-is-azure-ai-foundry)?
- [What is Azure Logic Apps](/azure/logic-apps/logic-apps-overview)?
