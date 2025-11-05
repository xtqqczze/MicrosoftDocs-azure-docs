---
title: Create an IoT hub with Certificate Management in Azure Device Registry using Azure CLI
description: This article explains how to create an IoT hub with Azure Device Registry and Certificate Management integration using the Azure CLI.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
ms.topic: include
ms.date: 11/05/2025
---

## Overview

Use the Azure CLI commands to create an IoT hub with Azure Device Registry and Certificate Management integration.

The setup process in this article includes the following steps:

1. Assign an ADR role, setup the right privileges, and create a user-assigned managed identity.
1. Create an ADR namespace.
1. Create a credential and policy and associate them to the namespace.
1. Create an IoT Hub SKU with linked namespace.
1. Create a DPS with linked ADR namespace and Hub.
1. Sync your credential and policies to ADR namespace.
1. Create an enrollment group and link to your policy to enable device onboarding.

> [!IMPORTANT]
> During the preview period, IoT Hub with ADR and Certificate Management features enabled on top of IoT Hub are available **free of charge**. Device Provisioning Service (DPS) is billed separately and isn't included in the preview offer. For details on DPS pricing, see [Azure IoT Hub pricing](https://azure.microsoft.com/pricing/details/iot-hub/).

## Prepare your environment

To prepare your environment to use Azure Device Registry, complete the following steps:

1. Open a terminal window.
1. To sign in to your Azure account, run `az login`.
1. To list all subscriptions and tenants you have access to, run `az account list`.
1. If you have access to multiple Azure subscriptions, set your active subscription where your IoT devices will be created by running the following command.

    ```azurecli-interactive
    az account set --subscription "<your subscription name or ID>"
    ```

1. To display your current account details, run `az account show`. Copy both of the following values from the output of the command, and save them to a safe location.

    - The `id` GUID. You use this value to provide your Subscription ID.
    - The `tenantId` GUID. You use this value to update your permissions using Tenant ID.

## Configure your resource group, permissions, and managed identity

To create a resource group, role, and permissions for your IoT solution, complete the following steps:

1. Create a resource group to hold your resources:

    ```azurecli-interactive
    az group create --name <RESOURCE_GROUP_NAME> --location <REGION>
    ```

1. Assign a contributor role to IoT Hub on the resource group level. The `AppId` value, which is the principal ID for IoT Hub, is `89d10474-74af-4874-99a7-c23c2f643083` and it's the same for all Hub apps.

    ```azurecli-interactive
    az role assignment create --assignee "89d10474-74af-4874-99a7-c23c2f643083" --role "Contributor" --scope "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>"
    ```

1. Create a new user-assigned managed identity in the specific resource group and location to link the IoT Hub, DPS, and ADR.

    ```azurecli-interactive
    az identity create --name <USER_IDENTITY> --resource-group <RESOURCE_GROUP_NAME> --location <REGION>
    ```

1. Retrieve the resource ID of the managed identity. You need the resource ID to assign roles, configure access policies, or link the identity to other resources.    

    ```azurecli-interactive
    UAMI_RESOURCE_ID=$(az identity show --name <USER_IDENTITY> --resource-group <RESOURCE_GROUP_NAME> --query id -o tsv)
    ```

## Create a new ADR namespace

Set up a new ADR namespace with a system-assigned managed identity. Creating namespace with system-assigned managed identity also creates a credential, known as root CA, and a default policy, known as intermediate CA. [Certificate Management](../articles/iot-hub/iot-hub-certificate-management-overview.md) uses these credentials and policies to onboard devices to the namespace.

> [!NOTE]
> Credentials are optional. You can also create a namespace without a managed identity by omitting the `--enable-credential-policy` and `--policy-name` flags.

1. Create a new ADR namespace. Your namespace `name` can only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, the name "msft-namespace" is valid. To enable a system-assigned managed identity for the ADR namespace, the `--enable-credential-policy` command creates credential (Root CA) for this namespace and `--policy-name` command creates a policy (issuing CA) that can issue certificates with a validity of 30 days.

    ```azurecli-interactive
    az iot adr ns create --name <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME> --location <REGION> --enable-credential-policy true --policy-name <POLICY_NAME>
    ```

    > [!NOTE]
    > The creation of the namespace with system-assigned managed identity might take up to 5 minutes.

1. You can optionally create a custom policy using the `az iot adr ns policy create` command. Set the name, certificate subject, and validity period for the policy following these rules:

    - The policy `name` value must be unique within the namespace. If you try to create a policy with a name that already exists, you receive an error message.
    - The certificate subject `cert-subject` value must be unique across all policies in the namespace. If you try to create a policy with a subject that already exists, you receive an error message.
    - The validity period `cert-validity-days` value must be between 1 and 3650 days (10 years). If you try to create a policy with a validity period outside this range, you receive an error message.
    
    The following example creates a policy named "custom-policy" with a subject of "CN=TestDevice" and a validity period of 30 days. 

    ```azurecli-interactive
    az iot adr ns policy create --name "custom-policy" --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME> --cert-subject "CN=TestDevice" --cert-validity-days "30"
    ```

