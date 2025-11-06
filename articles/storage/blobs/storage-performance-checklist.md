---
title: Performance checklist for Azure Blob Storage
titleSuffix: Azure Storage
description: A comprehensive checklist of recommendations that reduce latency and maximize throughput when transferring objects to, from, and between Azure Blob Storage. 
services: storage
author: normesta

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 11/05/2025
ms.author: normesta
ms.devlang: csharp
ms.custom: devx-track-csharp, devx-track-dotnet
# Customer intent: As a developer or system administrator, I want a comprehensive checklist of performance optimization techniques for Azure Blob Storage, so that I can reduce latency, maximize throughput, choose the right storage options and tools, and align with Azure Storage targets to prevent throttling.
---

# Performance checklist for Blob Storage

Use the checklist in this article to reduce _latency_, increase _throughput_, and align with Azure Storage scale and performance _targets_. 

Azure Storage publishes [standard storage account targets](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json) and [Blob Storage targets](scalability-targets.md). These values are called _targets_ rather than _limits_ because some values can be increased upon request.  

When clients approach or exceed these targets, Azure Storage might throttle requests, which increases latency. However, you can align with targets without sacrificing performance by following this checklist.

## Performance checklist

> [!div class="checklist"]
>
> - **Consider premium storage** - If clients must exceed request rate or ingress and egress targets, consider using premium block blob storage accounts, which are optimized for high transaction rates and low, consistent latency. To learn more, see [Premium block blob storage accounts](storage-blob-block-blob-premium.md). 
>
> - **Use an efficient object naming convention** - Enable better load balancing by using an efficient naming convention. Add a hash character sequence (such as three digits) as early as possible in the partition key. If you use timestamps in names, consider adding a seconds value to the beginning of that stamp. Using a hash code or seconds value at the beginning of a partition key reduces the time required to list, query, and read blobs. For complete guidance, see [Partitioning](/azure/storage/blobs/storage-performance-checklist#partitioning).  
>
> - **Locate data near clients** - Reducing the physical distance between the storage account and VMs, services, and on-premises clients can improve performance and reduce network latency. Locate storage accounts, VM clients, and data-consuming service instances in the same region.<br><br>For clients that aren't hosted on Azure, locate the storage account in a region closer to those clients.<br>- If clients exist in multiple regions and don't require the same data, consider using one storage account per region.<br>- If those clients need to share some data, consider using an object-replication policy to asynchronously copy relevant objects to a storage account closest to the client.<br>- For broad consumption by web clients (streaming video, audio, or static website content), consider using a content delivery network (CDN) through [Azure Front Door](../../frontdoor/front-door-overview.md).
>
> - **Use performance-optimized data transfer tools** - The AzCopy command-line utility is a simple and efficient option for bulk transfer of blobs to, from, and across storage accounts. AzCopy is optimized to achieve high transfer rates. For example, AzCopy copies data between accounts by using server-to-server APIs and uploads data in parallel by default, which spreads the upload across multiple partitions of the storage service. See [Get started with AzCopy](../common/storage-use-azcopy-v10.md).<br>For importing large volumes of data into Blob storage, consider using the Azure Data Box family for offline transfers. Microsoft-supplied Data Box devices are a good choice for moving large amounts of data to Azure when you're limited by time, network availability, or costs. For more information, see the [Azure DataBox Documentation](../../databox/index.yml). 
>
> - **Optimize custom code** - If you build or maintain a custom application using REST or an Azure Storage SDK, see the [Performance checklist for developers (Azure Blob Storage)](storage-performance-checklist-developers.md) for recommendations that can reduce application latency.
>
> - **Activate high-throughput block blobs** - Configure clients to upload blob or block sizes greater than 4 MiB for standard storage accounts and 256 KiB for premium storage accounts. Larger blob or block sizes automatically activate high-throughput block blobs, which provide high-performance ingest that isn't affected by partition naming.  
>
> - **Maximize network throughput** - If you need higher network limits, use a larger VM size. The network interface card on a larger VM instance has greater capacity. If you're accessing Azure Storage from an on-premises application, review the network capabilities of the client device and the network connectivity to the Azure Storage location. You can improve those capabilities or configure clients to work more efficiently with them.<br>Errors and packet loss can also slow effective throughput. Monitor link quality by using tools such as WireShark or NetMon.

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Performance checklist for developers (Azure Blob Storage)](storage-performance-checklist-developers.md)
- [Latency in Blob Storage](storage-blobs-latency.md)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

