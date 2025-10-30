---
title: Azure Storage Geo Priority Replication
titleSuffix: Azure Storage
description: Learn how Azure Storage Geo Priority Replication helps maintain high availability and cross-region data integrity.
services: storage
author: stevenmatthew

ms.service: azure-storage
ms.topic: concept-article
ms.date: 10/23/2025
ms.author: shaas
ms.subservice: storage-common-concepts
ms.custom: references_regions, engagement
# Customer intent: "As a cloud architect, I want to understand the Azure Object and Geo-Redundant Storage Replication SLA so that I can understand what to expect in terms of data durability and high availability requirements."
---

<!--
Initial: 98 (896/1)
Current: 99 (975/1)
-->

# Azure Storage Geo Priority Replication

Azure Blob Storage Geo Priority Replication is designed to meet the stringent compliance and business continuity requirements of Azure Blob users. The feature prioritizes the replication traffic of Block Blob data for storage accounts with geo-redundant storage (GRS) and geo-zone redundant storage (GZRS) enabled. This prioritization accelerates data replication between the primary and secondary regions of these geo-redundant accounts. 

A Service Level Agreement (SLA) backs geo priority replication, and applies to any account that has Geo priority replication enabled. It guarantees that the Last Sync Time (LST) for your account's Block Blob data remains lagged 15 minutes or less for 99.0% of the billing month. In addition to prioritized replication traffic, the feature includes enhanced monitoring and detailed telemetry.

You can monitor your geo lag via Azure portal's **Metrics** pane.

> [!IMPORTANT]
> This feature is generally available but is currently only offered in a limited number of regions.
>
> Priority replication is available only within the following regions:
> - East US 2
> - West US 2
> - North Europe
> - West Europe
> - Japan East
> - Japan West
> - Central India
> - Switzerland North
> - UAE North

## Benefits of geo priority replication

While there are many benefits to using geo priority replication, it's especially beneficial, for example, in the following scenarios:

- Meeting compliance regulations that require a strict Recovery Point Objective (RPO) for storage data.
- Recovering from a storage related outage in the primary region where initiating an [unplanned failover](storage-failover-customer-managed-unplanned.md?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json) is required. Users can guarantee that all their Block Blob data is replicated to their secondary region within 15 minutes or less. As a result, any Block Blob data written within 15 minutes of an unplanned failover can be fully recovered after the unplanned failover is completed.
- Strengthening your disaster recovery planning to meet both compliance and business requirements. Users with business-critical data and a need for high availability and disaster recovery receive a significant benefit.

<!--
## SLA terms and guarantees

The SLA defines the specific conditions under which GRS Priority Replication features are guaranteed. It also describes the service credit tiers and billing scope associated with SLA violations.

Microsoft guarantees that the Last Sync Time (LST) is within 15 minutes across **99.0% of a billing month**. Failure to meet this performance guarantee results in Priority Replication and Geo Data Transfer fee credits for all write transactions during a specific billing month.

The following list specifies the credit tiers that apply if this guarantee isn't met:

| Percent of billing month | Service Credit  |
|--------------------------|-----------------|
| 99.0% to 98.0%           | **10% credit**  |
| 98.0% to 95.0%           | **25% credit**  |
| Below 95.0%              | **100% credit** |
-->

## SLA eligibility and exclusions

While Geo Priority Replication introduces an SLA-backed capability for Azure Blob Storage, it comes with several important exclusions. Users benefit from prioritized replication along with the improved visibility into their Blob Geo Lag while Geo priority replication is enabled. However, there are workloads and time periods where users aren't eligible for the Service Level Agreement for Geo priority replication. These limitations include:

- Other blob types, such as page blobs and append blobs. The SLA applies exclusively to Block Blob data. If these unsupported blob types contribute to geo lag, the affected time window is excluded from SLA eligibility,
- Storage accounts where Append or Page Blob API calls were made within the last 30 days,
- Storage accounts with a Last Sync Time greater than 15 minutes lagged during the enablement of Geo priority replication. Data replication prioritization begins immediately after enabling the feature, but the SLA might not apply during this initial sync period. If the account's Last Sync Time exceeds 15 minutes during this time, the SLA doesn't apply until the Last Sync Time is consistently at or below 15 minutes lagged. Customers can [monitor their LST](last-sync-time-get.md?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json) and replication status through Azure's provided metrics and dashboards.
- During time periods where:
    - Your storage account data transfer rate exceeds 1 gigabit per second (Gbps) and the resulting back log of writes are being replicated, or
    - Your storage account exceeds 100 CopyBlob requests per second and the resulting back log of writes are being replicated
    
These limitations are critical to understanding how and when the SLA applies, and Azure provides detailed telemetry and metrics to help customers monitor their eligibility throughout the billing month. During these intervals, although replication of the data remains prioritized, the account is temporarily excluded from SLA eligibility. Refer to the official [SLA terms] for a comprehensive list of eligibility requirements. 

> [!IMPORTANT]
> Certain operational scenarios can also disrupt SLA coverage. For example, an unplanned failover will automatically disable Geo Priority Replication, requiring you to re-enable the feature manually after geo-redundancy is restored. By comparison, planned failovers and account conversions between GRS and geo zone redundant storage (GZRS) don't affect SLA eligibility, provided the account remains within guardrails.


## Enabling Geo-Redundant Storage replication
Enabling Geo Priority Replication is straightforward and can be completed via the Azure portal, PowerShell, or the Azure CLI. It can be enabled for existing accounts, or during the process of creating a new account.

### Enabling replication during new account creation

To enable Geo Priority Replication when creating a new storage account, complete the following steps:

# [Azure portal](#tab/portal)

