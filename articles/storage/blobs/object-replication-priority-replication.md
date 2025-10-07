---
title: Introducing object replication priority replication for block blobs
titleSuffix: Azure Storage
description: Object replication's priority replication feature allows users to obtain prioritized replication from their source storage account to the destination storage account of their replication policy.
author: stevenmatthew

ms.service: azure-blob-storage
ms.topic: concept-article
ms.date: 10/05/2025
ms.author: shaas

# Customer intent: As a cloud storage administrator, I want to implement priority object replication for block blobs, so that I can improve data availability, reduce read latency, and optimize cost-efficiency across multiple regions.
---

# Priority Replication for Azure Storage object replication (preview)

Currently, object replication copies all operations from a source storage account to one or more destination accounts asynchronously, with no guaranteed completion time. However, with the introduction of priority replication, users can now choose to prioritize replication for their replication policies. This feature ensures that these operations are replicated more quickly than standard operations.

Priority replication also provides a Service Level Agreement (SLA) guarantee if your policy's source and destination account are located within the same continent. The SLA is expressed in terms of a percentage of operations that are replicated within 15 minutes. It guarantees that 99.9% of operations are replicated within 15 minutes during a billing month.

> [!IMPORTANT]
> This feature enabled is currently in preview and is available only in a limited number of regions. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.
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

## Benefits of priority replication

Priority replication significantly improves the performance and observability for Azure Object Replication (OR). When enabled, the feature prioritizes replication for an organization's replication policies. This feature takes effect immediately and ensures that these operations are replicated more quickly than standard operations.

Moreover, priority replication comes with a Service Level Agreement (SLA) that provides users with a performance guarantee provided the source and destination storage accounts are located within the same continent. The SLA guarantees that 99.9% of replication operations complete within 15 minutes during a billing month. This level of assurance is especially valuable for scenarios involving disaster recovery, business continuity, and high-availability architectures.

In addition to performance guarantees, priority replication enhances visibility into replication progress through required OR metrics. These metrics allow users to monitor the number of operations and bytes pending replication, segmented into time buckets such as 0–5 minutes, 5–10 minutes, and beyond. This detailed insight helps teams proactively manage replication health and identify potential delays.

Organizations can enable priority replication on both new and existing OR policies using the REST API. This flexibility allows teams to upgrade their current replication workflows without reconfiguring their entire setup. Overall, priority replication empowers businesses to replicate their most important data with confidence and precision.

## Feature Pricing

Priority replication introduces a new pricing model to reflect its enhanced capabilities. Customers are charged $0.015 per gigabyte of data replicated under this feature. This cost takes effect shortly after Priority replication is enabled.

While Priority replication itself incurs a charge, the associated OR metrics are free of cost. However, enabling metrics might lead to increased change feed reads, which could result in extra charges depending on usage.

