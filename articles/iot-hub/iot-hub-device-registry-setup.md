---
title: Get Started with ADR and Certificate Management in IoT Hub (Preview)
titleSuffix: Azure IoT Hub
description: This article explains how to create an IoT Hub with ADR integration and Microsoft-backed X.509 certificate management.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 11/07/2025
zone_pivot_groups: service-azcli-script
#Customer intent: As a developer new to IoT, I want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---

# Get started with ADR integration and Microsoft-backed X.509 certificate management in IoT Hub (preview)

This article explains how to create a new IoT Hub with [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) integration and [Microsoft-backed X.509 certificate management](iot-hub-certificate-management-overview.md). 

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Prerequisites

- An active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- If you don't have the Azure CLI installed, follow the steps to [install the Azure CLI](/cli/azure/install-azure-cli). 
- Install the **Azure IoT CLI extension with previews enabled** to access the ADR integration and certificate management functionalities. To install the extension, complete the following steps:

    Check for existing Azure CLI extension installations.
    
    ```azurecli-interactive
    az extension list
    ```
    
    Remove any existing azure-iot installations.
    
    ```azurecli-interactive
    az extension remove --name azure-iot
    ```
    
    Install the preview version of the azure-iot extension.
    
    ```azurecli-interactive
    az extension add --name azure-iot --allow-preview
    ```
    
    After the install, validate your azure-iot extension version is greater than **0.30.0b1**.
    
    ```azurecli-interactive
    az extension list
    ```

- You need elevated permissions to perform role assignments, such as Owner or User Administrator. To use pre-built roles, scope them to your subscription or resource group as needed:
    - Assign the **Azure Device Registry Onboarding** role to the user who sets up resources like IoT Hub, ADR namespace, DPS, and Managed Identity.
    - During setup, assign the **Azure Device Registry Contributor** role to the newly created user-assigned managed identity. Elevated permissions (for example, Owner or User Administrator) are required to complete this step.

## Choose a deployment method

To use certificate management, you must also set up IoT Hub, ADR, and the [Device Provisioning Service (DPS)](../iot-dps/index.yml). If you prefer, you can choose not to enable certificate management and configure only IoT Hub with ADR.

To set up your IoT Hub with ADR integration and certificate management, you can use Azure CLI or a script that automates the setup process.

| Deployment method | Description |
|-------------------|-------------|
| Select **Azure CLI** at the top of the page | Use the Azure CLI to create a new IoT Hub, DPS instance, and ADR namespace and configure all necessary settings. |
| Select **PowerShell script** at the top of the page | Use a PowerShell script to automate the creation of a new IoT Hub, DPS instance, and ADR namespace and configure all necessary settings. |

> [!NOTE]
> Azure portal support for creating IoT Hubs with ADR and certificate management is coming soon.

:::zone pivot="azure-cli"

[!INCLUDE [iot-hub-device-registry-azurecli](../../includes/iot-hub-device-registry-azure-cli.md)]

:::zone-end

:::zone pivot="script"

[!INCLUDE [iot-hub-device-registry-script](../../includes/iot-hub-device-registry-script.md)]

:::zone-end

## Next steps

At this point, your IoT Hub with ADR integration and certificate management is set up and ready to use. You can now start onboarding your IoT devices to the hub using the Device Provisioning Service (DPS) instance and manage your IoT devices securely using the policies and enrollments you have set up.

For more information on how to onboard devices, check out some the [DPS Device SDKs samples](../iot-dps/libraries-sdks.md#device-sdks). Certificate management is only supported in the following DPS Device SDKs: 

- Embedded C:
    - Bare metal: [Sample](https://github.com/Azure/azure-sdk-for-c/blob/master/sdk/samples/iot/README.md)
    - Free RTOS: [Sample](https://github.com/Azure-Samples/iot-middleware-freertos-samples)
- C: [Sample](https://github.com/Azure/azure-iot-sdk-c/tree/main/provisioning_client/samples)
- Python: [Sample](https://github.com/Azure/azure-iot-sdk-python/tree/main/samples)

