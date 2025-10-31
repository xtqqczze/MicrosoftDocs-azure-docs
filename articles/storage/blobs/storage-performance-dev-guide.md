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

# Application performance checklist

This is stuff you plan to move to the developer guides. Place this doc at the beginning of the application developer guide section.

Use this checklist as a guide.

> [!div class="checklist"]
>
> - **Item** - Action description. (**[Learn more](/azure/storage/common/section-1)**).
>
> - **Item2**: Action description. (**[Learn more](/azure/storage/blobs/section-2)**).

### Section 1

Brief description.

- **Advice caption** Description or succinct guidance. Link to more information.

- **Advice caption** Description or succinct guidance. Link to more information.

See "Link to more information if appropriate".

### Section 2

Brief description.

- **Advice caption** Description or succinct guidance. Link to more information.

- **Advice caption** Description or succinct guidance. Link to more information.

## More content

Build out this guide a bit with items / tips / guidance captured in the dev guide under config options for perf optimization. Comb through docs and then add references here.

Also comb for things like guidance around concurrency and other app developer guidance around perf.

## Reference to troubleshooting guides for errors and issues around perf

Put something here. For more information, see [Troubleshoot performance in Azure storage accounts](/troubleshoot/azure/azure-storage/blobs/alerts/troubleshoot-storage-performance)

## Capacity and transaction charges

- If your application is approaching the scalability targets, then make sure that you're using an exponential backoff for retries. It's best to try to avoid reaching the scalability targets by implementing the recommendations described in this article. However, using an exponential backoff for retries prevents your application from retrying rapidly, which could make throttling worse. For more information, see the section titled [Timeout and Server Busy errors](#timeout-and-server-busy-errors).

## SAS and CORS

Suppose that you need to authorize code such as JavaScript that is running in a user's web browser or in a mobile phone app to access data in Azure Storage. One approach is to build a service application that acts as a proxy. The user's device authenticates with the service, which in turn authorizes access to Azure Storage resources. In this way, you can avoid exposing your storage account keys on insecure devices. However, this approach places a significant overhead on the service application, because all of the data transferred between the user's device and Azure Storage must pass through the service application.

You can avoid using a service application as a proxy for Azure Storage by using shared access signatures (SAS). Using SAS, you can enable your user's device to make requests directly to Azure Storage by using a limited access token. For example, if a user wants to upload a photo to your application, then your service application can generate a SAS and send it to the user's device. The SAS token can grant permission to write to an Azure Storage resource for a specified interval of time, after which the SAS token expires. For more information about SAS, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](../common/storage-sas-overview.md).

Typically, a web browser doesn't allow JavaScript in a page that is hosted by a website on one domain to perform certain operations, such as write operations, to another domain. Known as the same-origin policy, this policy prevents a malicious script on one page from obtaining access to data on another web page. However, the same-origin policy can be a limitation when building a solution in the cloud. Cross-origin resource sharing (CORS) is a browser feature that enables the target domain to communicate to the browser that it trusts requests originating in the source domain.

For example, suppose a web application running in Azure makes a request for a resource to an Azure Storage account. The web application is the source domain, and the storage account is the target domain. You can configure CORS for any of the Azure Storage services to communicate to the web browser that requests from the source domain are trusted by Azure Storage. For more information about CORS, see [Cross-origin resource sharing (CORS) support for Azure Storage](/rest/api/storageservices/Cross-Origin-Resource-Sharing--CORS--Support-for-the-Azure-Storage-Services).

Both SAS and CORS can help you avoid unnecessary load on your web application.

## Increase default connection limit (add to config options for upload download)

> [!NOTE]
> This section applies to projects using .NET Framework, as connection pooling is controlled by the ServicePointManager class. .NET Core introduced a significant change around connection pool management, where connection pooling happens at the HttpClient level and the pool size is not limited by default. This means that HTTP connections are automatically scaled to satisfy your workload. Using the latest version of .NET is recommended, when possible, to take advantage of performance enhancements.

For projects using .NET Framework, you can use the following code to increase the default connection limit (which is usually two in a client environment or ten in a server environment) to 100. Typically, you should set the value to approximately the number of threads used by your application. Set the connection limit before opening any connections.

```csharp
ServicePointManager.DefaultConnectionLimit = 100; //(Or More)  
```

