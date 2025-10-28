---
title: Connect external services to Azure SRE Agent (Preview)
description: Learn to connect external resources to Azure SRE Agent for data consumption and outbound communication.
author: craigshoemaker
ms.author: cshoe
ms.topic: conceptual
ms.date: 10/28/2025
ms.service: azure-sre-agent
---

# Connect external services to Azure SRE Agent (Preview)

Connectors in Azure SRE Agent let you integrate external services for communication and data ingestion. Use connectors to send notifications, receive updates, and pull telemetry from monitoring platforms. This article explains connector types, how they work, and how to set them up.

## What are connectors?

Connectors are modular integrations that extend the SRE Agent's capabilities. There are two main types:

| Type | Description | Possible use case |
|--|--|--|
| **Communication connectors** | Send notifications and updates to services like Outlook and Microsoft Teams. | When the SRE Agent detects an incident, it can email stakeholders or post updates in Teams. |
| **Consumption connectors** | Ingest data from external monitoring platforms such as Datadog, Dynatrace, and New Relic. | During troubleshooting, the agent can query telemetry from Datadog or Dynatrace. |

## Available connectors

Azure SRE Agent includes these connectors:

- **Outlook** for sending email notifications.
- **Microsoft Teams** to post messages to Teams channels.
- **Custom MCP Servers** for integration with your own MCP server.
- **Approved partners** to ingest telemetry from Dynatrace, Datadog, and New Relic.

## Configure a connector

Follow these steps to set up a connector:

1. Go to **Settings** in the SRE Agent portal.
1. Select **Connectors**.
1. Choose a connector type (Outlook, Teams, or Custom MCP Server).
1. Authenticate:
   - For Outlook and Teams, use OAuth-based authentication.
   - For MCP Servers, provide the MCP URL and credentials or OAuth token.
1. Confirm and save your configuration.
