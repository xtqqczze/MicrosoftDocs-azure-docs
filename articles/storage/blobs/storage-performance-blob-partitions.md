---
title: Optimize blob partitions (Azure Blob Storage)
titleSuffix: Azure Storage
description: Learn how to partition Blob Storage
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

# Optimize blob partitions

When upload operations use small block sizes, you can reduce the latency of listing, query, and read operations by choosing an efficient naming scheme. A _small_ block size in this context is less than 4 MiB for standard accounts or 256 KiB for premium accounts. Larger blocks aren't affected by partition naming. 

The partition key for a blob is: account name + container name + virtual directory or blob name. The system uses these keys to partition data into ranges and load-balance these ranges across the system. A naming scheme is _efficient_ if it helps the system colocate blobs into logical partitions and then load balance ranges of those partitions across multiple servers. 

An effective way to help the system efficiently divide blobs is to use a hash prefix at the beginning of the blob partition key. A hash prefix helps the system distribute your blobs across multiple partitions and balance traffic across more servers. If you plan to use timestamps in names, consider adding a seconds value to the beginning of that timestamp (for example: `ssyyyymmdd`).

Avoid sequential naming schemes such as `log20160101`, `log20160102`, `log20160103`. These schemes concentrate traffic on one server, which can exceed scalability targets and cause latency issues.

Avoid append-only or prepend-only patterns when using timestamps or numerical identifiers. These patterns route all traffic to a single partition, which prevents load balancing. For example, daily operations that use `yyyymmdd` timestamps direct all daily traffic to one blob on one partition server, potentially exceeding scale targets. Consider splitting into multiple blobs if needed. 

For more information on the partitioning scheme used in Azure Storage, see [Azure Storage: A Highly Available Cloud Storage Service with Strong Consistency](https://sigops.org/sosp/sosp11/current/2011-Cascais/printable/11-calder.pdf).

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

