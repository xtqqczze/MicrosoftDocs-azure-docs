---
title: Create an IoT hub Gen 2
titleSuffix: Azure IoT Hub
description: This article explains how to create an IoT hub Gen 2 with Azure Device Registry integration.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 10/20/2025
#Customer intent: As a developer new to IoT, I want to understand what Azure Device Registry is and how it can help me manage my IoT devices.
---

# Create IoT hubs with Azure Device Registry integration

**Applies to:** ![IoT Hub checkmark](media/iot-hub-version/yes-icon.png) IoT Hub Gen 2

IoT Hub Gen 2 expands on the capabilities of IoT Hub Gen 1 by integrating with [Azure Device Registry (ADR)](iot-hub-device-registry-overview.md) and [Certificate Management](iot-hub-certificate-management-overview.md). 

This article explains how to create a new IoT hub with ADR and Certificate Management integration. You can optionally not link Certificate Management if you only want to use ADR.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Overview

To set up your IoT hub with ADR, you can use the Azure portal, Azure CLI, or run a script. Follow the instructions in the section that corresponds to your preferred method.

The setup process includes the following steps:

1. Create a custom ADR role, setup the right privileges, and create a user-assigned managed identity.
1. Create an ADR namespace.
1. Create a credential and policy and associate them to the namespace.
1. Create an IoT Hub Gen 2 SKU with linked namespace.
1. Create a DPS with linked ADR namespace and Hub.
1. Sync your credential and policies to ADR namespace.
1. Create an enrollment group and link to your policy to enable device onboarding.

For more information about how to create namespaces, policies, and credentials, see [Create and manage namespaces](iot-hub-device-registry-namespaces.md).

## Prerequisites

### [Azure portal](#tab/portal)

Have an Azure account. If you don't have an Azure account, create a [free account](https://azure.microsoft.com/free/).

### [Azure CLI](#tab/cli)

