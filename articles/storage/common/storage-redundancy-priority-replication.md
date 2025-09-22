---
title: Azure Storage Geo Priority Replication
titleSuffix: Azure Storage
description: Learn how Azure Storage Geo Priority Replication helps maintain high availability and cross-region data integrity.
services: storage
author: stevenmatthew

ms.service: azure-storage
ms.topic: concept-article
ms.date: 09/17/2025
ms.author: shaas
ms.subservice: storage-common-concepts
ms.custom: references_regions, engagement
# Customer intent: "As a cloud architect, I want to understand the Azure Object and Geo-Redundant Storage Replication SLA so that I can understand what to expect in terms of data durability and high availability requirements."
---

<!--
Initial: 98 (896/1)
Current: 99 (975/1)
-->

# Azure Storage Geo Priority Replication

Azure Blob Storage Geo Priority Replication is designed to meet the stringent compliance and business continuity requirements of Azure Blob users. The feature prioritizes the replication traffic of Blob data for storage accounts with geo-redundant storage (GRS) and geo-zone redundant storage (GZRS) enabled. This prioritization accelerates data replication between the primary and secondary regions of these geo-redundant accounts. 

A Service Level Agreement (SLA) backs geo priority replication, and applies to any account that has Geo priority replication enabled. It guarantees that the Last Sync Time (LST) for your account's Blob data is 15 minutes or less for 99.0% of the time. In addition to prioritized replication traffic, the feature includes enhanced monitoring and detailed telemetry, with the assurance of service credits if the SLA isn't met.

You can monitor your geo lag via Azure portal's **Insights** and **Metrics** panes. If the SLA is breached, you might be eligible for service credits based on the degree of nonconformance.

## Benefits of geo priority replication

While there are many benefits to using geo priority replication, it's especially beneficial, for example, in the following scenarios:

- Meeting compliance regulations that require a strict Recovery Point Objective (RPO) for storage accounts.
- Recovering from a storage related outage in the primary region where initiating an [unplanned failover](storage-failover-customer-managed-unplanned?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json) is required. Users can guarantee that all their Blob and Azure Data Lake Storage (ADLS) data is replicated to their secondary region within 15 minutes or less. As a result, any Blob or ADLS data written within 15 minutes of an unplanned failover can be fully recovered after the unplanned failover is completed.
- Strengthening your disaster recovery planning to meet both compliance and business requirements. Users with business-critical data and a need for high availability and disaster recovery receive a significant benefit.

<!--
## SLA terms and guarantees

The SLA defines the specific conditions under which GRS Priority Replication features are guaranteed. It also describes the service credit tiers and billing scope associated with SLA violations.

Microsoft guarantees that the Last Sync Time (LST) is within 15 minutes across **99.0% of a billing month**. Failure to meet this performance guarantee results in Priority Replication and Geo Data Transfer fee credits for all write transactions during a specific billing month.

The following list specifies the credit tiers that apply if this guarantee isn't met:

| Percent of billing month | Service Credit  |
|--------------------------|-----------------|
| 99.0% to 98.0%           | **10% credit**  |
| 98.0% to 95.0%           | **25% credit**  |
| Below 95.0%              | **100% credit** |
-->

## SLA eligibility and exclusions

While Geo Priority Replication introduces an SLA-backed capability for Azure Blob Storage, it comes with several important limitations. First and foremost, the SLA applies exclusively to block blob data. Other blob types, such as page blobs and append blobs, aren't supported under this SLA. If these unsupported blob types contribute to geo lag, the affected time window is excluded from SLA eligibility. 

Additionally, the SLA is contingent on the storage account remaining within specific operational thresholds, known as guardrails. These guardrails include:

- Account ingress rate exceeding 1 Gbps
- More than 100 CopyBlob requests per second

Although the account's replication is still prioritized during these time periods, the account is temporarily ineligible for the SLA. The SLA will resume after the rate drops below these thresholds, and the resulting backlog of writes are replicated. These thresholds are in place to ensure that the replication pipeline can maintain the promised performance levels. 

Another consideration is the initial synchronization period, which is the period immediately following the enabling of the Geo Priority Replication feature. Data replication prioritization begins immediately after enabling the feature, but the SLA might not apply during this initial sync period. If the account's Last Sync Time exceeds 15 minutes during this time, the SLA doesn't apply and service credits aren't available until the Last Sync Time is consistently at or below 15 minutes. Customers can [monitor their LST](last-sync-time-get?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json) and replication status through Azure's provided metrics and dashboards. 

Certain operational scenarios can also disrupt SLA coverage. For example, an unplanned failover will automatically disable Geo Priority Replication, requiring you to re-enable the feature manually after geo-redundancy is restored. By comparison, planned failovers and account conversions between GRS and geo zone redundant storage (GZRS) don't affect SLA eligibility, provided the account remains within guardrails. 

Finally, customers who choose to opt out of Geo Priority Replication continue to be billed for an extra 30 days.  

These limitations are critical to understanding how and when the SLA applies, and Azure provides detailed telemetry and metrics to help customers monitor their eligibility throughout the billing cycle. 

## Next steps

- [Manage Geo Priority Replication](storage-redundancy-priority-replication-manage.md)
- [Geo Priority Replication pricing](storage-redundancy-priority-replication-pricing.md)
- [Azure Storage pricing](https://azure.microsoft.com/pricing/details/storage/)
