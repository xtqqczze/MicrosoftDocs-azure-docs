---
title: Private Endpoint Setup for DPM/MABS in Azure Backup
description: Learn how to configure private endpoints for Azure Backup when using Data Protection Manager (DPM) or Microsoft Azure Backup Server (MABS) to back up on-premises data securely.
#customer intent: As a DPM/MABS user, I want to register my server with a Recovery Services vault using private endpoints so that I can back up on-premises data securely.
author: AbhishekMallick-MS
ms.author: v-mallicka
ms.reviewer: v-mallicka
ms.date: 11/27/2025
ms.topic: how-to
ms.service: azure-backup
---

# Configure private endpoint for DPM/MABS server in Azure Backup

This article describes how to configure private endpoints for Azure Backup when using Data Protection Manager (DPM) or Microsoft Azure Backup Server (MABS) to back up on-premises data securely.

Azure Backup allows you to back up and restore your data securely from your Recovery Services vaults using [private endpoints](../private-link/private-endpoint-overview.md). Private endpoints use one or more private IP addresses from your Azure Virtual Network (VNet), effectively bringing the service into your VNet.

This feature enables private endpoints for Azure Backup to maintain the security of your resources.

Azure Backup now provides an enhanced experience in creation and use of private endpoints compared to the [classic experience ](private-endpoints-overview.md)(v1).

