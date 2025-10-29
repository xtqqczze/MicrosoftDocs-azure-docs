---
title: Built-in RBAC Roles 
titleSuffix: Azure IoT Hub
description: Learn about the built-in RBAC roles for Azure IoT Hub and how to use them to control access to resources.
author: SoniaLopezBravo
ms.author: sonialopez
services: iot-hub
ms.service: azure-iot-hub
ms.topic: overview
ms.date: 10/29/2025

#CustomerIntent: As an IT administrator, I want to configure Azure RBAC built-in roles on resources in my Azure IoT Hub instance to control access to them.
---

# Built-in RBAC roles for Azure IoT Hub

**Applies to:** ![IoT Hub checkmark](media/iot-hub-version/yes-icon.png) IoT Hub Gen 2

Azure IoT Hub offers three built-in roles designed to simplify and secure access management for Azure Device Registry resources: Azure Device Registry Contributor, Azure Device Registry Credentials Contributor, and Azure Device Registry Onboarding. If your scenario requires more granular access, you can [create a custom RBAC role](../reference/custom-rbac.md).

> [!IMPORTANT]
> The built-in roles for IoT Hub streamline access management for IoT Hub resources, but don't automatically grant permissions for all required Azure dependencies. IoT Hub relies on several Azure services, such as Azure Key Vault, Azure Storage, Azure Arc, and others. Always review and assign the necessary additional roles to ensure users have end-to-end access for successful IoT Hub deployment and operation.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Azure Device Registry Contributor role

The Azure Device Registry Contributor role provides full access to manage Azure Device Registry resources, including creating, updating, and deleting device registries. This role is ideal for users who need comprehensive control over device registry configurations and operations.

When assigning this built-in role, you need to ensure that the following roles are also assigned to the user:

// TO DO

## Azure Device Registry Credentials Contributor role

The Azure Device Registry Credentials Contributor role allows users to manage credentials for devices within the Azure Device Registry. This includes creating, updating, and deleting device credentials, but does not grant permissions to modify other aspects of the device registry itself. This role is suitable for users responsible for maintaining device authentication and security.

When assigning this built-in role, you need to ensure that the following roles are also assigned to the user:

// TO DO

## Azure Device Registry Onboarding role

The Azure Device Registry Onboarding role provides the necessary permissions to deploy Azure Device Registry components.

When assigning this built-in role, you need to ensure that the following roles are also assigned to the user:

// TO DO