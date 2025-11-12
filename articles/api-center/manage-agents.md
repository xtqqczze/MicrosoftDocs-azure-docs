---
title: Manage Agents in Azure API Center
description: "Learn how to update agent metadata, add skills, configure capabilities, and manage provider information for A2A agents."
author: ProfessorKendrick
ms.author: kkendrick
ms.service: azure-api-center
ms.topic: how-to
ms.date: 11/11/2025
---

# Manage Agents in Azure API Center

This guide shows you how to update and manage agents after they've been registered in API Center. You can add skills, configure capabilities, and update provider information.

## Prerequisites

- An Azure API Center instance with at least one [registered agent](agent-to-agent-overview.md#register-an-ai-agent)
- Appropriate permissions to edit APIs in your API Center

## Update agent metadata

1. In the [Azure portal](https://azure.microsoft.com), go to your API center.
1. In the sidebar menu, under **Assets**, select **APIs**.
1. From the table, select your A2A agent by clicking the agent name in the **Title** column.
1. Select the **Edit** button to open the **Edit** page in the working pane.

    :::image type="content" source="media/manage-agents/edit-agent.png" alt-text="Screenshot of the AI agent overview in Azure portal with the edit button highlighted.":::

### Add skills to your agent

Skills define the capabilities and actions your A2A agent can perform.

1. On the **Edit** page, locate the **Agent Skills** section.
1. Select **+ Add**.
1. In the **Agent Skills** page, define the skill by providing information for the required fields.
    > [!TIP]
    > For detailed skill schema information, see the [Agent2Agent (A2A) Protocol Official Specification](https://a2a-protocol.org/latest/specification/).
1. Select **Add** to add the skill.

### Add provider information

Provider information helps other teams identify who maintains the agent.

1. On the agent **Edit** page, locate the **Agent Provider** section.
1. Enter the following details:

    |Field                 |Description                                                              |
    |----------------------|-------------------------------------------------------------------------|
    |Organization name     |The name of the agent provider's organization                            |
    |Organization URL      |A URL for the agent provider's website or relevant documentation         |

1. Select **Save**.

### Configure agent capabilities

Agent capabilities describe what features your A2A agent supports.

1. On the **Edit** page, locate the **Agent Capabilities** section.
1. Enable or disable the following capabilities as needed:

    |Field                    |Description                                                                             |
    |-------------------------|----------------------------------------------------------------------------------------|
    |Streaming Support        |Indicates if the agent supports Server-Sent Events (SSE) for streaming responses        |
    |Push Notifications       |Indicates if the agent supports sending push notifications for asynchronous task updates|
    |State Transition History | Indicates if the agent provides a history of state transitions for a task              |

1. Select **Save**.

## Related content

[Agent registry in Azure API Center](agent-to-agent-overview.md)