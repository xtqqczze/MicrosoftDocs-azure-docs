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

If your clients upload data by using _small_ block sizes, you can improve performance by choosing an efficient naming scheme. A _small_ block size is less than 4 MiB for standard accounts or 256 KiB for premium accounts. Larger blocks aren't affected by partition naming. 

The partition key for a blob is account name + container name + blob name. The partition key is used to partition data into ranges and these ranges are load-balanced across the system.

To help the system partition data more efficiently, avoid sequential naming schemes such as `log20160101`, `log20160102`, `log20160103`. These schemes concentrate traffic on one server, which can exceed scalability targets and cause latency issues. 

Instead, Add a hash character sequence (such as three digits) as early as possible in the partition key of a blob. If you plan to use timestamps in names, consider adding a seconds value to the beginning of that timestamp (for example: `ssyyyymmdd`).

If you use timestamps or numerical identifiers, avoid append-only or prepend-only patterns. These patterns route all traffic to a single partition which prevents load balancing. However, if you plan to use these patterns, consider splitting data into multiple blobs. Apply a hash prefix to each blob that represents a time interval such as seconds (`ss`) or minutes (`mm`). That way traffic isn't repeatedly directed to a single blob on a single partition server which could exceed scalability limits.

## Next steps

- [Performance checklist for Azure Blob Storage](storage-performance-checklist.md)
- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)

