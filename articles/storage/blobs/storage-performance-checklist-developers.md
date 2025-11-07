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

> [!NOTE]
> This article applies only to custom applications. Review the [Performance checklist for Blob Storage](storage-performance-checklist.md) for recommendations that apply to all clients. 

## Performance checklist

> [!div class="checklist"]
>
> - **Use Azure Storage client libraries**: For best performance, transfer objects by using latest client libraries provided by Microsoft. Azure Storage client libraries are available for a variety of languages. Microsoft actively develops these client libraries with performance in mind, keeps them up-to-date with the latest service versions, and ensures that they handle many of the proven performance practices internally.
>
> - **Optimize parallel block transfers**: You can increase the number of parallel transfers by configuring a smaller block size. However, make sure that block sizes remain above 4 MiB for standard storage accounts and 256 KiB for premium storage accounts which is the minimum block size required to automatically activate high-throughput block blobs; an internal capability that enhances the performance of ingest. While parallel uploads improve performance, too many concurrent requests might exceed the client device's capabilities or the storage account's scale targets which lead to longer latencies and throttling. Therefore, you might have to set an upper limit on the number of parallel requests an application can make. To set the block size and the maximum number of parallel requests, see the performance and tuning guidance for  [.NET](storage-blobs-tune-upload-download.md), [Java](storage-blobs-tune-upload-download-java.md), [JavaScript](storage-blobs-tune-upload-download-javascript.md), [Python](storage-blobs-tune-upload-download-python.md), and [Go](storage-blobs-tune-upload-download-go.md). by using storage options available each Azure Storage client library. 
>
> - **Use an exponential back off retry policy**: Handle transient errors such as a momentary loss of network connectivity or a request timeout when a service or resource is busy by using an exponential back off retry policy. For example, your application can retry a request after two seconds, then four seconds, then 10 seconds, then 30 seconds, and then give up completely. An exponential backoff strategy prevents your application from continuing to retry errors that might not be transient in nature. For example, request might be throttled because they approach or exceed the performance and scale targets of the storage account. The Azure Storage client libraries are aware of which errors can be retried and which one's can't (For example: throttling errors). However, if you're calling the Azure Storage REST API directly, there are some errors that you shouldn't retry. For example, a 400 (Bad Request) error indicates that the client application sent a request that couldn't be processed because it wasn't in the expected form. Resending this request results the same response every time, so there's no point in retrying it. If you're calling the Azure Storage REST API directly, be aware of potential errors and whether they should be retried. To learn how to implement retry policies by using an Azure Storage client library, see the retry policy guidance for [.NET](storage-retry-policy.md), [Java](storage-retry-policy-java.md), [JavaScript](storage-blobs-tune-upload-download-javascript.md), [Python](storage-blobs-tune-upload-download-python.md), and [Go](storage-blobs-tune-upload-download-go.md).
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

