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

Priority replication is backed by a Service Level Agreement (SLA) guarantee if your policy's source and destination account are located within the same continent. The SLA ensures 99.0% of operations are replicated from the source storage account to the destination storage account within 15 minutes during a billing month. Please refer to the official [SLA terms] for a comprehensive list of eligibility requirements.

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

In addition to performance guarantees, priority replication automatically enabled OR metrics which enhances visibility into replication progress. These metrics allow users to monitor the number of operations and bytes pending replication, segmented into time buckets such as 0–5 minutes, 5–10 minutes, and beyond. This detailed insight helps teams proactively manage replication health and identify potential delays. To learn more about OR metrics view, (insert link)

Organizations can enable priority replication on both new and existing OR policies using the REST API. This flexibility allows teams to upgrade their current replication workflows without reconfiguring their entire setup. Overall, priority replication empowers businesses to replicate their most important data with confidence and precision.

## SLA Eligibility and Exclusions

Once Object Replication Priority Replication is enabled users will benefit from prioritized replication along with the improved visibility into their replication progress from OR metrics. While the replication from the source storage account to destination storage account remains prioritized there are limitations to which workloads are eligible for the Service Level Agreement for Priority Replication. These limitations include:

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
  
Please refer to the official [SLA terms] for a comprehensive list of eligibility requirements.

> [!IMPORTANT]
> Although a storage account can have up to two object replication policies, priority replication can only be enabled on one object replication policy per storage account.


## Feature Pricing

Rewrite, add link: https://review.learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview?branch=pr-en-us-306513#billing

Priority replication introduces a new pricing model to reflect its enhanced capabilities. Customers are charged $0.015 per gigabyte of data replicated under this feature. This cost takes effect shortly after Priority replication is enabled.

While Priority replication itself incurs a charge, the associated OR metrics are free of cost. However, enabling metrics might lead to increased change feed reads, which could result in extra charges depending on usage.

Standard costs for read and write transactions, and for network egress still apply. These charges are consistent with existing OR pricing and should be considered when estimating the total cost of using Priority replication. For detailed pricing information, customers are encouraged to consult the [Blob Storage pricing page](https://azure.microsoft.com/pricing/details/storage/blobs/) page.


## How to monitor SLA compliance for OR priority Replication

Object Replication Priority Replication: 

Replication Metrics for Object Replication empower users to troubleshoot replication delays and will help users with priority replication enabled monitor their SLA compliance. Metrics now supported are: 

Pending Operations: Tracks the total number of operations pending replication from the source to the destination storage account of your OR policy  

Pending Bytes: Tracks the total volume of data pending replication from the source to the destination storage account of your OR policy  

These metrics are grouped into various time buckets including 0-5 minutes, 10-15 minutes and > 24 hours.  

Users with OR priority replication that would like to ensure all their operations are replicating within 15 minutes; can monitor the larger time buckets (ex: 30 mins – 2hours or 8-24 hours) and ensure they are at zero or near zero. 


Users also have other options such as checking the replication status of their source blob. Users can check the replication status of a source blob to determine whether replication to the destination has been completed. Once the replication status is marked as “Completed,” the user can guarantee the blob is available in the destination account. 

## Configuring priority replication

Some stuff to add here about how to enable priority replication

## Opt-Out Policy and Billing Continuity

Customers have the flexibility to disable Priority replication at any time. However, it's important to note that billing for the feature will continue for 30 days after being disabled. This policy ensures that any in-progress replication operations are completed and monitored appropriately, maintaining data integrity and consistency. 

This 30-day billing continuity allows Azure to manage the transition smoothly and ensures that customers don't experience unexpected interruptions in replication performance. Organizations should plan accordingly when deciding to opt out of Priority replication, especially if the feature was enabled for critical workloads.
