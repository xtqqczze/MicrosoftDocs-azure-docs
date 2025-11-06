---
title: Performance checklist for developers (Azure Blob Storage)
titleSuffix: Azure Storage
description: A comprehensive checklist of recommendations to optimize code for efficient data transfer blobs to, from, or between Azure Blob Storage accounts. Use this checklist to reduce latency and maximize throughput.
services: storage
author: normesta

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 11/06/2025
ms.author: normesta

# Customer intent: As a developer, I want a checklist of proven practices for optimizing Blob storage performance, so that I can ensure my application scales efficiently and meets performance targets while avoiding throttling and errors.
---

# Performance checklist for developers

Use this checklist to reduce _latency_, increase _throughput_, and align with Azure Storage scale and performance _targets_. 

## Scale and performance targets

Azure Storage publishes [standard storage account targets](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json) and [Blob Storage targets](scalability-targets.md). These values are called _targets_ rather than _limits_ because some values can be increased upon request. When clients approach or exceed these targets, Azure Storage might throttle requests, which increases latency. Use the checklist in this article to align with targets without sacrificing performance.

## Performance checklist

> [!div class="checklist"]
>
> - **Review primary performance checklist**: Description goes here. See [Performance checklist for Blob Storage](storage-performance-checklist.md).
> 
> - **Leverage client libraries**: For best performance, always use the latest client libraries and tools provided by Microsoft. Azure Storage client libraries are available for a variety of languages. Microsoft actively develops these client libraries with performance in mind, keeps them up-to-date with the latest service versions, and ensures that they handle many of the proven performance practices internally.
>
> - **Optimize the performance of custom code**: Consider using Storage SDKs instead of creating your own wrappers for blob REST operations. Azure SDKs are optimized for performance and provide mechanisms to fine-tune performance. 
>
> - **Tune the performance of data transfers**: When an application transfers data using the Azure Storage client library, there are several factors that can affect speed, memory usage, and even the success or failure of the request. To maximize performance and reliability for data transfers, it's important to be proactive in configuring client library transfer options based on the environment your app runs in. Mention some of the subtopics such as increasing default connection limit and increasing the number of threads. Also adjusting the transfer size of each operation and the maximum number of parallel requests that can occur. To learn more, see any of these articles: link for each language
>
> - **Leverage AzCopy to upload many blobs quickly**: To upload many blobs quickly, upload **blobs** in parallel. Uploading blobs in parallel is faster than uploading single blobs at a time with parallel **block** uploads because it spreads the upload across multiple partitions of the storage service. [AzCopy](../common/storage-use-azcopy-v10.md) performs uploads in parallel by default.
>
> - **Upload blocks in parallel**: To upload large blobs quickly, a client application can upload its blocks or pages in parallel, being mindful of the scalability targets for individual blobs and the storage account as a whole. The Azure Storage client libraries support uploading in parallel. Client libraries for other supported languages provide similar options.
>
> - **Place an upper limit on parallel requests**: While parallelism can be great for performance, be careful about using unbounded parallelism, meaning that there's no limit enforced on the number of threads or parallel requests. Be sure to limit parallel requests to upload or download data, to access multiple partitions in the same storage account, or to access multiple items in the same partition. If parallelism is unbounded, your application can exceed the client device's capabilities or the storage account's scalability targets, resulting in longer latencies and throttling. Each SDK has a way to set that upper limit by way of storage transfer options.
>
> - **Reduce throttling with exponential backoff strategies**: Azure Storage may throttle your application if it approaches the scalability limits. In some cases, Azure Storage may be unable to handle a request due to some transient condition. In both cases, the service may return a 503 (Server Busy) or 500 (Timeout) error. These errors can also occur if the service is rebalancing data partitions to allow for higher throughput. The client application should typically retry the operation that causes one of these errors. However, if Azure Storage is throttling your application because it's exceeding scalability targets, or even if the service was unable to serve the request for some other reason, aggressive retries may make the problem worse. Using an exponential back off retry policy is recommended, and the client libraries default to this behavior. For example, your application may retry after 2 seconds, then 4 seconds, then 10 seconds, then 30 seconds, and then give up completely. In this way, your application significantly reduces its load on the service, rather than exacerbating behavior that could lead to throttling. Connectivity errors can be retried immediately, because they aren't the result of throttling and are expected to be transient. The client libraries handle retries with an awareness of which errors can be retried and which can't be retried. However, if you're calling the Azure Storage REST API directly, there are some errors that you shouldn't retry. For example, a 400 (Bad Request) error indicates that the client application sent a request that couldn't be processed because it wasn't in the expected form. Resending this request results the same response every time, so there's no point in retrying it. If you're calling the Azure Storage REST API directly, be aware of potential errors and whether they should be retried. Link to error codes here.
>
> - **Use server-to-server APIs to copy between accounts**: To copy blobs across storage accounts, use the [Put Block From URL](/rest/api/storageservices/put-block-from-url) operation. This operation copies data synchronously from any URL source into a block blob. Using the `Put Block from URL` operation can significantly reduce required bandwidth when you're migrating data across storage accounts. Because the copy operation takes place on the service side, you don't need to download and re-upload the data. To copy data within the same storage account, use the [Copy Blob](/rest/api/storageservices/Copy-Blob) operation. Copying data within the same storage account is typically completed quickly.
>
> - **Use server-side queries** - Consider using [query acceleration](/azure/storage/blobs/data-lake-storage-query-acceleration) to filter out unwanted data during the storage request and keep clients from needlessly transferring data across the network.
>
> **Cache data to improve performance**: Cache data that is frequently accessed or rarely changed. In general, reading data once is preferable to reading it twice. Consider the example of a web application that has retrieved a 50 MiB blob from the Azure Storage to serve as content to a user. Ideally, the application caches the blob locally to disk and then retrieves the cached version for subsequent user requests. One way to avoid retrieving a blob if it hasn't been modified since it was cached is to qualify the GET operation with a conditional header for modification time. If the last modified time is after the time that the blob was cached, then the blob is retrieved and re-cached. Otherwise, the cached blob is retrieved for optimal performance. You may also decide to design your application to assume that the blob remains unchanged for a short period after retrieving it. In this case, the application doesn't need to check whether the blob was modified during that interval. Configuration data, lookup data, and other data that is frequently used by the application are good candidates for caching. For more information about using conditional headers, see [Specifying conditional headers for Blob service operations](/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
>
> **Upload data in batches**: Cache data the client and then upload that data in batches. In some scenarios, you can aggregate data locally, and then periodically upload it in a batch instead of uploading each piece of data immediately. For example, suppose a web application keeps a log file of activities. The application can either upload details of every activity as it happens to a table (which requires many storage operations), or it can save activity details to a local log file and then periodically upload all activity details as a delimited file to a blob. If each log entry is 1 KB in size, you can upload thousands of entries in a single transaction. A single transaction supports uploading a blob of up to 64 MiB in size. The application developer must design for the possibility of client device or upload failures. If the activity data needs to be downloaded for an interval of time rather than for a single activity, then using Blob storage is recommended over Table storage.

## Next steps

- [Performance checklist for Blob Storage](storage-performance-checklist.md)
- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Latency in Blob Storage](storage-blobs-latency.md)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