To learn more about connection pool limits in .NET Framework, see [.NET Framework Connection Pool Limits and the new Azure SDK for .NET](https://devblogs.microsoft.com/azure-sdk/net-framework-connection-pool-limits/).

For other programming languages, see the documentation to determine how to set the connection limit.

## Increase minimum number of threads (add to config options for upload download )

If you're using synchronous calls together with asynchronous tasks, you may want to increase the number of threads in the thread pool:

```csharp
ThreadPool.SetMinThreads(100,100); //(Determine the right number for your application)  
```

For more information, see the [ThreadPool.SetMinThreads](/dotnet/api/system.threading.threadpool.setminthreads) method.

## Unbounded parallelism

While parallelism can be great for performance, be careful about using unbounded parallelism, meaning that there's no limit enforced on the number of threads or parallel requests. Be sure to limit parallel requests to upload or download data, to access multiple partitions in the same storage account, or to access multiple items in the same partition. If parallelism is unbounded, your application can exceed the client device's capabilities or the storage account's scalability targets, resulting in longer latencies and throttling.

## Client libraries and tools

For best performance, always use the latest client libraries and tools provided by Microsoft. Azure Storage client libraries are available for a variety of languages. Azure Storage also supports PowerShell and Azure CLI. Microsoft actively develops these client libraries and tools with performance in mind, keeps them up-to-date with the latest service versions, and ensures that they handle many of the proven performance practices internally.

> [!TIP]
> The [ABFS driver](data-lake-storage-abfs-driver.md) was designed to overcome the inherent deficiencies of WASB. Microsoft recommends using the ABFS driver over the WASB driver, as the ABFS driver is optimized specifically for big data analytics.

## Handle service errors

Azure Storage returns an error when the service can't process a request. Understanding the errors that may be returned by Azure Storage in a given scenario is helpful for optimizing performance. For a list of common error codes, see [Common REST API error codes](/rest/api/storageservices/common-rest-api-error-codes).

### Timeout and Server Busy errors

Azure Storage may throttle your application if it approaches the scalability limits. In some cases, Azure Storage may be unable to handle a request due to some transient condition. In both cases, the service may return a 503 (Server Busy) or 500 (Timeout) error. These errors can also occur if the service is rebalancing data partitions to allow for higher throughput. The client application should typically retry the operation that causes one of these errors. However, if Azure Storage is throttling your application because it's exceeding scalability targets, or even if the service was unable to serve the request for some other reason, aggressive retries may make the problem worse. Using an exponential back off retry policy is recommended, and the client libraries default to this behavior. For example, your application may retry after 2 seconds, then 4 seconds, then 10 seconds, then 30 seconds, and then give up completely. In this way, your application significantly reduces its load on the service, rather than exacerbating behavior that could lead to throttling.

Connectivity errors can be retried immediately, because they aren't the result of throttling and are expected to be transient.

### Non-retryable errors

The client libraries handle retries with an awareness of which errors can be retried and which can't be retried. However, if you're calling the Azure Storage REST API directly, there are some errors that you shouldn't retry. For example, a 400 (Bad Request) error indicates that the client application sent a request that couldn't be processed because it wasn't in the expected form. Resending this request results the same response every time, so there's no point in retrying it. If you're calling the Azure Storage REST API directly, be aware of potential errors and whether they should be retried.

For more information on Azure Storage error codes, see [Status and error codes](/rest/api/storageservices/status-and-error-codes2).

### Blob copy APIs

To copy blobs across storage accounts, use the [Put Block From URL](/rest/api/storageservices/put-block-from-url) operation. This operation copies data synchronously from any URL source into a block blob. Using the `Put Block from URL` operation can significantly reduce required bandwidth when you're migrating data across storage accounts. Because the copy operation takes place on the service side, you don't need to download and re-upload the data.

To copy data within the same storage account, use the [Copy Blob](/rest/api/storageservices/Copy-Blob) operation. Copying data within the same storage account is typically completed quickly.

## Performance tuning for data transfers (Include links to articles for each language)

When an application transfers data using the Azure Storage client library, there are several factors that can affect speed, memory usage, and even the success or failure of the request. To maximize performance and reliability for data transfers, it's important to be proactive in configuring client library transfer options based on the environment your app runs in. To learn more, see [Performance tuning for uploads and downloads](storage-blobs-tune-upload-download.md).

## Upload blobs quickly

To upload blobs quickly, first determine whether you're uploading one blob or many. Use the below guidance to determine the correct method to use depending on your scenario. If you're using the Azure Storage client library for data transfers, see [Performance tuning for data transfers](#performance-tuning-for-data-transfers) for further guidance.

### Upload one large blob quickly

To upload a single large blob quickly, a client application can upload its blocks or pages in parallel, being mindful of the scalability targets for individual blobs and the storage account as a whole. The Azure Storage client libraries support uploading in parallel. Client libraries for other supported languages provide similar options.

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

