---
title: About Threat Detection for Azure VM Backups
description: Learn about threat detection for Azure VM backups, a feature that helps identify ransomware-infected restore points using Microsoft Defender for Cloud.
#customer intent: As an IT admin, I want to enable threat detection for Azure VM backups so that I can identify and mitigate ransomware threats in restore points.
author: AbhishekMallick-MS
ms.author: v-mallicka
ms.reviewer: v-mallicka
ms.date: 10/24/2025
ms.topic: tutorial
ms.service: azure-backup
---

# About Threat Detection for Azure VM Backups (preview)

Azure Backup integrates with Microsoft Defender for Cloud (MDC) to offer advanced threat detection for Azure Virtual Machine (VM) backups. This feature allows you to assess the health of backup restore points by identifying potentially malicious or ransomware-infected backups.

With security signals from Microsoft Defender for Servers, Azure Backup detects compromise indicators such as disruption patterns, behavioral anomalies, and ransomware signatures. Azure Backup also uses Defender scans the source VM and validates restore point health during snapshot creation.

## Key benefits of Threat Detection for Azure VM Backups

Threat detection for Azure VM backups includes the following benefits:

- **Proactive threat identification:** Threat detection Configuration at the vault level automatically identifies compromised restore points across all VM backups in the vault, which enhances recovery confidence.

- **Faster recovery:** Reduce time to recover by quickly identifying clean restore points suitable for ransomware recovery.

- **Seamless integration:** Works natively with [Microsoft Defender for Servers Plan 1 and Plan 2](/azure/defender-for-cloud/defender-for-servers-overview#plan-protection-features), ensuring a unified and consistent security experience across Azure workloads.

## Supported regions for Threat Detection for Azure VM Backups

This feature is available in public preview in limited regions: West Central US, Australia East, North Europe.

## Limitations and known issues

This preview feature has the following limitations and known issues:

- **Re-registration to Multiple Vaults**: When a virtual machine is registered to backup multiple vaults, the threat detection feature currently shows only one vault. However, the source-side scan status and summary show aggregated values across all protected items.

- **Update for Active Ransomware Alerts**: After the threat detection is enabled, if the VM has any active ransomware alerts, the backup scan summary might take up to 48 hours to correctly update and reflect as **Suspicious**.

- **MDC Pricing Disabled for VM or Subscription:** When MDC pricing is disabled for a virtual machine or subscription, the protected item status changes to **Configuration Failed**. Subsequent backups appear in an **Unknown (-)** state, and the source scan summary for the protected item appears as **Unknown**.

## Next steps

[Enable Threat Detection and monitor health of Azure VM Backups](threat-detection-configure-monitor-tutorial.md).

