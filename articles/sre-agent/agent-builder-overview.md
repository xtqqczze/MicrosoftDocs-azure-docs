---
title: Agent Builder in Azure SRE Agent overview
description: Learn how to use Agent Builder in Azure SRE Agent to create and manage intelligent agents for automating operational workflows.
author: craigshoemaker
ms.author: cshoe
ms.topic: how-to
ms.date: 11/06/2025
ms.service: azure-sre-agent
---

# Agent Builder in Azure SRE Agent overview

Agent Builder is a configuration tool in Azure SRE Agent that helps you create, customize, and manage intelligent agents for your operational workflows. Use Agent Builder to design agents that can automatically respond to incidents, run scheduled tasks, connect to observability tools, and use your organization's knowledge base to improve decision-making.

## What you can build with Agent Builder

Agent Builder empowers you to create sophisticated automation solutions for your operational workflows:

| Capability | Description | Example use cases | Actions |
|--|--|--|--|
| Custom agents | Build specialized agents with tailored instructions and behaviors | • RCA specialists for specific services<br>• Monitoring agents for resource health<br>• Compliance checkers for security policies |  |
| Data integration | Connect your observability tools and knowledge sources | • Azure Monitor for metrics and logs<br>• File uploads for documentation<br>• External APIs through MCP connectors |  |
| Automated triggers | Set up incident response plans and scheduled tasks | • Automatic incident investigation<br>• Daily health reports<br>• Weekly compliance scans |  |

## Work with Agent Builder

To create a new subagent, start by defining the agent’s primary purpose and operational scope so its responsibilities are clear. Then connect the data sources the agent uses to expand its content. Potential sources include observability connectors or organizational knowledge (runbooks, procedures).

You can extend the subagent's capabilities by associating system tools and any MCP integrations, and provide custom instructions that guide analytical and operational behavior. Finally, define handoff rules that control when processing should transition to other subagents or human operators.

Incident response plans or scheduled tasks trigger subagents.

Once running, continuously monitor and refine your subagent. Regularly review performance and decision quality, adjust instructions, tune tool selections, and expand capabilities as needs evolve.

## Create your first subagent

Agent Builder makes it easy to design and deploy your first intelligent subagent in just a few steps. The following section shows you how to create a new subagent and connect it to tools and data sources.

### Prerequisites

Before using Agent Builder, ensure you have:

- **Azure subscription**: A subscription with permissions to create and manage SRE Agent resources.
- **Operational context**: An understanding of your incident response procedures and operational workflows.
- **Data sources**: Access to observability tools and knowledge repositories.

### Create the subagent

1. Go to your Azure SRE Agent in the Azure portal.

1. Select the **Sub-Agent Builder** tab.

1. Select **Create Your First Entity**.

1. Select **Sub-Agent**.

1. Provide values for the following settings:

    | Property | Value |
    |--|--|
    | Agent Name | Enter a name for your subagent. |
    | Instructions | Enter custom instructions telling the subagent how you want it to behave. |
    | Handoff Description | Describe when and why other subagents should hand off processing to this subagent. |
    | Extended Tools (optional) | Select one or more tools for the subagent to use during processing. |
    | System Tools (optional) | Select one or more system tools to make available to the subagent. |
    | Handoff Agents (optional) | Select the next subagent you want to pick up processing once this subagent is done executing. |

## Related content

- [Agent Builder scenarios](./agent-builder-scenarios.md)
