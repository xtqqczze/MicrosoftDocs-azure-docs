---
title: Create and Configure Azure Registry Endpoints
description: Learn how to configure registry endpoints with Azure Key Vault secrets.
author: sethmanheim
ms.author: sethm
ms.date: 12/05/2025
ms.topic: article
ms.service: azure-iot-operations
ms.subservice: azure-data-flows
---

# Manage registry endpoints

Registry endpoints serve as authenticated access points to Azure Container Registries (ACRs). They enable you to retrieve and manage container images and metadata for use in connector templates and dataflow graphs.

Key capabilities include:

**Creation and configuration**: Create registry endpoints through the Azure portal or Azure CLI. Select an Azure Container Registry (ACR), specify authentication (anonymous, artifact secret, system or user managed identity), and optionally provide credentials.
**Authentication UI**: A wizard-based UI that guides you through authentication setup. It dynamically adjusts fields based on the selected method.
**Integration with DOE**: DOE dynamically pulls data from registry endpoints to display available dataflow graphs. You can filter and search these graphs.
**Connector templates**: Registry endpoints are foundational for connector templates. They enable developers to upload metadata and images that define connector behavior.

## Customer scenarios

The following customer scenarios illustrate how registry endpoints are used:

### Create Azure container registry

- **Job**: Developers successfully create and publish connector and discovery handler container images, along with associated dataflow graphs, to an ACR.
- **Outcome**: Enables integration into downstream platforms such as DOE and Azure IoT Operations for deployment and runtime execution.

### Create registry endpoint

- **Job**: When a developer or IT admin needs to enable secure access to container images for use in DOE and Azure IoT Operations, they create a registry endpoint that connects to an ACR or external registry, so that downstream systems can authenticate and pull artifacts reliably and securely.
- **Outcome**: A registry endpoint is successfully created and configured with the appropriate authentication method (such as managed identity, username/secret, or anonymous) and trust settings. This setup enables downstream platforms like Azure IoT Operations to discover, validate, and deploy containerized artifacts without manual intervention or security exceptions.

### Save configuration in resource provider

- **Job**: Customer IT saves the registry endpoint and credentials in Azure IoT Operations resource provider.
- **Outcome**: Securely store configuration details to enable seamless integration and operations with Azure IoT Operations.

### Create connector metadata and connector image

- **Job**: Customer developer creates connector metadata and connector images.
- **Outcome**: Develop and package the necessary connector metadata and connector images to enable connectivity.

### Upload connector metadata and connector image to ACR

- **Job**: Customer developer uploads the connector metadata and connector image to Azure container registry (ACR).
- **Outcome**: Store the connector metadata and connector images securely in ACR for easy access and management.

### Create dataflow graph artifact

- **Job**: Customer developer creates dataflow graph artifact and the operator images for each graph node.
- **Outcome**: Develop and package the necessary dataflow graph artifacts and operator images to enable efficient data processing.

### Upload dataflow graphs to ACR

- **Job**: Customer developer uploads the dataflow graphs to Azure container registry (ACR).
- **Outcome**: Store the dataflow graphs securely in ACR for easy access and management.

# Functional Requirements Summary

## Requirements for Azure Portal, CLI

Priority: **P0** - Crawl \| **P1** - Walk \| **P2** - Run

| Requirement | Priority |
|-------------|----------|
| 1. Ability to view list of registry endpoints | 0 |
| 1. Ability to create registry endpoints | 0 |
| 1. Ability to create registry endpoints with anonymous authentication type | 0 |
| 1. Ability to create registry endpoints with system managed identity | 0 |
| 1. Ability to create registry endpoints with user managed identity | 0 |
| 1. Ability to create registry endpoints with artifact secrets | 0 |

# Functional Requirements Details

## Ability to view list of registry endpoints

Users can view a list of registry endpoints. The AIO RP ARG call returns the list of registry endpoints.

:::image type="content" source="media/portal-registry-endpoints/image1.png" alt-text="Screenshot of the registry endpoints list view in the Azure portal interface.":::

## Ability to create registry endpoints

Users can create registry endpoints and provide host details of an ACR and optionally provide credentials.

Users start with an empty registry endpoint screen.

:::image type="content" source="media/portal-registry-endpoints/image2.png" alt-text="Screenshot of the empty registry endpoint creation screen in the Azure portal.":::

To create a registry endpoint, user enters

- Registry endpoint name

- Host name for the ACR

- One of four supported authentication types:

  - Anonymous

  - System managed identity

  - User managed identity

  - Artifact secret

## Ability to create registry endpoints with anonymous authentication type

You can create a new registry endpoint by specifying the host details of an Azure Container Registry (ACR), enabling anonymous access for public image retrieval, and storing the configuration for reuse in DOE and AIO environments.

:::image type="content" source="media/portal-registry-endpoints/image3.png" alt-text="Screenshot of the registry endpoint creation form with anonymous authentication selected.":::

:::image type="content" source="media/portal-registry-endpoints/image4.png" alt-text="Screenshot of the completed anonymous authentication configuration for registry endpoint.":::

## Ability to create registry endpoints with system managed identity authentication type

You can create a new registry endpoint by specifying the host details of an Azure Container Registry (ACR), authenticating by using a system-assigned managed identity for secure access, and storing the configuration for reuse in DOE and AIO environments.

:::image type="content" source="media/portal-registry-endpoints/image5.png" alt-text="Screenshot of the registry endpoint creation form with system managed identity authentication selected.":::

:::image type="content" source="media/portal-registry-endpoints/image6.png" alt-text="Screenshot of the completed system managed identity authentication configuration for registry endpoint.":::

## Ability to create registry endpoints with user managed identity authentication type

You can create a new registry endpoint by specifying the host details of an Azure Container Registry (ACR), authenticating by using a user-assigned managed identity for secure access, and storing the configuration for reuse in DOE and AIO environments.

To enable user managed identity, provide the Client ID and Tenant ID.

:::image type="content" source="media/portal-registry-endpoints/image7.png" alt-text="Screenshot of the registry endpoint creation form with user managed identity authentication selected.":::

:::image type="content" source="media/portal-registry-endpoints/image8.png" alt-text="Screenshot of the completed user managed identity authentication configuration for registry endpoint.":::

## Ability to create registry endpoints with artifact secrets 

You can create a new registry endpoint by specifying the host details of an Azure Container Registry (ACR). Authenticate by using artifact secrets for secure access, and store the configuration for reuse in DOE and AIO environments.

Use artifact secrets to authenticate with private container registries (like ACR, Docker Hub, or MCR) when pulling container images. They're essential when the registry requires credentials, and the image isn't publicly accessible. This scenario is valid for managing dataflow graphs across AIO and DOE.

Set up artifact secrets from Azure key vault by selecting existing secrets.

:::image type="content" source="media/portal-registry-endpoints/image9.png" alt-text="Screenshot of the registry endpoint creation form with artifact secrets authentication selected.":::

:::image type="content" source="media/portal-registry-endpoints/image10.png" alt-text="Screenshot of the Azure Key Vault secret selection interface for artifact secrets.":::

Set up artifact secrets from Azure key vault by creating new secrets and storing them in Azure key vault.

:::image type="content" source="media/portal-registry-endpoints/image11.png" alt-text="Screenshot of the create new secret form in Azure Key Vault for artifact secrets.":::