1. Verify that the namespace with a system-assigned managed identity, or principal ID, is created.

    ```azurecli-interactive
    az iot adr ns show --name <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME>
    ```

1. Verify that a credential named "default" and policy named "PolicyName" are created.

    ```azurecli-interactive
    az iot adr ns credential show --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME>
    az iot adr ns policy show --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME> --name <POLICY_NAME>
    ```

    > [!NOTE]
    > If you don't assign a policy name, the policy is created with the name "default".

## Assign UAMI role to access the ADR namespace

To allow the user-assigned managed identity (UAMI) to access the ADR namespace, you need to assign the **Azure Device Registry Contributor** role to the UAMI for the ADR namespace.

1. Retrieve the principal ID of the User-Assigned Managed Identity. This ID is needed to assign roles to the identity.

    ```azurecli-interactive
    UAMI_PRINCIPAL_ID=$(az identity show --name <USER_IDENTITY> --resource-group <RESOURCE_GROUP> --query principalId -o tsv)
    ```

1. Retrieve the resource ID of the ADR namespace. This ID is used as the scope when assigning the custom ADR role to the user-assigned managed identity.

    ```azurecli-interactive
    NAMESPACE_RESOURCE_ID=$(az iot adr ns show --name <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP> --query id -o tsv)
    ```

1. Assign the **Azure Device Registry Contributor** role to the managed identity for the ADR namespace. This grants the managed identity the necessary permissions, scoped to the namespace.

    ```azurecli-interactive
    az role assignment create --assignee $UAMI_PRINCIPAL_ID --role "a5c3590a-3a1a-4cd4-9648-ea0a32b15137" --scope $NAMESPACE_RESOURCE_ID
    ```

## Create an IoT hub with ADR namespace integration

1. Create a new IoT hub instance linked to the ADR namespace and with the user-assigned identity.

    ```azurecli-interactive
    az iot hub create --name <HUB_NAME> --resource-group <RESOURCE_GROUP> --location <HUB_LOCATION> --sku GEN2 --mi-user-assigned $UAMI_RESOURCE_ID --ns-resource-id $NAMESPACE_RESOURCE_ID --ns-identity-id $UAMI_RESOURCE_ID
    ```

    [!INCLUDE [iot-hub-pii-note-naming-hub](iot-hub-pii-note-naming-hub.md)]

1. Verify that the IoT hub has correct identity and ADR properties configured.

    ```azurecli-interactive
    az iot hub show --name <HUB_NAME> --resource-group <RESOURCE_GROUP> --query identity --output json
    ```
## Assign IoT Hub roles to access the ADR namespace

1. Retrieve the principal ID of the ADR Namespace's managed identity. This identity needs permissions to interact with the IoT hub.

    ```azurecli-interactive
    ADR_PRINCIPAL_ID=$(az iot adr ns show --name <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP> --query identity.principalId -o tsv)
    ```
1. Retrieve the resource ID of the IoT hub. This ID is used as the scope for role assignments.

    ```azurecli-interactive
    HUB_RESOURCE_ID=$(az iot hub show --name <HUB_NAME> --resource-group <RESOURCE_GROUP> --query id -o tsv)
    ```
1. Assign the "Contributor" role to the ADR identity. This grants the ADR namespace's managed identity Contributor access to the IoT hub. This role allows broad access, including managing resources, but not assigning roles.

    ```azurecli-interactive
    az role assignment create --assignee $ADR_PRINCIPAL_ID --role "Contributor" --scope $HUB_RESOURCE_ID
    ```
1. Assign the "IoT Hub Registry Contributor" role to the ADR identity. This grants more specific permissions to manage device identities in the IoT hub. This is essential for ADR to register and manage devices in the hub.

    ```azurecli-interactive
    az role assignment create --assignee $ADR_PRINCIPAL_ID --role "IoT Hub Registry Contributor" --scope $HUB_RESOURCE_ID
    ```

## Create a Device Provisioning Service instance with ADR namespace integration

1. Create a new DPS instance linked to your ADR namespace created in the previous sections. Your DPS instance must be located in the same region as your ADR namespace.

    ```azurecli-interactive
    az iot dps create --name <DPS_NAME> --resource-group <RESOURCE_GROUP> --location <LOCATION> --mi-user-assigned $UAMI_RESOURCE_ID --ns-resource-id $NAMESPACE_RESOURCE_ID --ns-identity-id $UAMI_RESOURCE_ID
    ```