[Learn more about the enhanced capabilities of private endpoints](backup-azure-private-endpoints-concept.md#key-enhancements) (v2 Experience).

## Considerations

Before you configure private endpoints for Azure Backup, ensure that you review the following considerations:

- A Recovery Services vault works with both Azure Backup and Azure Site Recovery. This article focuses on using private endpoints for Azure Backup only.
- Create private endpoints only for new Recovery Services vaults that have no registered or protected items.
- You can't upgrade vaults that include private endpoints created in the classic experience to the new experience. Delete all existing private endpoints and then create new ones using the v2 experience.
- A single virtual network can host private endpoints for multiple Recovery Services vaults. Likewise, one Recovery Services vault can have private endpoints across multiple virtual networks.
- A private endpoint for a vault uses up to 10 private IPs, which may vary by location. When you use private endpoints for Azure Backup or DPM, ensure you have 10 + n IPs available (where n equals the number of data sources protected on DPM or Azure Backup Server).
- DPM or MABS configured with a private endpoint can protect up to 80 data sources on a Recovery Services vault under the current configuration.
- Private endpoints for Azure Backup don't include access to Microsoft Entra ID. Enable outbound access for IPs and FQDNs required for Microsoft Entra ID in the secured network when you back up using the MARS agent. You can also use NSG tags and Azure Firewall tags to allow access to Microsoft Entra ID.
- If your Recovery Services vault uses a private endpoint, all backup data travels through a private IP in your Azure VNet. In this case, ExpressRoute Private Peering is required to carry backup traffic between on-premises and Azure.
- You can create DNS across subscriptions.

## Difference in network connections for private endpoints

Private endpoints are essential when you back up workloads in DPM or MABS using the MARS agent. Irrespective of the private endpoint configuration, MARS agent connects to Microsoft Entra ID through the FQDNs listed in sections 56 and 59 in [Microsoft 365 Common and Office Online](/office365/enterprise/urls-and-ip-address-ranges#microsoft-365-common-and-office-online).

When MARS agent is installed for Recovery Services vault with private endpoint, the following endpoints are communicated:

| Service    | Domain  names                             | Ports|
| -------------- | ------------------------------------------------------------ | --- |
| Azure  Backup  | `*.privatelink.<geo>.backup.windowsazure.com`                             | 443 |
| Azure  Storage | `*.blob.core.windows.net` <br><br> `*.queue.core.windows.net` <br><br> `*.blob.storage.azure.net` | 443 |
| Microsoft Entra ID      | `*.login.microsoft.com` <br><br> Allow  access to FQDNs under sections 56 and 59 according to [this article](/office365/enterprise/urls-and-ip-address-ranges#microsoft-365-common-and-office-online) | 443 <br><br> As applicable |

 In the domain name, `\<geo\>` refers to the region code (for example, **eus** for East US and **ne** for North Europe). Learn about the supported geography for the following regions:

- [**All public clouds**](https://download.microsoft.com/download/1/2/6/126a410b-0e06-45ed-b2df-84f353034fa1/AzureRegionCodesList.docx)

- [**China**](/azure/china/resources-developer-guide#check-endpoints-in-azure)

- [**Germany**](/azure/germany/germany-developer-guide#endpoint-mapping)

- [**US Gov**](/azure/azure-government/documentation-government-developer-guide)

For a Recovery Services vault with private endpoint setup, the name resolution for the FQDNs (privatelink.\<geo\>.backup.windowsazure.com, \*.blob.core.windows.net, \*.queue.core.windows.net, \*.blob.storage.azure.net) should fetch a private IP address. You can fetch the IP address using the following parameters:

- Azure Private DNS zones
- Custom DNS
- DNS entries in host files
- Conditional forwarders to Azure DNS / Azure Private DNS zones.

## Create a Recovery Service vault and disable public access to the vault

To create a Recovery Services vault with private endpoints and disable the public access, follow these steps:

1. [Create a vault in the resource group same as the datasource you want to back up](backup-create-recovery-services-vault.md#create-a-recovery-services-vault).

   :::image type="content" source="media/private-endpoint-vault-backup-server/create-vault.png" alt-text="Screenshot shows Recovery Services vault creation interface in Azure portal.":::

1. After the vault creates successfully, go to the **vault** > **Networking**.

1. To prevent access from public networks, on the **Networking** pane, on the **Public access** tab, select **Deny**.

   :::image type="content" source="media/private-endpoint-vault-backup-server/public-access-deny.png" alt-text="Screenshot shows how to deny public access to a vault.":::

## Create private endpoints for Azure Backup

To create private endpoints for Azure Backup, follow these steps:

1. Go to the **Recovery Services vault** where you have disabled public access > **Networking** > **Private access**, and then select **+ Private endpoint**.

1. On the **Create a private endpoint** pane, specify the required details for creating your private endpoint connection by following these steps.

    1. On the **Basics** tab, enter the basic details for your private endpoints. The region should be the same as the vault and the resource for backup.

      :::image type="content" source="media/private-endpoint-vault-backup-server/basic-private-endpoint-configuration.png" alt-text="Screenshot shows the private endpoint basics configuration page.":::

   1. On the **Resource** tab, select the PaaS resource for which you want to create your connection, **Resource type** as `Microsoft.RecoveryServices/vaults` . Then, choose the name of your Recovery Services vault as the **Resource** and **AzureBackup** as the **Target sub-resource**.

      :::image type="content" source="media/private-endpoint-vault-backup-server/private-endpoint-resource-details.png" alt-text="Screenshot shows the private endpoint resource selection configuration." lightbox="media/private-endpoint-vault-backup-server/private-endpoint-resource-details.png":::

   1. On the **Virtual Network** tab, specify the virtual network and subnet where you want the private endpoint to be created ( the Vnet where the VM is located).

      :::image type="content" source="media/private-endpoint-vault-backup-server/private-endpoint-virtual-network-configuration.png" alt-text="Screenshot shows the private endpoint configuration settings for virtual network and subnet.":::

   1. On the **DNS** tab, configure a DNS record to connect privately through your private endpoint. We recommend integrating the private endpoint with a private DNS zone. Alternatively, you can use your own DNS servers or create DNS records in the host files on your virtual machines.

      The following screenshot shows that the private endpoint is integrated with Private DNS Zone.

      :::image type="content" source="media/private-endpoint-vault-backup-server/private-endpoint-dns-configuration.png" alt-text="Screenshot shows the DNS configuration settings for private endpoint integration." lightbox="media/private-endpoint-vault-backup-server/private-endpoint-dns-configuration.png":::

   1. (Optional)On the **Tags** tab, add tags for your private endpoint.

   1. On the **Review + create** tab, review your settings. When the validation completes, select **Create** to create the private endpoint.

## Approve private endpoints for the Recovery Services vault

Private endpoints are auto-approved when created by the vault owner. If you're not the owner, private endpoints require manual approval in the Azure portal.

This section describes the manual approval process of private endpoints through the Azure portal.

 The following screenshot shows that the owner created the private endpoint, so it's auto-approved.

:::image type="content" source="media/private-endpoint-vault-backup-server/private-endpoint-approval-status.png" alt-text="Screenshot shows the private endpoint approval status in Azure portal." lightbox="media/private-endpoint-vault-backup-server/private-endpoint-approval-status.png":::

To manually approve private endpoints via the Azure portal, follow these steps:

1. On the **Recovery Services vault** with private endpoint created, go to **Settings** > **Networking**.

1. On the **Networking** pane, select **Private access** > the **private endpoint connection** from the list that you want to approve.

1. Select **Approve**.

## Manage DNS records for private endpoints

Private connectivity requires DNS records in private DNS zones or servers. You can integrate the private endpoint to Azure private DNS zones or configure custom DNS servers, depending on your network design.  This configuration is required for all three services - Azure Backup, Azure Blobs, and Queues.

### Integrate private endpoints with Azure private DNS zones

If you choose to integrate your private endpoint with private DNS zones, Azure Backup adds the required DNS records. You can view the private DNS zones that's used under **DNS configuration** of the private endpoint. If these DNS zones aren't present, they're created automatically when creating the private endpoint.

However, you must verify that your virtual network (which contains the resources to be backed up) is properly linked with all three private DNS zones.

:::image type="content" source="media/private-endpoint-vault-backup-server/virtual-network-links.png" alt-text="Screenshot shows the DNS configuration details for private endpoint zones." lightbox="media/private-endpoint-vault-backup-server/virtual-network-links.png":::

If you're using proxy servers, you can bypass the proxy server or perform your backups through the proxy server. To bypass a proxy server, continue to the following sections. To use the proxy server for performing your backups, see [proxy server setup details for Recovery Services vault](../backup/private-endpoints.md#set-up-proxy-server-for-recovery-services-vault-with-private-endpoint).

To validate and  integrate virtual network links for the preceding  **private DNS** zone  (for Backup, Blobs and Queues), follow these steps:

1. On the **Recovery Services vault** where you have configured private endpoints, go to **Networking** > **Private access**, and then select the private endpoint from the list.

1. On the selected **private endpoint** pane, select **Settings** > **DNS configuration**.

1. On the **DNS configuration** pane, select the **Private DNS zone** link.

1. On the selected **private DNS zone** pane, select **Virtual Network Links**

1. On the selected **virtual network link** pane, select **Virtual Network Links**

   A virtual network link entry appears for which you've created the private endpoint. The following screenshot shows an example of virtual network links for all three DNS zones.

   :::image type="content" source="media/private-endpoint-vault-backup-server/virtual-network-links-domain-name-server-zones.png" alt-text="Screenshot shows the virtual network links configuration in private DNS zones." lightbox="media/private-endpoint-vault-backup-server/virtual-network-links-domain-name-server-zones.png":::

1. If no entry appears, select **+ Add** and link the virtual network to the required DNS zones.

   The following screenshot shows the **Add virtual network link** pane for linking the virtual network to the DNS zone.

   :::image type="content" source="media/private-endpoint-vault-backup-server/image11.png" alt-text="Screenshot of adding virtual network links to DNS zones configuration.":::

### Configure custom DNS servers or host files

- If you're using a custom DNS server, you can use conditional forwarder for backup service, blob, and queue FQDNs to redirect the DNS requests to Azure DNS (168.63.129.16). Azure DNS redirects it to Azure Private DNS zone. In such setup, ensure that a virtual network link for Azure Private DNS zone exists as mentioned in [this article](/azure/backup/private-endpoints#when-using-custom-dns-server-or-host-files).

The following table lists the Azure Private DNS zones required by Azure Backup:

| Service | Zone name |
|---------|-----------|
| Azure Backup | privatelink.\<geo\>.backup.windowsazure.com |
| Azure Blobs | privatelink.blob.core.windows.net |
| Azure Queues | privatelink.queue.core.windows.net |

 In the zone name, `\<geo\>` refers to the region code (for example, **eus** for East US and **ne** for North Europe). Learn about the supported geography for the following regions:

- [**All public clouds**](https://download.microsoft.com/download/1/2/6/126a410b-0e06-45ed-b2df-84f353034fa1/AzureRegionCodesList.docx)

- [**China**](/azure/china/resources-developer-guide#check-endpoints-in-azure)

- [**Germany**](/azure/germany/germany-developer-guide#endpoint-mapping)

- [**US Gov**](/azure/azure-government/documentation-government-developer-guide)

- [**Geo-code list - sample XML**](./scripts/geo-code-list.md)

- If you're using custom DNS servers or host files and don't have the Azure Private DNS zone setup, add the DNS records required by the private endpoints to your DNS servers or in the host file.

> Navigate to the private endpoint you created, and then go to **DNS configuration**. Then add an entry for each FQDN and IP displayed as *Type A* records in your DNS.
>
> If you're using a host file for name resolution, make corresponding entries in the host file for each IP and FQDN according to the format - \<private ip\>\<space\>\<FQDN\>.

> [!NOTE]
> Azure Backup will allocate new storage account for your vault for the backup data, and MARS agent needs to access the respective endpoints. For more about how to add more DNS records after registration and backup, see [**how to use private endpoints for backup**](/azure/backup/backup-azure-private-endpoints-configure-manage#use-private-endpoints-for-backup).

## Back up on-premises resources using DPM/MABS with private endpoints

When using the MARS Agent to back up you're on-premises resources, make sure your on-premises network (containing your resources to be backed up) is peered with the Azure VNet that contains a private endpoint for the vault, so you can use it. You can then continue to install the MARS agent and configure backup as detailed here. However, you must ensure all communication for backup happens through the peered network only.

1. Register your DPM\MABS Server to the vault created with private endpoints

:::image type="content" source="media/private-endpoint-vault-backup-server/image13.jpeg" alt-text="Screenshot of DPM/MABS server registration to vault with private endpoints.":::

1. Enabled backup on DPM\MABS Server for disk and online

:::image type="content" source="media/private-endpoint-vault-backup-server/image14.jpeg" alt-text="Screenshot of backup configuration on DPM/MABS server for disk and online protection.":::

1. Please wait for the Initial Replica to complete.

1. You can wait for the online backup schedule to kick in or manually run online backups for data sources.

:::image type="content" source="media/private-endpoint-vault-backup-server/image15.jpeg" alt-text="Screenshot of online backup schedule and manual backup options for data sources.":::

1. Please wait for the online backup to also complete.

:::image type="content" source="media/private-endpoint-vault-backup-server/image16.jpeg" alt-text="Screenshot of online backup completion status and progress information.":::

1. Check on Azure Portal and you will be storage account (Blob) getting created for each data sources you protected on DPM\MABS Server.

:::image type="content" source="media/private-endpoint-vault-backup-server/image17.png" alt-text="Screenshot of storage accounts created in Azure portal for protected data sources.":::

So, the DPM\MABS Server can connect to the vault using Private Endpoints and backups are working as well.

## Delete private endpoints

After you remove private endpoints from the vault, re-register DPM/MABS with the vault. You don’t need to stop protection.

To delete the private endpoint from Recovery Service vault, follow these steps:

1. Go to the vault you created, and then select **Settings** > **Networking** > **Private access**.

1. To stop using the private endpoint, select the **private endpoint** from the list, and then select **Reject** > **Yes**.

   After you confirm rejection, the vault starts rejecting private endpoint connections. Wait for the operation to complete. Once the operation completes the private endpoint **Connection Status** changes to **Rejected**.

   :::image type="content" source="media/private-endpoint-vault-backup-server/image18.png" alt-text="Screenshot of private endpoint connection status showing rejected state.":::

1. To confirm the deletion for the private endpoint, select the **private endpoint** > **Delete** > **Yes** .

   :::image type="content" source="media/private-endpoint-vault-backup-server/image19.png" alt-text="Screenshot of private endpoint deletion confirmation dialog box.":::

1. After the private endpoint deletion is complete, go to the **Vault** > **Settings** > **Networking** > **Public access**, and then select **Allow from all network and select apply**.

   :::image type="content" source="media/private-endpoint-vault-backup-server/image20.png" alt-text="Screenshot of vault public access settings with allow from all networks option.":::

## Re-register the DPM\MABS Server with vault

After you delete the private endpoints from the vault, download a new Credential File from the Azure portal for that vault.

To re-register the DPM\MABS Server with the vault, follow these steps:

1. Sign in to the **DPM**\ **MABS** Server, and then select **Management** > **Online** > **Register**.

1. On the **Register Server Wizard**, follow the onscreen instruction and provide the **same passphrase**that was used initially to register DPM\MABS Server on the **Encryption Setting** pane.

1. Select **Register** and wait for the registration process to complete.

:::image type="content" source="media/private-endpoint-vault-backup-server/image21.png" alt-text="Screenshot of DPM/MABS server re-registration process and encryption settings.":::

1. Please check the online recovery point and make sure it is visible on Recovery tab

:::image type="content" source="media/private-endpoint-vault-backup-server/image22.jpeg" alt-text="Screenshot of online recovery points visibility verification in Recovery tab.":::

1. I even tried to perform the online recovery to make sure we can recover the data from the vault successfully or not. **The online recovery was successful**

:::image type="content" source="media/private-endpoint-vault-backup-server/image23.jpeg" alt-text="Screenshot of successful online recovery process completion status.":::

1. Manually created local backup for the data sources on DPM\MABS Server.

1. Triggered the online backup for the data sources which was also getting successful without any errors.

:::image type="content" source="media/private-endpoint-vault-backup-server/image24.jpeg" alt-text="Screenshot of successful online backup completion for data sources without errors.":::
