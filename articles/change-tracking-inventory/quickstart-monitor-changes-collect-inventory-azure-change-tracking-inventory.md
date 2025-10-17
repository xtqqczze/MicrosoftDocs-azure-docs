---
title: Quickstart - Enable Azure Change Tracking and Inventory
description: In this quickstart, learn how to enable Azure Change Tracking and Inventory.
services: automation
ms.date: 10/17/2025
ms.topic: quickstart
#Customer intent: As a customer, I want to enable Azure Change Tracking and Inventory so that I can further use the CTI services.
ms.service: azure-change-tracking-inventory
ms.author: v-jasmineme
author: jasminemehndir
---

# Quickstart: Monitor changes and collect inventory using Azure Change Tracking and Inventory

Azure Change Tracking and Inventory (CTI) service enables the auditing and governance for in-guest operations by monitoring changes and collecting detailed inventory logs for servers across Azure, on-premises, and other cloud environments.

This quickstart guides you on how to enable Azure CTI service.

## Enable Change Tracking and Inventory

Enable Azure CTI [for multiple VMs using Azure portal and Azure CLI](../automation/change-tracking/enable-vms-monitoring-agent?tabs=singlevm%2Cmultiplevms&pivots=multiple-portal-cli#enable-change-tracking-and-inventory-for-multiple-vms-using-azure-portal-and-azure-cli).

You can enable Azure CTI in the following ways:

- Manually for non-Azure Arc-enabled machines, Refer to the Initiative *Enable Change Tracking and Inventory for Arc-enabled virtual machines* in **Policy > Definitions > Select Category = ChangeTrackingAndInventory**. To enable Change Tracking and Inventory at scale, use the **DINE Policy** based solution. For more information, see [Enable Change Tracking and Inventory using Azure Monitoring Agent (Preview)](enable-virtual-machines-monitoring-agent.md).

- For a single Azure VM from the [Virtual machine page](../automation/change-tracking/enable-vms-monitoring-agent.md) in the Azure portal. This scenario is available for Linux and Windows VMs.

- For [multiple Azure VMs](enable-virtual-machines-monitoring-agent.md) by selecting them from the Virtual machines page in the Azure portal.

## Next steps

* To monitor changes and collect inventory using Azure Change Tracking and Inventory, see [About Change Tracking and Inventory](../automation/change-tracking/overview-monitoring-agent?tabs=win-az-vm).