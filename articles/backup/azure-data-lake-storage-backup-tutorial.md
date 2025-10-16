---
title: Tutorial - Back up Azure Data Lake Storage using the Azure portal
description: Learn how to back up Azure Data Lake Storage using  the Azure portal. 
ms.custom:
  - ignite-2025
ms.topic: tutorial
ms.date: 05/22/2025
ms.service: azure-backup
author: AbhishekMallick-MS
ms.author: v-mallicka
# Customer intent: As an IT administrator, I want to back up Azure Data Lake Storage using the portal so that I can ensure data protection against accidental or malicious deletions without maintaining on-premises infrastructure.
---

#  Tutorial: Back up Azure Data Lake Storage using the Azure portal

This tutorial describes how to back up Azure Data Lake Storage using  the Azure portal. 

Learn about [Azure Data Lake Storage backup and restore](azure-data-lake-storage-backup-overview.md), and the [supported scenarios](azure-data-lake-storage-backup-support-matrix.md).

## Prerequisites

Before you back up Azure Data Lake Storage, ensure the following prerequisites are met:

- The storage account must be in a [supported region and of the required types](azure-data-lake-storage-backup-support-matrix.md).
- The target account mustn't have containers with the  names same as the containers in a recovery point; otherwise, the restore operation fails.
- Identify or [create a Backup vault](create-manage-backup-vault.md#create-backup-vault) in the same region as the Azure Data Lake Storage account.
- [Create a backup policy for Azure Data Lake Storage](azure-data-lake-storage-backup-create-policy-quickstart.md?pivots=client-portal) to configure the backup schedule and retention.

>[!Note]
>- This feature is currently available in specific regions only. See the [supported regions](azure-data-lake-storage-backup-support-matrix.md#supported-regions).
>- Vaulted backup restores are only possible to a different storage account.

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

## Configure backup for the Azure Data Lake Storage

You can configure backup on multiple Azure Data Lake Storage.

To configure backup, follow these steps:

1. In the [Azure portal](https://portal.azure.com/), go to the **Backup vault**, and then select **+ Backup**. 
1. On the **Configure Backup** pane, on the **Basics** tab, review the **Datasource type** is selected as **Azure Data Lake Storage**.
1. On the **Backup policy** tab, under **Backup policy**, select the policy you want to use for data retention, and then select **Next**.
   If you want to create a new backup policy, select **Create new**. learn how to [create a backup policy](azure-data-lake-storage-backup-create-policy-quickstart.md?pivots=client-portal).
 
1. On the **Datasources** tab, Select**Add**. 

   :::image type="content" source="./media/azure-data-lake-storage-configure-backup/add-resource-for-backup.png" alt-text="Screenshot shows how to add resources for backup." lightbox="./media/azure-data-lake-storage-configure-backup/add-resource-for-backup.png":::

1. On the **Select storage account container** pane, provide the **Backup instance name**, and then click **select** under **Storage account**.

   :::image type="content" source="./media/azure-data-lake-storage-configure-backup/specify-backup-instance-name.png" alt-text="Screenshot shows how to provide the backup instance name." lightbox="./media/azure-data-lake-storage-configure-backup/specify-backup-instance-name.png":::

1. On the **Select hierarchical namespace enabled storage account** pane, select the storage accounts with Azure Data Lake Storage across subscriptions from the list that are in the region same as the vault.

   :::image type="content" source="./media/azure-data-lake-storage-configure-backup/select-storage-account.png" alt-text="Screenshot shows the selection of storage accounts." lightbox="./media/azure-data-lake-storage-configure-backup/select-storage-account.png":::

1. On the **Select storage account container** pane, you can back up all containers or select specific ones.

   After you add the resources, backup readiness validation starts. If the required roles are assigned, the  validation succeeds with the **Success** message.

   :::image type="content" source="./media/azure-data-lake-storage-configure-backup/role-assign-message-success.png" alt-text="Screenshot shows the success message for role assignments." lightbox="./media/azure-data-lake-storage-configure-backup/role-assign-message-success.png":::

   If access permissions are missing, error messages appear. See the [prerequisites](#prerequisites).

   Validation errors appear if the selected storage accounts don't have the **Storage Account Backup Contributor** role. Review the error messages and take necessary actions.

   | Error | Cause | Recommended action |
   | --- | --- | --- |
   | **Role assignment not done** | The **Storage account backup contributor** role and the other required roles for the storage account to the vault aren't assigned. | Select the roles, and then select **Assign missing roles** to automatically assign the required role to the Backup vault and trigger an auto revalidation. <br><br> If the role propagation takes more than **10 minutes**, then the validation might fail. In this scenario, you need to wait for a few minutes and select Revalidate to retry validation. <br><br> You need to assign the following types of permissions for various operations: <br><br> - **Resource-level** permissions: For backing up a single account within a resource group. <br> - **Resource group** or **Subscription-level** permissions: For backing up multiple accounts within a resource group. <br> - **Higher-level** permissions: For reducing the number of role assignments needed. <br><br> The maximum count of role assignments supported at the subscription level is **4,000**. Learn more [about Azure Role-Based Access Control Limits](/azure/role-based-access-control/troubleshoot-limits). |
   | **Insufficient permissions for role assignment** | The vault doesn't have the required role to configure backups, and you don't have enough permissions to assign the required role. | Download the role assignment template, and then share with users with permissions to assign roles for storage accounts. |
 
1. Review the configuration details, and then select **Configure Backup**.

You can track the progress of the backup configuration under **Backup instances**. After the configuration of backup is complete, Azure Backup triggers the backup operation as per the backup policy schedule to create the recovery points. Backup might take a minimum of 30–40 minutes, as backups rely on snapshots, which are taken in every 15 minutes and require two snapshots to detect changes before triggering the backup.

## Monitor an Azure Data Lake Storage backup job

The Azure Backup service creates a job for a scheduled backup or when you trigger an on-demand backup operation, allowing you to monitor the job progress.

To check the backup job status, follow these steps:

1. In the [Azure portal](), go to the **Backup vault** > **Backup jobs**.

   :::image type="content" source="./media/azure-data-lake-storage-backup-manage/monitor-backup-jobs.png" alt-text="Screenshot shows how to monitor the backup jobs." lightbox="./media/azure-data-lake-storage-backup-manage/monitor-backup-jobs.png":::

1. On the **Backup jobs** pane, select the required time range and apply filters to narrow down the list of jobs.

   The **Backup jobs** dashboard shows the operation and status for the past seven days.

## Next steps

- [Restore Azure Data Lake Storage using Azure portal](azure-data-lake-storage-restore.md).
- [Manage backup for Azure Data Lake Storage using Azure portal](azure-data-lake-storage-backup-manage.md).
 


