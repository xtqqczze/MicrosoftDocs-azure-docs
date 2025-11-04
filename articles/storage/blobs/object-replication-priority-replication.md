---
title: Introducing object replication priority replication for block blobs
titleSuffix: Azure Storage
description: Object replication's priority replication feature allows users to obtain prioritized replication from their source storage account to the destination storage account of their replication policy.
author: stevenmatthew

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 10/22/2025
ms.author: shaas
ms.custom: references_regions

# Customer intent: As a cloud storage administrator, I want to implement priority object replication for block blobs, so that I can improve data availability, reduce read latency, and optimize cost-efficiency across multiple regions.
---

# Priority replication for Azure Storage object replication

Object replication (OR) currently copies all operations from a source storage account to one or more destination accounts asynchronously, with no guaranteed completion time. However, with the introduction of object replication priority replication, users can now choose to prioritize the replication of the operations in their replication policy. 

Priority replication comes with a Service Level Agreement (SLA) guarantee if your policy's source and destination account are located within the same continent. The SLA ensures 99.0% of operations replicate from the source account to the destination account within 15 minutes during a billing month. Refer to the official [SLA terms](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1&msockid=0d36bfb9b86d68ee3afdae84b944695f) for a comprehensive list of eligibility requirements.

<!--
> [!IMPORTANT]
> This feature is generally available but is currently only offered in a limited number of regions.
>
>
> OR Priority replication is available only within the following regions:
> - East US 2
> - West US 2
> - North Europe
> - West Europe
> - Japan East
> - Japan West
> - Central India
> - Switzerland North
> - UAE North
>
> To gain access to the Azure portal experience of Object Replication priority replication, see [Set up preview features in Azure subscription](/azure/azure-resource-manager/management/preview-features) and specify AllowPriorityObjectReplicationInPortal as the feature name. The provider name for this preview feature is Microsoft.Storage.-->

## Benefits of priority replication

Priority replication significantly improves the performance and observability for Azure Object Replication (OR). Moreover, priority replication comes with a Service Level Agreement (SLA) that provides users with a performance guarantee provided the source and destination storage accounts are located within the same continent. The SLA guarantees that 99.0% of operations are replicated from the source to the destination storage account within 15 minutes during a billing month. This level of assurance is especially valuable for scenarios involving disaster recovery, business continuity, and high-availability architectures.

