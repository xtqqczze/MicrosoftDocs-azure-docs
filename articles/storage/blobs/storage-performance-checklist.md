---
title: Performance and scalability checklist for Blob storage
titleSuffix: Azure Storage
description: A checklist of proven practices for use with Blob storage in developing high-performance applications.
services: storage
author: normesta

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 06/01/2023
ms.author: normesta
ms.devlang: csharp
ms.custom: devx-track-csharp, devx-track-dotnet
# Customer intent: As a developer, I want a checklist of proven practices for optimizing Blob storage performance, so that I can ensure my application scales efficiently and meets performance targets while avoiding throttling and errors.
---

# Optimize the performance of Blob Storage data transfers

This article presents best practices for optimizing the performance of uploading blobs, downloading blobs, or copying blobs between containers or between accounts.

If you are building a custom application, then make sure to also look at the developer guide for optimizing for performance.

## Optimization checklist

> [!div class="checklist"]
>
> - **Scale and performance targets** - Understand the targets for both Azure Storage accounts and for Blob Storage. (**[Learn more](#section-link)**).
>
> - **Premium storage** - Consider premium accounts if clients near the transaction rate or request for blob scale limit. (**[Learn more](#premium-storage)**).
>
> - **Blob naming convention** - Enhance load balancing by using an efficient blob naming convention. (**[Learn more](#section-link)**).
>
> - **Data location** - Locate data near clients. (**[Learn more](#section-link)**).
>
> - **Content Delivery Network (CDN)** - Use a CDN to distribute content broadly. (**[Learn more](#section-link)**).
>
> - **Block size** - Leverage high-throughput block blobs by adjusting block sizes. (**[Learn more](#section-link)**).
>
> - **Network bandwidth** - Maximize bandwidth of VMs and on premises clients (**[Learn more](#section-link)**).
>
> - **Data transfer tools** - Use tools optimized for data transfer (**[Learn more](#section-link)**).
> 
> - **Performance monitoring** - Monitor metrics and logs for performance. (**[Learn more](#section-link)**).

## Review scale targets

Azure Storage publishes scale and performance _targets_. They are called _targets_ and not _limits_ because some numbers can be increased by request. 

The following table shows the targets that relate to data transfer.

| Scale resource                | Measurement         | Adjustable       | Scale targets                                                                      |
|-------------------------------|---------------------|------------------|------------------------------------------------------------------------------------|
| Ingress                       | GB per second       | Yes              | [Storage account scale targets](../common/scalability-targets-standard-account.md) |
| Egress                        | GB per second       | Yes              | [Storage account scale targets](../common/scalability-targets-standard-account.md) |
| Request rate                  | Requests per second | No               | [Storage account scale targets](../common/scalability-targets-standard-account.md) |
| Request rate of a single blob | Requests per second | No               | [Blob Storage scale targets](scalability-targets.md)                               |

Ingress and Egress limits can be increased by request. However request rates targets are fixed. You can keep within those targets by using a premium storage account, a Content Delivery Network (CDN), or by copying blobs to multiple accounts.

## Premium storage

If your your clients will far exceed the transaction target or you have multiple clients that need to read the same blob and you might exceed the number of requests that single blob can receive per second, then consider using premium block blob storage accounts which are optimized for high transaction rates and low and consistent latency. To learn more about the performance and cost effectiveness of premium block blob storage accounts, see [Premium block blob storage accounts](storage-blob-block-blob-premium.md). 

## Blob naming convention

Enable better load balancing by using an efficient naming convention. Add a hash character sequence (such as three digits) as early as possible in the partition key of a blob. The partition key is the account name, container name, virtual directory name, and blob name. If you plan to use timestamps in names, then consider adding a seconds value to the beginning of that stamp. For more information, see [Partitioning](/azure/storage/blobs/storage-performance-checklist#partitioning). Using a hash code or seconds value nearest the beginning of a partition key reduces the time required to list query and read blobs. 

## Data location

If client applications access Azure Storage but aren't hosted within Azure, such as mobile device apps or on premises enterprise services, then locating the storage account in a region near to those clients may reduce latency.
If your clients are broadly distributed (for example, some in North America, and some in Europe), then consider using one storage account per region. This approach is easier to implement if the data the application stores is specific to individual users, and doesn't require replicating data between storage accounts. 

In any distributed environment, placing the client near to the server delivers in the best performance. For accessing Azure Storage with the lowest latency, the best location for your client is within the same Azure region. For example, if you have an Azure web app that uses Azure Storage, then locate them both within a single region, such as US West or Asia Southeast. Co-locating resources reduces the latency and the cost, as bandwidth usage within a single region is free. Provision storage accounts in the same region where dependent resources are placed. 

For applications that aren't hosted on Azure, such as mobile device apps or on-premises enterprise services, locate the storage account in a region nearer to those clients. For more information, see [Azure geographies](https://azure.microsoft.com/explore/global-infrastructure/geographies/#overview). 

If clients from a different region don't require the same data, then create a separate account in each region. If clients from a different region require only some data, consider using an object-replication policy to asynchronously copy relevant objects to a storage account in the other region. Reducing the physical distance between the storage account and VMs, services, and on-premises clients can improve performance and reduce network latency. Reducing the physical distance also reduces cost for applications hosted in Azure because bandwidth usage within a single region is free. 

For broad distribution of blob content, use a content deliver network such as Azure CDN. For more information about Azure CDN, see [Azure CDN](../../cdn/cdn-overview.md). 

## Content Deliver Network

For broad consumption by web clients (streaming video, audio, or static website content), consider using a CDN through [Azure Front Door](../../frontdoor/front-door-overview.md).

Azure Front Door is Microsoft's modern cloud CDN that provides fast, reliable, and secure access between your users and your applications’ static and dynamic web content across the globe. Azure Front Door delivers your Blob Storage content using Microsoft's global edge network with hundreds of [global and local points of presence (PoPs)](../../frontdoor/edge-locations-by-region.md). 

A CDN can typically support much higher egress limits than a single storage account and offers improved latency for content delivery to other regions. F 

## Block size

When uploading blobs or blocks, use blob or block sizes greater than 4 MiB for standard storage accounts and 256 KiB for premium storage accounts. Larger blob or block sizes automatically activate high-throughput block blobs. High-throughput block blobs provide high-performance ingest that isn't affected by partition naming.  

## Network bandwidth

For bandwidth, the problem is often the capabilities of the client. Larger Azure instances have NICs with greater capacity, so you should consider using a larger instance or more VMs if you need higher network limits from a single machine. If you're accessing Azure Storage from an on premises application, then the same rule applies: understand the network capabilities of the client device and the network connectivity to the Azure Storage location and either improve them as needed or design your application to work within their capabilities.  

## Data transfer tools

The AzCopy command-line utility is a simple and efficient option for bulk transfer of blobs to, from, and across storage accounts. AzCopy is optimized for this scenario, and can achieve high transfer rates. AzCopy version 10 uses the `Put Block From URL` operation to copy blob data across storage accounts. AzCopy also performs uploads in parallel by default. Uploading in parallel is faster than uploading single blobs at a time with parallel block uploads because it spreads the upload across multiple partitions of the storage service. For more information, see [Copy or move data to Azure Storage by using AzCopy v10](../common/storage-use-azcopy-v10.md).Put something here for storage mover. For importing large volumes of data into Blob storage, consider using the Azure Data Box family for offline transfers. Microsoft-supplied Data Box devices are a good choice for moving large amounts of data to Azure when you're limited by time, network availability, or costs. For more information, see the [Azure DataBox Documentation](../../databox/index.yml). For more information about choosing a migration data tool, see put link here.  

## Performance metrics and log entries

Monitor your storage account to identify performance bottlenecks that occur from throttling. For more information, see [Monitoring your storage service with Monitor Storage insights](/azure/storage/common/storage-insights-overview#view-from-azure-monitor). Use both metrics and logs. Metrics provide numbers such as throttling errors. Logs describe activity. If you see throttling metrics, you can use logs to identity which clients are receiving throttling errors. For more information, see [Auditing data plane operations](/azure/storage/blobs/blob-storage-monitoring-scenarios#auditing-data-plane-operations).

Use WireShark or NetMon to monitor for errors and packet loss which can slow network throughput.

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

