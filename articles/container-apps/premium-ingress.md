---
title: Use premium ingress in Azure Container Apps
description: Learn how to use premium ingress in Azure Container Apps.
services: container-apps
author: craigshoemaker
ms.service: azure-container-apps
ms.custom: devx-track-azurecli, devx-track-bicep
ms.topic: tutorial
ms.date: 11/04/2025
ms.author: jefmarti
zone_pivot_groups: azure-cli-bicep
---

# Use premium ingress with Azure Container Apps

In this article, you learn how to use premium ingress with Azure Container Apps. With premium ingress, you can define how ingress is scaled and configured to better handle higher demand workloads. 

## Prerequisites

- Azure account with an active subscription.
  - If you don't have one, you [can create one for free](https://azure.microsoft.com/free/).

- Install the [Azure CLI](/cli/azure/install-azure-cli).

::: zone pivot="bicep"

- [Bicep](/azure/azure-resource-manager/bicep/install)

::: zone-end

## Create resource group

1. Sign in to Azure.

    ```azurecli
    az login
    ```

2. (Optional) Upgrade the Azure CLI to the latest version.

    ```azurecli
    az upgrade
    ```

3. Register required resource providers.

    ```azurecli
    az provider register --namespace Microsoft.App
    az provider register --namespace Microsoft.OperationalInsights
    ```

4. Create a resource group.

    ```azurecli
    az group create --name my-container-apps --location centralus
    ```

## Create the Container Apps environment

1. Create the container apps environment.

    ```azurecli
    az containerapp env create \
      --name my-container-apps-env \
      --resource-group my-resource-group \
      --location centralus
    ```

## Configure workload profile

Add a workload profile to the environment (required for premium ingress).

    ```azurecli
    az containerapp env workload-profile add \
      --resource-group my-resource-group \
      --name my-container-apps-env \
      --workload-profile-name Ingress-D4 \
      --workload-profile-type D4 \
      --min-nodes 2 \
      --max-nodes 4
    ```

Your workload profile must have at least two nodes to use premium ingress.

## Configure premium ingress

Add premium ingress settings to the environment.

    ```azurecli
    az containerapp env premium-ingress add \
      --resource-group my-resource-group \
      --name my-container-apps-env \
      --workload-profile-name Ingress-D4 \
      --termination-grace-period 500 \
      --request-idle-timeout 4 \
      --header-count-limit 100
    ```

The following table describes the parameters you can set when configuring premium ingress settings for your Container Apps environment.

| Parameter | Description | Default | Minimum | Maximum |
|--|--|--|--|--|
| `termination-grace-period` | The time (in seconds) to allow active connections to close before terminating the ingress. | n/a | 0 | 60 |
| `request-idle-limit` | The time (in minutes) a request can remain idle before being disconnected. | 4 | 4 | 30 |
| `header-count-limit` | The maximum number of HTTP headers allowed per request. | 100 | 1 | n/a |


Once configured, you see an output of the settings you just applied.

    ```json
    {
      "headerCountLimit": 100,
      "requestIdleTimeout": 4,
      "terminationGracePeriodSeconds": 500,
      "workloadProfileName": "Ingress-D4"
    }
    ```

## Update and manage premium ingress

- Update the premium ingress settings for the environment:

    ```azurecli
    az containerapp env premium-ingress update \
      --resource-group my-resource-group \
      --name my-container-apps-env \
      --workload-profile-name Ingress-D4 \
      --min-nodes 3 \
      --max-nodes 6 \
      --termination-grace-period 500 \
      --request-idle-timeout 4 \
      --header-count-limit 100
    ```

- Show the premium ingress settings for the environment:

    ```azurecli
    az containerapp env premium-ingress show \
      --resource-group my-resource-group \
      --name my-container-apps-env
    ```

- Remove the premium ingress settings for the environment:

    ```azurecli
    az containerapp env premium-ingress remove \
      --resource-group my-resource-group \
      --name my-container-apps-env
    ```

- Remove the workload profile from the environment:

    ```azurecli
    az containerapp env workload-profile remove \
      --resource-group my-resource-group \
      --name my-container-apps-env \
      --workload-profile-name Ingress-D4
    ```
