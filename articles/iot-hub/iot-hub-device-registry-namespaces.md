---
title: Create and Manage your ADR Namespaces
titleSuffix: Azure IoT Hub
description: Learn how to create and manage your Azure Device Registry namespaces using the Azure portal and Azure CLI.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: overview
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, i want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---


# Create and manage your Azure Device Registry namespaces

**Applies to:** ![IoT Hub checkmark](media/iot-hub-version/yes-icon.png) IoT Hub Gen 2

Azure IoT Operations and IoT Hub uses namespaces to organize assets and devices. This article explains how to manage your Azure Device Registry (ADR) namespaces using the Azure portal and Azure CLI.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## [Azure portal](#tab/portal)

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group to hold your resources. You can create a new resource group or use an existing one. 

## Create a new namespace

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select **+ Create** to create a new namespace. Make sure to use the same resource group as your Arc-enabled Kubernetes cluster.
1. By default, the **Namespaces** page shows the namespaces in your subscription. Use the filters to view a subset of the namespaces, such as the namespaces in a specific resource group.

    :::image type="content" source="media/device-registry/azure-device-registry-namespaces.png" alt-text="Screenshot of Azure Device Registry namespaces page in the Azure portal." lightbox="media/device-registry/azure-device-registry-namespaces.png":::

## View Azure Device Registry in the Azure portal

1. The **Overview** page summarizes the number of assets, schema registries and namespaces in your subscription:

    :::image type="content" source="media/device-registry/azure-device-registry-overview.png" alt-text="Screenshot of Azure Device Registry overview page in the Azure portal." lightbox="media/device-registry/azure-device-registry-overview.png":::

    > [!NOTE]
    > Schema registries are only available if you have an Azure IoT Operations instance in your subscription. 

1. Go to the **Assets** page to view the assets in Azure Device Registry. By default, the **Assets** page shows the assets in all namespaces in your subscription. Use the filters to view a subset of the assets, such as the assets in a specific namespace or resource group:

    :::image type="content" source="media/device-registry/azure-device-registry-assets.png" alt-text="Screenshot of Azure Device Registry assets page in the Azure portal." lightbox="media/device-registry/azure-device-registry-assets.png":::

## [Azure CLI](#tab/cli)

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group to hold your resources. You can create a new resource group or use an existing one. If you want to create a new resource group, use the [az group create](/cli/azure/group#az-group-create) command:

   ```azurecli
   az group create --name <RESOURCE_GROUP_NAME> --location "<REGION>"
   ```

- Install the [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) and the [Azure IoT extension](https://learn.microsoft.com/cli/azure/ext/azure-iot/install).

## Create a new namespace

Run the `az iot ops ns create` command to create an Azure Device Registry namespace. Replace <my namespace name> with a unique name for your namespace.

```bash    
az iot ops ns create -n <my namespace name> -g $RESOURCE_GROUP
```

## Manage your namespaces

1. List all the ADR namespaces in your subscription:

    ```bash
    az iot adr ns list --resource-group "$RESOURCE_GROUP"
    ```

1. Show the details of a specific ADR namespace:

    ```bash
    az iot adr ns show --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Show the credentials associated with a specific ADR namespace, if applicable:

    ```bash
    az iot adr ns credential show --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. List all policies associated with a specific ADR namespace, if applicable:

    ```bash
    az iot adr ns policy list --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Show the details of a specific policy associated with a specific ADR namespace, if applicable:

    ```bash
    az iot adr ns policy show --name "policy-name" --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Create a custom policy. You can set the certificate subject and validity period for the policy. The following example creates a policy named "custom-policy" with a subject of "CN=TestDevice" and a validity period of 30 days.

     > [!NOTE]
     > The policy name must be unique within the namespace. If you try to create a policy with a name that already exists, you receive an error message.

     > [!NOTE]
     > The `cert-subject` value must be unique across all policies in the namespace. If you try to create a policy with a subject that already exists, you receive an error message.

     > [!NOTE]
     > The `cert-validity-days` value must be between 1 and 3650 days (10 years). If you try to create a policy with a validity period outside this range, you receive an error message.

    ```bash
    az iot adr ns policy create --name "custom-policy" --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --cert-subject "CN=TestDevice" --cert-validity-days "30"
    ```

## Delete namespace and related resources

When you no longer need the ADR namespace and its related resources, you can delete them to avoid incurring unnecessary costs. To delete your namespace, you must also delete the IoT hub Gen 2 and DPS instances linked to the namespace.

```bash
# Delete hub
az iot hub delete --name "$HUB_NAME" --resource-group "$RESOURCE_GROUP"
# Delete namespace
az iot adr ns delete --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
# Delete DPS 
az iot dps delete --name "$DPS_NAME" --resource-group "$RESOURCE_GROUP"
# Delete user assigned identity
az identity delete --name "$USER_IDENTITY" --resource-group "$RESOURCE_GROUP"
```

***
