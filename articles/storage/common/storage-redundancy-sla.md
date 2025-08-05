---
title: Azure Object and Geo-Redundant Storage Replication SLA
titleSuffix: Azure Storage
description: Learn about the Azure Object and Geo-Redundant Storage Replication SLA.
services: storage
author: stevenmatthew

ms.service: azure-storage
ms.topic: concept-article
ms.date: 04/15/2025
ms.author: shaas
ms.subservice: storage-common-concepts
ms.custom: references_regions, engagement
# Customer intent: "As a cloud architect, I want to understand the Azure Object and Geo-Redundant Storage Replication SLA so that I can understand what to expect in terms of data durability and high availability requirements."
---

<!--
Initial: 98 (896/1)
-->

# Azure Object and Geo-Redundant Storage Replication SLA overview

Azure's Object Replication and Geo-Redundant Storage (GRS) Priority Replication features are designed to meet the stringent data durability and disaster recovery needs of enterprise customers. These features come with Service Level Agreements (SLAs) that guarantee replication performance under defined conditions. 

This article provides a detailed breakdown of the SLA terms, eligibility criteria, exceptions, and monitoring mechanisms to help customers understand and manage their replication commitments effectively.

## SLA terms and guarantees

This section outlines the specific replication guarantees provided by Azure’s Object Replication and GRS Priority Replication features. It also describes the service credit tiers and billing scope associated with SLA violations.

### Object Replication SLA

Microsoft guarantees that 99.9% of all Azure storage objects are replicated within **15 minutes** during a billing month. Failure to meet this performance guarantee results in service credits for SLA fees, replication data transfer, and Blob Storage requests for affected objects during a specific billing month.

The following list specifies the credit tiers that apply if this guarantee isn't met:

:::row:::
    :::column span="2":::
        **Service Credit Tiers**
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        99.9% to 98.0%
    :::column-end:::
    :::column:::
        **10% credit**
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        98.0% to 95.0%
    :::column-end:::
    :::column:::
        **25% credit**
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        Below 95.0%
    :::column-end:::
    :::column:::
        **100% credit**
    :::column-end:::
:::row-end:::

### GRS Priority Replication SLA

Microsoft guarantees that the Last Sync Time (LST) is within 15 minutes **99.0% of a billing month**. Failure to meet this performance guarantee results in Priority Replication and Geo Data Transfer fee credits for all write transactions during a specific billing month.

The following list specifies the credit tiers that apply if this guarantee isn't met:

:::row:::
    :::column span="2":::
        **Service Credit Tiers**
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        99.9% to 98.0%
    :::column-end:::
    :::column:::
        **10% credit**
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        98.0% to 95.0%
    :::column-end:::
    :::column:::
        **25% credit**
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        Below 95.0%
    :::column-end:::
    :::column:::
        **100% credit**
    :::column-end:::
:::row-end:::

## Eligibility

To qualify for SLA coverage, customers must meet specific conditions, commonly referred to as *guardrails*. These guardrails also include certain performance and configuration requirements as outlined within the following lists:

### Common Guardrails

- **Ingress Limit**: Must be below 1 Gbps.
- **CopyBlob Requests**: Must not exceed 100 requests per second.
- **Blob Type Restrictions**: Page Blob and Append Blob API calls within the last 30 days make the account ineligible.
- **Initial Sync**: SLA doesn't apply until the initial geo-replication or bootstrap is complete and LST is ≤ 15 minutes.

### Object Replication Guardrails

- SLA applies only to **new objects**.
- SLA doesn't cover **bootstrap replication** (existing data).
- SLA can be toggled on/off; billing and metrics apply only during active SLA periods.

### GRS Priority Replication Guardrails

- SLA begins once LST is ≤ 15 minutes.
- SLA is voided during **unplanned failovers**, **LRS to GRS conversions**, or **cross-region migrations** unless re-enabled.


## Exclusions and voiding scenarios

An SLA is voided under the following conditions:

- **Ingress or TPS spikes** beyond defined thresholds.
- **Replication configuration errors** - for example, mismatched prefixes.
- **Unplanned Failovers**: Automatically disables GRS Priority Replication.
- **Bootstrap Phase**: SLA is pending until backlog is cleared.
- **Feature Conflicts**: Certain operations, such as Page Blob uploads, can delay replication and void SLA temporarily.

## Monitoring compliance

Azure provides several metrics and dashboards to help customers monitor SLA performance:

### Metrics

- **Geo Blob Lag**: Tracks replication delay in seconds.
- **Reasons for SLA Ineligibility**: Indicates breached guardrails.
- **Pending Operations and Bytes**: Shows replication backlog.
- **SLA Compliance Percentage**: Calculated monthly based on eligible objects.

### Tools and Interfaces

- **Azure Portal**: SLA status, metrics, and activity logs.
- **Insights Blade**: Visualizes geo lag and SLA breaches.
- **Compliance Dashboards**: Internal tools used by support teams to validate credit claims.

## Enabling and Disabling the SLA

Enabling the SLA can be completed during account creation, or via the Redundancy pane in Azure portal (screen capture needed). The `SLAEffectiveDate` property indicates when SLA becomes active. After you enable the SLA, the status will be set to **Pending** until the replication backlog is cleared. You can check the SLA status in the Azure portal under the **Replication** section of your storage account. 

Customers can opt out and disable the SLA at any time, but billing for GRS continues for 30 days post-disablement. The SLA can be re-enabled at any time, but the `SLAEffectiveDate` value is reset to the current date. Metrics are retained for historical analysis.

## Claiming Service Credits

To claim a refund for SLA violations:

1. **Open a support case** via Azure portal.
2. Include:
   - "SLA Credit Request" in the subject.
   - Billing cycle and region.
   - Logs showing SLA breach.
3. Submit within **two billing cycles** of the incident.
4. Microsoft validates eligibility using internal dashboards.


## Pricing Overview

| Feature         | SLA Guarantee                        | Price per GB         | Credit Tiers         |
|----------------|--------------------------------------|----------------------|----------------------|
| AWS RTC        | 99.9% of objects                     | $0.015               | 10%, 25%, 100%       |
| GCP Turbo      | 99.0% time, 99.9% volume             | $0.04 (NA/EU), $0.11 (Asia) | 10%, 25%, 50%       |
| Azure GRS      | LST ≤ 15 min 99.0%                   | $0.015               | 10%, 25%, 100%       |
| Azure OR       | 99.9% of objects                     | $0.015               | 10%, 25%, 100%       |

---

## FAQs

### What happens if I enable SLA during a replication backlog?

You're billed immediately, but SLA eligibility starts only after the backlog is cleared and LST is ≤ 15 minutes.

### Can I enable SLA for existing data?

No. SLA applies only to new objects. Bootstrap replication is excluded.

### How do I know if I'm SLA eligible?

Use the "Reasons for SLA Ineligibility" metric to check guardrail breaches.

### Am I billed during ineligible periods?

Yes, billing continues, but you aren't eligible for service credits.
