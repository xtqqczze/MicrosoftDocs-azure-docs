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

# Performance and scalability checklist for Blob storage

Microsoft has developed a number of proven practices for developing high-performance applications with Blob storage. This checklist identifies key practices that developers can follow to optimize performance. Keep these practices in mind while you're designing your application and throughout the process.

Azure Storage has scalability and performance targets for capacity, transaction rate, and bandwidth. For more information about Azure Storage scalability targets, see [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json) and [Scalability and performance targets for Blob storage](scalability-targets.md).

This article organizes proven practices for performance into a checklist you can follow while developing your Blob storage application.

| Done | Category | Design consideration |
| --- | --- | --- |
| &nbsp; |Scalability targets |[Are you avoiding approaching capacity and transaction limits?](#capacity-and-transaction-targets) |
| &nbsp; |Scalability targets |[Are a large number of clients accessing a single blob concurrently?](#multiple-clients-accessing-a-single-blob-concurrently) |
| &nbsp; |Scalability targets |[Is your application staying within the scalability targets for a single blob?](#bandwidth-and-operations-per-blob) |
| &nbsp; |Partitioning |[Is your naming convention designed to enable better load-balancing?](#partitioning) |
| &nbsp; |Networking |[Do client-side devices have sufficiently high bandwidth and low latency to achieve the performance needed?](#throughput) |
| &nbsp; |Networking |[Do client-side devices have a high quality network link?](#link-quality) |
| &nbsp; |Networking |[Is the client application in the same region as the storage account?](#location) |
| &nbsp; |Direct client access |[Are you using shared access signatures (SAS) and cross-origin resource sharing (CORS) to enable direct access to Azure Storage?](#sas-and-cors) |
| &nbsp; |Caching |[Is your application caching data that is frequently accessed and rarely changed?](#reading-data) |
| &nbsp; |Caching |[Is your application batching updates by caching them on the client and then uploading them in larger sets?](#uploading-data-in-batches) |
| &nbsp; |.NET configuration |[Have you configured your client to use a sufficient number of concurrent connections?](#increase-default-connection-limit) |
| &nbsp; |.NET configuration |[For .NET applications, have you configured .NET to use a sufficient number of threads?](#increase-minimum-number-of-threads) |
| &nbsp; |Parallelism |[Have you ensured that parallelism is bounded appropriately so that you don't overload your client's capabilities or approach the scalability targets?](#unbounded-parallelism) |
| &nbsp; |Tools |[Are you using the latest versions of Microsoft-provided client libraries and tools?](#client-libraries-and-tools) |
| &nbsp; |Retries |[Are you using a retry policy with an exponential backoff for throttling errors and timeouts?](#timeout-and-server-busy-errors) |
| &nbsp; |Retries |[Is your application avoiding retries for non-retryable errors?](#non-retryable-errors) |
| &nbsp; |Copying blobs |[Are you copying blobs in the most efficient manner?](#blob-copy-apis) |
| &nbsp; |Copying blobs |[Are you using the latest version of AzCopy for bulk copy operations?](#use-azcopy) |
| &nbsp; |Copying blobs |[Are you using the Azure Data Box family for importing large volumes of data?](#use-azure-data-box) |
| &nbsp; |Content distribution |[Are you using a CDN for content distribution?](#content-distribution) |
| &nbsp; |Use metadata |[Are you storing frequently used metadata about blobs in their metadata?](#use-metadata) |
| &nbsp; |Service metadata | [Allow time for account and container metadata propagation](#account-and-container-metadata-updates) |
| &nbsp; |Performance tuning |[Are you proactively tuning client library options to optimize data transfer performance?](#performance-tuning-for-data-transfers) |
| &nbsp; |Uploading quickly |[When trying to upload one blob quickly, are you uploading blocks in parallel?](#upload-one-large-blob-quickly) |
| &nbsp; |Uploading quickly |[When trying to upload many blobs quickly, are you uploading blobs in parallel?](#upload-many-blobs-quickly) |
| &nbsp; |Blob type |[Are you using page blobs or block blobs when appropriate?](#choose-the-correct-type-of-blob) |

## Performance checklist

> [!div class="checklist"]
>
> - **Choose the optimal storage account type**: If your workload requires high transaction rates, smaller objects, and a consistently low transaction latency, then consider using premium block blob storage accounts. A standard general-purpose v2 account is most appropriate in most cases.  
> - **Reduce travel distance between the client and server**: Place data in regions nearest to connecting clients (ideally in the same region). Optimize for clients in regions far away by using object replication or a content delivery network. Default network configurations provide the best performance. Modify network settings only to improve security. In general, network settings don't decrease travel distance and don't improve performance.
> - **Collect performance data**: Monitor your storage account to identify performance bottlenecks that occur from throttling. For more information, see [Monitoring your storage service with Monitor Storage insights](/azure/storage/common/storage-insights-overview#view-from-azure-monitor). Use both metrics and logs. Metrics provide numbers such as throttling errors. Logs describe activity. If you see throttling metrics, you can use logs to identity which clients are receiving throttling errors. For more information, see [Auditing data plane operations](/azure/storage/blobs/blob-storage-monitoring-scenarios#auditing-data-plane-operations).
>
> - **Item**: Description.  
>
> - **Item**: Description.  
>
> - **Item**: Description.  
>
> - **Item**: Description.  
>
> - **Item**: Description.  
>
> - **Item**: Description.  
>
> - **Item**: Description.  
>
> - **Item**: Description.  
>

## Scalability targets

If your application approaches or exceeds any of the scalability targets, it might encounter increased transaction latencies or throttling. When Azure Storage throttles your application, the service begins to return 503 (Server busy) or 500 (Operation timeout) error codes. Avoiding these errors by staying within the limits of the scalability targets is an important part of enhancing your application's performance.

Link to scalability targets

### Capacity and transaction targets

If your application hits the transaction target, consider using block blob storage accounts, which are optimized for high transaction rates and low and consistent latency. For more information, see [Azure storage account overview](../common/storage-account-overview.md).

If you're building a custom application by using REST, make sure that you are performing automatic retries. SDKs have default retry behavior built into them. See - point to guidance.

### Bandwidth and operations per blob

If you have multiple clients that need to read the same blob and you might exceed the number of requests that single blob can receive per second, then consider using a block blob storage account. A block blob storage account provides a higher request rate, or I/O operations per second (IOPS).

You can also use a content delivery network (CDN) such as Azure CDN to distribute operations on the blob. For more information about Azure CDN, see [Azure CDN overview](../../cdn/cdn-overview.md).

### Multiple clients accessing a single blob concurrently

If you have a large number of clients accessing a single blob concurrently, you need to consider both per blob and per storage account scalability targets. The exact number of clients that can access a single blob varies depending on factors such as the number of clients requesting the blob simultaneously, the size of the blob, and network conditions.

If the blob can be distributed through a CDN such as images or videos served from a website, then you can use a CDN. For more information, see the section titled [Content distribution](#content-distribution).

In other scenarios, such as scientific simulations where the data is confidential, you have two options. The first is to stagger your workload's access such that the blob is accessed over a period of time vs being accessed simultaneously. Alternatively, you can temporarily copy the blob to multiple storage accounts to increase the total IOPS per blob and across storage accounts. Results vary depending on your application's behavior, so be sure to test concurrency patterns during design.

### Optimize data partitions

- If possible, use blob or block sizes greater than 4 MiB for standard storage accounts and 256 KiB for premium storage accounts. Larger blob or block sizes automatically activate high-throughput block blobs. High-throughput block blobs provide high-performance ingest that isn't affected by partition naming.

- Examine the naming convention you use for accounts, containers, and blobs. Consider prefixing account, container, or blob names with a three-digit hash using a hashing function that best suits your needs.

- If you organize your data using timestamps or numerical identifiers, make sure that you aren't using an append-only (or prepend-only) traffic pattern. These patterns aren't suitable for a range-based partitioning system. These patterns may lead to all traffic going to a single partition and limiting the system from effectively load balancing.

  For example, if you have daily operations that use a blob with a timestamp such as *yyyymmdd*, then all traffic for that daily operation is directed to a single blob, which is served by a single partition server. Consider whether the per-blob limits and per-partition limits meet your needs, and consider breaking this operation into multiple blobs if needed. Similarly, if you store time series data in your tables, all traffic may be directed to the last part of the key namespace. If you're using numerical IDs, prefix the ID with a three-digit hash. If you're using timestamps, prefix the timestamp with the seconds value, for example, *ssyyyymmdd*. If your application routinely performs listing and querying operations, choose a hashing function that limits your number of queries. In some cases, a random prefix may be sufficient.

  To learn more, see [Partitioning Blob Storage](storage-performance-partitioning.md)

From WAF:

Add a hash character sequence (such as three digits) as early as possible in the partition key of a blob. The partition key is the account name, container name, virtual directory name, and blob name. If you plan to use timestamps in names, then consider adding a seconds value to the beginning of that stamp. For more information, see [Partitioning](/azure/storage/blobs/storage-performance-checklist#partitioning).

Using a hash code or seconds value nearest the beginning of a partition key reduces the time required to list query and read blobs.

When uploading blobs or blocks, use a blob or block size that's greater than 256 KiB. | Blob or block sizes above 256 KiB takes advantage of performance enhancements in the platform made specifically for larger blobs and block sizes.

### Optimize VM size

For bandwidth, the problem is often the capabilities of the client. Larger Azure instances have NICs with greater capacity, so you should consider using a larger instance or more VMs if you need higher network limits from a single machine.

### Optimize on premises clients 

 If you're accessing Azure Storage from an on premises application, then the same rule applies: understand the network capabilities of the client device and the network connectivity to the Azure Storage location and either improve them as needed or design your application to work within their capabilities.

#### Examine link quality

As with any network usage, keep in mind that network conditions resulting in errors and packet loss slows effective throughput.  Using WireShark or NetMon may help in diagnosing this issue.

### Locate data near clients

In any distributed environment, placing the client near to the server delivers in the best performance. For accessing Azure Storage with the lowest latency, the best location for your client is within the same Azure region. For example, if you have an Azure web app that uses Azure Storage, then locate them both within a single region, such as US West or Asia Southeast. Co-locating resources reduces the latency and the cost, as bandwidth usage within a single region is free.

Provision storage accounts in the same region where dependent resources are placed. For applications that aren't hosted on Azure, such as mobile device apps or on-premises enterprise services, locate the storage account in a region nearer to those clients. For more information, see [Azure geographies](https://azure.microsoft.com/explore/global-infrastructure/geographies/#overview).

If clients from a different region don't require the same data, then create a separate account in each region. 

If clients from a different region require only some data, consider using an object-replication policy to asynchronously copy relevant objects to a storage account in the other region. 

Reducing the physical distance between the storage account and VMs, services, and on-premises clients can improve performance and reduce network latency. Reducing the physical distance also reduces cost for applications hosted in Azure because bandwidth usage within a single region is free

For broad distribution of blob content, use a content deliver network such as Azure CDN. For more information about Azure CDN, see [Azure CDN](../../cdn/cdn-overview.md).

## Distribute content efficiently

For broad consumption by web clients (streaming video, audio, or static website content), consider using a content delivery network through Azure Front Door.  

Content is delivered to clients faster because it uses the Microsoft global edge network with hundreds of global and local points of presence around the world.

Sometimes an application needs to serve the same content to many users (for example, a product demo video used in the home page of a website), located in either the same or multiple regions. In this scenario, use a Content Delivery Network (CDN) such as Azure Front Door. Azure Front Door is Microsoft’s modern cloud CDN that provides fast, reliable, and secure access between your users and your applications’ static and dynamic web content across the globe. Azure Front Door delivers your Blob Storage content using Microsoft’s global edge network with hundreds of [global and local points of presence (PoPs)](../../frontdoor/edge-locations-by-region.md). A CDN can typically support much higher egress limits than a single storage account and offers improved latency for content delivery to other regions. 

For more information about Azure Front Door, see [Azure Front Door](../../frontdoor/front-door-overview.md).

### Cache data to improve performance

In general, reading data once is preferable to reading it twice. Consider the example of a web application that has retrieved a 50 MiB blob from the Azure Storage to serve as content to a user. Ideally, the application caches the blob locally to disk and then retrieves the cached version for subsequent user requests.

One way to avoid retrieving a blob if it hasn't been modified since it was cached is to qualify the GET operation with a conditional header for modification time. If the last modified time is after the time that the blob was cached, then the blob is retrieved and re-cached. Otherwise, the cached blob is retrieved for optimal performance.

You may also decide to design your application to assume that the blob remains unchanged for a short period after retrieving it. In this case, the application doesn't need to check whether the blob was modified during that interval.

Configuration data, lookup data, and other data that is frequently used by the application are good candidates for caching.

For more information about using conditional headers, see [Specifying conditional headers for Blob service operations](/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).

### Upload data in batches

In some scenarios, you can aggregate data locally, and then periodically upload it in a batch instead of uploading each piece of data immediately. For example, suppose a web application keeps a log file of activities. The application can either upload details of every activity as it happens to a table (which requires many storage operations), or it can save activity details to a local log file and then periodically upload all activity details as a delimited file to a blob. If each log entry is 1 KB in size, you can upload thousands of entries in a single transaction. A single transaction supports uploading a blob of up to 64 MiB in size. The application developer must design for the possibility of client device or upload failures. If the activity data needs to be downloaded for an interval of time rather than for a single activity, then using Blob storage is recommended over Table storage.

### Use performance-optimized tools to transfer data

The AzCopy command-line utility is a simple and efficient option for bulk transfer of blobs to, from, and across storage accounts. AzCopy is optimized for this scenario, and can achieve high transfer rates. AzCopy version 10 uses the `Put Block From URL` operation to copy blob data across storage accounts. For more information, see [Copy or move data to Azure Storage by using AzCopy v10](../common/storage-use-azcopy-v10.md).

Put something here for storage mover.

For importing large volumes of data into Blob storage, consider using the Azure Data Box family for offline transfers. Microsoft-supplied Data Box devices are a good choice for moving large amounts of data to Azure when you're limited by time, network availability, or costs. For more information, see the [Azure DataBox Documentation](../../databox/index.yml).

For more information about choosing a migration data tool, see put link here.

## Upload many blobs quickly

To upload many blobs quickly, upload blobs in parallel. Uploading in parallel is faster than uploading single blobs at a time with parallel block uploads because it spreads the upload across multiple partitions of the storage service. AzCopy performs uploads in parallel by default, and is recommended for this scenario. For more information, see [Get started with AzCopy](../common/storage-use-azcopy-v10.md).

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

