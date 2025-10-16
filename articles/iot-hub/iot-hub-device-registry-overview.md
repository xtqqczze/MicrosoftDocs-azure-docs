---
title: What is Azure Device Registry?
titleSuffix: Azure IoT Hub
description: This article discusses the basic concepts of how Azure Device Registry helps users manage IoT devices.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: overview
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, i want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---

# What is Azure Device Registry?

**Applies to:** ![IoT Hub checkmark](media/iot-hub-version/yes-icon.png) IoT Hub Gen 2

IoT Hub Gen 2 brings integration with Azure Device Registry (ADR) to provide a unified device registry for managing all your IoT devices. ADR is required for IoT Hub Gen 2 and is automatically created when you create an IoT Hub Gen 2 instance.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## How Azure Device Registry works with IoT solutions?

ADR provides a unified device registry for managing all your IoT devices. Azure Device Registry (ADR) is a backend service that enables the cloud and edge management of devices across multiple IoT solutions using namespaces. ADR is an ARM resource provider that​ registers devices as Azure resources in ARM, providing a single registry for all devices and enabling consistent policy, resource queries and control plane operations.

When you [create an IoT Hub Gen 2 instance](iot-hub-device-registry-setup.md), you link it to an existing ADR namespace or create a new one. The IoT Hub Gen 2 instance uses the linked namespace to manage its devices and namespace assets. 

> [!NOTE]
> Azure Device Registry is also available with [Azure IoT Operations](/azure/iot-operations) instances. 

## Supported regions

Azure Device Registry is currently supported in the following regions:

- East US
- East US 2
- West US
- West US 2
- West Europe
- North Europe

## Limits and quotas

The following table lists the default limits and quotas for Azure Device Registry:

| Feature	| Limit|
|----------------------------------|-------------------------------|
|Number of ADR namespaces per Azure subscription	| 100|
|Number of device create per minute	| 1000 devices per minute per tenant|
|Number of devices to be disabled per minute	| 1000|
|Number of devices to be enabled per minute	| 1000|
|Number of devices per subscription	| 10,000|



