---
title: Configure Backup for Azure Data Lake Storage using Azure portal
description: Learn how to configure backup for Azure Data Lake Storage using Azure portal.
ms.topic: how-to
ms.date: 07/23/2025
author: AbhishekMallick-MS
ms.author: v-mallicka
# Customer intent: As a cloud administrator, I want to configure backup for Azure Data Lake Storage, so that I can ensure data protection and recovery capabilities are in place for my storage accounts.
---

# Configure backup for Azure Data Lake Storage using Azure portal

This article describes how to configure backup (operational and vaulted) for Azure Data Lake Storage using Azure portal.

## Prerequisites

Before you configure backup for Azure Data Lake Storage, ensure the following prerequisites are met:

- The storage account must be in a [supported region and of the required types](azure-data-lake-storage-backup-support-matrix.md).
- The target account mustn't have containers with the  names same as the containers in a recovery point; otherwise, the restore operation fails.
- Identify or [create a Backup vault](create-manage-backup-vault.md#create-backup-vault) in the same region as the Azure Data Lake Storage account.
- [Grant permissions to the Backup vault on storage accounts](azure-data-lake-storage-backup-tutorial.md#grant-permissions-to-the-backup-vault-on-storage-accounts).

>[!Note]
>- This feature is currently available in specific regions only. See the [supported regions](azure-data-lake-storage-backup-support-matrix.md#supported-regions).
>- Vaulted backup restores are only possible to a different storage account.

For more information about the supported scenarios, limitations, and availability, see the [support matrix](azure-data-lake-storage-backup-support-matrix.md).


[!INCLUDE [How to configure backup for Azure Data Lake Storage](../../includes/azure-data-lake-storage-configure-backup.md)]


Learn how to [monitor backup jobs](azure-data-lake-storage-backup-tutorial.md#monitor-an-azure-data-lake-storage-backup-job).

## Next steps

[Restore Azure Data Lake Storage using Azure portal](azure-data-lake-storage-restore.md).
 


