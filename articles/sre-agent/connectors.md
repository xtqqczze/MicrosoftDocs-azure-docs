---
title: Connect a code repository to resources in Azure SRE Agent Preview
description: Learn to connect resources managed by Azure SRE Agent Preview to a code repository for detailed root cause analysis and summary reports.
author: craigshoemaker
ms.author: cshoe
ms.topic: conceptual
ms.date: 10/27/2025
ms.service: azure-sre-agent
---

# Connect external services with Azure SRE Agent connectors

Connectors in Azure SRE Agent let you integrate external services for communication and data ingestion. Use connectors to send notifications, receive updates, and pull telemetry from monitoring platforms. This article explains connector types, how they work, and how to set them up.

## What are connectors?

Connectors are modular integrations that extend the SRE Agent's capabilities. There are two main types:

- **Communication connectors**: Send notifications and updates to services like Outlook and Microsoft Teams.

- **Consumption connectors**: Ingest data from external monitoring platforms such as Datadog, Dynatrace, and New Relic.

## Available connectors

Azure SRE Agent includes these connectors:

- **Outlook** – Send email notifications.
- **Microsoft Teams** – Post messages to Teams channels.
- **Custom MCP Servers** – Integrate with your own MCP server.
- **Approved partners** – Ingest telemetry from Dynatrace, Datadog, and New Relic.

## How connectors work

After you configure a connector, it becomes available in the SRE Agent UI. You can use connectors to:

- Send email alerts when incidents occur.
- Post Teams messages with incident details.
- Pull logs from Datadog or Dynatrace for analysis.

## Configure a connector

Follow these steps to set up a connector:

1. Go to **Settings** in the SRE Agent portal.
2. Select **Connectors**.
3. Choose a connector type (Outlook, Teams, or Custom MCP Server).
4. Authenticate:
   - For Outlook and Teams, use OAuth-based authentication.
   - For MCP Servers, provide the MCP URL and credentials or OAuth token.
5. Confirm and save your configuration.

## Scenarios and benefits

**Communication example:**  
When the SRE Agent detects an incident, it can email stakeholders or post updates in Teams.

**Consumption example:**  
During troubleshooting, the agent can query telemetry from Datadog or Dynatrace.

**Benefits:**  
- Faster incident response with integrated communication.
- Better decision-making with real-time data.
- Simpler setup compared to traditional integrations.
