---
title: Enable Threat Detection for Azure VM Backups
description: Enable proactive threat detection for Azure VM backups with Azure Backup and Microsoft Defender for Cloud. Follow this guide to secure your restore points.
#customer intent: As an IT admin, I want to enable threat detection for Azure VM backups so that I can identify and mitigate ransomware threats in restore points.
author: AbhishekMallick-MS
ms.author: v-mallicka
ms.reviewer: v-mallicka
ms.date: 10/24/2025
ms.topic: tutorial
ms.service: azure-backup
---

# Tutorial:

Azure Backup is now integrated with Microsoft Defender for Cloud to provide advanced threat detection for Azure VM backups. This capability allows customers to assess the health of their backup restore points (RPs) by distinguishing potentially malicious or ransomware-infected backups from healthy ones.

By leveraging security signals from Microsoft Defender for Servers, Azure Backup can detect indicators of compromise such as disruption patterns, behavioural anomalies, and malware or ransomware signatures. Malware scans are performed by Defender on the source virtual machine, and Azure Backup determines the health of the restore points based on these signals at the time of taking the backup snapshot.

**Availability:**

This feature is available in public preview in limited regions: West Central US, Australia East, North Europe.

For any queries or additional information, you can reach out to product group on AskAzureBackupTeam@microsoft.com

**Prerequisites**:

- **Defender for Servers**: You must have Microsoft Defender for Servers Plan 1 or Plan 2 enabled on your subscription.

  - If you are using Plan 1, Microsoft Defender for Endpoint (MDE) must also be enabled on your virtual machines. You must ensure that MDE is set up correctly on the source virtual machine, if not backups may be incorrectly tagged.

- **Sentinel Integration**: If you are using Microsoft Sentinel for incident management, ensure that bi-directional alert synchronization is enabled so backup recovery points can be accurately identified.

- **Third-Party Incident Management Tools**: If you are using any third-party incident management solution alongside Defender, make sure that alerts are also marked as resolved within the Microsoft Defender for Cloud portal.

**Customer Value Proposition:**

- **Proactive threat identification:** Configure threat detection at the vault level to automatically identify compromised restore points across all VM backups in the vault, enhancing recovery confidence.

- **Faster recovery:** Reduce time to recover by quickly identifying clean restore points suitable for ransomware recovery.

- **Seamless integration:** Works natively with Microsoft Defender for Servers Plan 1 and Plan 2, ensuring a unified and consistent security experience across Azure workloads.

**Known Constraints:**

- **Re-registration to Multiple Vaults:** When a virtual machine is registered to backup multiple vaults, the Threat Detection blade in Azure Resiliency may display only one vault name. The source-side scan status and summary will show aggregated values across all protected items.

- **Update for Active Ransomware Alerts**: After enabling threat detection, if the VM has any active ransomware alerts, it may take up to 48 hours for the backup scan summary to correctly update and reflect as “Suspicious.”

- **MDC Pricing Disabled for VM or Subscription:** If MDC pricing is disabled for a virtual machine or subscription, the protected item will move to a Configuration Failed state. Subsequent backups will appear in an Unknown (-) state, and the source scan summary for the protected item will also show as Unknown.

States of source scan

# How-to guide:

Azure Backup is now integrated with Microsoft Defender for Cloud to provide advanced threat detection for Azure VM backups. This capability allows customers to assess the health of their backup restore points (RPs) by distinguishing potentially malicious or ransomware-infected backups from healthy ones.

By leveraging security signals from Microsoft Defender for Servers, Azure Backup can detect indicators of compromise such as disruption patterns, behavioural anomalies, and malware or ransomware signatures. Malware scans are performed by Defender on the source virtual machine, and Azure Backup determines the health of the restore points based on these signals at the time of taking the backup snapshot.

**Availability:**

This feature is available in public preview in limited regions: West Central US, Australia East, North Europe.

**Enable threat detection for Azure VM backups from Azure Resiliency:**

1.  Open Azure Portal and navigate to Azure Resiliency.

2.  Under Backup and Disaster Recovery overview, you can see a new section for threat detection.

3.  You can select the threat detection blade to configure source-scan at-scale at the vault level. The malware scans are performed by defender at the source virtual machine and Azure Backup identifies the health of recovery points at the time of taking a snapshot.

4.  Select “+ Configure Scan” to start configuring source-scan integration.

> :::image type="content" source="media/threat-detection/image1.png" alt-text="A screenshot of a chat AI-generated content may be incorrect.":::

5.  Select the subscription where you want to enable this source-scan integration.

6.  If the selected subscription has the required Defender for Servers plan enabled, you can proceed to select the vaults.

7.  Select the vaults which contains the protected Items (VM backups) where you want to enable integration with MDC.

8.  Select “Configure Scan” and threat detection will be enabled for the vaults in the preview regions where the feature is available.

9.  All the new RPs created for the VM backups in the vault will start getting the scan status configured.

**Enable threat detection from vault properties:**

1.  Navigate to “Properties” under Recovery Services Vault settings.

:::image type="content" source="media/threat-detection/image2.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

2.  Navigate to “Threat detection” under security settings

3.  If you have the required MDC plans, you can enable source-scan integration, and the feature is currently irreversible.

4.  Select Update and threat detection will be enabled.

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

**Restoring a VM:**

At the time of restore, you will also be able to view the scan status of each RP which will help you in selecting the appropriate restore point for ransomware recovery.

:::image type="content" source="media/threat-detection/image6.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::
