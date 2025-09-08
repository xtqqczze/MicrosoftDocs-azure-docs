---
title: Azure Storage Geo Priority Replication
titleSuffix: Azure Storage
description: Learn how Azure Storage Geo Priority Replication helps maintain high availability and cross-region data integrity.
services: storage
author: stevenmatthew

ms.service: azure-storage
ms.topic: concept-article
ms.date: 09/05/2025
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

The Azure Storage Geo Priority Replication feature is designed to meet the stringent compliance and business continuity requirements of enterprise customers. This feature includes a Service Level Agreement (SLA) that guarantees a Recovery Point Objective (RPO) of ≤15 minutes lag 99.0% of the time for geo-redundant storage (GRS) accounts. Opting into this feature provides prioritized replication traffic and detailed telemetry, with the assurance of service credits if the SLA isn't met.

This article provides a detailed breakdown of the SLA terms, eligibility criteria, exceptions, and monitoring mechanisms to help customers understand and manage their replication commitments effectively.

## How geo priority replication works

Geo Priority Replication enhances Azure's geo-redundant storage by prioritizing replication traffic in several layers of the Azure technology stack. This prioritization ensures that data written to the primary region is replicated to the secondary region within 15 minutes. Last Sync Time (LST) is recorded every minute, and any minute in which LST exceeds 15 minutes is counted as a *Bad LST Minute*. 

The SLA conformance percentage is calculated monthly using the following formula:

`(Total minutes − Bad LST minutes)/Total minutes X 100%`

For example, assuming a 30-day month with 43,200 total minutes, SLA conformance for 432 Bad LST Minutes would be calculated as:

`(43,200 - 432) / 43,200 X 100% = 99.0%`

Customers can monitor their geo lag via Azure portal's **Insights** and **Metrics** panes. If the SLA is breached, users might be eligible for service credits based on the degree of nonconformance.

## SLA terms and guarantees

The SLA defines the specific conditions under which Azure's Object Replication and GRS Priority Replication features are guaranteed. It also describes the service credit tiers and billing scope associated with SLA violations.

Microsoft guarantees that the Last Sync Time (LST) is within 15 minutes across **99.0% of a billing month**. Failure to meet this performance guarantee results in Priority Replication and Geo Data Transfer fee credits for all write transactions during a specific billing month.

The following list specifies the credit tiers that apply if this guarantee isn't met:

| Percent of billing month | Service Credit  |
|--------------------------|-----------------|
| 99.9% to 98.0%           | **10% credit**  |
| 98.0% to 95.0%           | **25% credit**  |
| Below 95.0%              | **100% credit** |

## SLA eligibility and exclusions

While Geo Priority Replication introduces a SLA-backed capability for Azure Storage, it comes with several important limitations. First and foremost, the SLA applies exclusively to block blob data. Other blob types, such as page blobs and append blobs, aren't supported under this SLA. If these unsupported blob types contribute to geo lag, the affected time window is excluded from SLA eligibility.

Additionally, the SLA is contingent on the storage account remaining within specific operational thresholds, known as guardrails. If the account experiences an ingress rate exceeding 1 Gbps, or more than 100 CopyBlob requests per second, the SLA is considered temporarily ineligible until the rate drops below these thresholds. These thresholds are in place to ensure that the replication pipeline can maintain the promised performance levels.

Another consideration is the initial synchronization period, which is the period immediately following the enabling of Geo Priority Replication. During this time, the account might have a significant backlog of data to replicate. The SLA doesn't apply and service credits aren't available until this backlog is cleared and the Last Sync Time (LST) is consistently at or below 15 minutes. Customers can monitor their LST and replication status through Azure's provided metrics and dashboards.

Certain operational scenarios can also disrupt SLA coverage. For example, an unplanned failover will automatically disable Geo Priority Replication, requiring you to re-enable the feature manually after geo-redundancy is restored. By comparison, planned failovers and account conversions between GRS and geo zone redundant storage (GZRS) don't affect SLA eligibility, provided the account remains within guardrails.

Finally, customers who choose to opt out of Geo Priority Replication continue to be billed for an extra 30 days. This policy acts as a safeguard against enabling the feature solely to prioritize backlog replication and then immediately disabling it to avoid charges. 

These limitations are critical to understanding how and when the SLA applies, and Azure provides detailed telemetry and metrics to help customers monitor their eligibility throughout the billing cycle.

## Monitoring compliance

To ensure transparency and empower customers to track their SLA compliance, Azure provides a set of monitoring tools integrated directly into the Azure portal. 

After Geo Priority Replication is enabled, access to detailed telemetry is provided through the **Metrics** and **Insights** panes. These dashboards display real-time and historical data on *geo blob lag*, which measures the replication delay between the primary and secondary regions. 

You can view lag metrics over timeframes ranging from the last five minutes to multiple months. These metrics allow you to assess performance trends and identify potential SLA breaches. Additionally, a specialized **Reasons for Geo Priority Replication Ineligibility** metric identifies whether any guardrails were breached. Examples of these breaches include ingress limits and unsupported blob types, both of which would invalidate SLA eligibility during specific time windows. 

These tools provide a comprehensive view of replication health and SLA conformance, enabling you to make informed decisions and initiate service credit claims when necessary.

## Enabling and Disabling the SLA

Enabling the SLA can be completed during account creation, or via the **Redundancy** pane in Azure portal (screen capture needed). The `SLAEffectiveDate` property indicates when SLA becomes active. After you enable the SLA, the status will be set to **Pending** until the replication backlog is cleared. You can check the SLA status in the Azure portal under the **Replication** section of your storage account. 

Customers can opt out and disable the SLA at any time, but billing for GRS continues for 30 days post-disablement. The SLA can be re-enabled at any time, but the `SLAEffectiveDate` value is reset to the current date. Metrics are retained for historical analysis.

## Claiming service credits

To claim a refund for SLA violations:

1. **Open a support case** via Azure portal.
2. Include:
   - "SLA Credit Request" in the subject.
   - Billing cycle and region.
   - Logs showing SLA breach.
3. Submit within **two billing cycles** of the incident.
4. Microsoft validates eligibility using internal dashboards.