In addition to performance guarantees, priority replication automatically enables OR metrics, which enhances visibility into replication progress. These metrics allow users to monitor the number of operations and bytes pending replication, segmented into time buckets such as 0–5 minutes, 5–10 minutes, and beyond. This detailed insight helps teams proactively manage replication health and identify potential delays. To learn more about OR metrics, see the [replication metrics](object-replication-overview.md#replication-metrics) article.

## SLA eligibility and exclusions

When Object Replication Priority Replication is enabled, users benefit from prioritized replication along with the improved visibility into their replication progress from OR metrics. While the replication from the source storage account to destination storage account remains prioritized, there are limitations to which workloads are eligible for the Service Level Agreement for Priority Replication. These limitations include:

- Objects larger than 5 gigabytes (GB).
- Objects that are modified more than 10 times per second.
- Object Replication Policies where the Source Storage Account and Destination Storage Account aren't within the same continent.
- Storage accounts that are:
    - Larger than 5 petabytes (PB), or 
    - Have more than 10 billion blobs, and 
- During time periods where:
    - Your storage account or Replication Policy data transfer rate exceeds 1 gigabit per second (Gbps) and the resulting back log of writes are being replicated.
    - Your storage account or Replication Policy exceeds 1,000 PUT or DELETE operations per second and the resulting back log of writes are being replicated, and 
    - Existing blob replication is pending following a recent Replication Policy creation or update. Existing blob replication is estimated to progress at 100 TB per day on average but might experience reduced velocity when blobs with many versions are present.
  
Refer to the official [SLA terms](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1&msockid=0d36bfb9b86d68ee3afdae84b944695f) for a comprehensive list of eligibility requirements.

> [!IMPORTANT]
> Although a storage account can have up to two object replication policies, priority replication can only be enabled on one object replication policy per storage account. Users should plan accordingly when deciding to opt out of Priority replication, especially if the feature was enabled for critical workloads.

## Feature pricing

Standard costs for read and write transactions, and for network egress still apply for object replication. These charges are consistent with existing OR pricing and should be considered when estimating the total cost of using priority replication. Enabling OR priority replication has a per-GB cost for all new data ingress. 

For detailed Azure Storage pricing information, refer to the [Azure Storage pricing](https://azure.microsoft.com/pricing/details/storage/) article. For an overview of Object Replication-specific pricing, see the pricing section within the [object replication overview](object-replication-overview.md#billing) article.

> [!IMPORTANT]
> Customers have the flexibility to disable priority replication at any time. However, it's important to note that billing for the feature will continue for 30 days after being disabled.

## Monitor SLA compliance for OR priority replication

To ensure transparency and empower customers to track the performance of OR priority replication, Azure provides a two monitoring tools integrated directly into Azure portal, PowerShell and Azure CLI. When OR priority replication is enabled, Replication Metrics for Object Replication is automatically enabled as well. These metrics empower users to troubleshoot replication delays and help users monitor their SLA compliance. Metrics now supported are: 

- **Operations pending for replication**: Total number of operations pending replication from source to destination storage account emitted per the time buckets
- **Bytes pending for replication**: Sum of bytes pending replication from source to destination storage accounts emitted per the time buckets

Each of the metrics previously mentioned can be viewed with the dimension of time buckets including 0-5 minutes, 10-15 minutes and > 24 hours. Users with OR priority replication that would like to ensure all their operations are replicating within 15 minutes; can monitor the larger time buckets (ex: 30 mins – 2 hours or 8-24 hours) and ensure they are at zero or near zero throughout the billing month. 

For more information about OR metrics, see [replication metrics](object-replication-overview.md#replication-metrics).

Users also have other options such as checking the replication status of their source blob. Users can check the replication status of a source blob to determine whether replication to the destination is complete. Once the replication status is marked as `Completed`, the user can guarantee the blob is available in the destination account. For more information view, [Check the replication status of a blob](object-replication-configure.md?tabs=portal#check-the-replication-status-of-a-blob).

## Enable and disable object replication priority replication

Users can enable OR priority replication on both new and existing OR policies using Azure portal, PowerShell, or the Azure CLI. It can be enabled for existing OR policies, or during the process of creating new a new OR policy.

### Enable priority replication during new policy creation

To enable OR Priority Replication when creating a new OR policy, complete the following steps:

# [Azure portal](#tab/portal)

1. Navigate to the Azure portal and create a new storage account.
1. Select the **Create replication rules** tab to open the **Create replication rules** pane as shown in the following screenshot.

    :::image type="content" source="media/object-replication-priority-replication/replication-new-accounts-sml.png" alt-text="Screenshot showing the location of the geo priority replication checkbox for a new storage account." lightbox="media/object-replication-priority-replication/replication-new-accounts-lrg.png":::

1. In the **Create replication rules** pane, select your chosen **Destination subscription** and **Destination storage account**. Select the checkbox for **Geo priority replication** as shown.

    :::image type="content" source="media/object-replication-priority-replication/create-replication-rules-sml.png" alt-text="Screenshot showing the location of the Enable Priority Replication and Enable Replication Monitoring checkboxes in the replication rules pane." lightbox="media/object-replication-priority-replication/create-replication-rules-lrg.png":::

1. Complete the remaining fields and select **Add rule** to create the new OR policy with priority replication enabled.

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

# Set OR policy on destination account with priority replication enabled
$rule1 = New-AzStorageObjectReplicationPolicyRule -SourceContainer $srcContainer ` 
    -DestinationContainer $destContainer
$destPolicy = Set-AzStorageObjectReplicationPolicy -ResourceGroupName $rgname `
    -StorageAccountName $destAccountName -PolicyId default `
    -SourceAccount $srcAccountName -Rule $rule1 -EnableMetric $true `
    -EnablePriorityReplication $true
$destPolicy.PriorityReplication.Enabled

```

# [Azure CLI](#tab/cli)

```azurecli-interactive

# Login to your Azure account
az login

# Set variables
$rgname          = "<resource-group-name>"
$newAccountName  = "<new-account-name>"
$destAccountName = "<destination-account-name>"
$srcAccountName  = "<source-account-name>"
$srcContainer    = "<source-container-name>"
$destContainer   = "<destination-container-name>"

# Set OR policy on destination account with priority replication enabled

az storage account or-policy create -n $destAccountName -s $srcAccountName /
    --dcont $dstContainer --scont $srcContainer -t "2020-02-19T16:05:00Z" /
    --enable-metrics True --priority-replication true

```

---

### Enable or disable priority replication for existing policies

To enable or disable Priority Replication for an existing OR policy, complete the following steps:

# [Azure portal](#tab/portal)

1. In the Azure portal, navigate to the storage account you want to modify.
1. Select the **Your accounts** tab to view the list of accounts within your subscription as shown.



1. Locate the **Destination account** containing the **Source container** and **Destination container** whose OR policy you want to modify. Select the ellipsis or the **More options** button and then select **Edit rules** to open the **Edit replication rules** pane as shown.

    :::image type="content" source="media/object-replication-priority-replication/edit-replication-rules-sml.png" alt-text="Screenshot showing how to locate the Edit Rules option for existing replication rules." lightbox="media/object-replication-priority-replication/edit-replication-rules-lrg.png":::

1. To enable OR priority replication, select **Enable** link  in the corresponding storage account's **Priority replication** column as shown in the following screenshot, and then select **Save**.

    :::image type="content" source="media/object-replication-priority-replication/edit-replication-rules-pane-sml.png" alt-text="Screenshot showing the location of the Enable Priority Replication checkbox in the Edit Replication Rules pane." lightbox="media/object-replication-priority-replication/edit-replication-rules-pane-lrg.png":::

1. To disable OR priority replication, select the **Disable** link in the corresponding storage account's **Priority replication** column and then select **Save**, as shown.

# [Azure PowerShell](#tab/powershell)

```powershell

# First, login to your Azure account
Connect-AzAccount

# Next, set your variables
$rgname          = "<resource-group-name>"
$newAccountName  = "<new-account-name>"
$destAccountName = "<destination-account-name>"
$srcAccountName  = "<source-account-name>"
$srcContainer    = "<source-container-name>"
$destContainer   = "<destination-container-name>"

# Get the destination OR policy
# and enable priority replication
$Policy = Get-AzStorageObjectReplicationPolicy -ResourceGroupName $rgname `
    -StorageAccountName $destAccountName
$destPolicy.PriorityReplication.Enabled

# Get the source OR policy
# and enable priority replication
$Policy = Get-AzStorageObjectReplicationPolicy -ResourceGroupName $rgname `
    -StorageAccountName $srcAccountName
$srcPolicy.PriorityReplication.Enabled

# Remove the OR policy from the destination account
Remove-AzStorageObjectReplicationPolicy -ResourceGroupName $rgname `
    -StorageAccountName $destAccountName -PolicyId $destPolicy.PolicyId

# Remove the OR policy from the source account
Remove-AzStorageObjectReplicationPolicy -ResourceGroupName $rgname `
    -StorageAccountName $srcAccountName -PolicyId $srcPolicy.PolicyId

```

# [Azure CLI](#tab/cli)

```azurecli-interactive
# Login to your Azure account
```

---
