---
title: Azure Geo-Redundant Storage Replication SLA pricing
description: Learn about the Azure Object and Geo-Redundant Storage Replication SLA pricing.
titleSuffix: Azure Storage
services: storage
author: stevenmatthew

ms.service: azure-storage
ms.topic: concept-article
ms.date: 08/05/2025
ms.author: shaas
ms.subservice: storage-common-concepts
ms.custom: references_regions, engagement
# Customer intent: "As a cloud architect, I want to understand the Azure Object and Geo-Redundant Storage Replication SLA so that I can understand what to expect in terms of data durability and high availability requirements."
---

<!--
Initial: 97 (516/1)
-->

# Azure Geo-Priority Replication pricing

Geo Priority Replication is an optional enhancement for Azure GRS (Geo-Redundant Storage) accounts that guarantees a Recovery Point Objective (RPO) of 15 minutes 99.0% of each billing month. This feature is designed for mission-critical workloads and backed by a Service Level Agreement (SLA). After enabling the feature, you're continuously billed based on the total new data ingress.

## Feature pricing

The Geo Priority Replication pricing model is layered, but straightforward. Customers begin paying for the feature as soon as they opt in, even if their account is temporarily not meeting the SLA due to initial lag or catch-up, or for guardrail violations. For a broader explanation of the SLA, see [Azure Object and Geo-Redundant Storage Replication SLA overview](storage-redundancy-sla.md).

Here's a breakdown:

### Base pricing

- New data ingress charges at $0.015 per GB. All new data written to the storage account after enabling Geo Priority Replication is charged at this rate.
- Billing starts immediately upon enablement, regardless of current replication lag.
- Charges apply to all write transactions, including:
  - Geo Priority Replication fee
  - Geo Data Transfer, or "bandwidth"

### Additional Charges

- Standard GRS charges still apply - storage and read/write operations, for example.
- Network usage charges might be incurred if ingress exceeds defined thresholds.

To help visualize the pricing, here's a sample calculation:

| Component                       | Cost        |
|---------------------------------|-------------|
| Data Storage (GZRS)             | $8.28       |
| Geo Priority Replication Fee    | $1.50       |
| Write Operations (10,000)       | $0.10       |
| Read Operations (10,000)        | $0.004      |
| Geo-Replication Bandwidth       | $2.00       |
| **Total**                       | **$11.884** |

This example shows how the total cost is built from multiple components. The Geo Priority Replication fee is just one part of the overall bill, but its the key differentiator for SLA-backed replication.

## Credit policy

Customers can request service credits if their last sync time (LST) exceeds 15 minutes for more than 1% of their billing month. Customer service credits apply to Geo Priority Replication and Geo Data Transfer fees for all writes. Customers are only eligible for credits if no SLA guardrails are breached during the lag period.

The following table explains how Microsoft compensates customers when the replication guarantee isn't met. The more severe the breach, the higher the refund—up to 100% of the relevant fees.

> [!IMPORTANT]
> Credits apply only if SLA guardrails aren't breached during the lag period.

| Monthly Time Conformance  | Service Credit  |
|---------------------------|-----------------|
| 98.0% – < 99.0%           | 10%             |
| 95.0% – < 98.0%           | 25%             |
| < 95.0%                   | 100%            |

## Guardrails and eligibility

Customers are billed regardless of SLA eligibility, even if replication lags. SLA credits are voided if certain operational thresholds are violated. These thresholds are also referred to as *guardrails*, and include any of the following conditions:

- Ingress exceeds 1 Gbps for Block Blob accounts.
- CopyBlob requests per second exceed 100.
- Page or Append Blob API calls are made within the previous 30 days.
- LST exceeds 15 minutes at the time of opt-in, until the "lag" is resolved or "caught up."

These guardrails are in place to ensure the system can maintain performance. Breaching them disqualifies the account from SLA credits, even if replication falls behind.

## Opt-out policy and billing continuity

Customers who disable Geo Priority Replication continue to be billed for 30 days post-disablement. This practice is meant to prevent short-term opt-ins aimed at clearing replication backlogs. It also aligns with Azure's approach to other features like read-access disablement.

## Next steps

- [Azure Object and Geo-Redundant Storage Replication SLA overview](storage-redundancy-sla.md)
- [Azure Storage pricing](https://azure.microsoft.com/pricing/details/storage/)
- [Geo Priority Replication management](storage-redundancy-sla-manage.md)
