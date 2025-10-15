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

Azure Device Registry (ADR) is a backend service that enables the cloud and edge management of devices across multiple IoT solutions using namespaces. ADR is an ARM resource provider that​ registers devices as Azure resources in ARM, providing a single registry for all devices and enabling consistent policy, resource queries and control plane operations.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

> [!NOTE]
> Azure Device Registry is currently available with Azure IoT Operations and Azure IoT Hub Gen 2 (Preview) instances only.

## Namespaces and namespace assets

ADR uses *namespaces* to organize *namespace assets* and devices. Each IoT Hub instance uses a single namespace for its assets and devices. Multiple instances can share a single namespace.

Namespaces are logical containers for grouping devices and namespace assets. A namespace asset is a digital representation of a physical or virtual asset, such as a device, module, or sensor. Namespace assets can include metadata and properties that describe the asset and its capabilities.
Namespaces provide a way to organize and manage assets at scale. They enable you to group related assets together, apply policies and access controls, and manage the lifecycle of assets.

ADR maps namespace assets from your edge environment to Azure resources in the cloud. It offers a unified registry so apps and services interacting with your assets connect to a single source. ADR syncs assets in the cloud with custom resources in Kubernetes on the edge. 

Enterprises can use Azure Resource Manager, Azure's deployment and management service, with namespace assets. Azure Resource Manager supports resource groups, tags, role-based access control (RBAC), policies, logging, and auditing.

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

## View Azure Device Registry in the Azure portal

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**. The **Overview** page summarizes the number of assets, schema registries and namespaces in your subscription:

    :::image type="content" source="media/device-registry/azure-device-registry-overview.png" alt-text="Screenshot of Azure Device Registry overview page in the Azure portal." lightbox="media/device-registry/azure-device-registry-overview.png":::

    > [!NOTE]
    > Schema registries are only available if you have an Azure IoT Operations instance in your subscription. 

1. Go to the **Assets** page to view the assets in Azure Device Registry. By default, the **Assets** page shows the assets in all namespaces in your subscription. Use the filters to view a subset of the assets, such as the assets in a specific namespace or resource group:

    :::image type="content" source="media/device-registry/azure-device-registry-assets.png" alt-text="Screenshot of Azure Device Registry assets page in the Azure portal." lightbox="media/device-registry/azure-device-registry-assets.png":::

1. Go to the **Namespaces** page to view the namespaces in Azure Device Registry. By default, the **Namespaces** page shows the namespaces in your subscription. Use the filters to view a subset of the namespaces, such as the namespaces in a specific resource group. From this page, you can create new namespaces, or view the details of existing namespaces:

    :::image type="content" source="media/device-registry/azure-device-registry-namespaces.png" alt-text="Screenshot of Azure Device Registry namespaces page in the Azure portal." lightbox="media/device-registry/azure-device-registry-namespaces.png":::

