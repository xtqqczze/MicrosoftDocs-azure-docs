---
title: Manage your certificates with Certificate Management (Preview)
titleSuffix: Azure IoT Hub
description: Learn how to create and manage certificate authorities and policies using Certificate Management in Azure IoT Hub.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, I want to learn how to create and manage certificate authorities and policies using Certificate Management in Azure IoT Hub, so that I can effectively manage device certificates for secure authentication.
---

# Manage your certificates with Certificate Management (Preview)

Certificate Management consists of several integrated components that work together to streamline the deployment of public key infrastructure (PKI) across IoT devices. To use Certificate Management with IoT Hub, you must set up both an Azure Device Registry (ADR) namespace and a Device Provisioning Service (DPS) instance.

This article explains how to create and manage certificate authorities and policies using Azure portal.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group to hold your resources. You can create a new resource group or use an existing one. 


## Assign a policy when creating an enrollment group

When creating an enrollment group in Device Provisioning Service (DPS), you can assign a policy created within your ADR namespace to manage certificate issuance and lifecycle.

TO DO


## Assign a policy from an existing enrollment group

You can select a policy from an existing enrollment group and assign it to one or multiple enrollment groups in Device Provisioning Service (DPS). This allows you to reuse policies and streamline the management of certificate issuance and lifecycle across multiple enrollment groups.

TO DO


## Sync policies to IoT hubs

You can synchronize a policy created within your ADR namespace to the IoT hubs linked to that namespace. This synchronization enables IoT Hub to trust any devices authenticating with a leaf certificate issued by the policy's issuing CA (ICA).

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to sync policies for.
1. In the namespace page, under **Namespace resources**, select **Credential policies (Preview)**.
1. In the **Credential policies** page, you can view your policies, validity periods, intervals, and status.
1. Select the policies you want to sync. You can sync more than one policy at a time.
1. Select **Sync**.

    :::image type="content" source="media/device-registry/sync-policies.png" alt-text="Screenshot of the namespace page in Azure portal that shows the sync option." lightbox="media/device-registry/sync-policies.png":::

> [!NOTE]
> If you select to sync more than one policy, policies are synced to their respective IoT hubs. You can't undo a sync operation once it's done.
