---
title: Get started with ADR and certificate management in IoT Hub (Preview)
titleSuffix: Azure IoT Hub
description: This article explains how to create an IoT hub with Azure Device Registry and certificate management integration.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 11/07/2025
zone_pivot_groups: service-azcli-script
#Customer intent: As a developer new to IoT, I want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---

# Get started with Azure Device Registry and certificate management in IoT Hub (Preview)

This article explains how to create a new IoT hub with [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) and [certificate management](iot-hub-certificate-management-overview.md) integration. 

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Choose a deployment method

To use certificate management, you must also set up IoT Hub, ADR, and the [Device Provisioning Service (DPS)](../iot-dps/index.yml). If you prefer, you can choose not to enable certificate management and configure only IoT Hub with ADR.

To set up your IoT hub with ADR and certificate management, you can use Azure CLI or a script that automates the setup process.

| Deployment method | Description |
|-------------------|-------------|
| Select **Azure CLI** at the top of the page | Use the Azure CLI to create a new IoT hub, DPS instance, and ADR namespace and configure all necessary settings. |
| Select **PowerShell script** at the top of the page | Use a PowerShell script to automate the creation of a new IoT hub, DPS instance, and ADR namespace and configure all necessary settings. |

> [!NOTE]
> Azure portal support for creating IoT hubs with ADR and certificate management is coming soon.

:::zone pivot="azure-cli"

[!INCLUDE [iot-hub-device-registry-azurecli](../../includes/iot-hub-device-registry-azure-cli.md)]

:::zone-end

:::zone pivot="script"

[!INCLUDE [iot-hub-device-registry-script](../../includes/iot-hub-device-registry-script.md)]

:::zone-end

## Next steps

At this point, your IoT hub with ADR and certificate management integration is set up and ready to use. You can now start onboarding your IoT devices to the hub using the Device Provisioning Service (DPS) instance and manage your IoT devices securely using the policies and enrollments you have set up.

For more information on how to onboard devices, check out some the [DPS Device SDKs samples](../iot-dps/libraries-sdks.md#device-sdks). Certificate management is only supported in the following DPS Device SDKs: Embedded C (Bare metal, Free RTOS), C, and Python. IoT Hub SDKs don't support it.

