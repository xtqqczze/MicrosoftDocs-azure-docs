---
title: Turn off Key-based access on cache accounts.
description: Learn how to turn off Key-based access on cache accounts.
services: site-recovery
author: swbela
ms.service: azure-site-recovery
ms.topic: concept-article
ms.date: 09/16/2025
ms.author: swbela_microsoft

# Customer intent: Turn off key-based authentication on cache account used by Azure Site Recovery.
---

# Overview
Previously, key-based access was required for cache storage accounts used by Azure Site Recovery (ASR). ASR now supports cache accounts with key-based authentication disabled. This article explains how to turn off key-based access without disrupting replication.

We recommend disabling key-based authentication on cache storage accounts for security compliance.

## Prerequisites
Before proceeding, ensure the following:
* [Enable Managed Identity on the Recovery Services Vault](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints#enable-the-managed-identity-for-the-vault)

* [Grant access to Recovery services vault managed identity to read-write to cache account](https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints#grant-required-permissions-to-the-vault)

### Scenario 1 
If the Recovery Services Vault already has a managed identity enabled, follow the steps in the [Related Content](#Related-content).

### Scenario 2
If the vault lacked a managed identity when VMs were initially protected, you can add it afterward. Once prerequisites are met, you can safely disable key-based access on the cache account.


> [!NOTE]  
> Replication will continue without interruption if prerequisites are completed before disabling key-based access. Do not disable and re-enable protection for existing VMs or servers after completing prerequisites.

### Related content
- [Disable shared key authorization on cache accounts](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent?tabs=portal#disable-shared-key-authorization)
