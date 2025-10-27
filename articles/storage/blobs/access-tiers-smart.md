---
title: Optimize costs with smart tier (preview)
description: Optimize your Azure Blob Storage costs with smart tier, automatically moving data between access tiers based on usage patterns.
author: beber-msft
ms.author: beber
ms.service: azure-storage
ms.topic: how-to
ms.date: 10/17/2025

#CustomerIntent: As a storage administrator, I want to optimize costs for blob storage so that I can reduce expenses while maintaining performance.
---
# Optimize costs with smart tier (preview)

Smart tier automatically moves your data between the hot, cool, and cold access tiers based on usage patterns, optimizing your costs for these access tiers without setting up additional rulesets or policies. Smart tier is the ideal tier to choose when you are looking to store your data on standard online tiers but are not fully aware of the data access patterns or do not want to manage data transitions across online tiers.
By default, new data is stored in the hot tier. Any object that isn't accessed for 30 days is moved to the cool tier; after 90 days of inactivity, it transitions to the cold tier. If any of those objects are later accessed, they are transitioned back to the hot tier automatically and restart their tiering cycle. The automatic movement of inactive data to cooler tiers can lead to large cost savings over time.
Access behavior, performance characteristics, and SLAs of the underlying residence tier do apply to objects in smart tier.


## Known issues and considerations

- Smart tier is currently in Public Preview for account level tiering for zone redundancy (ZRS, GZRS, and RA-GZRS) for both flat and hierarchical namespaces. 
- Redundancy conversions to non-zonal accounts are not supported. 
- After a failover of a GZRS account, the resulting LRS account needs to be converted to a zonal redundancy again within 60 days of failover for smart tier to remain supported. 
- Smart tier characteristics might change during or after the public preview phase. 

## Enabling smart tier
Smart tier is configured on the [default account access tier](access-tiers-overview.md#default-account-access-tier-setting). [Legacy account types](storage-account-overview.md#legacy-storage-account-types) such as Standard general-purpose v1 (GPv2) are not supported by smart tier. After enabling smart tier on existing storage accounts, all blobs in the account for which an access tier hasn't been explicitly set, will be moved to smart tier. Blobs that have an explicit tier set, will not be moved to smart tier. A monitoring fee will be billed for each group of 10,000 objects managed by smart tier.
Objects can be moved out of smart tier by explicitly setting a different online tier or changing the default account access tier setting to a different tier. Once moved to an explicit tier, objects cannot be tiered back to smart tier.
To set the default access tier setting for a storage account, see [Set a blob's access tier](access-tiers-online-manage.md)


## Working with smart tier
All smart tiered objects are automatically managed across the underlying residency tiers - hot, cool, and cold. The archive tier or the premium storage account kind are not in scope for smart tier. Smart tier operates on block blobs; page blobs are not supported. 
All objects that are created or moved onto smart tier enabled accounts will be stored in the hot residency tier initially. Small objects in smart tier, below 128 KiB in size, are not moved across residency tiers and will be kept on hot tier for efficiency reasons. No monitoring fee will be billed for those objects under 128 KiB in size. All other objects will remain in hot tier for 30 days and move to the cool tier if no access operation occurs. 

The Get Blob and Put Blob operations are access operations and will update the last access time of an object. However, the Get Blob Properties, Get Blob Metadata, and Get Blob Tags aren't access operations. Those operations won't update the last access time of an object or impact the tiering behavior of smart tier objects. After 60 additional days of not accessing objects on smart tier, they will transition to the cold tier. No further transitions will occur unless the object is accessed. The data always stays on online tiers, delivering you the regular availability, scale and performance targets of Azure Blob storage. 

Access operations against smart tier objects will reset the tier transition timer and immediately move the object to hot tier.
Objects on smart tier are not impacted by blob lifecycle management. Storage actions cannot be used to influence tiering operations for objects on smart tier. Soft deleted objects continue to transition to cooler tiers until their deletion expiry period is met.


## Billing details
Objects on smart tier are billed the capacity meters and connected prices of the underlying capacity tier (hot, cool, or cold tier). There is no smart tier specific capacity meter or price. All capacity under smart tier is billed at pay-as-you-go rates. There is no reserved capacity applicable.
Smart tier charges a monitoring operation for each set of 10,000 objects over 128KiB managed by smart tier.
Objects in smart tier are not charged for tier transitions within smart tier, early deletion fees, or data retrieval operations.

All operations billed for smart tier objects occur against the hot tier. This includes the initial transaction that triggers the move to hot tier for any object on other residency tiers. Moving existing objects into smart tier enabled accounts triggers a cool tier read operation per object, moving blobs out of smart tier triggers a cool write operation per object.
Versions and snapshots are billed full content length in current public preview phase.
Storage account metrics can be leveraged to identify the distribution of smart tier objects across the underlying tiers for both blob count and blob capacity. Objects smaller than 128KiB will be displayed under the regular hot tier metric.


## Client Tooling
The Azure Portal supports the current smart tier public preview. Smart tier requires the following minimum versions of REST, SDKs, and tools.

| Environment | Minimum version |
|---|---|
| [REST API](/rest/api/storageservices/blob-service-rest-api)| 2025-08-01 |


## Next steps

- [Set a blob's access tier](access-tiers-online-manage.md)
- [Archive a blob](archive-blob.md)
- [Optimize costs by automatically managing the data lifecycle](lifecycle-management-overview.md)
- [Best practices for using blob access tiers](access-tiers-best-practices.md)

