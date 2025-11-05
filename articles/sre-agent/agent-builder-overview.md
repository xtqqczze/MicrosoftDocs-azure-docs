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

## TODO

Go to Agent Builder in the Azure SRE Agent portal.

Choose Create Agent and provide a descriptive name

Define the agent's primary purpose and operational scope

Connect data sources

Add relevant data connectors for your observability tools

Upload organizational knowledge and procedural documentation

Test connectivity and validate data access

Configure capabilities

Select appropriate system tools and MCP integrations

Define custom instructions tailored to your operational procedures

Set up handoff rules for escalation scenarios

Set up automation

Create incident response plans with appropriate filters and autonomy levels

Configure scheduled tasks for recurring operational activities

Test automation scenarios before production deployment

Monitor and Refine

Review agent performance and decision quality

Adjust instructions and tool selections based on operational feedback

Expand capabilities as your automation needs to evolve

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

