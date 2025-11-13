---
title: Create Agent Tools with Workflow-Based MCP Servers in AI Foundry
description: Learn to create agent tools from Model Context Protocol (MCP) servers driven by Azure Logic Apps using Microsoft Foundry.
services: logic-apps, azure-ai-foundry
author: ecfan
ms.suite: integration
ms.reviewers: estfan, divswa, azla
ms.topic: how-to
ms.collection: ce-skilling-ai-copilot
ms.date: 11/18/2025
ms.update-cycle: 180-days
# Customer intent: As an AI integration developer working in Microsoft Foundry, I want to create agent tools from MCP servers that I build using workflow connector actions in Azure Logic Apps.
---

# Create agent tools from MCP servers driven by Azure Logic Apps using Microsoft Foundry (preview)

[!INCLUDE [logic-apps-sku-consumption](includes/logic-apps-sku-consumption.md)]

> [!NOTE]
>
> This capability is in preview, might incur charges, and is subject to the
> [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

This guide shows how to create agent tools in Microsoft Foundry from Model Content Protocol (MCP) servers. You build these servers, which are driven by automated workflows that run connector actions in Azure Logic Apps. These agent tools let you run actions that can integrate with Azure, Microsoft, or other services, systems, apps, and data sources - without writing any code. Your MCP server can include single or multiple actions that you choose from the available supported connectors.

## Prerequisites

- An Azure account and subscription. [Get a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- An [Azure AI Foundry project](/azure/ai-foundry/how-to/create-projects?tabs=ai-studio) and an [agent in your project](/azure/ai-foundry/agents/quickstart?context=%2Fazure%2Fai-foundry%2Fcontext%2Fcontext&pivots=ai-foundry-portal).

## Limitations and known issues

- Microsoft Foundry

  - The experience to add an Azure Logic Apps powered agent tool is currently available only in Microsoft Foundry.

  - This release supports only non-OAuth Microsoft and external managed connectors, which are hosted and run in multitenant Azure.

  - Connector search filters can't be cleared after you select them. To clear the filters, return to the **Tools** page and start over with **Connect your first tool**.

- Azure portal

  - Some connectors are available for you to select but don't show any actions that you can select.

  - In the MCP server registration wizard, after you select a connector and the actions you want, you can't delete the connector to choose a different one.



## Create an agent tool

1. In the [Azure AI Foundry portal](https://ai.azure.com/), open your project, and go to your agent.

1. On the Azure AI Foundry title bar, select **New AI Foundry**.

   The Azure AI Foundry portal changes to the Microsoft Foundry portal.

1. Under **Your recent work**, select your agent.

1. On the **Agents** sidebar, select **Tools**.

1. On the **Tools** page, select **Connect a tool**.

1. In the **Select a tool** window, select **Catalog**.

1. On the **Catalog** tab, select **Registry** > **Logic app connectors**.

1. In the search box, enter the name for the connector with the actions that you want.

   This example uses the **RSS** connector.

1. Select the connector, then select **Create**.

   The Azure portal opens, starts the **Register an MCP server with Azure Logic Apps** wizard, and opens the **Add actions** pane.

1. On the **Add actions** pane, find and select the connector actions to include in your MCP server.

   This example uses the **RSS** connector and the action named **List all RSS feed items**.

1. When you're ready, select **Next**.

1. If the Azure portal prompts you to sign in for authentication, sign in now.



## Add a tool to your agent

Follow these steps to create an agent tool in Microsoft Foundry that calls an MCP server.

## Related content

- [What is Azure AI Foundry](/ai-foundry/what-is-azure-ai-foundry)?
- [What is Azure Logic Apps](/azure/logic-apps/logic-apps-overview)?
