---
title: Create an IoT hub with Certificate Management in Azure Device Registry (Preview)
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

# Create an IoT hub with Certificate Management in Azure Device Registry (Preview)

This article explains how to create a new IoT hub with [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) and [Certificate Management](iot-hub-certificate-management-overview.md) integration. 

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

> [!NOTE]
> Certificate Management requires you to also use IoT Hub, ADR, and [Device Provisioning Service (DPS)](../iot-dps/index.yml). You can optionally not use Certificate Management, and limit your setup to just IoT Hub and ADR.

## Choose a deployment method

To set up your IoT hub with ADR, you can use the Azure portal, Azure CLI, or a script that automates the setup process.

| Deployment method | Description | Includes | Requires |
|-------------------|-------------|----------|--------------|
| [Azure portal](#create-an-iot-hub-with-adr-integration-using-azure-portal)| Use the Azure portal to create a new IoT hub and link it to an existing or new ADR namespace. | Creation of a new ADR namespace and a new IoT hub | A user-assigned managed identity, credentials, and a DPS instance. |
| [Azure CLI](#create-an-iot-hub-with-adr-integration-using-azure-cli) | Use the Azure CLI to create a new ADR namespace, a new IoT hub, and a new DPS instance and link them together. | Creation of a new ADR namespace, a new IoT hub, and a new DPS instance, user-assigned managed identity, credentials, and policies. | Installation of the Azure IoT CLI extension. |
| [Script](#create-an-iot-hub-with-adr-integration-using-script) | Use a PowerShell script to automate the setup of your IoT hub with ADR integration.| Creation of a new ADR namespace and a new IoT hub | A user-assigned managed identity, credentials, and a DPS instance. |

:::zone pivot="azure-portal"

[!INCLUDE [iot-hub-device-registry-portal](../../includes/iot-hub-device-registry-portal.md)]

:::zone-end

:::zone pivot="azure-cli"

[!INCLUDE [iot-hub-device-registry-azurecli](../../includes/iot-hub-device-registry-azure-cli.md)]

:::zone-end

:::zone pivot="script"

[!INCLUDE [iot-hub-device-registry-script](../../includes/iot-hub-device-registry-script.md)]

:::zone-end

## Next steps

You can now start using your IoT hub with Azure Device Registry integration. To learn more about how to connect devices to your IoT hub, see the following articles:

- [Create and manage device identities](create-connect-device.md)
- [Monitor IoT Hub with metrics and logs](monitor-iot-hub.md)
- [Create and manage namespaces](iot-hub-device-registry-namespaces.md)