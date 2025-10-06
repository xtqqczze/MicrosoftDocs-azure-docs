---
title: Introducing object replication priority replication for block blobs
titleSuffix: Azure Storage
description: Object replication's priority replication feature allows users to obtain prioritized replication from their source storage account to the destination storage account of their replication policy.
author: stevenmatthew

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 10/05/2025
ms.author: shaas

# Customer intent: As a cloud storage administrator, I want to implement object replication for block blobs, so that I can improve data availability, reduce read latency, and optimize cost-efficiency across multiple regions.
---

# Introducing Priority Replication for Azure Storage object replication (preview)

Currently, object replication copies all operations from a source storage account to one or more destination accounts asynchronously, with no guaranteed completion time. However, with the introduction of priority replication, users can now choose to prioritize replication for their replication policies. This feature ensures that these operations are replicated more quickly than standard operations.

Priority replication also provides a Service Level Agreement (SLA) guarantee if your policy's source and destination account are located within the same continent. The SLA is expressed in terms of a percentage of operations that are replicated within 15 minutes. It guarantees that 99.9% of operations are replicated within 15 minutes during a billing month.

> [!IMPORTANT]
> This feature enabled is currently in preview and is available only in a limited number of regions. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.
>
> Priority replication is available only within the following regions:
    - East US 2
    - West US 2
    - North Europe
    - West Europe
    - Japan East
    - Japan West
    - Central India
    - Switzerland North
    - UAE North

## Benefits of priority replication

Priority replication significantly improves the performance and observability for Azure object replication. When enabled, the feature prioritizes replication for an organization's replication policies. This feature ensures that these operations are replicated more quickly than standard operations.

Moreover, priority replication comes with a Service Level Agreement (SLA) that provides users with a performance guarantee provided the source and destination storage accounts are located within the same continent. The SLA guarantees that 99.9% of replication operations complete within 15 minutes during a billing month. This level of assurance is especially valuable for scenarios involving disaster recovery, business continuity, and high-availability architectures.

In addition to performance guarantees, priority replication enhances visibility into replication progress through required object replication metrics. These metrics allow users to monitor the number of operations and bytes pending replication, segmented into time buckets such as 0–5 minutes, 5–10 minutes, and beyond. This detailed insight helps teams proactively manage replication health and identify potential delays.

Organizations can enable priority replication on both new and existing object replication policies using the REST API. This flexibility allows teams to upgrade their current replication workflows without reconfiguring their entire setup. Overall, priority replication empowers businesses to replicate their most important data with confidence and precision.

## SLA Eligibility and Exclusions

To benefit from the priority replication SLA, certain conditions must be met. First, the source and destination storage accounts must be located within the same continent. This geographic proximity is essential for achieving the expected replication speed.

The SLA applies only to objects that are 5 GB or smaller. Additionally, priority replication can only be configured on one replication policy per source account. This limitation ensures that Azure can maintain the performance guarantees across all participating accounts.

There are also operational thresholds that might affect SLA eligibility. The SLA is only valid when storage account data transfer rates remain below 1 gigabit per second and experiences fewer than 1,000 `PUT` or `DELETE` operations per second. Similarly, if the replication policy was recently created or updated, the SLA might take time to become active. This delay might also occur when there's a significant operations backlog pending replication.

## Feature Pricing

Priority replication introduces a new pricing model to reflect its enhanced capabilities. Customers are charged $0.015 per gigabyte of data replicated under this feature. This cost takes effect shortly after Priority replication is enabled.

While Priority replication itself incurs a charge, the associated object replication metrics are free of cost. However, enabling metrics might lead to increased change feed reads, which could result in extra charges depending on usage.

Standard costs for read and write transactions, and for network egress still apply. These charges are consistent with existing object replication pricing and should be considered when estimating the total cost of using Priority replication. For detailed pricing information, customers are encouraged to consult the [Blob Storage pricing page](/pricing/details/storage/blobs/) page.

## Opt-Out Policy and Billing Continuity

Customers have the flexibility to disable Priority replication at any time. However, it's important to note that billing for the feature will continue for 30 days after being disabled. This policy ensures that any in-progress replication operations are completed and monitored appropriately, maintaining data integrity and consistency.
This 30-day billing continuity allows Azure to manage the transition smoothly and ensures that customers don't experience unexpected interruptions in replication performance. Organizations should plan accordingly when deciding to opt out of Priority replication, especially if the feature was enabled for critical workloads.
