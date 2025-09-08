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
Enabling Geo Priority Replication is straightforward and can be completed via the Azure portal, PowerShell, or the Azure CLI. It can be enabled for existing accounts, or during the process of creating a new account.

### Enabling replication during new account creation

1. Navigate to the Azure portal and create a new storage account.
1. In the **Basics** tab, select the checkbox for **Geo priority replication** as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-new-accounts.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for a new storage account.":::

### Enabling replication for preexisting accounts

1. Navigate to the Azure portal and select a storage account. 
1. In the **Data Management** group, select **Redundancy** to display the redundancy options for the storage account.
1. Select the **Geo priority replication (Blob only)** checkbox to enable the feature as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-existing-accounts.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for existing accounts.":::

### Confirmation and Monitoring

After priority replication is enabled, you have the ability to view geo-lag metrics on the account as shown in the following screenshot. You can check your "geo lag" performance throughout the month via the **Insights** and **Metrics** panes.

:::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-enabled.png" alt-text="Screenshot showing a storage account with geo priority replication enabled.":::

<!--
## Metrics and Performance Limitations

After geo priority replication is enabled, you have access to monitor your storage account's geo lag metrics, which tracks replication delay in seconds. SLA compliance requires that the delay is less than 900 seconds, or 15 minutes.

The following sample screen capture provides an example of a monthly geo lag metric view from within the **Insights** pane. This example shows that the storage account's geo lag is well within the 900-s range of the SLA. As a result, there's no need to request a service credit for an SLA violation.

:::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-lag.png" alt-text="Screenshot showing a storage account's geo lag metrics with geo priority replication enabled.":::

By comparison, the following example shows the geo blob lag exceeding the 15-minute threshold several times throughout the billing month. As a result, the affected user might be eligible to receive a service credit for the SLA violation.

:::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-lag-breach.png" alt-text="Screenshot showing a storage account's geo lag metrics breaching the SLA.":::

### SLA Ineligibility

There are several factors that can affect a user's eligibility for a service credit under the geo priority replication SLA. Although geo blob lag metrics might suggest eligibility for a replication SLA service credit, the feature contains various guardrails that might temporarily suspend the SLA. These guardrails include ingress and copy blob requests limits. 

For example, although the geo blob lag might exceed 15 minutes, this spike could be the result of a guardrail breach, making the storage account ineligible for a service credit. As a result, you need to determine whether you're eligible for the SLA during spikes in your geo blob lag.

The **Reasons for Geo Priority Replication Ineligibility** metric allows you to track whether you're eligible for the SLA throughout the month. This metric tracks the number of reasons an account is ineligible for geo priority replication, providing a count of guardrails breached. If your geo blob lag exceeds 15 minutes, check the **Reasons for Geo Priority Replication Ineligibility** metric to ensure you haven't breached any guardrails during the billing period. The sample image provided illustrates this metric. If no guardrails are reported, the SLA has likely been breached and you should contact support to obtain a service credit.

:::image type="content" source="media/storage-redundancy-priority-replication-manage/replication-ineligibility-reason.png" alt-text="Screenshot of the Reasons for Geo Priority Replication Ineligibility metric when multiple guardrails are violated throughout the month.":::

### Guardrails and performance limitations

To maintain SLA eligibility, users must remain within defined guardrails:

- **Ingress Limit:** Must remain below 1 Gbps for block blob accounts.
- **CopyBlob Requests:** Must not exceed 100 requests/sec.
- **Blob Types:** Page and Append Blob API calls within the last 30 days make the account ineligible.
- **Initial LST:** LST must be ≤ 15 minutes on at least one occasion before the SLA applies.
-->