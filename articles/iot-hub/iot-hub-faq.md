---
title: "FAQ: What is new in Azure IoT Hub Gen 2 (Preview)?"
titleSuffix: Azure IoT Hub
description: Learn about the new features and improvements in Azure IoT Hub Gen 2, and what's changed from Gen 1.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
ms.topic: troubleshooting
ms.date: 10/20/2025
#Customer intent: 
---

# FAQ: What is new in Azure IoT Hub Gen 2 (Preview)?

Azure IoT Hub Gen 2 introduces advanced capabilities to improve security and unify operations across cloud and edge-connected deployments. This FAQ addresses common questions about the new generation of IoT Hub.

## What are the new features in IoT Hub Gen 2?

IoT Hub Gen 2 introduces two major innovations: Azure Device Registry (ADR) and Certificate Management. These features are designed to enhance security, simplify device management, and streamline operations for IoT deployments.

While ADR is required for IoT Hub Gen 2, Certificate Management is an optional feature. You can use ADR to manage devices across multiple IoT hubs without using Certificate Management.

- **Azure Device Registry (ADR)**: A centralized device registry that allows you to manage devices across multiple IoT hubs using namespaces. You can create a link between an existing ADR namespace to your IoT Hub Gen 2 or create a new namespace and create the link. For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

- **Certificate Management**: IoT Hub Gen 2 introduces built-in support for managing device certificates using Microsoft-managed PKI with X.509 certificates. These X.509 certificates are strictly operational certificates which the devices uses to authenticate with IoT Hub for secure communications, after the device has onboarded with a different credential. Certificate Management is an optional feature. For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md).

## What are the differences between IoT Hub Gen 1 and Gen 2?

IoT Hub Gen 2 builds on the capabilities of IoT Hub Gen 1, so essentially, everything that works in IoT Hub Gen 1 continues to work in IoT Hub Gen 2. 

The following table summarizes the key differences between IoT Hub Gen 1 and Gen 2:

|Feature | IoT Hub Gen1 | IoT Hub Gen2 (Preview)|
|--------|--------------|-------------|
|Azure Device Registry (ADR) | Not supported. Local registry per IoT Hub instance; devices managed individually. | Required |
|Certificate Management | Not supported | Optional but requires ADR namespace creation and DPS integration. |
|Namespace integration | No namespace concept; visibility limited to individual hubs. | Supports namespaces for unified visibility and control across hubs. |
|Device Provisioning Service | Use DPS for onboarding into individual hubs. | DPS continues and it's required if you want to use Certificate Management. |
|Migration and setup | Existing hubs remain functional; no changes are required. | Migration isn't supported. Requires new hub creation with ADR integration. |
|Azure Device Update | Supported | Not supported |
|Pricing model | Based on number of messages and features used. | Free during preview period. |
|Throttling limits | Limits based on tier (B1, B2, S1, S2, S3). | Only available in Free and S1 tiers. |

## Can I migrate my existing hubs to Gen 2?

No. Currently, you can't migrate your existing Gen 1 hubs to Gen 2. You need to create a new IoT hub Gen 2 instance and reconfigure your devices and applications to connect to the new hub.

## Can I use namespaces and Azure Device Registry in my existing hubs?

No, namespaces and Azure Device Registry aren't available in IoT Hub Gen 1. You must create a new IoT hub Gen 2 instance to use these features. For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

## Can I use Certificate Management in my existing hubs?

No, Certificate Management isn't available in IoT Hub Gen 1. You must create a new IoT hub Gen 2 instance to use this feature. For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md) and [Set up Azure Device Registry](iot-hub-device-registry-setup.md).

## Can I use Azure Device Registry without Certificate Management?

Yes. While ADR is required for IoT Hub Gen 2, Certificate Management is an optional feature. You can use ADR to manage devices across multiple IoT hubs and choose to use other authentication methods, such as symmetric keys or third-party X.509 certificates. For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

## Can I use Certificate Management without Azure Device Registry?

No. Certificate Management requires using Azure Device Registry (ADR) to manage device certificates. You must set up an ADR namespace and link it to your IoT Hub Gen 2 and DPS instance to use Certificate Management. For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md) and [Set up Azure Device Registry](iot-hub-device-registry-setup.md).


## Can I use Device Update with IoT Hub Gen 2?

[Azure Device Update](/azure/iot-hub-device-update/) isn't currently supported with IoT Hub Gen 2. You can continue to use Device Update with your existing IoT hub Gen 1 instances.

## Does the pricing model change in IoT Hub Gen 2?

Yes, the pricing model for IoT Hub Gen 2 is different from Gen 1. During the preview period, IoT Hub Gen 2 is free to use. After the preview period, pricing details will be provided.

## What are the quotas and limits for IoT Hub Gen 2?

IoT Hub Gen 2 is only available in the **Free and S1 tiers**. For more information, see the standard tier operations section in [IoT Hub quotas and throttling](iot-hub-devguide-quotas-throttling.md#standard-tier-operations).

## What are the supported regions for IoT Hub Gen 2?

IoT Hub Gen 2 is available in the following regions:

- East US
- East US 2
- West US
- West US 2
- West Europe
- North Europe



