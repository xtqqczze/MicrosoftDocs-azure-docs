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

Azure IoT Hub with Azure Device Registry (ADR) integration (preview) provides a unified device registry for managing all your IoT devices.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## ADR namespaces

ADR uses *namespaces* to organize IoT devices. Namespaces provide a way to organize and manage devices at scale. They enable you to group related devices together, apply policies and access controls, and manage the lifecycle of devices. Each IoT Hub instance uses a single namespace for its devices. Multiple instances can share a single namespace.

ADR offers a unified registry so apps and services interacting with your IoT devices connect to a single source. ADR syncs devices in the cloud with custom resources in Kubernetes on the edge. Enterprises can use Azure Resource Manager, Azure's deployment and management service, with namespace assets. Azure Resource Manager supports resource groups, tags, role-based access control (RBAC), policies, logging, and auditing.

## How ADR works with IoT solutions?

ADR provides a unified device registry for managing all your IoT devices. Azure Device Registry (ADR) is a backend service that enables the cloud and edge management of devices across multiple IoT solutions using namespaces. ADR is an ARM resource provider that​ registers devices as Azure resources in ARM, providing a single registry for all devices and enabling consistent policy, resource queries and control plane operations.

When you [create a new IoT Hub instance](iot-hub-device-registry-setup.md), you can link it to an existing ADR namespace or create a new one. The IoT Hub instance uses the linked namespace to manage its devices and namespace assets.

> [!NOTE]
> Azure Device Registry is also available with [Azure IoT Operations](/azure/iot-operations) instances. 

## Built-in RBAC roles

Azure Device Registry offers three built-in roles designed to simplify and secure access management for hub resources: Azure Device Registry Contributor, Azure Device Registry Credentials Contributor, and Azure Device Registry Onboarding. For more information, see [Built-in RBAC roles for Azure IoT](/azure/role-based-access-control/built-in-roles/internet-of-things).


## Limits and quotas

See [Azure subscription and service limits](../azure-resource-manager/management/azure-subscription-service-limits.md#azure-iot-hub-limits) for the latest information about limits and quotas for ADR with IoT Hub.