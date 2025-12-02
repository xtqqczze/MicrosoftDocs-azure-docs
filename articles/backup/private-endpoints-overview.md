---
title: Private Endpoints Overview
description: Understand the use of private endpoints for Azure Backup and the scenarios where using private endpoints helps maintain the security of your resources.
ms.topic: conceptual
ms.date: 09/09/2025
ms.service: azure-backup
author: AbhishekMallick-MS
ms.author: v-mallicka
ms.custom:
  - sfi-image-nochange
# Customer intent: As a cloud administrator, I want to implement private endpoints for Azure Backup so that I can enhance the security of my backup operations and ensure that all data traffic remains within my virtual network.
---

# Overview and concepts of private endpoints for Azure Backup

With Azure Backup, you can back up and restore your data from your Recovery Services vaults by using [private endpoints](../private-link/private-endpoint-overview.md). Private endpoints use one or more private IP addresses from your Azure virtual network, effectively bringing the service into your virtual network.

This article helps you understand how private endpoints for Azure Backup work. It provides scenarios where using private endpoints helps maintain the security of your resources.

> [!NOTE]
> Azure Backup provides a new experience for creating private endpoints. [Learn more](backup-azure-private-endpoints-concept.md).

## Considerations

- You can create private endpoints for new Recovery Services vaults only (if no items are registered to the vault). You must create private endpoints before you try to protect any items in the vault. However, private endpoints are currently not supported for Backup vaults.
- Customer-managed keys (CMKs) with a network-restricted key vault isn't supported with a vault that's enabled for private endpoints.
- One virtual network can contain private endpoints for multiple Recovery Services vaults. Also, one Recovery Services vault can have private endpoints for it in multiple virtual networks. The maximum number of private endpoints that you can create for a vault is 12.
- If public network access for the vault is set to **Allow from all networks**, the vault allows backups and restores from any machine registered to the vault. If public network access for the vault is set to **Deny**, the vault allows backups and restores only from the machines registered to the vault that are requesting backups/restores via private IPs allocated for the vault.
- A private endpoint connection for Azure Backup uses a total of 11 private IPs in your subnet, including the IPs that Azure Backup uses for storage. This number might be higher for certain Azure regions. We recommend that you have enough private IPs (/25) available when you try to create private endpoints for Azure Backup.
- Although both Azure Backup and Azure Site Recovery use a Recovery Services vault, this article discusses use of private endpoints for Azure Backup only.
- Private endpoints for Azure Backup don't include access to Microsoft Entra ID. You need to provide access to Microsoft Entra ID separately. So, IPs and FQDNs that are required for Microsoft Entra ID to work in a region need outbound access to be allowed from the secured network when performing backup of databases in Azure VMs and backup using the MARS agent. You can also use NSG tags and Azure Firewall tags for allowing access to Microsoft Entra ID, as applicable.
- You need to re-register the Recovery Services resource provider with the subscription if you registered it before May 1 2020. To re-register the provider, go to your subscription in the Azure portal, navigate to **Resource provider** on the left navigation bar, then select **Microsoft.RecoveryServices** and select **Re-register**.
- [Cross-region restore](backup-create-rs-vault.md#set-cross-region-restore) for SQL and SAP HANA database backups aren't supported if the vault has private endpoints enabled.
- When you move a Recovery Services vault already using private endpoints to a new tenant, you'll need to update the Recovery Services vault to recreate and reconfigure the vault's managed identity and create new private endpoints as needed (which should be in the new tenant). If this isn't done, the backup and restore operations will start failing. Also, any Azure role-based access control (Azure RBAC) permissions set up within the subscription will need to be reconfigured.

## Recommended and supported scenarios

While private endpoints are enabled for the vault, they're used for backup and restore of SQL and SAP HANA workloads in an Azure VM, MARS agent backup and DPM only. You can use the vault for backup of other workloads as well (they won't require private endpoints though). In addition to backup of SQL and SAP HANA workloads and backup using the MARS agent, private endpoints are also used to perform file recovery for Azure VM backup. For more information, see the following table:

| Scenarios | Recommendations |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Backup of workloads in Azure VM (SQL, SAP HANA), Backup using MARS Agent, DPM server. | Use of private endpoints is recommended to allow backup and restore without needing to add to an allowlist any IPs/FQDNs for Azure Backup or Azure Storage from your virtual networks. In that scenario, ensure that VMs that host SQL databases can reach Microsoft Entra IPs or FQDNs. |
| **Azure  VM backup**                                         | VM backup doesn't require you to allow access to any IPs or FQDNs. So, it doesn't require private endpoints for backup and restore  of disks.  <br><br>   However, file recovery from a vault containing private endpoints would be restricted to virtual networks that contain a private endpoint for the vault. <br><br> When using ACL'ed unmanaged disks, ensure the storage account containing the disks allows access to **trusted Microsoft services** if it's ACL'ed. |
| **Azure  Files backup**                                      | Azure Files backups are stored in the local  storage account. So it doesn't require private endpoints for backup and  restore. |
| **Changed virtual network for Private endpoint in the Vault and Virtual Machine** | Stop backup protection and configure backup protection in a new vault with Private Endpoints enabled. |

