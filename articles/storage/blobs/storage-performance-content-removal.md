---
title: Performance content removal
titleSuffix: Azure Storage
description: This is stuff you plan to remove entirely from performance checklist
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

# Performance content removal

This is the content that I removed from the perf and scale checklist article

## Maximum number of storage accounts

If you're approaching the maximum number of storage accounts permitted for a particular subscription/region combination, evaluate your scenario and determine whether any of the following conditions apply:

- Are you using storage accounts to store unmanaged disks and adding those disks to your virtual machines (VMs)? For this scenario, Microsoft recommends using managed disks. Managed disks scale for you automatically and without the need to create and manage individual storage accounts. For more information, see [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview).

- Are you using one storage account per customer, for the purpose of data isolation? For this scenario, Microsoft recommends using a blob container for each customer, instead of an entire storage account. Azure Storage now allows you to assign Azure roles on a per-container basis. For more information, see [Assign an Azure role for access to blob data](assign-azure-role-data-access.md).

- Are you using multiple storage accounts to shard to increase ingress, egress, I/O operations per second (IOPS), or capacity? In this scenario, Microsoft recommends that you take advantage of increased limits for storage accounts to reduce the number of storage accounts required for your workload if possible. Contact [Azure Support](https://azure.microsoft.com/support/options/) to request increased limits for your storage account.

## Capacity and transaction charges

- Reconsider the workload that causes your application to approach or exceed the scalability target. Can you design it differently to use less bandwidth or capacity, or fewer transactions?

## Use metadata

The Blob service supports HEAD requests, which can include blob properties or metadata. For example, if your application needs the Exif (exchangeable image format) data from a photo, it can retrieve the photo and extract it. To save bandwidth and improve performance, your application can store the Exif data in the blob's metadata when the application uploads the photo. You can then retrieve the Exif data in metadata using only a HEAD request. Retrieving only metadata and not the full contents of the blob saves significant bandwidth and reduces the processing time required to extract the Exif data. Keep in mind that 8 KiB of metadata can be stored per blob.

## Choose the correct type of blob

Azure Storage supports block blobs, append blobs, and page blobs. For a given usage scenario, your choice of blob type affects the performance and scalability of your solution.

Block blobs are appropriate when you want to upload large amounts of data efficiently. For example, a client application that uploads photos or video to Blob storage would target block blobs.

Append blobs are similar to block blobs in that they're composed of blocks. When you modify an append blob, blocks are added to the end of the blob only. Append blobs are useful for scenarios such as logging, when an application needs to add data to an existing blob.

Page blobs are appropriate if the application needs to perform random writes on the data. For example, Azure virtual machine disks are stored as page blobs. For more information, see [Understanding block blobs, append blobs, and page blobs](/rest/api/storageservices/understanding-block-blobs--append-blobs--and-page-blobs).

## Location

If client applications access Azure Storage but aren't hosted within Azure, such as mobile device apps or on premises enterprise services, then locating the storage account in a region near to those clients may reduce latency. If your clients are broadly distributed (for example, some in North America, and some in Europe), then consider using one storage account per region. This approach is easier to implement if the data the application stores is specific to individual users, and doesn't require replicating data between storage accounts.

For broad distribution of blob content, use a content deliver network such as Azure CDN. For more information about Azure CDN, see [Azure CDN](../../cdn/cdn-overview.md).

## SAS and CORS

Suppose that you need to authorize code such as JavaScript that is running in a user's web browser or in a mobile phone app to access data in Azure Storage. One approach is to build a service application that acts as a proxy. The user's device authenticates with the service, which in turn authorizes access to Azure Storage resources. In this way, you can avoid exposing your storage account keys on insecure devices. However, this approach places a significant overhead on the service application, because all of the data transferred between the user's device and Azure Storage must pass through the service application.

You can avoid using a service application as a proxy for Azure Storage by using shared access signatures (SAS). Using SAS, you can enable your user's device to make requests directly to Azure Storage by using a limited access token. For example, if a user wants to upload a photo to your application, then your service application can generate a SAS and send it to the user's device. The SAS token can grant permission to write to an Azure Storage resource for a specified interval of time, after which the SAS token expires. For more information about SAS, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](../common/storage-sas-overview.md).

Typically, a web browser doesn't allow JavaScript in a page that is hosted by a website on one domain to perform certain operations, such as write operations, to another domain. Known as the same-origin policy, this policy prevents a malicious script on one page from obtaining access to data on another web page. However, the same-origin policy can be a limitation when building a solution in the cloud. Cross-origin resource sharing (CORS) is a browser feature that enables the target domain to communicate to the browser that it trusts requests originating in the source domain.

For example, suppose a web application running in Azure makes a request for a resource to an Azure Storage account. The web application is the source domain, and the storage account is the target domain. You can configure CORS for any of the Azure Storage services to communicate to the web browser that requests from the source domain are trusted by Azure Storage. For more information about CORS, see [Cross-origin resource sharing (CORS) support for Azure Storage](/rest/api/storageservices/Cross-Origin-Resource-Sharing--CORS--Support-for-the-Azure-Storage-Services).

Both SAS and CORS can help you avoid unnecessary load on your web application.

## Upload blobs quickly

To upload blobs quickly, first determine whether you're uploading one blob or many. Use the below guidance to determine the correct method to use depending on your scenario. If you're using the Azure Storage client library for data transfers, see [Performance tuning for data transfers](#performance-tuning-for-data-transfers) for further guidance.

### Upload one large blob quickly

To upload a single large blob quickly, a client application can upload its blocks or pages in parallel, being mindful of the scalability targets for individual blobs and the storage account as a whole. The Azure Storage client libraries support uploading in parallel. Client libraries for other supported languages provide similar options.

## Networking

The physical network constraints of the application might have a significant impact on performance. The following sections describe some of limitations users may encounter.

### Client network capability

Bandwidth and the quality of the network link play important roles in application performance, as described in the following sections.

## Caching

Caching plays an important role in performance. The following sections discuss caching best practices.

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

