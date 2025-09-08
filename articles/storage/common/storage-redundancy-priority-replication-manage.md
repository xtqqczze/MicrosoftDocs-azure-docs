---
title: Managing the Azure Object and Geo-Redundant Storage Replication Service Level Agreement
titleSuffix: Azure Storage
description: Enable and disable Geo-Redundant Storage Replication.
services: storage
author: stevenmatthew

ms.service: azure-storage
ms.topic: concept-article
ms.date: 08/05/2025
ms.author: shaas
ms.subservice: storage-common-concepts
ms.custom: references_regions, engagement
# Customer intent: "As a cloud architect, I want to understand the Azure Object and Geo-Redundant Storage Replication service level agreement so that I can understand what to expect in terms of data durability and high availability requirements."
---

<!--
Initial: 98 (896/1)
-->

# Managing Azure Geo-Redundant Storage replication

Geo Priority Replication is a premium feature designed to meet stringent Recovery Point Objectives (RPO) for geo-redundant storage accounts. It carries a service level agreement (SLA) guaranteeing the Last Sync Time (LST) remains within 15 minutes lag for 99.0% of a billing month.

## Enabling Geo-Redundant Storage replication
Enabling Geo Priority Replication is straightforward and can be completed via the Azure portal, PowerShell, or the Azure CLI. It can be enabled for existing accounts, or during the process of creating a new account. The `SLAEffectiveDate` property indicates when SLA becomes active. After you enable the SLA, the status will be set to **Pending** until the replication backlog is cleared. You can check the SLA status in the Azure portal under the **Replication** section of your storage account. 

### Enabling replication during new account creation

1. Navigate to the Azure portal and create a new storage account.
1. In the **Basics** tab, select the checkbox for **Geo priority replication** as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-new-accounts.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for a new storage account.":::

### Enabling replication for preexisting accounts

1. Navigate to the Azure portal and select a storage account. 
1. In the **Data Management** group, select **Redundancy** to display the redundancy options for the storage account.
1. Select the **Geo priority replication (Blob only)** checkbox to enable the feature as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-existing-accounts.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for existing accounts.":::

## Monitoring compliance

To ensure transparency and empower customers to track their SLA compliance, Azure provides a set of monitoring tools integrated directly into the Azure portal. After priority replication is enabled, you have the ability to view geo-lag metrics on a per-account basis. You can check your "geo lag" performance throughout the month via the **Insights** and **Metrics** panes. These dashboards display real-time and historical data on *geo blob lag*, which measures the replication delay between the primary and secondary regions. 

You can view lag metrics over timeframes ranging from the last five minutes to multiple months. These metrics allow you to assess performance trends and identify potential SLA breaches. Additionally, a specialized **Reasons for Geo Priority Replication Ineligibility** metric identifies whether any guardrails were breached. Examples of these breaches include ingress limits and unsupported blob types, both of which would invalidate SLA eligibility during specific time windows. 

These tools provide a comprehensive view of replication health and SLA conformance, as shown in the following screenshot. This visibility enables you to make informed decisions and initiate service credit claims when necessary. 

:::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-enabled.png" alt-text="Screenshot showing a storage account with geo priority replication enabled.":::

## Claiming service credits

To claim a refund for SLA violations:

1. **Open a support case** via Azure portal.
2. Include:
   - "SLA Credit Request" in the subject.
   - Billing cycle and region.
   - Logs showing SLA breach.
3. Submit within **two billing cycles** of the incident.
4. Microsoft validates eligibility using internal dashboards.

## Next steps

- [Geo Priority Replication pricing](storage-redundancy-priority-replication-pricing.md)
- [Azure Storage pricing](https://azure.microsoft.com/pricing/details/storage/)
