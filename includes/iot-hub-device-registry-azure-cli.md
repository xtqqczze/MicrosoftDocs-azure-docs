---
title: Create an IoT hub with Certificate Management in Azure Device Registry using Azure CLI
description: This article explains how to create an IoT hub with Azure Device Registry and Certificate Management integration using the Azure CLI.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
ms.topic: include
ms.date: 11/05/2025
---

## Create an IoT hub with ADR integration using Azure CLI

The setup process includes the following steps:

1. Assign an ADR role, setup the right privileges, and create a user-assigned managed identity.
1. Create an ADR namespace.
1. Create a credential and policy and associate them to the namespace.
1. Create an IoT Hub SKU with linked namespace.
1. Create a DPS with linked ADR namespace and Hub.
1. Sync your credential and policies to ADR namespace.
1. Create an enrollment group and link to your policy to enable device onboarding.

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group in your Azure subscription. If you want to create a new resource group, use the [az group create](/cli/azure/group#az-group-create) command:

  ```azurecli
  az group create --name <RESOURCE_GROUP_NAME> --location <REGION>
  ```

- Install [Azure CLI](/cli/azure/install-azure-cli) in your environment, or run `az upgrade` to ensure you have the latest version.
- Install the **preview Azure IoT CLI extension** to access the ADR and Certificate Management functionalities. To install the extension, complete the following steps:

    1. Download the preview [Azure IoT CLI extension](https://github.com/Azure/hubgen2-certmgmt/blob/feature/publicPreview/content/azure_iot-0.30.0a2-py3-none-any.whl). Don't change the **azure_iot-0.30.0a2-py3-none-any.whl** file name, otherwise the installation fails.
    1. Open a terminal window and sign in to your Azure account.
    
        ```azurecli-interactive
        az login
        ```

    1. Check for existing Azure CLI extension installations.
    
        ```azurecli-interactive
        az extension list
        ```
    
    1. Remove any existing azure-iot installations.
    
        ```azurecli-interactive
        az extension remove --name azure-iot
        ```
    
    1. Install the Azure IoT CLI preview extension that you downloaded. Replace `<local file path to azure_iot-0.30.0a2-py3-none-any.whl>` with the path to the downloaded whl file.
    
        ```azurecli-interactive
        az extension add --source <local file path to azure_iot-0.30.0a2-py3-none-any.whl> -y
        ```
    
    1. After the install, validate your azure-iot extension version is **0.30.0a2**.
    
        ```azurecli-interactive
        az extension list
        ```

## Prepare your environment

To prepare your environment to use Azure Device Registry, complete the following steps:

1. Open a terminal window.
1. To sign in to your Azure account, run `az login`.
1. To list all subscriptions and tenants you have access to, run `az account list`.
1. If you have access to multiple Azure subscriptions, set your active subscription:

    ```azurecli-interactive
    az account set --subscription "<your subscription name or id>"
    ```

1. To display your current account details, run `az account show`. Copy both of the following values from the output of the command, and save them to a safe location.

    - The `id` GUID. You use this value to provide your Subscription ID.
    - The `tenantId` GUID. You use this value to update your permissions using Tenant ID.

## Set up environment variables

To simplify the process of creating and managing resources, set up the following environment variables in your terminal session. Replace the placeholder values with your own values.

1. Set up your subscription ID, resource group name, and location. Check out the available locations in the [Supported regions](../articles/iot-hub/iot-hub-device-registry-overview.md#supported-regions) section.

    ```azurecli-interactive
    SUBSCRIPTION_ID="your-subscription-id"
    RESOURCE_GROUP="your-resource-group"
    LOCATION="your-adr/dps-location"
    HUB_LOCATION="your-hub-location"
    ```

1. Set up your resource names. The `USER_IDENTITY` and `ENROLLMENT_ID` values don't already exist, you need to define their names.

    ```azurecli-interactive
    NAMESPACE_NAME="your-adr-namespace-name"
    HUB_NAME="your-hub-name"
    DPS_NAME="your-dps-name"
    USER_IDENTITY="your-user-identity-name"
    ENROLLMENT_ID="your-enrollment-name"
    ```

    [!INCLUDE [iot-hub-pii-note-naming-hub](iot-hub-pii-note-naming-hub.md)]

1. Verify that the environment variables are set correctly by running the following command. If the variables are set correctly, the command outputs the values you set, otherwise it outputs a blank line.

    ```azurecli-interactive
    echo $HUB_NAME
    ```

## Configure your resource group, permissions, and managed identity

To create a resource group, role, and permissions for your IoT solution, complete the following steps:

1. Create a resource group to hold your resources:

    ```azurecli-interactive
    az group create --name $RESOURCE_GROUP --location $LOCATION
    ```

1. Assign a contributor role to IoT Hub on the resource group level. The `AppId` value, which is the principal ID for IoT Hub, is `89d10474-74af-4874-99a7-c23c2f643083` and it's the same for all Hub apps.

    ```azurecli-interactive
    az role assignment create --assignee "89d10474-74af-4874-99a7-c23c2f643083" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
    ```

1. Create a new user-assigned managed identity in the specific resource group and location to link the IoT Hub, DPS, and ADR.

    ```azurecli-interactive
    az identity create --name $USER_IDENTITY --resource-group $RESOURCE_GROUP --location $LOCATION
    ```

1. Retrieve the resource ID of the managed identity. You need the resource ID to assign roles, configure access policies, or link the identity to other resources.    

    ```azurecli-interactive
    UAMI_RESOURCE_ID=$(az identity show --name $USER_IDENTITY --resource-group $RESOURCE_GROUP --query id -o tsv)
    ```

## Set up an ADR namespace

Set up a new ADR namespace with a system-assigned managed identity. Creating namespace with system-assigned managed identity also creates a credential, known as root CA, and a default policy, known as intermediate CA. [Certificate Management](../articles/iot-hub/iot-hub-certificate-management-overview.md) uses these credentials and policies to onboard devices to the namespace.

> [!NOTE]
> Credentials are optional. You can also create a namespace without a managed identity by omitting the `--enable-credential-policy` and `--policy-name` flags.

1. Create a new ADR namespace. Your namespace `name` can only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, the name "msft-namespace" is valid. If you want to enable a system-assigned managed identity for the ADR namespace, add the `--enable-credential-policy` flag to the command and the policy name using the `--policy-name` flag. 

    ```azurecli-interactive
    az iot adr ns create --name $NAMESPACE_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --enable-credential-policy true --policy-name "PolicyName"
    ```

    > [!TIP]
    > You can also create a custom policy using the `az iot adr ns policy create` command. For more information, see [Create and manage namespaces](../articles/iot-hub/iot-hub-device-registry-namespaces.md#create-a-custom-policy-for-your-namespace).

    > [!NOTE]
    > The creation of the namespace with system-assigned managed identity might take up to 5 minutes.

1. Verify that the namespace with a system-assigned managed identity, or principal ID, is created.

    ```azurecli-interactive
    az iot adr ns show --name $NAMESPACE_NAME --resource-group $RESOURCE_GROUP
    ```

1. Verify that a credential named "default" and policy named "PolicyName" are created.

    ```azurecli-interactive
    az iot adr ns credential show --namespace $NAMESPACE_NAME --resource-group $RESOURCE_GROUP
    az iot adr ns policy show --namespace $NAMESPACE_NAME --resource-group $RESOURCE_GROUP --name "PolicyName"
    ```

    > [!NOTE]
    > If you don't assign a policy name, the policy is created with the name "default".

1. Retrieve the principal ID of the User-Assigned Managed Identity. This ID is needed to assign roles to the identity.

    ```azurecli-interactive
    UAMI_PRINCIPAL_ID=$(az identity show --name $USER_IDENTITY --resource-group $RESOURCE_GROUP --query principalId -o tsv)
    ```

1. Retrieve the resource ID of the ADR namespace. This ID is used as the scope when assigning the custom ADR role to the user-assigned managed identity.

    ```azurecli-interactive
    NAMESPACE_RESOURCE_ID=$(az iot adr ns show --name $NAMESPACE_NAME --resource-group $RESOURCE_GROUP --query id -o tsv)
    ```

1. Assign the **Azure Device Registry Contributor** role to the managed identity for the ADR namespace. This grants the managed identity the necessary permissions, scoped to the namespace.

    ```azurecli-interactive
    az role assignment create --assignee $UAMI_PRINCIPAL_ID --role "a5c3590a-3a1a-4cd4-9648-ea0a32b15137" --scope $NAMESPACE_RESOURCE_ID
    ```

## Create an IoT hub with ADR namespace integration

1. Create a new IoT hub instance linked to the ADR namespace and with the User-Assigned Identity.

    ```azurecli-interactive
    az iot hub create --name $HUB_NAME --resource-group $RESOURCE_GROUP --location $HUB_LOCATION --sku GEN2 --mi-user-assigned $UAMI_RESOURCE_ID --ns-resource-id $NAMESPACE_RESOURCE_ID --ns-identity-id $UAMI_RESOURCE_ID
    ```

1. Verify that the IoT hub has correct identity and ADR properties configured.

    ```azurecli-interactive
    az iot hub show --name $HUB_NAME --resource-group $RESOURCE_GROUP --query identity --output json
    ```

    > [!NOTE]
    > If you run into error or warning messages during role assignment, you need to manually assign the following roles to the hub for the ADR namespace's system-assigned identity:
    > 
    > 1. Retrieve the principal ID of the ADR Namespace's managed identity. This identity needs permissions to interact with the IoT hub.
    > 
    >  ```azurecli-interactive
    >  ADR_PRINCIPAL_ID=$(az iot adr ns show --name $NAMESPACE_NAME --resource-group $RESOURCE_GROUP --query identity.principalId -o tsv)
    >  ```
    > 1. Retrieve the resource ID of the IoT hub. This ID is used as the scope for role assignments.
    > 
    >  ```azurecli-interactive
    >  HUB_RESOURCE_ID=$(az iot hub show --name $HUB_NAME --resource-group $RESOURCE_GROUP --query id -o tsv)
    >  ```
    > 1. Assign the "Contributor" role to the ADR identity. This grants the ADR namespace's managed identity Contributor access to the IoT hub. This role allows broad access, including managing resources, but not assigning roles.
    >
    >  ```azurecli-interactive
    >  az role assignment create --assignee $ADR_PRINCIPAL_ID --role "Contributor" --scope $HUB_RESOURCE_ID
    >  ```
    > 1. Assign the "IoT Hub Registry Contributor" role to the ADR identity. This grants more specific permissions to manage device identities in the IoT hub. This is essential for ADR to register and manage devices in the hub.
    >
    >  ```azurecli-interactive
    >  az role assignment create --assignee $ADR_PRINCIPAL_ID --role "IoT Hub Registry Contributor" --scope $HUB_RESOURCE_ID
    >  ```

## Create a Device Provisioning Service with ADR namespace integration

1. Create a new Device Provisioning Service (DPS) instance linked to the ADR namespace with the User-Assigned Identity. Your DPS must be located in the same region as your ADR namespace.

    ```azurecli-interactive
    az iot dps create --name $DPS_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --mi-user-assigned $UAMI_RESOURCE_ID --ns-resource-id $NAMESPACE_RESOURCE_ID --ns-identity-id $UAMI_RESOURCE_ID
    ```

1. Verify that the DPS has correct identity and ADR properties configured.

    ```azurecli-interactive
    az iot dps show --name $DPS_NAME --resource-group $RESOURCE_GROUP --query identity --output json
    ```

## Link IoT Hub to the Device Provisioning Service

1. Link the IoT hub to DPS.

    ```azurecli-interactive
    az iot dps linked-hub create --dps-name $DPS_NAME --resource-group $RESOURCE_GROUP --hub-name $HUB_NAME
    ```

1. Verify that the IoT hub appears in the list of linked hubs for the DPS.

    ```azurecli-interactive
    az iot dps linked-hub list --dps-name $DPS_NAME --resource-group $RESOURCE_GROUP
    ```

## Run ADR credential synchronization

To enable IoT Hub to register the CA certificates and trust any issued leaf certificates, sync your credential and all its child policies to the ADR namespace.

```azurecli-interactive
az iot adr ns credential sync --namespace $NAMESPACE_NAME --resource-group $RESOURCE_GROUP
```

## Validate Hub Certificate

Validate that your IoT hub has registered its CA certificate.

```azurecli-interactive
az iot hub certificate list --hub-name $HUB_NAME --resource-group $RESOURCE_GROUP
```

## Create an enrollment group in DPS

To provision devices with leaf certificates, you need to create an enrollment group and assign it to the appropriate policy. The allocation-policy defines the onboarding authentication mechanism DPS uses before issuing a leaf certificate. The default attestation mechanism is a symmetric key.

> [!NOTE]
> If you created a policy with a different name from "default", ensure that you use that policy name after the `--credential-policy` parameter.

```azurecli-interactive
az iot dps enrollment-group create --dps-name $DPS_NAME --resource-group $RESOURCE_GROUP --enrollment-id $ENROLLMENT_ID --credential-policy default
```