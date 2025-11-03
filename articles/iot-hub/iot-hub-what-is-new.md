---
title: What is New in Azure IoT Hub?
titleSuffix: Azure IoT Hub
description: This article explains the new features and improvements in Azure IoT Hub.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: overview
ms.date: 11/07/2025
#Customer intent: As a developer new to IoT Hub, I want to understand the new features and improvements in Azure IoT Hub.
---

# What is New in Azure IoT Hub?

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

From November 2025, IoT Hub introduces two major innovations: Azure Device Registry (ADR) and Certificate Management. These features are designed to enhance security, simplify device management, and streamline operations for IoT deployments.

Integration of IoT hubs with ADR is essential to leverage the latest enhancements in device provisioning, certificate management, and deeper integration with Azure Resource Manager. For more information, see [Create an IoT hub with Azure Device Registry integration](iot-hub-device-registry-setup.md).

## Manage your devices in a unified registry with Azure Device Registry

IoT Hub now integrates directly with Azure Device Registry (ADR) to bring a consistent experience across cloud and edge workloads. ADR is a centralized device registry that allows you to manage devices across multiple IoT hubs using namespaces. You can create a link between an existing ADR namespace to your IoT Hub or create a new namespace and create the link. For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

## Manage your X.509 credentials with Certificate Management

IoT Hub now introduces built-in support for managing device certificates using Microsoft-managed PKI with X.509 certificates. X.509 certificates are undoubtedly the gold standard for IoT security. With IoT Hub, you can use DPS to improve the security posture of your IoT devices by adopting X.509-based authentication. These X.509 certificates are strictly operational certificates which the devices uses to authenticate with IoT Hub for secure communications, after the device has onboarded with a different credential. For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md) and [Key concepts for Certificate Management](iot-hub-certificate-management-concepts.md).

