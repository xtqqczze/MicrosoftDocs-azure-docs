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

Azure Storage has scalability and performance targets for capacity, transaction rate, and bandwidth. For more information about Azure Storage scalability targets, see [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json) and [Scalability and performance targets for Blob storage](scalability-targets.md).

This article presents best practices for optimizing the performance of uploading blobs, downloading blobs, or copying blobs between containers or between accounts.

## Performance checklist to optimize latency

Azure Storage latency is related to request rates for Azure Storage operations. Request rates are also known as input/output operations per second (IOPS). To learn more about latency, see [Latency in Blob storage](storage-blobs-latency.md).

Monitor your storage account to identify performance bottlenecks that occur from throttling. For more information, see [Monitoring your storage service with Monitor Storage insights](/azure/storage/common/storage-insights-overview#view-from-azure-monitor). Use both metrics and logs. Metrics provide numbers such as throttling errors. Logs describe activity. If you see throttling metrics, you can use logs to identity which clients are receiving throttling errors. For more information, see [Auditing data plane operations](/azure/storage/blobs/blob-storage-monitoring-scenarios#auditing-data-plane-operations).

> [!div class="checklist"]
>
> - **Choose the optimal storage account type**: If your workload requires high transaction rates, smaller objects, and a consistently low transaction latency, then consider using premium block blob storage accounts. A standard general-purpose v2 account is most appropriate in most cases.  
> - **Capacity and transaction targets**: If your application hits the transaction target, consider using block blob storage accounts, which are optimized for high transaction rates and low and consistent latency. For more information, see [Azure storage account overview](../common/storage-account-overview.md). If you're building a custom application by using REST, make sure that you are performing automatic retries. SDKs have default retry behavior built into them. See - point to guidance. Question - how would you know that you are approaching transaction targets?.  
>
> - **Bandwidth and operations per blob**: If you have multiple clients that need to read the same blob and you might exceed the number of requests that single blob can receive per second, then consider using a block blob storage account. A block blob storage account provides a higher request rate, or I/O operations per second (IOPS). You can also use a content delivery network (CDN) such as Azure CDN to distribute operations on the blob. For more information about Azure CDN, see [Azure CDN overview](../../cdn/cdn-overview.md). How would the customer measure this and know that they have this issue? 
>
> - **Multiple clients accessing a single blob concurrently**: If you have a large number of clients accessing a single blob concurrently, you need to consider both per blob and per storage account scalability targets. The exact number of clients that can access a single blob varies depending on factors such as the number of clients requesting the blob simultaneously, the size of the blob, and network conditions. If the blob can be distributed through a CDN such as images or videos served from a website, then you can use a CDN. For more information, see the section titled [Content distribution](#content-distribution). In other scenarios, such as scientific simulations where the data is confidential, you have two options. The first is to stagger your workload's access such that the blob is accessed over a period of time vs being accessed simultaneously. Alternatively, you can temporarily copy the blob to multiple storage accounts to increase the total IOPS per blob and across storage accounts. Results vary depending on your application's behavior, so be sure to test concurrency patterns during design. 
>
> - **Optimize data partitions**: Enable better load balancing by using an efficient naming convention. Add a hash character sequence (such as three digits) as early as possible in the partition key of a blob. The partition key is the account name, container name, virtual directory name, and blob name. If you plan to use timestamps in names, then consider adding a seconds value to the beginning of that stamp. For more information, see [Partitioning](/azure/storage/blobs/storage-performance-checklist#partitioning). Using a hash code or seconds value nearest the beginning of a partition key reduces the time required to list query and read blobs.  
>
> - **Locate data near clients**: If client applications access Azure Storage but aren't hosted within Azure, such as mobile device apps or on premises enterprise services, then locating the storage account in a region near to those clients may reduce latency. If your clients are broadly distributed (for example, some in North America, and some in Europe), then consider using one storage account per region. This approach is easier to implement if the data the application stores is specific to individual users, and doesn't require replicating data between storage accounts. For broad distribution of blob content, use a content deliver network such as Azure CDN. For more information about Azure CDN, see [Azure CDN](../../cdn/cdn-overview.md). In any distributed environment, placing the client near to the server delivers in the best performance. For accessing Azure Storage with the lowest latency, the best location for your client is within the same Azure region. For example, if you have an Azure web app that uses Azure Storage, then locate them both within a single region, such as US West or Asia Southeast. Co-locating resources reduces the latency and the cost, as bandwidth usage within a single region is free. Provision storage accounts in the same region where dependent resources are placed. For applications that aren't hosted on Azure, such as mobile device apps or on-premises enterprise services, locate the storage account in a region nearer to those clients. For more information, see [Azure geographies](https://azure.microsoft.com/explore/global-infrastructure/geographies/#overview). If clients from a different region don't require the same data, then create a separate account in each region. If clients from a different region require only some data, consider using an object-replication policy to asynchronously copy relevant objects to a storage account in the other region. Reducing the physical distance between the storage account and VMs, services, and on-premises clients can improve performance and reduce network latency. Reducing the physical distance also reduces cost for applications hosted in Azure because bandwidth usage within a single region is free. For broad distribution of blob content, use a content deliver network such as Azure CDN. For more information about Azure CDN, see [Azure CDN](../../cdn/cdn-overview.md). 
>
> - **Distribute content efficiently**: For broad consumption by web clients (streaming video, audio, or static website content), consider using a content delivery network through Azure Front Door. Content is delivered to clients faster because it uses the Microsoft global edge network with hundreds of global and local points of presence around the world. Sometimes an application needs to serve the same content to many users (for example, a product demo video used in the home page of a website), located in either the same or multiple regions. In this scenario, use a Content Delivery Network (CDN) such as Azure Front Door. Azure Front Door is Microsoft’s modern cloud CDN that provides fast, reliable, and secure access between your users and your applications’ static and dynamic web content across the globe. Azure Front Door delivers your Blob Storage content using Microsoft’s global edge network with hundreds of [global and local points of presence (PoPs)](../../frontdoor/edge-locations-by-region.md). A CDN can typically support much higher egress limits than a single storage account and offers improved latency for content delivery to other regions. For more information about Azure Front Door, see [Azure Front Door](../../frontdoor/front-door-overview.md). 
> 

## Performance checklist to optimize throughput

Throughput is related to the request rate and can be calculated by multiplying the request rate (IOPS) by the request size. 

Perhaps a link to any guidance about to monitor throughput or perhaps any information that might appear due to throughput issues.

> [!div class="checklist"]
>
> - **block size and throughput**: When uploading blobs or blocks, use a blob or block size that's greater than 256 KiB. | Blob or block sizes above 256 KiB takes advantage of performance enhancements in the platform made specifically for larger blobs and block sizes. If possible, use blob or block sizes greater than 4 MiB for standard storage accounts and 256 KiB for premium storage accounts. Larger blob or block sizes automatically activate high-throughput block blobs. High-throughput block blobs provide high-performance ingest that isn't affected by partition naming.  
>
> - **Optimize network bandwidth**: For bandwidth, the problem is often the capabilities of the client. Larger Azure instances have NICs with greater capacity, so you should consider using a larger instance or more VMs if you need higher network limits from a single machine. If you're accessing Azure Storage from an on premises application, then the same rule applies: understand the network capabilities of the client device and the network connectivity to the Azure Storage location and either improve them as needed or design your application to work within their capabilities.  
>
> - **Examine the quality of network links**: As with any network usage, keep in mind that network conditions resulting in errors and packet loss slows effective throughput.  Using WireShark or NetMon may help in diagnosing this issue. 
>
> - **Use performance optimized tools**: The AzCopy command-line utility is a simple and efficient option for bulk transfer of blobs to, from, and across storage accounts. AzCopy is optimized for this scenario, and can achieve high transfer rates. AzCopy version 10 uses the `Put Block From URL` operation to copy blob data across storage accounts. AzCopy also performs uploads in parallel by default. Uploading in parallel is faster than uploading single blobs at a time with parallel block uploads because it spreads the upload across multiple partitions of the storage service. For more information, see [Copy or move data to Azure Storage by using AzCopy v10](../common/storage-use-azcopy-v10.md).Put something here for storage mover. For importing large volumes of data into Blob storage, consider using the Azure Data Box family for offline transfers. Microsoft-supplied Data Box devices are a good choice for moving large amounts of data to Azure when you're limited by time, network availability, or costs. For more information, see the [Azure DataBox Documentation](../../databox/index.yml). For more information about choosing a migration data tool, see put link here.  
>

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

