---
title: Agent registry in Azure API Center
description: "Overview of the agent registry for discovering, registering, and managing A2A agents in API Center."
author: ProfessorKendrick
ms.author: kkendrick
ms.service: API Center
ms.topic: overview
ms.date: 11/03/2025

#customer intent: As an API platform owner, I want to understand how to use the agent registry to discover, register, and manage AI agents.

---

# Agent registry in Azure API Center

The agent registry within Azure API Center provides a centralized platform for discovering, registering, and managing AI agents. It supports first-party and third-party agents, integrates with API Management for private endpoints, and stores customizable metadata to improve discoverability and governance.

## Key features

**Centralized Discovery and Management**: A single location to register and manage both first-party and third-party AI agents, including those exposed in API Management or hosted externally.

**Enhanced Discoverability**: Enables developers and other stakeholders to easily find and access approved AI agents through a curated catalog, either via the built-in API Center portal or a custom UI.

**Governance and Security**: Addresses shadow IT and uncontrolled AI tool adoption by providing a governed channel for accessing AI agents, improving security and compliance.

**Integration with API Management**: AI agents can be placed behind an API Management gateway for private endpoints, enhanced security, and controlled access.

**Customizable Metadata**: Organizations can define and store relevant metadata for each registered AI agent, facilitating filtering and searching.

## Register an AI agent

Manually register an AI agent in your API center inventory similar to the way you register other APIs, specifying the API type as **A2A**. To register an API using the Azure portal, see [Tutorial: Register your APIs](../tutorials/register-apis.md).

## Manage your AI agent

You can manage your AI agent as you would other resources via the Azure portal. 

1. In the Azure portal, navigate to your API center.
1. In the sidebar menu, under Assets, select **APIs**.
1. Choose your AI agent from the table in the working pane by selecting your agent from the *Title* column. 
1. Select the edit button.

    :::image type="content" source="media/register-a2a/edit-agent.png" alt-text="Screenshot of the AI agent overview in Azure portal with the edit link emphasized in the working pane.":::

1. From here, you can make changes to your agent.

    - Add skills to your agent. See the [Agent2Agent (A2A) Protocol Official Specification](https://a2a-protocol.org/latest/specification/) for details.
    - Add information about the Agent provider, such as the organization name and URL details.
    - Select which capabilities the A2A agent supports (Streaming Support, Push Notifications, State Transition History).

1. Select **Save**.

## View dependency maps for A2A agents (preview)

API platform administrators can now create relationships feature across the A2A agents using dependency tracker feature. This allows API Center to identify the right agent to call and enable seamless communication across agents in a enterprise.

To view dependencies:

1. In the Azure portal, navigate to your API center.
1. In the sidebar menu, under Assets, select **Dependency tracker (preview)**.
1. Select **Graph View**.

:::image type="content" source="media/register-a2a/dependency-tracker.png" alt-text="Screenshot of the dependency tracker in Azure portal with Graph View displayed.":::