1. Verify that the DPS has the correct identity and ADR properties configured.

    ```azurecli-interactive
    az iot dps show --name <DPS_NAME> --resource-group <RESOURCE_GROUP> --query identity --output json
    ```

## Link your IoT hub to the Device Provisioning Service instance

1. Link the IoT hub to DPS.

    ```azurecli-interactive
    az iot dps linked-hub create --dps-name <DPS_NAME> --resource-group <RESOURCE_GROUP> --hub-name <HUB_NAME>
    ```

1. Verify that the IoT hub appears in the list of linked hubs for the DPS.

    ```azurecli-interactive
    az iot dps linked-hub list --dps-name <DPS_NAME> --resource-group <RESOURCE_GROUP>
    ```

## Run ADR credential synchronization

To enable IoT Hub to register the CA certificates and trust any issued leaf certificates, sync your credential and all its child policies to the ADR namespace.

```azurecli-interactive
az iot adr ns credential sync --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP>
```

## Validate the hub Certificate

Validate that your IoT hub has registered its CA certificate.

```azurecli-interactive
az iot hub certificate list --hub-name <HUB_NAME> --resource-group <RESOURCE_GROUP>
```

## Create an enrollment group in DPS

To provision devices with leaf certificates, you need to create an enrollment group and assign it to the appropriate policy. The allocation-policy defines the onboarding authentication mechanism DPS uses before issuing a leaf certificate. The default attestation mechanism is a symmetric key.

> [!NOTE]
> If you created a policy with a different name from "default", ensure that you use that policy name after the `--credential-policy` parameter.

```azurecli-interactive
az iot dps enrollment-group create --dps-name <DPS_NAME> --resource-group <RESOURCE_GROUP> --enrollment-id <ENROLLMENT_ID> --credential-policy <POLICY_NAME>
```

Your IoT hub with ADR and Certificate Management integration is now set up and ready to use.

## Manage and clean up resources

### Manage your namespaces

1. List all namespaces in your resource group.

    ```azurecli-interactive
    az iot adr ns list --resource-group <RESOURCE_GROUP_NAME>
    ```

1. Show details of a specific namespace.

    ```azurecli-interactive
    az iot adr ns show --name <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME>
    ```

1. List all policies in your namespace.

    ```azurecli-interactive
    az iot adr ns policy list --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME>
    ```

1. Show details of a specific policy.

    ```azurecli-interactive
    az iot adr ns policy show --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME> --name <POLICY_NAME>
    ```

1. List all credentials in your namespace.

    ```azurecli-interactive
    az iot adr ns credential list --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME>
    ```

### Disable devices

1. List all devices in your IoT hub.

    ```azurecli-interactive
    az iot hub device-identity list --hub-name <HUB_NAME> --resource-group <RESOURCE_GROUP_NAME>
    ```

1. Disable a device by updating its status to `disabled`. Make sure to replace `<MY_DEVICE_ID>` with the device ID you want to disable.

    ```azurecli-interactive
    az iot hub device-identity update --hub-name <HUB_NAME> --resource-group <RESOURCE_GROUP_NAME> -d <MY_DEVICE_ID> --status disabled
    ```

1. Run the device again and verify that it is unable to connect to an IoT Hub.

### Create a custom policy

Create a custom policy using the `az iot adr ns policy create` command. Set the name, certificate subject, and validity period for the policy following these rules:

- The policy `name` value must be unique within the namespace. If you try to create a policy with a name that already exists, you receive an error message.
- The certificate subject `cert-subject` value must be unique across all policies in the namespace. If you try to create a policy with a subject that already exists, you receive an error message.
- The validity period `cert-validity-days` value must be between 1 and 3650 days (10 years). If you try to create a policy with a validity period outside this range, you receive an error message.

The following example creates a policy named "custom-policy" with a subject of "CN=TestDevice" and a validity period of 30 days. 

    ```azurecli-interactive
    az iot adr ns policy create --name "custom-policy" --namespace <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME> --cert-subject "CN=TestDevice" --cert-validity-days "30"
    ```

### Delete resources

To delete your ADR namespace, you must first delete any IoT hubs and DPS instances linked to the namespace.

```azurecli-interactive
az iot hub delete --name <HUB_NAME> --resource-group <RESOURCE_GROUP_NAME>
az iot adr ns delete --name <NAMESPACE_NAME> --resource-group <RESOURCE_GROUP_NAME>
az iot dps delete --name <DPS_NAME> --resource-group <RESOURCE_GROUP_NAME> 
az identity delete --name <USER_IDENTITY> --resource-group <RESOURCE_GROUP_NAME>
```


