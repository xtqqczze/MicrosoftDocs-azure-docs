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
# Customer intent: As a developer, I want a checklist of proven practices for optimizing Blob storage performance, so that I can ensure my application scales efficiently and meets performance targets while avoiding throttling and errors.
---

# Performance checklist for Blob Storage

You can use the checklists in this article to reduce _latency_ and improve the _throughput_ of object transfers to, from, and between Azure storage accounts. _Latency_ is the amount of time that a client must wait for a request to complete. It's measured as input/output operations per second (IOPS). _Throughput_ is amount of data transferred per second and is calculated by multiplying the request rate (IOPS) by the request size. 

Optimize your data estate not only to reduce latency and increase throughput, but also to align with Azure Storage scale and performance _targets_. They are called _targets_ and not _limits_ because some numbers can be increased by request. The following articles lists all performance targets and identifies which targets can be increased by contacting support:

- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Scalability and performance targets for Blob storage](scalability-targets.md)

If clients approach or exceed targets such as the default maximum request rate or the default maximum ingress or egress in GB per second, then latency might increase, and requests might be throttled by the server. When Azure Storage throttles your clients, the service begins to return 503 (Server busy) or 500 (Operation timeout) error codes.

You don't have to reduce performance to meet these scale targets. The recommendations in this article can help you achieve maximum latency and throughput while ensuring that your data estate and workload demands align with targets. 

## Checklist of recommendations

> [!div class="checklist"]
>
> - **Consider premium storage** - If your your clients will far exceed the transaction target or you have multiple clients that need to read the same blob and you might exceed the number of requests that single blob can receive per second, then consider using premium block blob storage accounts which are optimized for high transaction rates and low and consistent latency. To learn more about the performance and cost effectiveness of premium block blob storage accounts, see [Premium block blob storage accounts](storage-blob-block-blob-premium.md). Point to scale limits, egress, and ingress.
>
> - **Blob naming convention** - Enable better load balancing by using an efficient naming convention. Add a hash character sequence (such as three digits) as early as possible in the partition key of a blob. The partition key is the account name, container name, virtual directory name, and blob name. If you plan to use timestamps in names, then consider adding a seconds value to the beginning of that stamp. For more information, see [Partitioning](/azure/storage/blobs/storage-performance-checklist#partitioning). Using a hash code or seconds value nearest the beginning of a partition key reduces the time required to list query and read blobs. 
>
> - **Data location** - If client applications access Azure Storage but aren't hosted within Azure, such as mobile device apps or on premises enterprise services, then locating the storage account in a region near to those clients may reduce latency.<br><br>If your clients are broadly distributed (for example, some in North America, and some in Europe), then consider using one storage account per region. This approach is easier to implement if the data the application stores is specific to individual users, and doesn't require replicating data between storage accounts. <br><br>In any distributed environment, placing the client near to the server delivers in the best performance. For accessing Azure Storage with the lowest latency, the best location for your client is within the same Azure region. For example, if you have an Azure web app that uses Azure Storage, then locate them both within a single region, such as US West or Asia Southeast. Co-locating resources reduces the latency and the cost, as bandwidth usage within a single region is free. Provision storage accounts in the same region where dependent resources are placed<br><br>For applications that aren't hosted on Azure, such as mobile device apps or on-premises enterprise services, locate the storage account in a region nearer to those clients. For more information, see [Azure geographies](https://azure.microsoft.com/explore/global-infrastructure/geographies/#overview).<br><br> If clients from a different region don't require the same data, then create a separate account in each region. If clients from a different region require only some data, consider using an object-replication policy to asynchronously copy relevant objects to a storage account in the other region. Reducing the physical distance between the storage account and VMs, services, and on-premises clients can improve performance and reduce network latency. Reducing the physical distance also reduces cost for applications hosted in Azure because bandwidth usage within a single region is free.<br><br>For broad distribution of blob content, use a content deliver network such as Azure CDN. For more information about Azure CDN, see [Azure CDN](../../cdn/cdn-overview.md).  
>
> - **Content Delivery Network (CDN)** - For broad consumption by web clients (streaming video, audio, or static website content), consider using a CDN through [Azure Front Door](../../frontdoor/front-door-overview.md).
>
> Azure Front Door is Microsoft's modern cloud CDN that provides fast, reliable, and secure access between your users and your applications’ static and dynamic web content across the globe. Azure Front Door delivers your Blob Storage content using Microsoft's global edge network with hundreds of [global and local points of presence (PoPs)](../../frontdoor/edge-locations-by-region.md). <br><br>A CDN can typically support much higher egress limits than a single storage account and offers improved latency for content delivery to other regions.<br><br>Mention that this can also help keep within request rate, ingress, and egress limits
>
> - **Data transfer tools** - The AzCopy command-line utility is a simple and efficient option for bulk transfer of blobs to, from, and across storage accounts. AzCopy is optimized for this scenario, and can achieve high transfer rates. AzCopy version 10 uses the `Put Block From URL` operation to copy blob data across storage accounts. AzCopy also performs uploads in parallel by default. Uploading in parallel is faster than uploading single blobs at a time with parallel block uploads because it spreads the upload across multiple partitions of the storage service. For more information, see [Copy or move data to Azure Storage by using AzCopy v10](../common/storage-use-azcopy-v10.md).Put something here for storage mover. For importing large volumes of data into Blob storage, consider using the Azure Data Box family for offline transfers. Microsoft-supplied Data Box devices are a good choice for moving large amounts of data to Azure when you're limited by time, network availability, or costs. For more information, see the [Azure DataBox Documentation](../../databox/index.yml). For more information about choosing a migration data tool, see put link here. 
>
> - **Optimize custom code** - Reduce latency by modifying the code of custom applications that you build or maintain, see [Performance checklist for developers (Azure Blob Storage)](storage-performance-checklist-developers.md).
>
> - **Block size** - When uploading blobs or blocks, use blob or block sizes greater than 4 MiB for standard storage accounts and 256 KiB for premium storage accounts. Larger blob or block sizes automatically activate high-throughput block blobs. High-throughput block blobs provide high-performance ingest that isn't affected by partition naming.  
>
> - **Network bandwidth** - For bandwidth, the problem is often the capabilities of the client. Larger Azure instances have NICs with greater capacity, so you should consider using a larger instance or more VMs if you need higher network limits from a single machine. If you're accessing Azure Storage from an on premises application, then the same rule applies: understand the network capabilities of the client device and the network connectivity to the Azure Storage location and either improve them as needed or design your application to work within their capabilities.  
>
> - **Network link quality** - Use WireShark or NetMon to monitor for errors and packet loss which can slow network throughput.

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Performance checklist for developers (Azure Blob Storage)](storage-performance-checklist-developers.md)
- [Latency in Blob Storage](storage-blobs-latency.md)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