- Have an Azure account. If you don't have an Azure account, create a [free account](https://azure.microsoft.com/free/).
- Install [Azure CLI](/cli/azure/install-azure-cli) in your environment, or run `az upgrade` to ensure you have the latest version.
- Install the [IoT extension for Azure CLI](https://github.com/Azure/azure-cli).
- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group in your Azure subscription. If you want to create a new resource group, use the [az group create](/cli/azure/group#az-group-create) command:

  ```azurecli
  az group create --name <RESOURCE_GROUP_NAME> --location <REGION>
  ```

### [Script](#tab/script)

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group to hold your resources. You can create a new resource group or use an existing one. If you want to create a new resource group, use the [az group create](/cli/azure/group#az-group-create) command:

   ```azurecli
   az group create --name <RESOURCE_GROUP_NAME> --location "<REGION>"
   ```
- A Device Provisioning Service (DPS) instance. If you don't have a DPS instance, use the [az iot dps create](/cli/azure/iot/dps#az-iot-dps-create) command to create one:

   ```azurecli
   az iot dps create --name <DPS_NAME> --resource-group <RESOURCE_GROUP_NAME> --location "<REGION>"
   ```

***

## Create an IoT hub 

### [Azure portal](#tab/portal)

1. Sign in to the [Azure portal](https://portal.azure.com).
1. On the Azure homepage, select the **+ Create a resource** button.
1. From the **Categories** menu, select **Internet of Things**, and then select **IoT Hub**.
1. On the **Basics** tab, complete the fields as follows:

   [!INCLUDE [iot-hub-pii-note-naming-hub](../../includes/iot-hub-pii-note-naming-hub.md)]

   | Property | Value |
   | ----- | ----- |
   | **Subscription** | Select the subscription to use for your hub. |
   | **Resource group** | Select a resource group or create a new one. To create a new one, select **Create new** and fill in the name you want to use.|
   | **IoT hub name** | Enter a name for your hub. This name must be globally unique, with a length between 3 and 50 alphanumeric characters. The name can also include the dash (`'-'`) character.|
   | **Region** | IoT Hub Gen 2 is in **preview** and only available in [certain regions](iot-hub-faq.md#what-are-the-supported-regions-for-iot-hub-gen-2). Select the region, closest to you, where you want your hub to be located.|
   | **Tier** | Select the **Gen 2** tier. To compare the features available to each tier, select **Compare tiers**.|
   | **ADR namespace** | Select an existing ADR namespace or create a new one. To create a new one, select **Create new** and fill in the name you want to use.|
   | **Daily message limit** | Select the maximum daily quota of messages for your hub. The available options depend on the tier you select for your hub. To see the available messaging and pricing options, select **See all options** and select the option that best matches the needs of your hub. For more information, see [IoT Hub quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling).|

   :::image type="content" source="./media/iot-hub-create-hub/iot-hub-gen-2-basics.png" alt-text="Screen capture that shows how to create an IoT hub in the Azure portal.":::

   > [!NOTE]
   > Prices shown are for example purposes only.

    1. If you select **Create new** for the ADR namespace, a new pane appears. Fill in the fields to create a new namespace as follows:

        | Property | Value |
        | ----- | ----- |
        | **Subscription** | Select the subscription to use for your ADR namespace. |
        | **Resource group** | Select the resource group you used for your IoT hub. |
        |**Label**| Enter a name for your ADR namespace. Your namespace name can only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, the name "msft-namespace" is valid. |
        | **Identity**| Select **Enabled** or **Disabled** to enable or disable a system-assigned managed identity for the ADR namespace. It's recommended to enable the managed identity to allow secure access to other Azure resources.|
        |**Tags**| (Optional) Add tags to organize your ADR namespace. When you create a tag, you define a name, a value, and a resource for it. You can use tags to filter and group your resources in the Azure portal.|

       :::image type="content" source="./media/iot-hub-create-hub/iot-hub-gen-2-adr-namespace.png" alt-text="Screen capture that shows how to create an ADR namespace when creating an IoT hub in the Azure portal.":::

        > [!NOTE]
        > The creation of the namespace with system-assigned managed identity might take up to 5 minutes.

    1. Select **OK** to save your new ADR namespace and return to the Basics tab.

1. Once created, you can view and select your ADR namespace from the **ADR namespace** dropdown.
1. Select **Next: Networking** to continue creating your hub.
1. On the **Networking** tab, complete the fields as follows:

   | Property | Value |
   | ----- | ----- |
   | **Connectivity configuration** | Choose the endpoints that devices can use to connect to your IoT hub. Accept the default setting, **Public access**, for this example. You can change this setting after the IoT hub is created. For more information, see [IoT Hub endpoints](/azure/iot-hub/iot-hub-devguide-endpoints). |
   | **Minimum TLS Version** | Select the minimum [TLS version](/azure/iot-hub/iot-hub-tls-support#tls-12-enforcement-available-in-select-regions) supported by your IoT hub. Once the IoT hub is created, this value can't be changed. Accept the default setting, **1.0**, for this example. |

   :::image type="content" source="../../includes/media/iot-hub-include-create-hub/iot-hub-create-network-screen.png" alt-text="Screen capture that shows how to choose the endpoints that can connect to a new IoT hub.":::

1. Select **Next: Management** to continue creating your hub.
1. On the **Management** tab, accept the default settings. If desired, you can modify any of the following fields:

   | Property | Value |
   | ----- | ----- |
   | **Permission model** | Part of role-based access control, this property decides how you *manage access* to your IoT hub. Allow shared access policies or choose only role-based access control. For more information, see [Control access to IoT Hub by using Microsoft Entra ID](/azure/iot-hub/iot-hub-dev-guide-azure-ad-rbac). |
   | **Assign me** | You might need access to IoT Hub data APIs to manage elements within an instance. If you have access to role assignments, select **IoT Hub Data Contributor role** to grant yourself full access to the data APIs.<br><br>To assign Azure roles, you must have `Microsoft.Authorization/roleAssignments/write` permissions, such as [User Access Administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](/azure/role-based-access-control/built-in-roles#owner). |
   | **Device-to-cloud partitions** | This property relates the device-to-cloud messages to the number of simultaneous readers of the messages. Most IoT hubs need only four partitions. |

   :::image type="content" source="../../includes/media/iot-hub-include-create-hub/iot-hub-management.png" alt-text="Screen capture that shows how to set the role-based access control and scale for a new IoT hub.":::

1. Select **Next: Add-ons** to continue to the next screen.
1. On the **Add-ons** tab, accept the default settings. If desired, you can modify any of the following fields:

   | Property | Value |
   | -------- | ----- |
   | **Enable Device Update for IoT Hub** | Turn on Device Update for IoT Hub to enable over-the-air updates for your devices. If you select this option, you're prompted to provide information to provision a Device Update for IoT Hub account and instance. For more information, see [What is Device Update for IoT Hub?](/azure/iot-hub-device-update/understand-device-update) |
   | **Enable Defender for IoT** | Turn Defender for IoT on to add an extra layer of protection to IoT and your devices. This option isn't available for hubs in the free tier. For more information, see [Security recommendations for IoT Hub](/azure/defender-for-iot/device-builders/concept-recommendations) in [Microsoft Defender for IoT](/azure/defender-for-iot/device-builders) documentation. |

   :::image type="content" source="../../includes/media/iot-hub-include-create-hub/iot-hub-create-add-ons.png" alt-text="Screen capture that shows how to set the optional add-ons for a new IoT hub.":::

   > [!NOTE]
   > Prices shown are for example purposes only.

1. Select **Next: Tags** to continue to the next screen.

    Tags are name/value pairs. You can assign the same tag to multiple resources and resource groups to categorize resources and consolidate billing. In this document, you don't add any tags. For more information, see [Use tags to organize your Azure resources and management hierarchy](/azure/azure-resource-manager/management/tag-resources).

    :::image type="content" source="../../includes/media/iot-hub-include-create-hub/iot-hub-create-tags.png" alt-text="Screen capture that shows how to assign tags for a new IoT hub.":::

1. Select **Next: Review + create** to review your choices.
1. Select **Create** to start the deployment of your new hub. Your deployment might progress for a few minutes while the hub is being created. Once the deployment is complete, select **Go to resource** to open the new hub.

### [Azure CLI](#tab/cli)

### Prepare your environment

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

### Set up the environment variables

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

    [!INCLUDE [iot-hub-pii-note-naming-hub](../../includes/iot-hub-pii-note-naming-hub.md)]

1. Verify that the environment variables are set correctly by running the following command:

    ```bash
    echo $HUB_NAME
    ```

### Configure your group, role, and permissions

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
        "Microsoft.DeviceRegistry/namespaces/credentials/policies/read",
        "Microsoft.Devices/iothubs/certificates/*",
        "Microsoft.Devices/iothubs/read"
      ],
      "dataActions": [
        "Microsoft.DeviceRegistry/namespaces/credentials/policies/issueCertificate/action",
        "Microsoft.Devices/iothubs/devices/*"
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

### Set up an ADR namespace

Set up a new ADR namespace with a system-assigned managed identity. Creating namespace with system-assigned managed identity also creates a credential, known as root CA, and a default policy, known as intermediate CA. [Certificate Management](iot-hub-certificate-management-overview.md) uses these credentials and policies to onboard devices to the namespace.

> [!NOTE]
> Credentials are optional. You can also create a namespace without a managed identity by omitting the `--enable-credential-policy` and `--policy-name` flags.

1. Create a new ADR namespace. Your namespace `name` can only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, the name "msft-namespace" is valid. If you want to enable a system-assigned managed identity for the ADR namespace, add the `--enable-credential-policy` flag to the command and the policy name using the `--policy-name` flag. 

    ```bash
    az iot adr ns create --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --location "$LOCATION" --enable-credential-policy true --policy-name "PolicyName"
    ```

    > [!TIP]
    > You can also create a custom policy using the `az iot adr ns policy create` command. For more information, see [Create and manage namespaces](iot-hub-device-registry-namespaces.md#create-a-custom-policy).

    > [!NOTE]
    > The creation of the namespace with system-assigned managed identity might take up to 5 minutes.

1. Verify that the namespace with a system-assigned managed identity, or principal ID, is created.

    ```bash
    az iot adr ns show --name "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    ```

1. Verify that a credential named "default" and policy named "PolicyName" are created.
    
    ```bash
    az iot adr ns credential show --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
    az iot adr ns policy show --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP" --name "PolicyName"
    ```

    > [!NOTE]
    > If you don't assign a policy name, the policy is created with the name "default".

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

### Create an IoT hub with ADR namespace integration

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

### Create a Device Provisioning Service with ADR namespace integration

1. Create a new Device Provisioning Service (DPS) instance linked to the ADR namespace with the User-Assigned Identity. Your DPS must be located in the same region as your ADR namespace.

    ```bash
    az iot dps create --name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --location "$LOCATION" --mi-user-assigned "$UAMI_RESOURCE_ID" --ns-resource-id "$NAMESPACE_RESOURCE_ID" --ns-identity-id "$UAMI_RESOURCE_ID"
    ```

1. Verify that the DPS has correct identity and ADR properties configured.

    ```bash
    az iot dps show --name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --query identity --output json
    ```

### Link IoT Hub to the Device Provisioning Service

1. Link the IoT hub to DPS.

    ```bash
    az iot dps linked-hub create --dps-name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --hub-name "$HUB_NAME"
    ```

1. Verify that the IoT hub appears in the list of linked hubs for the DPS.

    ```bash
    az iot dps linked-hub list --dps-name "$DPS_NAME" --resource-group "$RESOURCE_GROUP"
    ```

### Run ADR credential synchronization

To enable IoT Hub to register the CA certificates and trust any issued leaf certificates, sync your credential and all its child policies to the ADR namespace.

```bash
az iot adr ns credential sync --namespace "$NAMESPACE_NAME" --resource-group "$RESOURCE_GROUP"
```

### Validate Hub Certificate

Validate that your IoT hub has registered its CA certificate.

```bash
az iot hub certificate list --hub-name "$HUB_NAME" --resource-group "$RESOURCE_GROUP"
```

### Create an enrollment group in DPS

To provision devices with leaf certificates, you need to create an enrollment group and assign it to the appropriate policy. The allocation-policy defines the onboarding authentication mechanism DPS uses before issuing a leaf certificate. The default attestation mechanism is a symmetric key.

> [!NOTE]
> If you created a policy with a different name from "default", ensure that you use that policy name after the `--credential-policy` parameter.

```bash
az iot dps enrollment-group create --dps-name "$DPS_NAME" --resource-group "$RESOURCE_GROUP" --enrollment-id "$ENROLLMENT_ID" --credential-policy default
```


### [Script](#tab/script)

### Prepare Your Environment

1. Navigate to the [GitHub repository](https://github.com/Azure/hubgen2-certmgmt/tree/main/Scripts) and download the entire folder, Scripts, which contains the script file (.ps1) and the role template (.json).
1. Place the script, role template, and the .whl files in your working folder and confirm they are accessible. Your working folder is the directory that holds all of your files.

### Customize the script variables

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

[!INCLUDE [iot-hub-pii-note-naming-hub](../../includes/iot-hub-pii-note-naming-hub.md)]

### Run the script interactively

1. Run the script in **PowerShell 7+** by navigating to the folder and running `.\cmsSetupCli.ps1`.
1. If you run into an execution policy issue, try running `powershell -ExecutionPolicy Bypass -File .\cmsSetupCli.ps1`.
1. Follow the guided prompts:

    - Press `Enter` to proceed with a step
    - Press `s` or `S` to skip a step
    - Press `Ctrl` + `C` to abort

> [!NOTE]
> The creation of your ADR Namespace, IoT Hub, DPS, and other resources may take up to 5 minutes each.

### Monitor execution and validate the resources

1. The script continues execution when warnings are encountered and only stops if a command returns a non-zero exit code. Monitor the console for red **ERROR** messages, which indicate issues that require attention.
1. Once the script completes, validate the creation of your resources:

    - IoT Hub
    - DPS
    - ADR Namespace
    - User-Assigned Managed Identity (UAMI)
    - Custom Role Assignments

***

## Delete an IoT hub

When you delete an IoT hub, you lose the associated device identity registry. If you want to move or upgrade an IoT hub, or delete an IoT hub but keep the devices, consider [migrating an IoT hub using the Azure CLI](./migrate-hub-state-cli.md).

### [Azure portal](#tab/portal)

To delete an IoT hub, open your IoT hub in the Azure portal, then choose **Delete**.

:::image type="content" source="./media/create-hub/delete-iot-hub.png" alt-text="Screenshot showing where to find the delete button for an IoT hub in the Azure portal." lightbox="./media/create-hub/delete-iot-hub.png":::

### [Azure CLI](#tab/cli)

To delete an IoT hub, run the [az iot hub delete](/cli/azure/iot/hub#az-iot-hub-delete) command:

```azurecli-interactive
az iot hub delete --name <IOT_HUB_NAME> --resource-group <RESOURCE_GROUP_NAME>
```

### [Script](#tab/script)

You can't delete an IoT hub using the script. Instead,  delete the IoT hub using the Azure portal or Azure CLI.

*** 

## Next steps

You can now start using your IoT hub with Azure Device Registry integration. To learn more about how to connect devices to your IoT hub, see the following articles:

- [Create and manage device identities](create-connect-device.md)
- [Monitor IoT Hub with metrics and logs](monitor-iot-hub.md)
- [Create and manage namespaces](iot-hub-device-registry-namespaces.md)