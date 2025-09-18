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

The Azure Storage Geo Priority Replication feature is designed to meet the stringent compliance and business continuity requirements of enterprise customers. The feature prioritizes replication traffic for storage accounts with geo-redundant storage (GRS) and geo-zone redundant storage (GZRS) enabled. This prioritization accelerates data replication between the primary and secondary regions.

Geo priority replication includes a Service Level Agreement (SLA) that applies to any account that has Geo priority replication enabled. It guarantees a Last Sync Time (LST) of 15 minutes or less for 99.0% of a billing month. In addition to prioritized replication traffic, the feature includes enhanced monitoring and detailed telemetry, with the assurance of service credits if the SLA isn't met. The SLA conformance percentage is calculated monthly using the following formula:

`(Total minutes − Exceeded LST minutes) / Total minutes X 100%`

For example, assuming a 30-day month with 43,200 total minutes, SLA conformance for 432 Exceeded LST Minutes would be calculated as:

`(43,200 - 432) / 43,200 X 100% = 99.0%`

You can monitor your geo lag via Azure portal's **Insights** and **Metrics** panes. If the SLA is breached, you might be eligible for service credits based on the degree of nonconformance.

## Benefits of geo priority replication

While there are many benefits to using geo priority replication, it's especially beneficial, for example, in the following scenarios:

- Meeting compliance regulations that require a strict Recovery Point Objective (RPO) for storage accounts that require an SLA. 
- Recovering from a storage related outage in the primary region where initiating an unplanned failover is required. Users can guarantee that all their blob and data lake storage accounts are replicated to their secondary region within 15 minutes or less. As a result, data written within 15 minutes of an unplanned failover can be fully recovered after the unplanned failover is completed.
- Strengthening your disaster recovery planning to meet both compliance and business requirements. Users with business-critical data and a need for high availability and disaster recovery receive a significant benefit.

## SLA terms and guarantees

The SLA defines the specific conditions under which GRS Priority Replication features are guaranteed. It also describes the service credit tiers and billing scope associated with SLA violations.

Microsoft guarantees that the Last Sync Time (LST) is within 15 minutes across **99.0% of a billing month**. Failure to meet this performance guarantee results in Priority Replication and Geo Data Transfer fee credits for all write transactions during a specific billing month.

The following list specifies the credit tiers that apply if this guarantee isn't met:

| Percent of billing month | Service Credit  |
|--------------------------|-----------------|
| 99.0% to 98.0%           | **10% credit**  |
| 98.0% to 95.0%           | **25% credit**  |
| Below 95.0%              | **100% credit** |

## SLA eligibility and exclusions

While Geo Priority Replication introduces a SLA-backed capability for Azure Storage, it comes with several important limitations. First and foremost, the SLA applies exclusively to block blob data. Other blob types, such as page blobs and append blobs, aren't supported under this SLA. If these unsupported blob types contribute to geo lag, the affected time window is excluded from SLA eligibility.

Additionally, the SLA is contingent on the storage account remaining within specific operational thresholds, known as guardrails. If the account experiences an ingress rate exceeding 1 Gbps, or more than 100 CopyBlob requests per second, the SLA is considered temporarily ineligible until the rate drops below these thresholds. These thresholds are in place to ensure that the replication pipeline can maintain the promised performance levels.

Another consideration is the initial synchronization period, which is the period immediately following the enabling of Geo Priority Replication. During this time, the account might have a significant backlog of data to replicate. The SLA doesn't apply and service credits aren't available until this backlog is cleared and the Last Sync Time (LST) is consistently at or below 15 minutes. Customers can monitor their LST and replication status through Azure's provided metrics and dashboards.

Certain operational scenarios can also disrupt SLA coverage. For example, an unplanned failover will automatically disable Geo Priority Replication, requiring you to re-enable the feature manually after geo-redundancy is restored. By comparison, planned failovers and account conversions between GRS and geo zone redundant storage (GZRS) don't affect SLA eligibility, provided the account remains within guardrails.

Finally, customers who choose to opt out of Geo Priority Replication continue to be billed for an extra 30 days. This policy acts as a safeguard against enabling the feature solely to prioritize backlog replication and then immediately disabling it to avoid charges. 

These limitations are critical to understanding how and when the SLA applies, and Azure provides detailed telemetry and metrics to help customers monitor their eligibility throughout the billing cycle.

## Next steps

- [Manage Geo Priority Replication](storage-redundancy-priority-replication-manage.md)
- [Geo Priority Replication pricing](storage-redundancy-priority-replication-pricing.md)
- [Azure Storage pricing](https://azure.microsoft.com/pricing/details/storage/)
