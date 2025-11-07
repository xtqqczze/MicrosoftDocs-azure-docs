---
title: How does Azure IoT Operations work in layered network?
description: Use the layered network sample to enable Azure IoT Operations in industrial network environment.
author: SoniaLopezBravo
ms.subservice: layered-network-management
ms.author: sonialopez
ms.topic: concept-article
ms.date: 11/07/2025

#CustomerIntent: As an operator, I want to learn about the architecture of Azure IoT Operations in a Purdue Network environment and how does Layered Network Management support this scenario.
ms.service: azure-iot-operations
---

# How does Azure IoT Operations work in layered network?

In the basic architecture described in [Azure IoT Operations Architecture Overview](../overview-iot-operations.md#architecture-overview), all the Azure IoT Operations components are deployed to a single internet-connected cluster. In this type of environment, component-to-component and component-to-Azure connections are enabled by default.

However, in many industrial scenarios, computing units for different purposes are located in separate networks. For example:
- Assets and servers on the factory floor
- Data collecting and processing solutions in the data center 
- Business logic applications with information workers

In industries like manufacturing, you often see segmented networking architectures that create layers. These layers minimize or block lower-level segments from connecting to the internet (for example, [Purdue Network Architecture](https://en.wikipedia.org/wiki/Purdue_Enterprise_Reference_Architecture)).

## Layered networking sample overview

IoT Operations provides a set of sample deployments and configurations to help you understand how to implement Azure IoT Operations in a layered network environment in a test environment and use it to route telemetry from assets on the edge to Azure services in the cloud.

This [IoT sample guidance](https://github.com/Azure-Samples/explore-iot-operations/tree/main/samples/layered-networking#readme) describes the test environment Microsoft uses to validate Azure IoT Operations deployments in a layered network using open, industry-recognized software.

This guidance covers:

- Kubernetes-based configuration and compatibility with networking primitives
- Connecting devices in layered networks at scale to [Azure Arc](/azure/azure-arc/) for remote management and configuration from a single Azure control plane
- Security and governance across network levels for devices and services with URL and IP allow lists and connection auditing

:::image type="content" source="media/layered-network-architecture.png" alt-text="Diagram that shows layered networking architecture for industrial layered networks.":::

> [!NOTE]
> The guidance doesn't recommend specific practices or provide production-ready implementation, configuration, or operations details. The guidance doesn't make recommendations about production networking architecture.

To learn more about how to prepare for a production-ready deployment of Azure IoT Operations, see the [Azure IoT Operations production checklist](../../iot-edge/production-checklist.md).

## Key scenarios

The layered networking sample guidance includes the following key scenarios:

1. Learn [How Azure IoT Operations Works in a layered network](https://github.com/Azure-Samples/explore-iot-operations/blob/main/samples/layered-networking/aio-layered-network.md).
1. Learn how to use CoreDNS and Envoy Proxy in [Configure the infrastructure](https://github.com/Azure-Samples/explore-iot-operations/blob/main/samples/layered-networking/configure-infrastructure.md).
1. Learn how to Arc enable the K3s clusters in [Arc enable the K3s clusters](https://github.com/Azure-Samples/explore-iot-operations/blob/main/samples/layered-networking/arc-enable-clusters.md).
1. Learn how to deploy Azure IoT Operations to the clusters in [Deploy Azure IoT Operations](https://github.com/Azure-Samples/explore-iot-operations/blob/main/samples/layered-networking/deploy-aio.md).
1. Learn how to flow asset telemetry through the deployments into Azure Event Hubs in [Flow asset telemetry](https://github.com/Azure-Samples/explore-iot-operations/blob/main/samples/layered-networking/asset-telemetry.md).



