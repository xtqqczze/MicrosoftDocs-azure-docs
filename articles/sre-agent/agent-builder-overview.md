---
title: Agent builder in Azure SRE Agent overview
description: Learn how to use Agent Builder in Azure SRE Agent to create, customize, and manage intelligent agents for automating operational workflows, integrating data sources, and improving incident response.
author: craigshoemaker
ms.author: cshoe
ms.topic: how-to
ms.date: 11/05/2025
ms.service: azure-sre-agent
---

# Agent builder in Azure SRE Agent overview

Agent Builder is a configuration tool in Azure SRE Agent that helps you create, customize, and manage intelligent agents for your operational workflows. Use Agent Builder to design agents that can automatically respond to incidents, run scheduled tasks, connect to observability tools, and use your organization's knowledge base to improve decision-making.

## What you can build with Agent Builder

Agent Builder empowers you to create sophisticated automation solutions for your operational workflows:

| Capability | Description | Example Use Cases |
|--|--|--|
| Custom agents | Build specialized agents with tailored instructions and behaviors | • RCA specialists for specific services<br>• Monitoring agents for resource health<br>• Compliance checkers for security policies |
| Data Integration | Connect your observability tools and knowledge sources | • Azure Monitor for metrics and logs<br>• File uploads for documentation<br>• External APIs through MCP connectors |
| Automated Triggers | Set up incident response plans and scheduled tasks | • Automatic incident investigation<br>• Daily health reports<br>• Weekly compliance scans |

## Work with Agent Builder

To create a new agent, you begin by defining the agent’s primary purpose and operational scope so its responsibilities are clear. Then you connect the data sources the agent uses to expand its content. Potential sources include observability connectors or organizational knowledge (runbooks, procedures).

You can extend the agent's capabilities by associating system tools and any MCP integrations, and provide custom instructions that guide analytical and operational behavior. Finally,  you can define handoff rules that control when processing should transition to other agents or human operators.

Agents are triggered via incident response plans or as scheduled tasks.

Once running, make sure to continuously monitor and refine your agent. Regularly review performance and decision quality, adjust instructions, tune tool selections, and expand capabilities as needs evolve.

## Create your first agent

Agent Builder makes it easy to design and deploy your first intelligent agent in just a few steps. The following section, shows you how to create a new agent, configure its core properties, and connect it to the tools and data sources it needs to operate effectively.

### Prerequisites

Before using Agent Builder, ensure you have:

- **Azure subscription**: A subscription with permissions to create and manage SRE Agent resources.
- **Operational context**: An understanding of your incident response procedures and operational workflows.
- **Data sources**: Access to observability tools and knowledge repositories.

### Create the agent

1. Go to your Azure SRE Agent in the Azure portal.

1. Select the **Sub-Agent Builder** tab.

1. Select **Create Your First Entity**.

1. Select **Sub-Agent**.

1. Provide values for the following settings:

    | Property | Value |
    |--|--|
    | Agent Name | Enter a name for your agent. |
    | Instructions | Enter custom instructions telling the agent how you want it to behave. |
    | Handoff Description | Describe when and why other agents should hand off processing to this agent. |
    | Extended Tools (optional) | Select one or more tools for the agent to use during processing. |
    | System Tools (optional) | Select one or more system tools to make available to the agent.  |
    | Handoff Agents (optional) | Select the next agent you want to pick up processing once this agent is done executing. |

## Related content

- [Agent Builder scenarios](./agent-builder-scenarios.md)
