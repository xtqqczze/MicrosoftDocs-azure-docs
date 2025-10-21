---
title: Introducing object replication priority replication for block blobs
titleSuffix: Azure Storage
description: Object replication's priority replication feature allows users to obtain prioritized replication from their source storage account to the destination storage account of their replication policy.
author: stevenmatthew

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 10/05/2025
ms.author: shaas

# Customer intent: As a cloud storage administrator, I want to implement priority object replication for block blobs, so that I can improve data availability, reduce read latency, and optimize cost-efficiency across multiple regions.
---

# Priority Replication for Azure Storage Object Replication

Object replication currently copies all operations from a source storage account to one or more destination accounts asynchronously, with no guaranteed completion time. However, with the introduction of object replication priority replication, users can now choose to prioritize the replication of their replication policy. 

Priority replication comes with a Service Level Agreement (SLA) guarantee if your policy's source and destination account are located within the same continent. The SLA ensures 99.0% of operations replicate from the source account to the destination account within 15 minutes during a billing month. Refer to the official [SLA terms] for a comprehensive list of eligibility requirements.

> [!IMPORTANT]
> This feature is generally available but is currently only offered in a limited number of regions.
>
> Priority replication is available only within the following regions:
> - East US 2
> - West US 2
> - North Europe
> - West Europe
> - Japan East
> - Japan West
> - Central India
> - Switzerland North
> - UAE North

## Benefits of priority replication

Priority replication significantly improves the performance and observability for Azure Object Replication (OR). Moreover, priority replication comes with a Service Level Agreement (SLA) that provides users with a performance guarantee provided the source and destination storage accounts are located within the same continent. The SLA guarantees that 99.0% of operations are replicated from the source storage account to the destination storage account within 15 minutes during a billing month. This level of assurance is especially valuable for scenarios involving disaster recovery, business continuity, and high-availability architectures.

In addition to performance guarantees, priority replication automatically enables OR metrics, which enhances visibility into replication progress. These metrics allow users to monitor the number of operations and bytes pending replication, segmented into time buckets such as 0–5 minutes, 5–10 minutes, and beyond. This detailed insight helps teams proactively manage replication health and identify potential delays. To learn more about OR metrics view, [replication metrics](https://learn.microsoft.com/azure/storage/blobs/object-replication-overview#replication-metrics).


## SLA Eligibility and Exclusions

When Object Replication Priority Replication is enabled, users benefit from prioritized replication along with the improved visibility into their replication progress from OR metrics. While the replication from the source storage account to destination storage account remains prioritized, there are limitations to which workloads are eligible for the Service Level Agreement for Priority Replication. These limitations include:

1. Objects larger than 5 gigabytes (GB), 
1. Objects that are modified more than 10 times per second,
1. Object Replication Policies where the Source Storage Account and Destination Storage Account are not within the same continent, 
1. Storage accounts that are:
    - Larger than 5 petabytes (PB) or 
    - Have more than 10 billion blobs and 
1. During time periods where:
    - Your storage account or Replication Policy data transfer rate exceeds 1 gigabit per second (Gbps) and the resulting back log of writes are being replicated, 
    - Your storage account or Replication Policy exceeds 1,000 PUT or DELETE operations per second and the resulting back log of writes are being replicated, and 
    - Existing blob replication is pending following a recent Replication Policy creation or update. Existing blob replication is estimated to progress at 100 TB per day on average but may experience reduced velocity when blobs with many versions are present.
  
Refer to the official [SLA terms] for a comprehensive list of eligibility requirements.

> [!IMPORTANT]
> Although a storage account can have up to two object replication policies, priority replication can only be enabled on one object replication policy per storage account. Users should plan accordingly when deciding to opt out of Priority replication, especially if the feature was enabled for critical workloads.


## Feature Pricing

Rewrite, add link: https://review.learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview?branch=pr-en-us-306513#billing

Priority replication introduces a new pricing model to reflect its enhanced capabilities. Customers are charged $0.015 per gigabyte of new data replicated under this feature. This cost takes effect shortly after Priority replication is enabled.

While Priority replication itself incurs a charge, the associated OR metrics are free of cost. However, enabling metrics might lead to increased change feed reads, which could result in extra charges depending on usage.

Standard costs for read and write transactions, and for network egress still apply. These charges are consistent with existing OR pricing and should be considered when estimating the total cost of using Priority replication. For detailed pricing information, customers are encouraged to consult the [Blob Storage pricing page](https://azure.microsoft.com/pricing/details/storage/blobs/).

> [!IMPORTANT]
> Customers have the flexibility to disable priority replication at any time. However, it's important to note that billing for the feature will continue for 30 days after being disabled.


## How to monitor SLA compliance for OR priority Replication

Object Replication Priority Replication: 

Replication Metrics for Object Replication empower users to troubleshoot replication delays and help users with priority replication enabled monitor their SLA compliance. Metrics now supported are: 

**Pending Operations**: Tracks the total number of operations pending replication from the source to the destination storage account of your OR policy  

**Pending Bytes**: Tracks the total volume of data pending replication from the source to the destination storage account of your OR policy  

These metrics are grouped into various time buckets including 0-5 minutes, 10-15 minutes and > 24 hours.  

Users with OR priority replication that would like to ensure all their operations are replicating within 15 minutes; can monitor the larger time buckets (ex: 30 mins – 2hours or 8-24 hours) and ensure they are at zero or near zero. 


Users also have other options such as checking the replication status of their source blob. Users can check the replication status of a source blob to determine whether replication to the destination has completed. Once the replication status is marked as “Completed,” the user can guarantee the blob is available in the destination account. 

## Enabling object replication priority replication

Users can enable OR priority replication on both new and exisiting OR policies using Azure portal, REST, PowerShell, or the Azure CLI. It can be enabled for existing OR policies, or during the process of creating new a new OR policy.

### Enabling priority replication during new policy creation

To enable OR Priority Replication when creating a new OR policy, complete the following steps:

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



