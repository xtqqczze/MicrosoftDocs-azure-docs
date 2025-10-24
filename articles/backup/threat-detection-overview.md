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

Azure Backup integrates with Microsoft Defender for Cloud to offer advanced threat detection for Azure VM backups. This feature allows you assess the health of backup restore points by identifying potentially malicious or ransomware-infected backups.

With security signals from Microsoft Defender for Servers, Azure Backup detects compromise indicators such as disruption patterns, behavioral anomalies, and ransomware signatures. Azure Backup also uses Defender scans the source VM and validates restore point health during snapshot creation.




**Availability:**

This feature is available in public preview in limited regions: West Central US, Australia East, North Europe.

For any queries or additional information, you can reach out to product group on AskAzureBackupTeam@microsoft.com



**Customer Value Proposition:**

- **Proactive threat identification:** Configure threat detection at the vault level to automatically identify compromised restore points across all VM backups in the vault, enhancing recovery confidence.

- **Faster recovery:** Reduce time to recover by quickly identifying clean restore points suitable for ransomware recovery.

- **Seamless integration:** Works natively with Microsoft Defender for Servers Plan 1 and Plan 2, ensuring a unified and consistent security experience across Azure workloads.

**Known Constraints:**

- **Re-registration to Multiple Vaults:** When a virtual machine is registered to backup multiple vaults, the Threat Detection blade in Azure Resiliency may display only one vault name. The source-side scan status and summary will show aggregated values across all protected items.

- **Update for Active Ransomware Alerts**: After enabling threat detection, if the VM has any active ransomware alerts, it may take up to 48 hours for the backup scan summary to correctly update and reflect as “Suspicious.”

- **MDC Pricing Disabled for VM or Subscription:** If MDC pricing is disabled for a virtual machine or subscription, the protected item will move to a Configuration Failed state. Subsequent backups will appear in an Unknown (-) state, and the source scan summary for the protected item will also show as Unknown.

States of source scan

