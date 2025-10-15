---
title: Set Up Azure Device Registry
titleSuffix: Azure IoT Hub
description: This article explains how to set up and manage devices using Azure Device Registry in Azure IoT Hub.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, I want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---

# Set up and manage devices with Azure Device Registry

Azure Device Registry (ADR) enables the cloud and edge management of devices across multiple IoT solutions using namespaces. This article explains how to set up your IoT hub with Azure Device Registry through either a script or manual steps.

For more information, see [What is Azure Device Registry?](iot-hub-device-registry-overview.md).

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

> [!NOTE]
> Azure Device Registry is currently available with Azure IoT Operations and Azure IoT Hub Gen 2 (Preview) instances only.

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- Install [Azure CLI](/cli/azure/install-azure-cli) in your environment, or run `az upgrade` to ensure you have the latest version.
- Install the [IoT extension for Azure CLI](https://github.com/Azure/azure-cli).

## Set up your IoT hub with Azure Device Registry

To set up your IoT hub with Azure Device Registry (ADR), you can use either a script or manual steps. The following sections provide both options.

### [Script](#tab/script)

#### Prepare Your Environment

1. Navigate to the [GitHub repository](https://github.com/Azure/hubgen2-certmgmt/tree/main/Scripts) and download the entire folder, Scripts, which contains the script file (.ps1) and the role template (.json).
1. Place the script, role template, and the .whl files in your working folder and confirm they are accessible. Your working folder is the directory that holds all of your files.

#### Customize the script variables

Set values for the following variables in the variables section

- `TenantId`: Your tenant ID. You can find this value by running `az account show` in your terminal.
- `SubscriptionId`: Your subscription ID. You can find this value by running `az account show` in your terminal.
- `ResourceGroup`: The name of your resource group.
- `Location`: The Azure region where you want to create your resources. Check out the available locations in the [Supported regions](iot-hub-device-registry-overview.md#supported-regions) section.
- `NamespaceName`: Your namespace name may only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, "msft-namespace" is a valid name.
- `HubName`: Your hub name can only contain lowercase letters and numerals.
- `DpsName`: The name of your Device Provisioning Service.
- `UserIdentity`: The user-assigned managed identity for your resources.
- `WorkingFolder`: The local folder where your scripts and templates are located.

#### Run the script interactively

1. Run the script in **PowerShell 7+** by navigating to the folder and running `.\cmsSetupCli.ps1`.
1. If you run into an execution policy issue, try running `powershell -ExecutionPolicy Bypass -File .\cmsSetupCli.ps1`.
1. Follow the guided prompts:

    - Press `Enter` to proceed with a step
    - Press `s` or `S` to skip a step
    - Press `Ctrl` + `C` to abort

> [!NOTE]
> The creation of your ADR Namespace, IoT Hub, DPS, and other resources may take up to 5 minutes each.

#### Monitor execution and validate the resources

1. The script continues execution when warnings are encountered and only stops if a command returns a non-zero exit code. Monitor the console for red **ERROR** messages, which indicate issues that require attention.
1. Once the script completes, validate the creation of your resources:

    - IoT Hub
    - DPS
    - ADR Namespace
    - User-Assigned Managed Identity (UAMI)
    - Custom Role Assignments

### [Manual steps](#tab/manual-steps)

#### Prepare your environment

To prepare your environment to use Azure Device Registry, complete the following steps:

1. Open a terminal window.
1. To sign in to your Azure account, run `az login`.
1. To list all subscriptions and tenants you have access to, run `az account list`.
1. If you have access to multiple Azure subscriptions, set your active subscription:

    ```bash
    az account set --subscription "<your subscription name or id>"
    ```

1. To display your current account details, run `az account show`. Copy both of the following values from the output of the command, and save them to a safe location.

    - The `id` GUID. You use this value to provide your Subscription ID.
    - The `tenantId` GUID. You use this value to update your permissions using Tenant ID.

#### Set up the environment variables

To simplify the process of creating and managing resources, set up the following environment variables in your terminal session. Replace the placeholder values with your own values.

1. Set up your subscription ID, resource group name, and location. Check out the available locations in the [Supported regions](iot-hub-device-registry-overview.md#supported-regions) section.

    ```bash
    SUBSCRIPTION_ID="your-subscription-id"
    RESOURCE_GROUP="your-resource-group"
    LOCATION="your-adr/dps-location"
    HUB_LOCATION="your-hub-location"
    ```

1. Set up your resource names. The `USER_IDENTITY`, `CUSTOM_ROLE_NAME`, and `ENROLLMENT_ID` values don't already exist, you need to define their names.

    ```bash
    NAMESPACE_NAME="your-adr-namespace-name"
    HUB_NAME="your-hub-name"
    DPS_NAME="your-dps-name"
    USER_IDENTITY="your-user-identity-name"
    CUSTOM_ROLE_NAME="your-custom-role-name"
    ENROLLMENT_ID="your-enrollment-name"
    ```

1. Verify that the environment variables are set correctly by running the following command:

    ```bash
    echo $HUB_NAME
    ```

#### Configure your group, role, and permissions

To create a resource group, role, and permissions for your IoT solution, complete the following steps:

1. Create a resource group to hold your resources:

    ```bash
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
    ```

1. Create a **custom ADR role** that assigns a superset of IoT Hub and Device Provisioning Service (DPS) permissions to the principal. The custom ADR role allows you to share one identity between IoT Hub and DPS that has full permissions to the ADR namespace. Ensure that the name of this role is unique. 

    If your resources are all in the same resource group, consider creating this role at the resource group level. If your resources are divided between different resources, you need a subscription level role. The following are example scopes for assignable scopes:

    - subscription level: `/subscriptions/$SUBSCRIPTION_ID`
    - resource group level: `/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP`
    
    > [!NOTE]
    > Depending on your Bash configuration, you may be required to remove the "/" before the subscriptions within the AssignableScopes. If this is true, you must do this each time you reference this path.

    ```bash
    az role definition create --role-definition '{
      "Name": "'$CUSTOM_ROLE_NAME'",
      "Description": "Custom role for ADR namespace integration",
      "Actions": [
        "Microsoft.DeviceRegistry/namespaces/devices/read",
        "Microsoft.DeviceRegistry/namespaces/devices/write", 
        "Microsoft.DeviceRegistry/namespaces/read",
        "Microsoft.DeviceRegistry/namespaces/write",
        "Microsoft.DeviceRegistry/namespaces/credentials/read",
        "Microsoft.DeviceRegistry/namespaces/credentials/policies/read"
      ],
      "AssignableScopes": ["/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"]
    }'
    ```

    If this succeeds, you see a JSON output with your permissions, role name, role type, and assignable scopes.

1. Assign a contributor role to IoT Hub on the resource group level. The `AppId` value, which is the principal ID for IoT Hub, is `89d10474-74af-4874-99a7-c23c2f643083` and it's the same for all Hub apps.

    ```bash
    az role assignment create --assignee "89d10474-74af-4874-99a7-c23c2f643083" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
    ```

1. Create a new user-assigned managed identity in the specific resource group and location to link the IoT Hub, DPS, and ADR.

    ```bash
    az identity create --name "$USER_IDENTITY" --resource-group "$RESOURCE_GROUP" --location "$LOCATION"
    ```

1. Retrieve the resource ID of the managed identity. You need the resource ID to assign roles, configure access policies, or link the identity to other resources.    

    ```bash
    UAMI_RESOURCE_ID=$(az identity show --name "$USER_IDENTITY" --resource-group "$RESOURCE_GROUP" --query id -o tsv)
    ```

#### Set up an ADR namespace

Set up a new ADR namespace with a system-assigned managed identity. Creating this namespace also creates a credential, known as root CA, and a default policy, known as intermediate CA.

1. Create a new ADR namespace. Your namespace `name` may only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, the name "msft-namespace" is valid. 

    ```bash
    az iot adr ns create --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --location "$LOCATION"
    ```

    > [!NOTE]
    > The creation of the namespace with credentials may take up to 5 minutes.

1. Verify that the namespace with a system-assigned managed identity, or principal ID, is created.

    ```bash
    az iot adr ns show --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Verify that a credential named "default" and policy named "default" are created.

    ```bash
    az iot adr ns credential show --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    az iot adr ns policy show --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --name "default"
    ```    

1. Retrieve the principal ID of the User-Assigned Managed Identity. This ID is needed to assign roles to the identity.
    
    ```bash
    UAMI_PRINCIPAL_ID=$(az identity show --name "$USER_IDENTITY" --resource-group "$RESOURCE_GROUP" --query principalId -o tsv)
    ```

1. Retrieve the resource ID of the ADR namespace. This ID is used as the scope when assigning the custom ADR role to the user-assigned managed identity.

    ```bash
    NAMESPACE_RESOURCE_ID=$(az iot adr ns show --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --query id -o tsv)
    ```

1. Assign the custom ADR role to the user-assigned managed identity for the ADR namespace. This grants the managed identity the permissions defined in the custom role, scoped to the namespace.

    ```bash
    az role assignment create --assignee "$UAMI_PRINCIPAL_ID" --role "$CUSTOM_ROLE_NAME" --scope "$NAMESPACE_RESOURCE_ID"
    ```

#### Create an IoT hub with ADR namespace integration

1. Create a new IoT Hub Gen 2 instance linked to the ADR namespace and with the User-Assigned Identity.

    ```bash
    az iot hub create --name "$IOT_HUB_NAME" --resource-group "$RESOURCE_GROUP" --location "$LOCATION" --sku S1 --enable-file-upload true --assign-identity "$UAMI_RESOURCE_ID"
    ```

1. Verify that the IoT hub has correct identity and ADR properties configured.

    ```bash
    az iot hub show --name "$HUB_NAME" --resource-group "$RESOURCE_GROUP" --query identity --output json
    ```

    > [!NOTE]
    > If you run into error or warning messages during role assignment, you need to manually assign the following roles to the hub for the ADR namespace's system-assigned identity:
    > 
    > 1. Retrieve the principal ID of the ADR Namespace's managed identity. This identity needs permissions to interact with the IoT hub.
    > 
    >  ```bash
    >  ADR_PRINCIPAL_ID=$(az iot adr ns show --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --query identity.principalId -o tsv)
    >  ```
    > 1. Retrieve the resource ID of the IoT hub. This ID is used as the scope for role assignments.
    > 
    >  ```bash
    >  HUB_RESOURCE_ID=$(az iot hub show --name "$HUB_NAME" --resource-group "$RESOURCE_GROUP" --query id -o tsv)
    >  ```
    > 1. Assign the "Contributor" role to the ADR identity. This grants the ADR namespace's managed identity Contributor access to the IoT hub. This role allows broad access, including managing resources, but not assigning roles.
    >
    >  ```bash
    >  az role assignment create --assignee "$ADR_PRINCIPAL_ID" --role "Contributor" --scope "$HUB_RESOURCE_ID"
    >  ```
    > 1. Assign the "IoT Hub Registry Contributor" role to the ADR identity. This grants more specific permissions to manage device identities in the IoT hub. This is essential for ADR to register and manage devices in the hub.
    >
    >  ```bash
    >  az role assignment create --assignee "$ADR_PRINCIPAL_ID" --role "IoT Hub Registry Contributor" --scope "$HUB_RESOURCE_ID"
    >  ```

#### Create a Device Provisioning Service with ADR namespace integration

1. Create a new Device Provisioning Service (DPS) instance linked to the ADR namespace with the User-Assigned Identity. Your DPS must be located in the same region as your ADR namespace.

    ```bash
    az iot dps create --name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --location "$LOCATION" --mi-user-assigned "$UAMI_RESOURCE_ID" --ns-resource-id "$NAMESPACE_RESOURCE_ID" --ns-identity-id "$UAMI_RESOURCE_ID"
    ```

1. Verify that the DPS has correct identity and ADR properties configured.

    ```bash
    az iot dps show --name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --query identity --output json
    ```

#### Link IoT Hub to the Device Provisioning Service

1. Link the IoT hub to DPS.

    ```bash
    az iot dps linked-hub create --dps-name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --hub-name "$HUB_NAME"
    ```

1. Verify that the IoT hub appears in the list of linked hubs for the DPS.

    ```bash
    az iot dps linked-hub list --dps-name "$DPS_NAME" --resource-group "$RESOURCE_GROUP"
    ```

#### Run ADR credential synchronization

To enable IoT Hub to register the CA certificates and trust any issued leaf certificates, sync your credential and all its child policies to the ADR namespace.

```bash
az iot adr ns credential sync --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
```

#### Validate Hub Certificate

Validate that your IoT hub has registered its CA certificate.

```bash
az iot hub certificate list --hub-name "$HUB_NAME" --resource-group "$RESOURCE_GROUP"
```

#### Create an enrollment group in DPS

To provision devices with leaf certificates, you need to create an enrollment group and assign it to the appropriate policy. The allocation-policy defines the onboarding authentication mechanism DPS uses before issuing a leaf certificate. The default attestation mechanism is a symmetric key.

> [!NOTE]
> If you created a policy with a different name from "default", ensure that you use that policy name after the `--credential-policy` parameter.

```bash
az iot dps enrollment-group create --dps-name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --enrollment-id "$ENROLLMENT_ID" --credential-policy default
```

***


## Manage your ADR namespace

1. List all the ADR namespaces in your subscription:

    ```bash
    az iot adr ns list --resource-group "$RESOURCE_GROUP"
    ```

1. Show the details of a specific ADR namespace

    ```bash
    az iot adr ns show --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Show the credentials associated with a specific ADR namespace:

    ```bash
    az iot adr ns credential show --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. List all policies associated with a specific ADR namespace:

    ```bash
    az iot adr ns policy list --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Show the details of a specific policy associated with a specific ADR namespace:

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
az iot hub delete --name "$HUB_NAME" --resource-group "$RESOURCE_GROUP"
az iot adr ns delete --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
az iot dps delete --name "$DPS_NAME" --resource-group "$RESOURCE_GROUP"
az identity delete --name "$USER_IDENTITY" --resource-group "$RESOURCE_GROUP"
```
