---
title: Manage Change Tracking and Inventory in Azure using Azure Monitoring Agent
description: Learn how to use Change Tracking and Inventory to track software and Microsoft service changes in your environment using Azure Monitoring Agent.
services: automation
ms.custom: linux-related-content
ms.date: 10/27/2025
ms.topic: how-to
ms.service: azure-change-tracking-inventory
ms.author: v-jasmineme
author: jasminemehndir
---

# Manage Change Tracking and Inventory with Azure Monitoring Agent

**Applies to:** :heavy_check_mark: Windows VMs :heavy_check_mark: Linux VMs :heavy_check_mark: Windows Registry :heavy_check_mark: Windows Files :heavy_check_mark: Linux Files :heavy_check_mark: Windows Software

This article describes how to manage change tracking and inventory with AMA.

## Disable Change Tracking from a virtual machine 

To remove change tracking with Azure Monitoring Agent from a virtual machine, follow these steps:

### Disassociate Data Collection Rule (DCR) from a VM

To disassociate DCR from a VM, follow these steps:

1. Sign in to [Azure portal](https://portal.azure.com), select **Virtual Machines** and in the search bar, select the specific Virtual Machine. 
1. On the **Virtual Machine** pane, under **Operations**, select **Change tracking**. Alternatively, in the search bar, enter **Change tracking** and select it from the results.
1. Select **Settings** > **DCR** to view all the virtual machines associated with the DCR.
1. Select the specific VM for which you want to disable the DCR.
1. Select **Delete**.

   :::image type="content" source="media/manage-azure-change-tracking-monitoring-agent/disable-data-collection-rule-inline.png" alt-text="Screenshot of selecting a VM to dissociate the DCR from the VM." lightbox="media/manage-azure-change-tracking-monitoring-agent/disable-data-collection-rule-expanded.png":::

   A notification appears to confirm the disassociation of the DCR for the selected VM.

### Uninstall change tracking extension

To uninstall change tracking extension, follow these steps:

1. Sign in to [Azure portal](https://portal.azure.com), select **Virtual Machines** and in the search bar, select the specific VM for which you have already disassociated the DCR.
1. On the **Virtual Machines** pane, under **Settings**, select **Extensions + applications**.
1. On the **VM |Extensions + applications** pane, under **Extensions** tab, select **MicrosoftAzureChangeTrackingAndInventoryChangeTracking-Windows/Linux**.

   :::image type="content" source="media/manage-azure-change-tracking-monitoring-agent/uninstall-extensions-inline.png" alt-text="Screenshot of selecting the extension for a VM that is already disassociated from the DCR." lightbox="media/manage-azure-change-tracking-monitoring-agent/uninstall-extensions-expanded.png":::

1. Select **Uninstall**.

## Next steps

* To learn about alerts, see [Configure alerts](../automation/change-tracking/configure-alerts.md).