> [!NOTE]
> Private endpoints are supported with only DPM server 2022, MABS v4, and later.

## Unsupported scenario

For the backup and restore operations, a private endpoint enabled Recovery Services vault is not compatible with a private endpoint enabled Azure Key Vault to store CMKs on Recovery Services vault.

## Difference in network connections due to private endpoints

As mentioned above, private endpoints are especially useful for backup of workloads (SQL, SAP HANA) in Azure VMs and MARS agent backups.

In all the scenarios (with or without private endpoints), both the workload extensions (for backup of SQL and SAP HANA instances running inside Azure VMs) and the MARS agent make connection calls to Microsoft Entra ID (to FQDNs mentioned under sections 56 and 59 in [Microsoft 365 Common and Office Online](/office365/enterprise/urls-and-ip-address-ranges#microsoft-365-common-and-office-online)).

In addition to these connections when the workload extension or MARS agent is installed for recovery services vault *without private endpoints*, connectivity to the following domains is also required:

| Service | Domain names | Port |
| --- | --- | --- |
| Azure Backup | `*.backup.windowsazure.com` | 443 |
| Azure Storage | `*.blob.core.windows.net` <br><br> `*.queue.core.windows.net` <br><br> `*.blob.storage.azure.net` <br><br> `*.storage.azure.net` | 443 |
| Microsoft Entra ID | `*.login.microsoft.com` <br><br>  [Allow access to FQDNs under sections 56 and 59](/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide&preserve-view=true#microsoft-365-common-and-office-online). | 443 <br><br> As applicable |

When the workload extension or MARS agent is installed for Recovery Services vault with private endpoint, the following endpoints are hit:

| Service | Domain name | Port |
| --- | --- | --- |
| Azure Backup | `*.privatelink.<geo>.backup.windowsazure.com` | 443 |
| Azure Storage | `*.blob.core.windows.net` <br><br> `*.queue.core.windows.net` <br><br> `*.blob.storage.azure.net`  <br><br> `*.storage.azure.net` | 443 | 
| Microsoft Entra ID |`*.login.microsoft.com` <br><br> [Allow access to FQDNs under sections 56 and 59](/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide&preserve-view=true#microsoft-365-common-and-office-online). | 443 <br><br> As applicable |

In the above text, `<geo>` refers to the region code (for example, **eus** for East US and **ne** for North Europe). Refer to the following lists for regions codes:

- [All public clouds](https://download.microsoft.com/download/1/2/6/126a410b-0e06-45ed-b2df-84f353034fa1/AzureRegionCodesList.docx)
- [China](/azure/china/resources-developer-guide#check-endpoints-in-azure)
- [Germany](../germany/germany-developer-guide.md#endpoint-mapping)
- [US Gov](../azure-government/documentation-government-developer-guide.md)

To auto-update the MARS Agent allow access to `download.microsoft.com/download/MARSagent/*`.

For a Recovery Services vault with private endpoint setup, the name resolution for the FQDNs (`privatelink.<geo>.backup.windowsazure.com`, `*.blob.core.windows.net`, `*.queue.core.windows.net`, `*.blob.storage.azure.net`) should return a private IP address. This can be achieved by using:

- Azure Private DNS zones
- Custom DNS
- DNS entries in host files
- Conditional forwarders to Azure DNS or Azure Private DNS zones.

The private endpoints for blobs and queues follow a standard naming pattern, they start with **\<the name of the private endpoint>_ecs** or **\<the name of the private endpoint>_prot**, and are suffixed with **\_blob** and **\_queue** respectively.

>[!Note]
>We recommend using Azure Private DNS zones, which enables you to manage the DNS records for blobs and queues using Azure Backup. The managed identity assigned to the vault is used to automate the addition of DNS record whenever new storage account is allocated for backup data.

If you've configured a DNS proxy server, using  third-party proxy servers or firewalls, the above domain names must be allowed and redirected to a custom DNS (which has DNS records for the above FQDNs) or to 168.63.129.16 on Azure virtual network which has private DNS zones linked to it.

The following example shows Azure firewall used as DNS proxy to redirect the domain name queries for Recovery Services vault, blob, queues and Microsoft Entra ID to *168.63.129.16*.

:::image type="content" source="./media/private-endpoints-overview/azure-firewall-used-as-dns-proxy.png" alt-text="Diagram showing the use of Azure firewall as DNS proxy to redirect the domain name queries." lightbox="./media/private-endpoints-overview/azure-firewall-used-as-dns-proxy.png":::

For more information, see [Creating and using private endpoints](private-endpoints.md).

## Network connectivity setup for vault with private endpoints

The private endpoint for recovery services is associated with a network interface (NIC). For private endpoint connections to work, it's required that all traffic for the Azure service is redirected to the network interface. This is achieved by adding DNS mapping for private IP associated with the network interface against the *service/blob/queue* URL.

When workload backup extensions are installed on the virtual machine registered to a Recovery Services vault with a private endpoint, the extension attempts connection on the private URL of the Azure Backup services `<vault_id>.<azure_backup_svc>.privatelink.<geo>.backup.windowsazure.com`. If the private URL isn't resolving the issue, it tries the public URL `<azure_backup_svc>.<geo>.backup.windowsazure.com`.

In the above text, `<geo>` refers to the region code (for example, **eus** for East US and **ne** for North Europe). Refer to the following lists for regions codes:

- [All public clouds](https://download.microsoft.com/download/1/2/6/126a410b-0e06-45ed-b2df-84f353034fa1/AzureRegionCodesList.docx)
- [China](/azure/china/resources-developer-guide#check-endpoints-in-azure)
- [Germany](../germany/germany-developer-guide.md#endpoint-mapping)
- [US Gov](../azure-government/documentation-government-developer-guide.md)

These private URLs are specific for the vault. Only extensions and agents registered to the vault can communicate with Azure Backup over these endpoints. If the public network access for Recovery Services vault is configured to *Deny*, this restricts the clients that aren't running in the virtual network from requesting backup and restore on the vault. We recommend setting the public network access to *Deny*, along with private endpoint setup. As the extension and agent attempt the private URL initially, the  `*.privatelink.<geo>.backup.windowsazure.com` DNS resolution of the URL should return the corresponding private IP associated with the private endpoint.

The solutions for DNS resolution are:

- Azure Private DNS zones
- Custom DNS
- DNS entries in host files
- Conditional forwarders to Azure DNS / Azure Private DNS zones.

When the private endpoint for Recovery Services vaults is created via Azure portal with the **integrate with private DNS zone** option, the required DNS entries for private IP addresses for Azure Backup services (`*.privatelink.<geo>backup.windowsazure.com`) are created automatically whenever the resource is allocated. In other solutions, you need to create the DNS entries manually for these FQDNs in the custom DNS or in the host files.

For the manual management of DNS records after the VM discovery for communication channel - blob/queue, see [DNS records for blobs and queues (only for custom DNS servers/host files) after the first registration](./private-endpoints.md#dns-records-for-blobs-and-queues-only-for-custom-dns-servershost-files-after-the-first-registration). For the manual management of DNS records after the first backup for backup storage account blob, see [DNS records for blobs (only for custom DNS servers/host files) after the first backup](./private-endpoints.md#dns-records-for-blobs-only-for-custom-dns-servershost-files-after-the-first-backup).

The private IP addresses for the FQDNs can be found in the private endpoint blade for the private endpoint created for the Recovery Services vault.

The following diagram shows how the resolution works when using a private DNS zone to resolve these private service FQDNs.

:::image type="content" source="./media/private-endpoints-overview/use-private-dns-zone-to-resolve-modified-service-fqdns.png" alt-text="Diagram showing how the resolution works using a private DNS zone to resolve modified service FQDNs." lightbox="./media/private-endpoints-overview/use-private-dns-zone-to-resolve-modified-service-fqdns.png":::

The workload extension running on Azure VM requires connection to at least two storage accounts - the first one is used as communication channel (via queue messages) and second one for storing backup data. The MARS agent requires access to one storage account used for storing backup data.

For a private endpoint enabled vault, the Azure Backup service creates private endpoint for these storage accounts. This prevents any network traffic related to Azure Backup (control plane traffic to service and backup data to storage blob) from leaving the virtual network. In addition to Azure Backup cloud services, the workload extension and agent require connectivity to Azure Storage accounts and Microsoft Entra ID.

As a pre-requisite, Recovery Services vault requires permissions for creating additional private endpoints in the same Resource Group. We also recommend providing the Recovery Services vault the permissions to create DNS entries in the private DNS zones (`privatelink.blob.core.windows.net`, `privatelink.queue.core.windows.net`). Recovery Services vault searches for private DNS zones in the resource groups where the virtual network and private endpoint are created. If it has the permissions to add DNS entries in these zones, they'll be created by the vault; otherwise, you must create them manually.

> [!NOTE]
> Integration with private DNS zone present in different subscriptions is unsupported in this experience.

The following diagram shows how the name resolution works for storage accounts using a private DNS zone.

:::image type="content" source="./media/private-endpoints-overview/name-resolution-works-for-storage-accounts-using-private-dns-zone.png" alt-text="Diagram showing how the name resolution works for storage accounts using a private DNS zone." lightbox="./media/private-endpoints-overview/name-resolution-works-for-storage-accounts-using-private-dns-zone.png":::

## Related content

- [Create and use private endpoints](private-endpoints.md)
