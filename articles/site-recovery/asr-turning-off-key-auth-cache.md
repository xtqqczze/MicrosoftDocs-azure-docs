---
title: Turning off key-based access on cache accounts.
description: Turning off key-based access on cache accounts.
services: site-recovery
author: swbela
ms.service: azure-site-recovery
ms.topic: concept-article
ms.date: 8/20/2025
ms.author: swbela_microsoft

# Customer intent: As a Site Recovery administrator, I want to turn off key-based authentication on cache account used by Azure Site Recovery.
---

# Turning off key-based authentication on ASR cache account.
This document describes how can an Azure Site Recovery customer turn off key-based access on cache account while ensuring replication is not impacted.

## Prerequisites
Before you begin:
Step 1 : Enable Managed Identity on the Recovery Services Vault. Follow below guide on how to do it.
        https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints#enable-the-managed-identity-for-the-vault

Step 2: Grant access to Recovery services vault managed identity to read-write to cache account. Follow this guide.
        https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints#grant-required-permissions-to-the-vault
        
## Next steps
1. Turn off the key based access on cache account. This can be done by following this guide:
https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent?tabs=portal#disable-shared-key-authorization
2. If you are already using a scenario that requires use of recovery services vault identity, then you just need to do step 3.
3. If your vault does not have managed identity when VMs were protected, managed identity can be added after VMs are protected as well.
   You will need to follow step 1 to step 3 in this case.
   
In either case re-enable is NOT needed.
