---
title: "FAQ: What is new in Azure IoT Hub?"
titleSuffix: Azure IoT Hub
description: Learn about the new features and improvements in Azure IoT Hub, and what's changed from Gen 1.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
ms.topic: troubleshooting
ms.date: 11/04/2025
#Customer intent: 
---

# FAQ: What is new in Azure IoT Hub?

Azure IoT Hub introduces advanced capabilities to improve security and unify operations across cloud and edge-connected deployments. This FAQ addresses common questions about the new generation of IoT Hub.

## What are the new features in IoT Hub?

From November 2025, IoT Hub introduces two major innovations: Azure Device Registry (ADR) and Certificate Management. These features are in **preview** and designed to enhance security, simplify device management, and streamline operations for IoT deployments.

- **Azure Device Registry (ADR)**: A centralized device registry that allows you to manage devices across multiple IoT hubs using namespaces. You can create a link between an existing ADR namespace to your IoT Hub or create a new namespace and create the link. For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

- **Certificate Management**: IoT Hub introduces built-in support for managing device certificates using Microsoft-managed PKI with X.509 certificates. These X.509 certificates are strictly operational certificates which the devices uses to authenticate with IoT Hub for secure communications, after the device has onboarded with a different credential. Certificate Management is an optional feature. For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md).

## Are my existing IoT hubs affected by these changes?

No, existing IoT hubs without ADR and Certificate Management integration remain fully functional. You can continue to use them as before without any changes. The new features are in preview and require creating new IoT hub instances with ADR integration. 

## Can I migrate my existing IoT hubs to use Azure Device Registry and Certificate Management?

No, migration from existing IoT hubs to IoT hubs with ADR and Certificate Management isn't supported. You must create a new IoT hub instance and link it to an ADR namespace. For more information, see [Create an IoT hub with Azure Device Registry integration](iot-hub-device-registry-setup.md).

## Can I use namespaces and Azure Device Registry in my existing hubs?

No, namespaces and Azure Device Registry aren't available in existing hubs. You must create a new IoT hub instance and link it to an ADR namespace. For more information, see [Create an IoT hub with Azure Device Registry integration](iot-hub-device-registry-setup.md).

## Can I use Certificate Management in my existing hubs?

No, Certificate Management isn't available in existing hubs. You must create a new IoT hub instance and link it to an ADR namespace.  For more information, see [Create an IoT hub with Azure Device Registry integration](iot-hub-device-registry-setup.md).

## Can I use Azure Device Registry without Certificate Management?

Yes. Certificate Management is an optional feature, you can use ADR to manage devices across multiple IoT hubs and choose to use other authentication methods, such as symmetric keys or third-party X.509 certificates. 

## Can I use Certificate Management without Azure Device Registry?

No. Certificate Management is an optional feature of ADR, and thus it requires using ADR to manage device certificates. You must set up an ADR namespace and link it to your IoT Hub and DPS instance to use Certificate Management. For more information, see the section [How Certificate Management works](iot-hub-certificate-management-overview.md#how-certificate-management-works) in [What is Certificate Management?](iot-hub-certificate-management-overview.md).

## Can I use Certificate Management without Device Provisioning Service (DPS)?

No, Certificate Management relies on the Device Provisioning Service (DPS) for device registration and certificate management. You must use DPS in conjunction with ADR to utilize Certificate Management features. For more information, see the section [Device Provisioning Service integration](iot-hub-certificate-management-overview.md#device-provisioning-service-integration) in [What is Certificate Management?](iot-hub-certificate-management-overview.md).

## What is the pricing model for IoT Hub with ADR and Certificate Management?

During the preview period, ADR and Certificate Management features in IoT Hub are **free of charge**. After the preview period, pricing details will be provided. Device Provisioning Service (DPS) is billed separately and isn't included in the preview offer. For details on DPS pricing, see [Azure IoT Hub pricing](https://azure.microsoft.com/pricing/details/iot-hub/).

## What are the quotas and limits for IoT Hub with ADR and Certificate Management?

IoT Hub with ADR and Certificate Management is only available in the **Free and S1 tiers**. For more information, see the standard tier operations section in [IoT Hub quotas and throttling](iot-hub-devguide-quotas-throttling.md#standard-tier-operations).

## What are the supported regions for IoT Hub with ADR and Certificate Management?

IoT Hub with ADR and Certificate Management is available in the following regions:

- East US
- East US 2
- West US
- West US 2
- West Europe
- North Europe



