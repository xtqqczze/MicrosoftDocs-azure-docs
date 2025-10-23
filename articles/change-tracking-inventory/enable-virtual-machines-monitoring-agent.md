---
title: Enable Azure Change Tracking for single machine and multiple machines from the portal
description: Learn how to enable the Change Tracking feature for single machine and multiple machines at scale from the Azure portal.
services: automation
ms.date: 10/23/2025
ms.topic: how-to
ms.service: azure-change-tracking-inventory
ms.author: v-jasmineme
author: jasminemehndir
ms.custom: sfi-image-nochange
---

# Enable Change Tracking and Inventory from Azure portal

To enable Azure Change Tracking and Inventory from the Azure portal, see the Quickstart article [Quickstart: Enable Azure Change Tracking and Inventory](/azure/change-tracking-inventory/quickstart-monitor-changes-collect-inventory-azure-change-tracking-inventory?branch=pr-en-us-307064).

## Create data collection rule

To know what data is collected from VMs, create a Data Collection Rule (DCR).

To create a DCR, follow these steps:

1. Download [CtDcrCreation.json](../automation/change-tracking/change-tracking-data-collection-rule-creation.md) file on your machine.
1. Go to Azure portal and in the search, enter *Deploy a custom template*.
1. In the **Custom deployment** pane > **select a template**, select **Build your own template in the editor**.
   :::image type="content" source="media/enable-virtual-machines-monitoring-agent/build-template.png" alt-text="Screenshot to get started with building a template.":::
1. In the **Edit template**, select **Load file** to upload the *CtDcrCreation.json* file.
1. Select **Save**.
1. In the **Custom deployment** > **Basics** tab, provide **Subscription** and **Resource group** where you want to deploy the Data Collection Rule. The **Data Collection Rule Name** is optional. The resource group must be same as the resource group associated with the Log Analytic workspace ID chosen here.

   :::image type="content" source="media/enable-virtual-machines-monitoring-agent/build-template-basics.png" alt-text="Screenshot to provide subscription and resource group details to deploy data collection rule.":::
   
   >[!NOTE]
   >- Ensure that the name of your Data Collection Rule is unique in that resource group, else the deployment will overwrite the existing Data Collection Rule.
   >- The Log Analytics Workspace Resource ID specifies the Azure resource ID of the Log Analytics workspace used to store change tracking data. Ensure that location of workspace is from the [Change tracking supported regions](../automation/how-to/region-mappings.md)

1. Select **Review+create** > **Create** to initiate the deployment of *CtDcrCreation*.
1. After the deployment is complete, select **CtDcr-Deployment** to see the DCR Name. Use the **Resource ID** of the newly created Data Collection Rule for Change tracking and inventory deployment through policy.
 
   :::image type="content" source="media/enable-virtual-machines-monitoring-agent/deployment-confirmation.png" alt-text="Screenshot of deployment notification.":::

> [!NOTE]
> After creating the Data Collection Rule (DCR) using the Azure Monitoring Agent's change tracking schema, ensure that you don't add any Data Sources to this rule. This can cause Change Tracking and Inventory to fail. You must only add new Resources in this section.

## Next steps

- For details of working with the feature, see [Manage Change Tracking and Inventory](../change-tracking-inventory/manage-change-tracking-monitoring-agent.md).
- To troubleshoot general problems with the feature, see [Troubleshoot Change Tracking and Inventory issues](../automation/troubleshoot/change-tracking.md).
