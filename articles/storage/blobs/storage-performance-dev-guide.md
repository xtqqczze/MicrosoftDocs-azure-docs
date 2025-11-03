---
title: Application performance checklist
titleSuffix: Azure Storage
description: This is stuff that you plan to move into developer guides
services: storage
author: normesta

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 10/30/2025
ms.author: normesta
ms.devlang: csharp
ms.custom: devx-track-csharp, devx-track-dotnet
# Customer intent: As a developer, I want a checklist of proven practices for optimizing Blob storage performance, so that I can ensure my application scales efficiently and meets performance targets while avoiding throttling and errors.
---

# Optimize the performance of applications

Introduction goes here.

## Performance checklist

Use this checklist as a guide.

> [!div class="checklist"]
>
> - **Tune the performance of data transfers**: When an application transfers data using the Azure Storage client library, there are several factors that can affect speed, memory usage, and even the success or failure of the request. To maximize performance and reliability for data transfers, it's important to be proactive in configuring client library transfer options based on the environment your app runs in. Mention some of the subtopics such as increasing default connection limit and increasing the number of threads.To learn more, see any of these articles: link for each language
>
> - **Reduce throttling with exponential backoff strategies**: Azure Storage may throttle your application if it approaches the scalability limits. In some cases, Azure Storage may be unable to handle a request due to some transient condition. In both cases, the service may return a 503 (Server Busy) or 500 (Timeout) error. These errors can also occur if the service is rebalancing data partitions to allow for higher throughput. The client application should typically retry the operation that causes one of these errors. However, if Azure Storage is throttling your application because it's exceeding scalability targets, or even if the service was unable to serve the request for some other reason, aggressive retries may make the problem worse. Using an exponential back off retry policy is recommended, and the client libraries default to this behavior. For example, your application may retry after 2 seconds, then 4 seconds, then 10 seconds, then 30 seconds, and then give up completely. In this way, your application significantly reduces its load on the service, rather than exacerbating behavior that could lead to throttling. Connectivity errors can be retried immediately, because they aren't the result of throttling and are expected to be transient. The client libraries handle retries with an awareness of which errors can be retried and which can't be retried. However, if you're calling the Azure Storage REST API directly, there are some errors that you shouldn't retry. For example, a 400 (Bad Request) error indicates that the client application sent a request that couldn't be processed because it wasn't in the expected form. Resending this request results the same response every time, so there's no point in retrying it. If you're calling the Azure Storage REST API directly, be aware of potential errors and whether they should be retried. Link to error codes here.
>
> - **Place an upper limit on parallel requests**: While parallelism can be great for performance, be careful about using unbounded parallelism, meaning that there's no limit enforced on the number of threads or parallel requests. Be sure to limit parallel requests to upload or download data, to access multiple partitions in the same storage account, or to access multiple items in the same partition. If parallelism is unbounded, your application can exceed the client device's capabilities or the storage account's scalability targets, resulting in longer latencies and throttling.
>
> - **Leverage client libraries**: For best performance, always use the latest client libraries and tools provided by Microsoft. Azure Storage client libraries are available for a variety of languages. Microsoft actively develops these client libraries with performance in mind, keeps them up-to-date with the latest service versions, and ensures that they handle many of the proven performance practices internally.
> - **Optimize the performance of custom code**: Consider using Storage SDKs instead of creating your own wrappers for blob REST operations. Azure SDKs are optimized for performance and provide mechanisms to fine-tune performance. 
>
> - **Use server-side queries** - Consider using [query acceleration](/azure/storage/blobs/data-lake-storage-query-acceleration) to filter out unwanted data during the storage request and keep clients from needlessly transferring data across the network.
>
> - **Use server-to-server APIs to copy between accounts**: To copy blobs across storage accounts, use the [Put Block From URL](/rest/api/storageservices/put-block-from-url) operation. This operation copies data synchronously from any URL source into a block blob. Using the `Put Block from URL` operation can significantly reduce required bandwidth when you're migrating data across storage accounts. Because the copy operation takes place on the service side, you don't need to download and re-upload the data. To copy data within the same storage account, use the [Copy Blob](/rest/api/storageservices/Copy-Blob) operation. Copying data within the same storage account is typically completed quickly.

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

