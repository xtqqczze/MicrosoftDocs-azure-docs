---
title: Create and Manage ADR Namespaces
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


# Create and manage Azure Device Registry namespaces

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

1. A pane appears where you can configure the namespace settings. In the **Basics** tab, complete the fields as follows:
    
    | Property | Value |    
    | -------- | ----- |
    | **Subscription** | Select the subscription to use for your namespace. |
    | **Resource group** | Select a resource group or create a new one. To create a new one, select **Create new** and fill in the name you want to use.|
    | **Name** | Enter a name for your namespace. Your namespace name can only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, the name "msft-namespace" is valid.|

1. Select **Next: Identity** to continue creating your namespace.
1. (Optional) In the **Identity** tab, you can choose to enable a system-assigned managed identity and a credential resource for your namespace. To enable these features, toggle the switch to **Enabled**. For more information about how ADR works with managed identities and credential resources, see [What is Certificate Management](iot-hub-certificate-management-overview.md).

    - Managed identities allow your namespace to authenticate to Azure services without storing credentials in your code. 
    - Credential resources securely store and manage device authentication credentials, such as API keys or certificates, for devices connecting to your namespace. When you enable this feature, you can set policies to control how certificates are issued and managed for your devices.
    
    > [!IMPORTANT]
    > Credential resources can't be disabled after the namespace is created.

1. Select **Next: Tags** to continue creating your namespace.
1. In the **Tags** tab, you can add tags to your namespace to organize and categorize your resources. Tags are key-value pairs that help you manage and identify your resources.
1. Select **Next: Review + create** to review your settings.
1. Select **Create** to create the namespace.

## Connect an existing IoT hub to your namespace

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to link to an existing IoT hub.
1. In the namespace page, under **Resources**, select **IoT hubs**.
1. In the **IoT hubs** page, you filter the list of IoT hubs by subscription and resource group. 
1. Select the IoT hub you want to link to your namespace.
1. Select **Connect hub**.

    :::image type="content" source="media/device-registry/link-existing-hub.png" alt-text="Screenshot of the namespaces page in the Azure portal that shows how to connect an existing IoT hub to a namespace." lightbox="media/device-registry/link-existing-hub.png":::

## Manage your namespaces

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Overview** page to view the number of assets, schema registries and namespaces in your subscription:

    :::image type="content" source="media/device-registry/azure-device-registry-overview.png" alt-text="Screenshot of Azure Device Registry overview page in the Azure portal." lightbox="media/device-registry/azure-device-registry-overview.png":::

    > [!NOTE]
    > Schema registries are only available if you have an Azure IoT Operations instance in your subscription. 

1. Go to the **Assets** page to view the assets in Azure Device Registry. By default, the **Assets** page shows the assets in all namespaces in your subscription. Use the filters to view a subset of the assets, such as the assets in a specific namespace or resource group:

    :::image type="content" source="media/device-registry/azure-device-registry-assets.png" alt-text="Screenshot of Azure Device Registry assets page in the Azure portal." lightbox="media/device-registry/azure-device-registry-assets.png":::

## Enable a credential resource for your namespace

Credential resources allow you to manage device authentication and authorization for devices connecting to your namespace. When you enable a credential resource, you can set up policies to control how certificates are issued and managed for your devices. 

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to enable a credential resource for.
1. In the namespace page, under **Settings**, select **Credentials**.
1. In the **Credentials** page, select **Enable**.

## Create a new policy

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to create a policy for.
1. In the namespace page, under **Resources**, select **Policies**.
1. In the **Policies** page, select **+ Create** to create a new policy.
1. A pane appears where you can configure the policy settings. In the **Basics** tab, complete the fields as follows:
    
    | Property | Value |    
    | -------- | ----- |
    | **Name** | Enter a unique name for your policy. The name must be between 3 and 50 alphanumeric characters and can include hyphens (`'-'`). |
    | **Enrollment group**| Select the enrollment group to associate with this policy. The enrollment group defines the attestation mechanism and onboarding process for devices using this policy. |
    | **Validity period (days)** | Enter the number of days the issued certificates are valid. The validity period must be between 1 and 3650 days (10 years). |
    | **Interval (percentage)** | Enter the percentage of the validity period after which a certificate renewal should be initiated. For example, if you set this value to 80 and the validity period is 100 days, the renewal process starts after 80 days. |

1. Select **Review + create** to review your settings.
1. The new policy appears in the list of policies for your namespace. If you enabled a credential resource for your namespace, the policy is listed as *Enabled*.

> [!NOTE]
> Editing or disabling a policy isn't supported in public preview.

## Sync policies to IoT hubs

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to sync policies for.
1. In the namespace page, under **Resources**, select **Policies**.
1. In the **Policies** page, you can view your policies, validity periods, intervals, and status.
1. Select the policies you want to sync. You can sync more than one policy at a time.
1. Select **Sync policies**.

    > [!NOTE]
    > If you select to sync more than one policy, policies are synced to their respective IoT hubs.

1. In the **Sync policies** pane, review the policies to be synced and select **Sync**.


## [Azure CLI](#tab/cli)

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- Install [Azure CLI](/cli/azure/install-azure-cli) in your environment, or run `az upgrade` to ensure you have the latest version.
- Install the [IoT extension for Azure CLI](https://github.com/Azure/azure-cli).
- A resource group to hold your resources. You can create a new resource group or use an existing one. If you want to create a new resource group, use the [az group create](/cli/azure/group#az-group-create) command:

   ```azurecli
   az group create --name <RESOURCE_GROUP_NAME> --location "<REGION>"
   ```

## Create a new namespace

Run the `az iot ops ns create` command to create an Azure Device Registry namespace. Replace `<my namespace name>` with a unique name for your namespace.

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
