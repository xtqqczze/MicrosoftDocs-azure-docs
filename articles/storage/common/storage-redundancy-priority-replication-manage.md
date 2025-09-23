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

Geo Priority Replication is a premium feature designed to meet stringent Recovery Point Objectives (RPO) for storage accounts using geo-redundant storage (GRS) or geo-zone redundant storage (GZRS). It enhances the replication process by enabling accelerated data replication between the primary and secondary regions. It carries a service level agreement (SLA) guaranteeing the Last Sync Time (LST) remains within 15 minutes lag for 99.0% of a billing month.

## Enabling Geo-Redundant Storage replication
Enabling Geo Priority Replication is straightforward and can be completed via the Azure portal, PowerShell, or the Azure CLI. It can be enabled for existing accounts, or during the process of creating a new account.

### Enabling replication during new account creation

To enable Geo Priority Replication when creating a new storage account, complete the following steps:

# [Azure portal](#tab/portal)

1. Navigate to the Azure portal and create a new storage account.
1. In the **Basics** tab, select the checkbox for **Geo priority replication** as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-new-accounts.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for a new storage account.":::

# [Azure PowerShell](#tab/powershell)

Content for PowerShell...

# [Azure CLI](#tab/cli)

Content for CLI...

# [REST API](#tab/rest)

Content for REST API...

---

### Enabling replication for preexisting accounts

To enable Geo Priority Replication for an existing storage account, complete the following steps:

# [Azure portal](#tab/portal)

1. Navigate to the Azure portal and select a storage account. 
1. In the **Data Management** group, select **Redundancy** to display the redundancy options for the storage account.
1. Select the **Geo priority replication (Blob only)** checkbox to enable the feature as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-existing-accounts.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for existing accounts.":::

# [Azure PowerShell](#tab/powershell)

Content for PowerShell...

# [Azure CLI](#tab/cli)

Content for CLI...

# [REST API](#tab/rest)

Content for REST API...

---

## Monitoring compliance

To ensure transparency and empower customers to track the performance of Geo priority replication, Azure provides a set of monitoring tools integrated directly into the Azure portal. After geo priority replication is enabled, you have the ability to view geo-lag metrics on a per-account basis. You can check your "geo lag" performance throughout the month via the **Insights** and **Metrics** panes. These dashboards display real-time and historical data on *geo blob lag*, which measures the replication delay between the primary and secondary regions of your storage account.

You can view lag metrics over timeframes ranging from the last five minutes to multiple months. These metrics allow you to assess performance trends and identify potential SLA breaches. 

One metric, **Geo Blob Lag**, allows you to monitor the lag, or the number of seconds since the last full data copy between the primary and secondary regions, of your block blob data. Geo blob lag can be viewed over the course of a specified time range, up to 12 months.

The following screenshot shows an example of geo blob lag over a 30-day period. In this example, the geo blob lag remains consistently below the 15-minute threshold, indicating compliance with the SLA.

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

- [Geo Priority Replication overview](storage-redundancy-priority-replication-pricing.md)
- [Azure Storage pricing](https://azure.microsoft.com/pricing/details/storage/)
