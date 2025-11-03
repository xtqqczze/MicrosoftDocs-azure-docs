---
title: Create and Manage ADR Namespaces
titleSuffix: Azure IoT Hub
description: Learn how to create and manage your Azure Device Registry namespaces using the Azure portal and Azure CLI.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, i want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---

# Create and manage Azure Device Registry namespaces

Azure IoT Operations and IoT Hub uses namespaces to organize assets and devices. This article explains how to manage your Azure Device Registry (ADR) namespaces using the Azure portal and Azure CLI.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Prerequisites

### [Azure portal](#tab/portal)

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group to hold your resources. You can create a new resource group or use an existing one. 

### [Azure CLI](#tab/cli)

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- Install [Azure CLI](/cli/azure/install-azure-cli) in your environment, or run `az upgrade` to ensure you have the latest version.
- Install the [IoT extension for Azure CLI](https://github.com/Azure/azure-cli).
- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group in your Azure subscription. If you want to create a new resource group, use the [az group create](/cli/azure/group#az-group-create) command:

  ```azurecli
  az group create --name <RESOURCE_GROUP_NAME> --location <REGION>
  ```

***

## Create a new namespace

### [Azure portal](#tab/portal)

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

### [Azure CLI](#tab/cli)

Run the `az iot ops ns create` command to create an Azure Device Registry namespace. Replace `<my namespace name>` with a unique name for your namespace.

```bash    
az iot ops ns create -n <my namespace name> -g $RESOURCE_GROUP
```

***

## Manage your namespaces

### [Azure portal](#tab/portal)

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Overview** page to view the number of assets, schema registries and namespaces in your subscription:

    :::image type="content" source="media/device-registry/azure-device-registry-overview.png" alt-text="Screenshot of Azure Device Registry overview page in the Azure portal." lightbox="media/device-registry/azure-device-registry-overview.png":::

    > [!NOTE]
    > Schema registries are only available if you have an Azure IoT Operations instance in your subscription. 

### [Azure CLI](#tab/cli)

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

***

## Assign your namespace to an DPS instance

If you already have a Device Provisioning Service (DPS) instance, you can link it to your ADR namespace to enable certificate management for your devices.

### [Azure portal](#tab/portal)

1. In the [Azure portal](https://portal.azure.com), search for and select **Device Provisioning Service**.
1. In the **Overview** page, select **Click here to add a namespace**.

    :::image type="content" source="media/device-registry/namespace-linking-1.png" alt-text="Screenshot of Azure Device Registry namespace linking page in the Azure portal." lightbox="media/device-registry/namespace-linking-1.png":::

1. A pane appears where you can select the ADR namespace you want to link to your DPS instance.
1. Select the namespace from the dropdown list. 
1. Select a user-assigned managed identity to link to your DPS instance. This identity is used to securely access other Azure resources, such as ADR namespace. If you don't have a user-assigned managed identity, you can create one in the Azure portal. For more information, see [Create a user-assigned managed identity in the Azure portal](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal).
1. Select **Add** to link the namespace to your DPS instance.


    :::image type="content" source="media/device-registry/namespace-linking-2.png" alt-text="Screenshot of Azure Device Registry namespace linking an existing DPS instance in the Azure portal." lightbox="media/device-registry/namespace-linking-2.png":::

### [Azure CLI](#tab/cli)

TO DO

***

## Create a custom policy for your namespace

### [Azure portal](#tab/portal)

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to create a policy for.
1. In the namespace page, under **Namespace resources**, select **Credential policies (Preview)**.

    :::image type="content" source="media/device-registry/custom-policy.png" alt-text="Screenshot of Azure Device Registry custom policy page in the Azure portal." lightbox="media/device-registry/custom-policy.png":::

1. Select **Enable** to enable credential policies for your namespace, if you haven't already done so.
1. In the **Credential policies** page, select **+ Create** to create a new policy.
1. A pane appears where you can configure the policy settings. In the **Basics** tab, complete the fields as follows:
    
    | Property | Value |    
    | -------- | ----- |
    | **Name** | Enter a unique name for your policy. The name must be between 3 and 50 alphanumeric characters and can include hyphens (`'-'`). |
    | **Validity period (days)** | Enter the number of days the issued certificates are valid. The validity period must be between 1 and 3650 days (10 years). |

1. Select **Review + create** to review your settings.
1. The new policy appears in the list of policies for your namespace. You can select the policy to view its details.
1. In the policy overview page, you can see the policy name, validity period, and status, which should be enabled.


> [!NOTE]
> Editing or disabling a policy isn't supported in public preview.

### [Azure CLI](#tab/cli)

1. List all policies associated with a specific ADR namespace:

    ```bash
    az iot adr ns policy list --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Show the details of a specific policy associated with a specific ADR namespace:

    ```bash
    az iot adr ns policy show --name "policy-name" --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Create a custom policy. Set the name, certificate subject, and validity period for the policy following these rules:

    - The policy `name` value must be unique within the namespace. If you try to create a policy with a name that already exists, you receive an error message.
    - The certificate subject `cert-subject` value must be unique across all policies in the namespace. If you try to create a policy with a subject that already exists, you receive an error message.

    - The validity period `cert-validity-days` value must be between 1 and 3650 days (10 years). If you try to create a policy with a validity period outside this range, you receive an error message.
    
    The following example creates a policy named "custom-policy" with a subject of "CN=TestDevice" and a validity period of 30 days. 

    ```bash
    az iot adr ns policy create --name "custom-policy" --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --cert-subject "CN=TestDevice" --cert-validity-days "30"
    ```

***


## Delete a namespace

When you no longer need the ADR namespace and its related resources, you can delete them to avoid incurring unnecessary costs.

### [Azure portal](#tab/portal)

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to delete.
1. In the namespace page, select **Delete**.

    :::image type="content" source="media/device-registry/namespace-delete.png" alt-text="Screenshot of the namespace page in Azure portal that shows the delete option." lightbox="media/device-registry/namespace-delete.png":::


### [Azure CLI](#tab/cli)

Run the `az iot adr ns delete` command to delete an Azure Device Registry namespace. Replace `$NAMESPACE_NAME` with the name of your namespace.

```bash
az iot adr ns delete --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
```
***




