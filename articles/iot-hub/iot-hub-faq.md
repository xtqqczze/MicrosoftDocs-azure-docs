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

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## What are the new features in IoT Hub Gen 2?

IoT Hub Gen 2 introduces two major innovations: Azure Device Registry (ADR) and Certificate Management. These features are designed to enhance security, simplify device management, and streamline operations for IoT deployments.

## Unified registry between cloud and edge with Azure Device Registry

IoT Hub Gen 2 integrates directly with Azure Device Registry (ADR) to bring a consistent experience across cloud and edge workloads. ADR is a centralized device registry that allows you to manage devices across multiple IoT hubs using namespaces. You can create a link between an existing ADR namespace to your IoT Hub Gen 2 or create a new namespace and create the link. 

ADR is an ARM resource provider that​ registers devices as Azure resources in ARM, providing a single registry for all devices and enabling consistent policy, resource queries and control plane operations. 

For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

## Zero-Touch provisioning of IoT devices at scale

Similarly to IoT Hub Gen 1, in order to use certificate management, devices must be provisioned via [Device Provisioning Service (DPS)](../iot-dps/index.yml). The device must onboard and authenticate using one of the existing supported methods: including X.509 certificate (procured from a third-party CA) or symmetric keys. Once the device is successfully authenticated, it's provisioned to the appropriate IoT Hub and registered to the appropriate ADR namespace. As part of this provisioning call, the device also submits a Certificate Signing Request (CSR) to DPS, which it uses to request an X.509 operational certificate that IoT Hub recognizes.

### X.509 credential management for IoT Devices

IoT Hub Gen 2 introduces built-in support for managing device certificates using Microsoft-managed PKI with X.509 certificates. X.509 certificates are undoubtedly the gold standard for IoT security. With IoT Hub Gen 2, you can use DPS to improve the security posture of your IoT devices by adopting X.509-based authentication. 

These X.509 certificates are strictly **operational certificates** which the devices uses to authenticate with IoT Hub for secure communications, after the device has onboarded with a different credential. 

For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md).

## What are the differences between IoT Hub Gen 1 and Gen 2?

The following table summarizes the key differences between IoT Hub Gen 1 and Gen 2:

|Feature | IoT Hub Gen1 | IoT Hub Gen2|
|--------|--------------|-------------|
|Device Registry Architecture | Local registry per IoT Hub instance; devices managed individually. | Centralized Azure Device Registry (ADR) with namespace support; devices as ARM records. |
|Certificate Management | Third-party PKI providers (e.g., DigiCert, GlobalSign); manual integration required. | Microsoft-managed PKI with X.509 certificates; configure certificate authorities directly in ADR. |
|Namespace Integration | No namespace concept; visibility limited to individual hubs. | Supports namespaces for unified visibility and control across hubs. |
|Device Provisioning | Use Device Provisioning Service (DPS) for onboarding into individual hubs. | DPS continues but will integrate with ADR namespaces for cross-hub provisioning. |
|Migration and Setup | Existing hubs remain functional; no changes are required. | Migration isn't supported. Requires new hub creation with ADR integration. |
|Device Update | Supported | Not supported |
|Pricing Model | Based on number of messages and features used. | Similar pricing model with potential adjustments for new features. |
|Throttling limits | Limits based on tier (B1, B2, S1, S2, S3). | Only available in Free and S1 tiers. |

## Can I migrate my existing hubs Gen 1 to Gen 2?

No. Currently, you can't migrate your existing hubs to Gen 2. You need to create a new IoT hub Gen 2 instance and reconfigure your devices and applications to connect to the new hub.

## Can I use namespaces and Azure Device Registry in my existing hubs?

No, namespaces and Azure Device Registry aren't available in IoT Hub Gen 1. You must set up a new IoT hub Gen 2 instance to use these features. For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

## Can I use Certificate Management in my existing hubs?

No, Certificate Management isn't available in IoT Hub Gen 1. You must set up a new IoT hub Gen 2 instance to use this feature. For more information, see [What is Certificate Management?](iot-hub-certificate-management-overview.md).

## Can I use Device Update with IoT Hub Gen 2?

[Azure Device Update](/azure/iot-hub-device-update/) isn't currently supported with IoT Hub Gen 2. You can continue to use Device Update with your existing IoT hub Gen 1 instances.

## What are the supported regions for IoT Hub Gen 2?

IoT Hub Gen 2 is available in the following regions:

- East US
- East US 2
- West US
- West US 2
- West Europe
- North Europe

## Does the pricing model change in IoT Hub Gen 2?


## What are the quotas and limits for IoT Hub Gen 2?

IoT Hub Gen 2 is only available in the **Free and S1 tiers**. For more information, see the standard tier operations section in [IoT Hub quotas and throttling](iot-hub-devguide-quotas-throttling.md#standard-tier-operations).

