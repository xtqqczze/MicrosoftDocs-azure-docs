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

## Namespace and namespace assets

ADR uses *namespaces* to organize *namespace assets* and devices. Each IoT Hub instance uses a single namespace for its assets and devices. Multiple instances can share a single namespace.

Namespaces are logical containers for grouping devices and namespace assets. A namespace asset is a digital representation of a physical or virtual asset, such as a device, module, or sensor. Namespace assets can include metadata and properties that describe the asset and its capabilities.
Namespaces provide a way to organize and manage assets at scale. They enable you to group related assets together, apply policies and access controls, and manage the lifecycle of assets.

ADR maps namespace assets from your edge environment to Azure resources in the cloud. It offers a unified registry so apps and services interacting with your assets connect to a single source. ADR syncs assets in the cloud with custom resources in Kubernetes on the edge.Enterprises can use Azure Resource Manager, Azure's deployment and management service, with namespace assets. Azure Resource Manager supports resource groups, tags, role-based access control (RBAC), policies, logging, and auditing.

For more information about namespaces, see [Create and manage namespaces](iot-hub-device-registry-namespaces.md).

## How ADR works with IoT solutions?

ADR provides a unified device registry for managing all your IoT devices. Azure Device Registry (ADR) is a backend service that enables the cloud and edge management of devices across multiple IoT solutions using namespaces. ADR is an ARM resource provider that​ registers devices as Azure resources in ARM, providing a single registry for all devices and enabling consistent policy, resource queries and control plane operations.

When you [create an IoT Hub Gen 2 instance](iot-hub-device-registry-setup.md), you link it to an existing ADR namespace or create a new one. The IoT Hub Gen 2 instance uses the linked namespace to manage its devices and namespace assets. 

> [!NOTE]
> Azure Device Registry is also available with [Azure IoT Operations](/azure/iot-operations) instances. 

## Built-in RBAC roles

Azure Device Registry offers three built-in roles designed to simplify and secure access management for hub resources: Azure Device Registry Contributor, Azure Device Registry Credentials Contributor, and Azure Device Registry Onboarding. For more information, see [Built-in RBAC roles for Azure IoT](/azure/role-based-access-control/built-in-roles/internet-of-things).

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