Standard costs for read and write transactions, and for network egress still apply. These charges are consistent with existing OR pricing and should be considered when estimating the total cost of using Priority replication. For detailed pricing information, customers are encouraged to consult the [Blob Storage pricing page](https://azure.microsoft.com/pricing/details/storage/blobs/) page.

## Opt-Out Policy and Billing Continuity

Customers have the flexibility to disable Priority replication at any time. However, it's important to note that billing for the feature will continue for 30 days after being disabled. This policy ensures that any in-progress replication operations are completed and monitored appropriately, maintaining data integrity and consistency.
This 30-day billing continuity allows Azure to manage the transition smoothly and ensures that customers don't experience unexpected interruptions in replication performance. Organizations should plan accordingly when deciding to opt out of Priority replication, especially if the feature was enabled for critical workloads.

## SLA Eligibility and Exclusions

To benefit from the priority replication SLA, certain conditions must be met. First, the source and destination storage accounts must be located within the same continent. This geographic proximity is essential for achieving the expected replication speed.

The SLA applies only to objects that are 5 GB or smaller and are mutated less frequently than 10 times per second. Additionally, priority replication can only be configured on one replication policy per source account. This limitation ensures that Azure can maintain the performance guarantees across all participating accounts.

Storage accounts with Locally Redundant Storage (LRS) must not exceed 5 PB of total data or contain more than 10 billion blobs to remain eligible for the SLA. Accounts that exceed these thresholds might experience delays in replication, and the SLA wouldn't apply during such periods. 

There are also operational thresholds that might affect SLA eligibility. The SLA is only valid when storage account data transfer rates remain below 1 Gbps and experience fewer than 1,000 `PUT` or `DELETE` operations per second while the resulting backlog of writes is being replicated. 

The SLA might be temporarily invalidated during the initial replication of existing blobs following the creation or update of a replication policy. Existing blob replication is estimated to progress at 100 TB per day on average but might experience reduced velocity when blobs with many versions are present. 

Exceeding these thresholds might lead to delays in replication, and the SLA wouldn't apply during such periods.

## Prerequisites during preview

During the preview phase, OR metrics are required to be enabled when enabling priority replication. The OR metrics provide users with insights into the replication progress and help monitor the health of their replication policies. The following metrics are available: 

- **Operations pending replication:** The total number of operations pending replication from the source to the destination storage account, emitted per the time buckets.
- **Bytes pending replication:** The sum of bytes pending replication from the source to the destination storage accounts, emitted per the time buckets.

Each of these metrics can be viewed with a time bucket dimension, enabling insight into the replication lag for the following time buckets:

- 0-5 mins
- 5-10 mins
- 10-15 mins
- 15-30 mins
- 30 mins-2 hrs
- 2-8 hrs
- 8-24 hrs
- 24+ hrs

You can enable and view the metrics on the source storage account for each OR policy. For more information, see the [OR Overview](object-replication-overview.md) article.

## Supported scenarios and limitations during preview

During the preview phase, priority replication supports only the following scenarios:

- Creating a new object replication policy with priority replication and metrics enabled on the source storage account.
- Enabling priority replication and object replication monitoring in an existing policy on the source storage account.
- Disabling priority replication on a replication policy on the source storage account.
- Viewing the OR metrics on the source storage account.
- Viewing the OR metrics in Azure Monitor by clicking through the metric on OR pane. 
- Setting Alerts on metrics based on threshold values relevant to your workload.

During the preview phase, the OR SLA can only be configured using the REST API. The Azure portal and Azure CLI don't yet support the configuration of this feature. Moreover, SDKs, Azure PowerShell cmdlet, and Azure CLI support aren't available during preview.

## Configuring Object Replication Priority Replication

As previously mentioned in the [Prerequisites during preview](#prerequisites-during-preview) section, enabling priority replication requires that object replication metrics are also enabled. To list, register, or unregister preview features in your Azure subscription, you need to access Azure Feature Exposure Control (AFEC). Access permission for AFEC is granted through the **Contributor** and **Owner** built-in roles, or through a custom role.

The first step to enable priority replication is to ensure the following features are registered in your subscription before you can enable priority replication on your subscription:

- **`Microsoft.Storage/ObjectReplicationPriorityReplication`**<br>
    This feature enables priority replication for object replication policies. Any request to enable the feature requires manual approval for registration. Enrollment requests can take up to five business days to complete after submission.
- **`Microsoft.Storage/ObjectReplicationMetrics`**<br>
    This feature enables object replication metrics on the source storage account. The subscription will be autoenrolled after the priority replication request is approved, though registration might take some amount of time to take effect.

Although the registration process for some features can be completed using the Azure portal, the OR SLA preview requires registration through the Azure PowerShell or Azure CLI. For more information about registering preview features, see [Register for preview features](https://learn.microsoft.com/azure/azure-resource-manager/management/register-azure-preview-features).

### Register, check approval status, and re-register resource providers

# [Azure PowerShell](#tab/psh)

To register for a feature with PowerShell, use the `Register-AzProviderFeature` cmdlet. For the OR SLA, you must register for both features to enable priority replication and the required metrics.

```azurepowershell

Register-AzProviderFeature `
    -FeatureName AllowObjectReplicationMetrics `
    -ProviderNamespace Microsoft.Storage

Register-AzProviderFeature `
    -FeatureName AllowObjectReplicationSLA `
    -ProviderNamespace Microsoft.Storage

 ```

After registering, you can check the status of your registration using the `Get-AzProviderFeature` command as shown in the following example:

```azurepowershell

Get-AzProviderFeature 
    `-ProviderNamespace Microsoft.Storage 
    `-FeatureName AllowObjectReplicationMetrics 

Get-AzProviderFeature 
    `-ProviderNamespace Microsoft.Storage 
    `-FeatureName AllowObjectReplicationSLA

```

When checking the status of the registration request, you're shown one of two states: **Registered** or **Pending**. After your registration is approved, you must re-register with the Azure Storage resource provider. To re-register the resource provider, use the `Register-AzResourceProvider` cmdlet.

```azurepowershell

Register-AzResourceProvider -ProviderNamespace 'Microsoft.Storage' 

```

# [Azure CLI](#tab/cli)

To register for a feature with Azure CLI, use the `az feature register` command. For the OR SLA, you must register for both features to enable priority replication and the required metrics.

```azurecli

az feature register --name AllowObjectReplicationMetrics --namespace Microsoft.Storage

az feature register --name AllowObjectReplicationSLA --namespace Microsoft.Storage

```

After registering, you can check the status of your registration using the `az feature show` command as shown in the following example:

```azurecli

az feature show --namespace Microsoft.Storage --name AllowObjectReplicationMetrics 

az feature show --namespace Microsoft.Storage --name AllowObjectReplicationSLA

```

After your registration is approved, you must re-register the Azure Storage resource provider. To re-register the resource provider with Azure CLI, use the `az provider register` command.

```azurecli

az provider register --namespace 'Microsoft.Storage' 

```
---

### Configure priority replication 

After successfully registering your subscription to use the preview, you can enable OR metrics and priority replication using REST API. Add the following highlighted properties in the following sample request. Replace the account and container names, and remove or update prefix filters as applicable to your scenario. 

When priority replication is enabled, monitoring metrics must also be enabled. The request to enable priority replication fails if the request doesn't enable metrics in the OR policy.

```rest
 
  "properties": { 
    "sourceAccount": "mysourceaccount",
    "destinationAccount": "mydestinationaccount", 

    "replicationSLA": {
        "enabled": true,
      } 

    "metrics": {  
        "enabled": true
      },  

    "rules": [ 
      {
        "sourceContainer": "mysourcecontainer",
        "destinationContainer": "mydestinationcontainer",
        "filters": { 
          "prefixMatch": [ 
            "blobA", 
            "blobB" 
          ] 
        } 
      } 
    ] 
  } 

```
