---
title: Configure a cache volume for Azure NetApp Files 
description: This article shows you how to create a cache volume in Azure NetApp Files. 
services: azure-netapp-files
author: netapp-manishc
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 09/17/2025
ms.author: anfdocs
ms.custom: sfi-image-nochange
# Customer intent: As a cloud administrator, I want to create a cache volume in Azure NetApp Files, so that I can leverage scalable storage solutions and reduce cost.
---
# Configure a cache volume for Azure NetApp Files

The purpose of this article is to provide users of Azure NetApp Files with cache volumes that simplify file distribution, reduce WAN latency, and lower WAN/ExpressRoute bandwidth costs. Azure NetApp Files cache volumes are currently designed to be peered with external sources (aka origin volumes in on-prem ONTAP, Cloud Volumes ONTAP, or Amazon FSx for NetApp.

Azure NetApp Files cache volumes are cloud based caches of an external origin volume, containing only the most actively accessed data on the volume. Cache volumes accept both reads and writes but operate at faster speeds with reduced latency. When a cache volume receives a read request of the hot data it contains, it can respond faster than the origin volume because the data doesn't need to travel as far to reach the client. If a cache volume receives a read request for infrequently read data (cold data), it retrieves the needed data from the origin volume and then stores the data before serving the client request. Subsequent read requests for that data are then served directly from the cache volume. After the first request, the data no longer needs to travel across the network or be served from a heavily loaded system.

Write-back allows the write to be committed to stable storage at the cache and acknowledges the client without waiting for the data to make it to the origin. This results in a globally distributed file system that enables writes to perform at near-local speeds for specific workloads and environments, offering significant performance benefits whereas write-around waits for the origin to commit the writes to the stable storage before acknowledging the client. This results in every write incurring the penalty of traversing the network between the cache and origin.  

## Considerations

* The delegated subnet address space for hosting the Azure NetApp Files volumes must have at least seven free IP addresses: 6 for cluster peering and 1 for data access to one or more cache volumes. It's recommended that the delegated subnet address space is sized appropriately to accommodate another Azure NetApp Files network interfaces. Review Guidelines for Azure NetApp Files network planning to ensure you meet the requirements for delegated subnet sizing.
* When creating each cache volume, the Azure NetApp Files volume placement algorithm attempts to re-use the same Azure NetApp Files storage system as any previously created volumes in the subscription. This is done to try and reduce the number of NICs/IPs consumed in the delegated subnet. If this isn't possible, another 6+1 NICs are consumed.
* If enabling write-back on the external origin volume, consider these key points
    * You must be running ONTAP 9.15.1P5 or later on the system hosting the external origin volume. 
    * It's recommended that each external origin system node have at least 128GB of RAM and 20 CPUs to absorb the write-back messages initiated by write-back enabled caches. This is the equivalent of an A400 or greater. If the origin cluster serves as the origin to multiple write-back enabled Azure NetApp Files cache volumes, it requires more CPU and RAM.
    * Testing must have been executed for files smaller than 100GB and WAN round-trip times between the cache and origin not exceeding 100 ms. Any workloads outside of these limits might result in unexpected performance characteristics.
    * The external origin must remain under 80% full. Cache volumes aren't granted exclusive lock delegations if there isn't at least 20% space remaining in the origin volume. Calls to a write-back-enabled cache are forwarded to the origin in this situation. This helps prevent running out of space at the origin, which would result in leaving dirty data orphaned at a write-back-enabled cache.
    * You shouldn't configure qtree, user, or group quotas at origin volume with write-back enabled cache volumes. This may incur a significant latency increase.
* You should be aware of the supported and unsupported features for cache volumes in Azure NetApp Files.
    * Unsupported features:
        * NFSv4.2
        * Ransomware protection
        * FlexCache Disaster Recovery
        * S3 Buckets
        * Azure NetApp Files Backup
        * CRR/CZR/CZRR
        * Snapshot Policies
        * Basic networking features
        * Application Volume Groups (AVGs)
        * Any other Azure NetApp Files feature not included as supported
    * Supported in private preview:
        * NFS and SMB
        * Availability zone volume placement
        * Customer-managed keys
        * SMB continuous availability shares
        * Standard network features
* The Azure NetApp Files cache volume must be deployed in an availability zone. To populate a new or existing volume in an availability zone, see [Manage availability zones in Azure NetApp Files](manage-availability-zone-volume-placement.md). 
* Cache volumes only support standard network features. Basic network features can't be configured on cache volumes. 
* When creating a cache volume, you just ensure there is sufficient space in the capacity pool to accommodate the new cache volume.
* You can't move a cache volume to another capacity pool after it’s created.
* You should ensure that the protocol type is the same for the cache volume and origin volume as the security style and the Unix permissions are inherited from the origin volume. Example: create a cache volume with protocol NFSv3 or NFSv4 when origin is UNIX, and SMB when the origin is NTFS.
* It's recommended to enable encryption on the origin volume.
* You can only modify specific fields of a cache volume such as ‘is-cifs-change-notify-enabled’, ‘is-writeback-enabled’, and ‘is-global-file-locking-enabled'.
* Cache volumes are supported in the regions listed:
    * Australia Central
    * Australia Central 2
    * Australia East
    * Australia Southeast
    * Brazil South
    * Brazil Southeast
    * Canada Central
    * Canada East
    * Central India
    * Central US
    * East Asia
    * East US
    * East US 2
    * France Central
    * Germany West Central
    * Israel Central
    * Italy North
    * Japan East
    * Japan West
    * Korea Central
    * Korea South
    * Malaysia West
    * New Zealand North
    * North Central US
    * North Europe
    * Norway East
    * Qatar Central
    * South Africa North
    * South Central US
    * Southeast Asia
    * Spain Central
    * Sweden Central
    * Switzerland North
    * Switzerland West
    * Taiwan North
    * UAE North
    * UK South
    * UK West
    * US Gov Arizona
    * US Gov Texas
    * US Gov Virginia
    * West Europe
    * West US
    * West US 2
    * West US 3

* The Azure Monitor portal supports the following new metrics for cache volumes:

    * **Cache miss blocks**      
        This metric counts missed blocks in the caching process. If this value exceeds client requested blocks, you may need to adjust throughput

    * **Client requested blocks**  
        A data movement over time count to provide insights into latency 

    * **Constituents at capacity count**      
        A count of the constituents that are at least 90% full

    * **Flex Cache connection status**      
        The metric displays 1 if all the cache volumes can connect to the origin volume. A value of 0 means the connection isn't working. 

    * **Maximum file size**      
        The maximum file size in bytes


## Register the feature

You need to register the feature before using it for the first time. After registration, the feature is enabled and works in the background. 

1. Register the feature: 

    ```azurepowershell-interactive
    Register-AzProviderFeature -ProviderNamespace Microsoft.NetApp -FeatureName ANFCacheVolumesExternal 
    ```

2. Check the status of the feature registration: 

    > [!NOTE]
    > The **RegistrationState** may be in the `Registering` state for up to 60 minutes before changing to`Registered`. Wait until the status is **Registered** before continuing.

    ```azurepowershell-interactive
    Get-AzProviderFeature -ProviderNamespace Microsoft.NetApp -FeatureName ANFCacheVolumesExternal 
    ```

You can also use [Azure CLI commands](/cli/azure/feature) `az feature register` and `az feature show` to register the feature and display the registration status.

## Before you begin

You must create Express Route or VPN resources to ensure network connectivity from the external NetApp ONTAP cluster to the target Azure NetApp Files cluster. This can be accomplished in many ways with the goal being that the source cluster has connectivity to the Azure NetApp Files delegated subnet. Connectivity includes this set of firewall rules (bidirectional for all):
    * ICMP
    * TCP 11104 
    * TCP 11105 
    * HTTPS
The network connectivity must be in place for all ‘intercluster’ (IC) LIFs on the source cluster to all IC LIFs on the Azure NetApp Files endpoint.

## Create a cache volume

1.	Create a cache volume

   ```
    curl -X 'PUT' \
    'https://management.azure.com/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-example/providers/Microsoft.NetApp/netAppAccounts/customer1/capacityPools/pool1/caches/cache1?api-version=2025-07-01-preview' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "tags": {
        "additionalProp1": "string",
        "additionalProp2": "string",
        "additionalProp3": "string"
    },
    "location": "string",
    "zones": [
        "1"
    ],
    "properties": {
        "filepath": "some-amazing-filepath",
        "size": 53687091200,
        "exportPolicy": {
        "rules": [
            {
            "ruleIndex": 0,
            "unixReadOnly": true,
            "unixReadWrite": true,
            "kerberos5ReadOnly": false,
            "kerberos5ReadWrite": false,
            "kerberos5iReadOnly": false,
            "kerberos5iReadWrite": false,
            "kerberos5pReadOnly": false,
            "kerberos5pReadWrite": false,
            "cifs": true,
            "nfsv3": true,
            "nfsv41": true,
            "allowedClients": "string",
            "hasRootAccess": true,
            "chownMode": "Restricted"
            }
        ]
        },
        "protocolTypes": [
        "NFSv3"
        ],
        "cacheSubnetResourceId": "string",
        "peeringSubnetResourceId": "string",
        "kerberos": "Disabled",
        "smbSettings": {
        "smbEncryption": "Disabled",
        "smbAccessBasedEnumeration": "Enabled",
        "smbNonBrowsable": "Enabled"
        },
        "throughputMibps": 128.223,
        "encryptionKeySource": "Microsoft.NetApp",
        "keyVaultPrivateEndpointResourceId": "string",
        "language": "c.utf-8",
        "originClusterInformation": {
        "peerClusterName": "cluster1",
        "peerAddresses": [
            "10.10.10.10",
            "10.10.10.11"
        ],
        "peerVserverName": "vserver1",
        "peerVolumeName": "originvol1"
        },
        "cifsChangeNotifications": "Disabled",
        "globalFileLocking": "Disabled",
        "writeBack": "Disabled"
    }
    }'
```

2. Ensure the cache state is available in cluster peering or Vserver peering:

    ```
    GET all flexcache volumes:
    curl -X 'GET' \
    'https://management.azure.com/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-example/providers/Microsoft.NetApp/netAppAccounts/customer1/capacityPools/pool1/caches?api-version=2025-07-01-preview' \
    -H 'accept: application/json'
    ```

3.	Generate the passphrase to enable cluster peering and Vserver peering:

    ```
    listPeeringPassphrases:
    curl -X 'POST' \
    'https://management.azure.com/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-example/providers/Microsoft.NetApp/netAppAccounts/customer1/capacityPools/pool1/caches/cache1/listPeeringPassphrases?api-version=2025-07-01-preview' \
    -H 'accept: application/json' \
    -d ''
    ```
    
## Delete a cache volume

You can delete a cache volume if it's no longer required. Before deleting a cache volume, you must ensure that the cache volume status is disconnected, and the write-back property of the cache volume is disabled.

1.	Run the following API to delete a cache volume:

    ```rest
    curl -X 'DELETE' \
    'https://management.azure.com/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-example/providers/Microsoft.NetApp/netAppAccounts/customer1/capacityPools/pool1/caches/cache1?api-version=2025-07-01-preview' \
    -H 'accept: application/json'
    ```