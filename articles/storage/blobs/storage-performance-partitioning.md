---
title: Partitioning Blob Storage
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

# Partitioning Blob Storage

Use a naming convention designed to enable better load-balancing.

## Guidance for how to create a partition

Understanding how Azure Storage partitions your blob data is useful for enhancing performance. Azure Storage can serve data in a single partition more quickly than data that spans multiple partitions. By naming your blobs appropriately, you can improve the efficiency of read requests.

Blob storage uses a range-based partitioning scheme for scaling and load balancing. Each blob has a partition key comprised of the full blob name (account+container+blob). The partition key is used to partition blob data into ranges. The ranges are then load-balanced across Blob storage.

Range-based partitioning means that naming conventions that use  lexical ordering (for example, *mypayroll*, *myperformance*, *myemployees*, etc.) or timestamps (*log20160101*, *log20160102*, *log20160102*, etc.) are more likely to result in the partitions being co-located on the same partition server until increased load requires that they're split into smaller ranges. Co-locating blobs on the same partition server impacts performance, so an important part of performance enhancement involves naming blobs in a way that organizes them most effectively.

For example, all blobs within a container can be served by a single server until the load on these blobs requires further rebalancing of the partition ranges. Similarly, a group of lightly loaded accounts with their names arranged in lexical order may be served by a single server until the load on one or all of these accounts require them to be split across multiple partition servers.

Each load-balancing operation may impact the latency of storage calls during the operation. The service's ability to handle a sudden burst of traffic to a partition is limited by the scalability of a single partition server until the load-balancing operation kicks in and rebalances the partition key range.

You can follow some best practices to reduce the frequency of such operations.

- If possible, use blob or block sizes greater than 4 MiB for standard storage accounts and 256 KiB for premium storage accounts. Larger blob or block sizes automatically activate high-throughput block blobs. High-throughput block blobs provide high-performance ingest that isn't affected by partition naming.
- Examine the naming convention you use for accounts, containers, blobs, tables, and queues. Consider prefixing account, container, or blob names with a three-digit hash using a hashing function that best suits your needs.
- If you organize your data using timestamps or numerical identifiers, make sure that you aren't using an append-only (or prepend-only) traffic pattern. These patterns aren't suitable for a range-based partitioning system. These patterns may lead to all traffic going to a single partition and limiting the system from effectively load balancing.

    For example, if you have daily operations that use a blob with a timestamp such as *yyyymmdd*, then all traffic for that daily operation is directed to a single blob, which is served by a single partition server. Consider whether the per-blob limits and per-partition limits meet your needs, and consider breaking this operation into multiple blobs if needed. Similarly, if you store time series data in your tables, all traffic may be directed to the last part of the key namespace. If you're using numerical IDs, prefix the ID with a three-digit hash. If you're using timestamps, prefix the timestamp with the seconds value, for example, *ssyyyymmdd*. If your application routinely performs listing and querying operations, choose a hashing function that limits your number of queries. In some cases, a random prefix may be sufficient.

- For more information on the partitioning scheme used in Azure Storage, see [Azure Storage: A Highly Available Cloud Storage Service with Strong Consistency](https://sigops.org/sosp/sosp11/current/2011-Cascais/printable/11-calder.pdf).

## Next steps

- [Scalability and performance targets for Blob storage](scalability-targets.md)
- [Scalability and performance targets for standard storage accounts](../common/scalability-targets-standard-account.md?toc=/azure/storage/blobs/toc.json)
- [Status and error codes](/rest/api/storageservices/Status-and-Error-Codes2)

