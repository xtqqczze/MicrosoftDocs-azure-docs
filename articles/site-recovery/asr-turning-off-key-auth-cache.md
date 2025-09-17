---
title: Turn off Key-based access on cache accounts.
description: Learn how to turn off Key-based access on cache accounts.
services: site-recovery
author: swbela
ms.service: azure-site-recovery
ms.topic: concept-article
ms.date: 09/16/2025
ms.author: swbela_microsoft

# Customer intent: As a Site Recovery administrator, I want to turn off key-based authentication on cache account used by Azure Site Recovery.
---

# Overview
 Key-based access on cache storage account was mandatory for successful functioning of ASR. Recently we have made changes to support cache accounts which have turned off Key based authentication. This article explains about Key-based access to cache accounts and howto turn off Key-based access on cache account, while you ensure no impact on replication.


## Prerequisites
Before you begin ensure you:
1. Enable Managed Identity on the Recovery Services Vault. Follow below guide on how to do it.
   https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints#enable-the-managed-identity-for-the-vault

2. Grant access to Recovery services vault managed identity to read-write to cache account. Follow this guide.
        https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints#grant-required-permissions-to-the-vault

## Turn off key-based access on storage accounts.
For higher security of Azure storage, we recommend you to Tturn off of key-based authentication.

### Scenario 1 
If you are already using a scenario that requires use of recovery services vault identity, then you just need to perform step in "Related Content".

### Scenario 2
If your vault does not have managed identity when VMs were protected, managed identity can be added after VMs are protected as well.
To do this, ensure you meet the prerequisites and then turn off Key-based authorization on cache account.

In either scenario, disable-enable protections for Virtual Machines, servers which are already protected with ASR, is not needed. Replication will continue seamlessly if prerequisites are done correctly before turning off Key-based access.

## Related content
Turn off the key based access on cache account.
https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent?tabs=portal#disable-shared-key-authorization
