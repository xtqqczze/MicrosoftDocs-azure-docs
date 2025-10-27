---
title: Tutorial - Enable Threat Detection and monitor health of Azure VM Backups
description: Learn how to enable threat detection for Azure VM backups using Azure Backup integrated with Microsoft Defender for Cloud, configure settings, and monitor backup restore point health.
ms.service: azure-backup
ms.date: 10/24/2025
ms.topic: tutorial
author: AbhishekMallick-MS
ms.author: v-mallicka
ms.reviewer: v-mallicka
#customer intent: As an IT admin, I want to enable threat detection for Azure VM backups so that I can identify and mitigate ransomware threats in restore points.

---

# Tutorial: Enable Threat Detection and monitor health of Azure VM Backups

This tutorial describes how to enable threat detection for Azure VM backups using Azure Backup integrated with Microsoft Defender for Cloud, configure settings, and monitor backup restore point health.

Azure Backup now leverages Microsoft Defender for Cloud to provide threat detection for Azure VM backups. By integrating security signals and malware scans from Defender for Servers, Azure Backup automatically assesses the health of restore points during backup creation. This helps you quickly identify and respond to suspicious or ransomware-infected backups, ensuring safer recovery options for your VMs. 

[Learn about Azure Backup threat detection features and supported scenarios](threat-detection-overview.md).

## Prerequisites

Before you enable threat detection for Azure VM backups, ensure the following prerequisites are met:

- Enable Microsoft Defender for Servers Plan 1 or Plan 2 on your Azure subscription. For Plan 1, enable Microsoft Defender for Endpoint (MDE) on virtual machines and verify correct configuration on the source VM; otherwise, backups may be incorrectly tagged.
- Enable bi-directional alert synchronization in Microsoft Sentinel to accurately identify backup recovery points.
- Mark alerts as resolved in Microsoft Defender for Cloud when using any third-party incident management solution alongside Defender.


## Enable threat detection for Azure VM backups

You can configure source-scan at-scale at the vault level, which allows Azure Backup to performn Malware scans using Microsoft Defender at the source virtual machine, and Azure Backup assesses the health of recovery points when snapshots are taken.

You can enable threat detection for Azure VM backups using one of the methods - Resiliency or Vault properties.

>[!Important]
>With the required Microsoft Defender for Cloud (MDC) plans, you can enable source-scan integration. This feature can't be disabled.


### Option 1: Configure threat detection using Resiliency


To enable threat detection for Azure VM backups, follow these steps:

1. In the [Azure portal](https://portal.azure.com/), go to **Resiliency**.

1. On the ** Backup and Disaster Recovery overview** pane,  select **Threat detection**.

1. On the **Threat detection** pane, select **+ Configure scan** to start configuring source-scan integration.

   


> :::image type="content" source="media/threat-detection/image1.png" alt-text="A screenshot of a chat AI-generated content may be incorrect.":::

5.  Select the subscription where you want to enable this source-scan integration.

6.  If the selected subscription has the required Defender for Servers plan enabled, you can proceed to select the vaults.

7.  Select the vaults which contains the protected Items (VM backups) where you want to enable integration with MDC.

8.  Select “Configure Scan” and threat detection will be enabled for the vaults in the preview regions where the feature is available.

9.  All the new RPs created for the VM backups in the vault will start getting the scan status configured.

### Option 2: Configure threat detection from vault properties

To enable threat detection for Azure VM backups from the Recovery Services Vault properties, follow these steps:

1. Go to the **Recovery Services vault**, and then select **Properties**.
1. On the **Properties** pane, under **Security Settings** > **Threat detection (Preview)**, select **Update**.

:::image type="content" source="./media/threat-detection-configure-monitor-tutorial/enable-threat-detection-vault.png" alt-text="Screenshot shows the enable threat detection option in the vault properties." lightbox"./media/threat-detection-configure-monitor-tutorial/enable-threat-detection-vault.png":::

1. On the **Threat Detection (Preview)** pane, turn on **Enable source-scan integration**, accept the terms by selecting the checkbox.
1. Select **Update**.

**View Health of RPs:**

1.  Open Azure Portal and navigate to Azure Resiliency.

2.  Under Overview, navigate to threat detection tile to view summary of the RP health.

3.  Go to Threat detection blade and click on the backup item to view the “Scan status” and “Scan summary”. Scan summary is aggregated value based on the scan status of the RPs created in the last 7 days.

:::image type="content" source="media/threat-detection/image3.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

4.  For RPs with “Suspicious” health status, click on the “Protected Item” and select “Suspicious” status hyper link and view the scan details.

:::image type="content" source="media/threat-detection/image4.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

5.  You can see the alerts that led to tagging this RP as suspicious. Select the alert and navigate to MDC to remediate and take action. You can stop backups or increase security level of backups by enabling immutability or MUA.

:::image type="content" source="media/threat-detection/image5.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

6.  After resolving all alerts and marking them as “resolved” in MDC, backup items will be marked as “No Threats Reported”.


You can also view the scan status of each recovery point during Azure VM restore, which helps you to select the appropriate restore point for ransomware recovery.

:::image type="content" source="media/threat-detection/image6.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::
