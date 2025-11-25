---
title: Best practices using client libraries with Azure Managed Redis
description: Learn about client libraries for Azure Managed Redis.
ms.date: 11/24/2025
ms.topic: conceptual
ms.custom:
  - devx-track-java
  - devx-track-javaee
  - devx-track-javaee-liberty
  - devx-track-javaee-liberty-aks
  - devx-track-extended-java
  - ignite-2024
  - build-2025
appliesto:
  - ✅ Azure Managed Redis
---

# Azure Managed Redis Client libraries

Azure Managed Redis is based on the popular in-memory data store, Redis. Redis clients for many programming languages can access Azure Managed Redis. Each client library has its own API that makes calls to Redis server using Redis commands, but the client libraries are built to talk to any Redis server.

Each client library maintains its own reference documentation. The libraries also provide links to get support through the client library developer community. The Azure Managed Redis team doesn't own the development, or the support for any client libraries.

The following recommendations are based on popularity and whether there's an active online community to support and answer your questions. We only recommend using the latest available version, and upgrading regularly as new versions become available. These libraries are under active development and often release new versions with improvements to reliability and performance.

| **Client library**        | **Language** | **GitHub** **repo**                                                 | **Documentation**                                                                    |
|---------------------------|--------------|---------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| StackExchange.Redis       | C#/.NET      | [Link](https://github.com/StackExchange/StackExchange.Redis)        | [More information here](https://stackexchange.github.io/StackExchange.Redis/)        |
| Lettuce                   | Java         | [Link](https://github.com/lettuce-io/)                              | [More information here](https://lettuce.io/)                                         |
| Jedis                     | Java         | [Link](https://github.com/redis/jedis)                              |                                                                                      |
| node_redis                | Node.js      | [Link](https://github.com/redis/node-redis)                         |                                                                                      |
| ioredis                   | Node.js      | [Link](https://github.com/luin/ioredis)                             | [More information here](https://ioredis.readthedocs.io/en/stable/API/)               |

> [!NOTE]
> Your application can use any client library that is compatible with open-source Redis to connect to your Azure Managed Redis instance.

## Choosing the right client library based on your clustering policy

Azure Managed Redis supports the Enterprise clustering policy and the OSS clustering policy. See more information here (add link to clustering policy information).

All client libraries work with your Redis instance with Enterprise clustering policy. However, if you're using the OSS clustering policy, ensure that the client library you choose supports connecting to clustered Redis instances.

## Blocked commands

Microsoft manages the configuration and management of Azure Managed Redis instances, which disables the following commands by default. For more information on blocked commands, see [Cluster management commands compatibility](https://redis.io/docs/latest/operate/rs/references/compatibility/commands/cluster/)

### Multi-key commands

Because the AMR instances use a clustered configuration, you might see `CROSSSLOT` exceptions on commands that operate on multiple keys. Behavior varies depending on the clustering policy used. If you use the OSS clustering policy, multi-key commands require all keys to be mapped to [the same hash slot](https://redis.io/docs/latest/operate/rs/databases/configure/oss-cluster-api/#multi-key-command-support).

You might also see `CROSSSLOT` errors with Enterprise clustering policy. Only the following multi-key commands are allowed across slots with Enterprise clustering: `DEL`, `MSET`, `MGET`, `EXISTS`, `UNLINK`, and `TOUCH`.

In Active-Active databases, multi-key write commands (`DEL`, `MSET`, `UNLINK`) can only be run on keys that are in the same slot. However, the following multi-key commands are allowed across slots in Active-Active databases: `MGET`, `EXISTS`, and `TOUCH`. For more information, see [Database clustering](https://redis.io/docs/latest/operate/rs/databases/durability-ha/clustering/#multikey-operations).

### Commands blocked for Enterprise clustering policy

- CLUSTER INFO
- CLUSTER HELP
- CLUSTER KEYSLOT
- CLUSTER NODES
- CLUSTER SLOTS

### Commands blocked for active geo-replication

- FLUSHALL
- FLUSHDB

## Client library-specific guidance

For information on client library-specific guidance best practices, see the following links:

- [StackExchange.Redis (.NET)](best-practices-connection.md#using-forcereconnect-with-stackexchangeredis)
- [Lettuce (Java)](https://github.com/Azure/AzureCacheForRedis/blob/main/Lettuce%20Best%20Practices.md)
- [Jedis (Java)](https://github.com/Azure/AzureCacheForRedis/blob/main/Redis-BestPractices-Java-Jedis.md)
- [Node.js](https://github.com/Azure/AzureCacheForRedis/blob/main/Redis-BestPractices-Node-js.md)
- [PHP](https://github.com/Azure/AzureCacheForRedis/blob/main/Redis-BestPractices-PHP.md)
- [HiRedisCluster](https://github.com/Azure/AzureCacheForRedis/blob/main/HiRedisCluster%20Best%20Practices.md)

## How to use client libraries

Besides the reference documentation, you can find tutorials showing how to get started with Azure Managed Redis using different languages and cache clients.

For more information on using some of these client libraries in tutorials, see the following articles:

- [Code a .NET Framework app](dotnet-how-to-use-azure-redis-cache.md)
- [Code a .NET Core app](dotnet-core-quickstart.md)
- [Code an ASP.NET web app](web-app-cache-howto.md)
- [Code an ASP.NET Core web app](web-app-aspnet-core-howto.md)
- [Code a Java app](java-get-started.md)
- [Code a Node.js app](nodejs-get-started.md)
- [Code a Python app](python-get-started.md)

## Next steps

- [Azure Managed Redis development FAQs](development-faq.yml)
- [Best practices for development](best-practices-development.md)