1. Navigate to the Azure portal and create a new storage account.
1. In the **Basics** tab, select the checkbox for **Geo priority replication** as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication/replication-new-accounts-sml.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for a new storage account." lightbox="media/storage-redundancy-priority-replication/replication-new-accounts-lrg.png":::

# [Azure PowerShell](#tab/powershell)

```powershell

# Login to your Azure account
Connect-AzAccount

# Set variables 
$rgname = 
$newAccountName = 
$destAccountName = 
$srcAccountName = 
$srcContainer = 
$destContainer =
 
# Create storage account with geo priority replication enabled
$account = New-AzStorageAccount -ResourceGroupName $rgname -StorageAccountName $newAccountName -SkuName Standard_GRS -Location centralusEUAP -EnableBlobGeoPriorityReplication $true

```
# [Azure CLI](#tab/cli)

Content for CLI...

```azurecli-interactive

# Login to your Azure account
Connect-AzAccount

# Set variables
$rgname          = "<resource-group-name>"
$newAccountName  = "<new-account-name>"
$destAccountName = "<destination-account-name>"
$srcAccountName  = "<source-account-name>"
$srcContainer    = "<source-container-name>"
$destContainer   = "<destination-container-name>"

# Create storage account with geo priority replication enabled
az storage account create -n $newAccountName -g $rgname --sku Standard_GRS --enable-blob-geo-priority-replication true
```

---

### Enabling replication for preexisting accounts

To enable Geo Priority Replication for an existing storage account, complete the following steps:

# [Azure portal](#tab/portal)

1. Navigate to the Azure portal and select a storage account. 
1. In the **Data Management** group, select **Redundancy** to display the redundancy options for the storage account.
1. Select the **Geo priority replication (Blob only)** checkbox to enable the feature as shown in the following screenshot, and then select **Save**.

    :::image type="content" source="media/storage-redundancy-priority-replication/replication-existing-accounts-sml.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for existing accounts." lightbox="media/storage-redundancy-priority-replication/replication-existing-accounts-lrg.png":::

1. Ensure that the setting is saved successfully. Validate that the **Geo priority replication** status is set to **Enabled**, and the **View metrics** link is available and enabled as shown in the following screenshot.

    :::image type="content" source="media/storage-redundancy-priority-replication/replication-enabled-sml.png" alt-text="Screenshot showing the geo priority replication enabled status for existing accounts." lightbox="media/storage-redundancy-priority-replication/replication-enabled-lrg.png":::

You can disable Geo Priority Replication at any time by clearing the checkbox and saving the settings as shown in the following screen capture.

:::image type="content" source="media/storage-redundancy-priority-replication/replication-disabled-sml.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for disabling the feature." lightbox="media/storage-redundancy-priority-replication/replication-disabled-lrg.png":::

# [Azure PowerShell](#tab/powershell)

```powershell
# Login to your Azure account
Connect-AzAccount
 
# Set variables
$rgname          = "<resource-group-name>"
$newAccountName  = "<new-account-name>"
$destAccountName = "<destination-account-name>"
$srcAccountName  = "<source-account-name>"
$srcContainer    = "<source-container-name>"
$destContainer   = "<destination-container-name>"
 
## Update storage account with Geo Priority Replication enabled
$account = Set-AzStorageAccount -ResourceGroupName $rgname -StorageAccountName $newAccountName -EnableBlobGeoPriorityReplication $false
$account
$account.GeoPriorityReplicationStatus.IsBlobEnabled
```

# [Azure CLI](#tab/cli)

```azurecli-interactive

# Login to your Azure account
Connect-AzAccount

# Set variables
$rgname              = "<resource-group-name>"
$storageAccountName  = "<new-account-name>"

# Update existing storage account to enable geo priority replication
az storage account update -n $storageAccountName -g $rgname --enable-blob-geo-priority-replication true

# Update existing storage account to disable geo priority replication
az storage account update -n $storageAccountName -g $rgname --enable-blob-geo-priority-replication false

```

---

## Monitoring compliance

> [!IMPORTANT]
> Geo Blob Lag metrics are currently in PREVIEW and available in all regions where Geo priority replication is supported.
> To opt in to the preview, see [Set up preview features in Azure subscription](/azure/azure-resource-manager/management/preview-features) and specify AllowGeoPriorityReplicationMetricsInPortal as the feature name. The provider name for this preview feature is Microsoft.Storage.
> 
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

To ensure transparency and empower customers to track the performance of Geo priority replication, Azure provides a new monitoring tool integrated directly into Azure Monitor Metrics. After geo priority replication is enabled, you have the ability to view the new **Geo Blob Lag metric (preview)** for Blob data on a per-account basis. You can check your "Geo blob lag" performance throughout the month via the **Redundancy** and **Metrics** panes. The **Geo Blob Lag metric (preview)** allows you to monitor the lag, or the number of seconds since the last full data copy between the primary and secondary regions, of your block blob data. Geo blob lag can be viewed over the course of a specified time range, up to 12 months. This metric allows you to assess the performance trends and identify potential SLA breaches for your account. 

<!-->INSERT IMAGE HERE-->

## Feature pricing

Users begin paying for Geo priority replication feature as soon as they enable the feature. Prioritization of the backlog and new writes are also prioritized after the feature is enabled. Pricing for Geo priority replication is based on the amount of data written to the storage account and the volume of data transferred to the secondary region. For detailed pricing information, refer to the [Azure Storage pricing page](https://azure.microsoft.com/pricing/details/storage/).

> [!IMPORTANT]
> When you disable Geo Priority Replication, the account is billed for 30 days beyond the date on which the feature was disabled.

## Next steps
- [Understand Azure Storage redundancy options](storage-redundancy-overview.md)
- [Azure Storage pricing](https://azure.microsoft.com/pricing/details/storage/)