---
title: Automatic device management at scale
titleSuffix: Azure IoT Hub
description: Use Azure IoT Hub automatic configurations to manage multiple IoT devices and modules in the Azure portal and Azure CLI.
author: SoniaLopezBravo
ms.service: azure-iot-hub
ms.topic: how-to
ms.date: 09/22/2022
ms.author: sonialopez
ms.custom: ['Role: Cloud Development', 'Role: IoT Device']
zone_pivot_groups: service-portal-azcli
---

# Automatic IoT device and module management using the Azure portal

Automatic device management in Azure IoT Hub automates many of the repetitive and complex tasks of managing large device fleets. With automatic device management, you can target a set of devices based on their properties, define a desired configuration, and then let IoT Hub update the devices when they come into scope. 

This update is done using an _automatic device configuration_ or _automatic module configuration_, which lets you summarize completion and compliance, handle merging and conflicts, and roll out configurations in a phased approach.

[!INCLUDE [iot-hub-basic](../../includes/iot-hub-basic-whole.md)]

## Overview of automatic device management

Automatic device management works by updating a set of device twins or module twins with desired properties and reporting a summary that's based on twin reported properties.  It introduces a new class and JSON document called a _Configuration_ that has three parts:

* The **target condition** defines the scope of device twins or module twins to be updated. The target condition is specified as a query on twin tags and/or reported properties.

* The **target content** defines the desired properties to be added or updated in the targeted device twins or module twins. The content includes a path to the section of desired properties to be changed.

* The **metrics** define the summary counts of various configuration states such as **Success**, **In Progress**, and **Error**. Custom metrics are specified as queries on twin reported properties.  System metrics are the default metrics that measure twin update status, such as the number of twins that are targeted and the number of twins that have been successfully updated.

Automatic configurations run for the first time shortly after the configuration is created and then at five minute intervals. Metrics queries run each time the automatic configuration runs. A maximum of 100 automatic configurations is supported on standard tier IoT hubs; ten on free tier IoT hubs. Throttling limits also apply. To learn more, see [Quotas and Throttling](iot-hub-devguide-quotas-throttling.md).

:::zone pivot="azure-portal"

[!INCLUDE [iot-hub-automatic-device-management-portal](../../includes/iot-hub-automatic-device-management-portal.md)]

:::zone-end

:::zone pivot="azure-cli"

[!INCLUDE [iot-hub-automatic-device-management-cli](../../includes/iot-hub-automatic-device-management-cli.md)]

:::zone-end

## Next steps

In this article, you learned how to configure and monitor IoT devices at scale.

To learn how to manage IoT Hub device identities in bulk, see [Import and export IoT Hub device identities in bulk](iot-hub-bulk-identity-mgmt.md)
