---
title: Configure Vaulted Backup for Azure Data Lake Storage using Azure portal
description: Learn how to configure vaulted backup for Azure Data Lake Storage using Azure portal.
ms.topic: how-to
ms.date: 07/23/2025
author: AbhishekMallick-MS
ms.author: v-mallicka
# Customer intent: As a cloud administrator, I want to configure vaulted backup for Azure Data Lake Storage, so that I can ensure data protection and recovery capabilities are in place for my storage accounts.
---

# Configure vaulted backup for Azure Data Lake Storage using Azure portal

This article describes how to configure vaulted backup for Azure Data Lake Storage using Azure portal.

## Prerequisites

Before you configure backup for Azure Data Lake Storage, ensure the following prerequisites are met:

- The storage account must be in a [supported region and of the required types](azure-data-lake-storage-backup-support-matrix.md).
- The target account mustn't have containers with the  names same as the containers in a recovery point; otherwise, the restore operation fails.

>[!Note]
>- This feature is currently available in specific regions only. See the [supported regions](azure-data-lake-storage-backup-support-matrix.md#supported-regions).
>- Vaulted backup restores are only possible to a different storage account.

For more information about the supported scenarios, limitations, and availability, see the [support matrix](azure-data-lake-storage-backup-support-matrix.md).

## Create a Backup vault

To back up Azure Data Lake Storage, ensure you have a Backup Vault in the same region. You can use an existing vault, or [create a new one](create-manage-backup-vault.md#create-backup-vault).

## Create a backup policy for Azure Data Lake Storage

A backup policy defines the schedule and frequency for backing up Azure Data Lake Storage. You can either create a backup policy from the Backup vault, or create it on the go during the backup configuration.

To create a backup policy for Azure Data Lake Storage from the Backup vault, follow these steps:

1. In the [Azure portal](https://portal.azure.com/), go to the **Backup vault** > **Backup policies**, and then select **+ Add**.
1. On the **Create Backup Policy** pane, on the **Basics** tab, provide a name for the new policy on **Policy name**, and then select **Datasource type** as **Azure Data Lake Storage**.

   :::image type="content" source="./media/azure-data-lake-storage-configure-backup/create-policy.png" alt-text="Screenshot shows how to start creating a backup policy." lightbox="./media/azure-data-lake-storage-configure-backup/create-policy.png":::

1. On the **Schedule + retention** tab, under the **Backup schedule** section, set the **Backup Frequency** as **Daily** or **Weekly** and the schedule for creating recovery points for vaulted backups.
1. Under the **Add retention** section, edit the default retention rule or add new rules to specify the retention of recovery points.
1. Select **Review + create**.
1. After the review succeeds, select **Create**.

### Grant permissions to the Backup vault on storage accounts

A Backup vault needs specific permissions on the storage account for backup operations. The **Storage Account Backup Contributor** role consolidates these permissions for easy assignment. We recommend you to grant this role to the Backup vault before configuring backup.

>[!Note]
>You can also perform the role assignment while configuring backup.

To assign the required role for storage accounts that you want to protect, follow these steps:

>[!Note]
>You can also assign the roles to the vault at the Subscription or Resource Group levels according to your convenience.

1. In the [Azure portal](https://portal.azure.com/), go to the storage account, and then select **Access Control (IAM)**.
1. On the **Access Control (IAM)** pane, select **Add role assignments** to assign the required role.

   :::image type="content" source="./media/azure-data-lake-storage-configure-backup/add-role-assignments.png" alt-text="Screenshot shows how to start assigning roles to the Backup vault." lightbox="./media/azure-data-lake-storage-configure-backup/add-role-assignments.png":::

1. On the **Add role assignment** pane, do the following steps:

   1. **Role**: Select **Storage Account Backup Contributor**.
   1. **Assign access to**: Select **User, group, or service principal**.
   1. **Members**: Click **+ Select members** and search for the Backup vault you created, and then select it from the search result to back up blobs in the underlying storage account.

1. Select **Save** to finish the role assignment.
 
>[!Note]
> The role assignment might take up to **30 minutes** to take effect.

[!INCLUDE [How to configure backup for Azure Data Lake Storage](../../includes/azure-data-lake-storage-configure-backup.md)]

## Next steps

[Restore Azure Data Lake Storage using Azure portal](azure-data-lake-storage-restore.md).
 


