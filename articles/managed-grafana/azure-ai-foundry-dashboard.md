---
title: Create an Azure AI Foundry dashboard in Azure Managed Grafana
description: Learn how to set up and configure an Azure AI Foundry platform metrics dashboard in Azure Managed Grafana to monitor AI workload performance and resource utilization.
#customer intent: As a platform engineer or data scientist, I want to monitor Azure AI Foundry platform metrics in a Grafana dashboard so that I can track resource utilization, performance, and operational health of my AI workloads.
author: maud-lv
ms.author: malev
ms.service: azure-managed-grafana
ms.topic: how-to
ms.date: 11/03/2025
ai-usage: ai-assisted
---

# Create an Azure AI Foundry dashboard in Azure Managed Grafana

In this guide, you learn how to set up an Azure AI Foundry platform metrics dashboard in Azure Managed Grafana. This dashboard provides visibility into your AI infrastructure, including compute utilization, model performance, resource consumption, and operational metrics.

The Azure AI Foundry dashboard is designed for platform engineers, data scientists, and operations teams who need to monitor AI workload performance, track resource usage, and identify potential issues in their Azure AI infrastructure.

## What is the Azure AI Foundry dashboard?

The Azure AI Foundry platform metrics dashboard is a pre-configured Grafana dashboard that visualizes key metrics from Azure AI services and infrastructure. It provides real-time monitoring of:

- **Model performance**: Inference latency, throughput, and success rates
- **Resource consumption**: Token usage, API calls, and cost tracking

This dashboard helps you optimize resource allocation, identify performance bottlenecks, and maintain the health of your AI platform.

## Prerequisites

Before you begin, ensure you have:

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free).
- An Azure Managed Grafana workspace. If you don't have one yet, [create an Azure Managed Grafana workspace](./quickstart-managed-grafana-portal.md).
- An Azure AI Foundry resource with metrics enabled.
- Appropriate permissions to read metrics from your Azure AI resources (Reader role or higher).
- Azure Monitor configured to collect metrics from your AI services.

## Import the Azure AI Foundry dashboard

Import the pre-built Azure AI Foundry dashboard into your Grafana workspace.

1. In the Azure portal, open your Azure Managed Grafana workspace and select the **Endpoint** URL to open the Grafana portal.

1. In the Grafana portal, go to **Dashboards** > **New** > **Import**.

1. Under **Find and import dashboards for common applications at grafana.com/dashboards**, enter the dashboard ID for the Azure AI Foundry dashboard: **24039**.

1. Select **Load**.

1. Configure the import settings:

   - **Name**: Optionally customize the dashboard name.
   - **Folder**: Select a folder to organize your dashboard.
   - **Unique identifier (UID)**: Leave as default or customize.
   - **Azure Monitor**: Select your Azure Monitor data source from the dropdown.

   > [!NOTE]
   > Ensure your Azure Managed Grafana workspace has the Monitoring Reader role on the subscription, resource group, or specific Azure AI Foundry resource. If not, [assign the role to the workspace's managed identity](./how-to-permissions.md#edit-azure-monitor-permissions).

1. Select **Import**.

1. After importing the dashboard, use the dropdown selectors at the top of the dashboard to filter your specific AI Foundry resource.

> [!TIP]
> You can also import this dashboard directly from the Azure portal. Go to **Monitor** > **Dashboards with Grafana (preview)**, and select the **AI Foundry** dashboard, or go to [AI Foundry dashboard](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureGrafana.ReactView/GalleryType/Azure%20Monitor/ConfigurationId/AIFoundry).

:::image type="content" source="media/ai-foundry-dashboard/ai-foundry-top-section.png" alt-text="Screenshot of Grafana showing Azure Monitor data source configuration." lightbox="media/ai-foundry-dashboard/ai-foundry-top-section.png":::::

:::image type="content" source="media/ai-foundry-dashboard/ai-foundry-latency.png" alt-text="Screenshot of Grafana showing Azure Monitor data source configuration."lightbox="media/ai-foundry-dashboard/ai-foundry-latency.png":::

## Customize the dashboard

Tailor the dashboard to your specific monitoring needs.

To add a new panel:

1. Select **Add** > **Visualization** at the top of the dashboard.

1. Select your Azure Monitor data source.

1. Configure the query:

   - **Data source**: Select **Azure Monitor**.
   - **Resource**: Choose your AI Foundry or OpenAI resource.
   - **Metric namespace**: Select the appropriate namespace (for example, `Microsoft.CognitiveServices/accounts`).
   - **Metric**: Choose the metric to display (for example, `TokenTransaction`, `Latency`). For a complete list of available metrics, see [Azure AI Foundry metrics](/azure/ai-foundry/foundry-models/how-to/monitor-models#metrics-explorer).
   - **Aggregation**: Select the aggregation method (Average, Sum, Count, Min, Max).

1. Configure visualization options:

   - **Panel title**: Enter a descriptive title.
   - **Visualization type**: Choose from Time series, Stat, Gauge, Bar chart, Table, or other types.
   - **Unit**: Set the appropriate unit (percent, milliseconds, requests/sec, etc.).
   - **Thresholds**: Define warning and critical thresholds for visual alerts.

1. Select **Apply** to add the panel to your dashboard.

   :::image type="content" source="media/ai-foundry-dashboard/azure-monitor-datasource.png" alt-text="Screenshot of Grafana showing Azure Monitor data source configuration.":::

## Related content

- [Create dashboards in Azure Managed Grafana](./how-to-create-dashboard.md).
- [Monitor model deployments in Azure AI Foundry Models](/azure/ai-foundry/foundry-models/how-to/monitor-models.md)
