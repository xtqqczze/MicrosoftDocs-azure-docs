---
title: Get started with ADR and Certificate Management in IoT Hub (Preview)
titleSuffix: Azure IoT Hub
description: This article explains how to create an IoT hub with Azure Device Registry and Certificate Management integration.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 11/07/2025
zone_pivot_groups: service-portal-azcli-script
#Customer intent: As a developer new to IoT, I want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---

# Get started with Azure Device Registry and Certificate Management in IoT Hub (Preview)

This article explains how to create a new IoT hub with [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) and [Certificate Management](iot-hub-certificate-management-overview.md) integration. 

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Choose a deployment method

Certificate Management requires you to also use IoT Hub, ADR, and [Device Provisioning Service (DPS)](../iot-dps/index.yml). You can optionally not use Certificate Management, and limit your setup to just IoT Hub and ADR.

To set up your IoT hub with ADR and Certificate Management, you can use the Azure portal, Azure CLI, or a script that automates the setup process.

| Deployment method | Description |
|-------------------|-------------|
| Select **Azure portal** at the top of the page | Use the Azure portal to create a new IoT hub, DPS instance, and ADR namespace, and configure all necessary settings. |
| Select **Azure CLI** at the top of the page | Use the Azure CLI to create a new IoT hub, DPS instance, and ADR namespace and configure all necessary settings. |
| Select **PowerShell script** at the top of the page | Use a PowerShell script to automate the creation of a new IoT hub, DPS instance, and ADR namespace and configure all necessary settings. |

:::zone pivot="azure-portal"

[!INCLUDE [iot-hub-device-registry-portal](../../includes/iot-hub-device-registry-portal.md)]

:::zone-end

:::zone pivot="azure-cli"

[!INCLUDE [iot-hub-device-registry-azurecli](../../includes/iot-hub-device-registry-azure-cli.md)]

:::zone-end

:::zone pivot="script"

[!INCLUDE [iot-hub-device-registry-script](../../includes/iot-hub-device-registry-script.md)]

:::zone-end

