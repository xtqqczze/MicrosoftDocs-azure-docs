---
title: Create an IoT hub with Certificate Management in Azure Device Registry using Azure portal
description: This article explains how to create an IoT hub with Azure Device Registry and Certificate Management integration using the Azure portal.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
ms.topic: include
ms.date: 11/05/2021
---

## Create an IoT hub with ADR integration using Azure portal

## Prerequisites

Have an Azure account. If you don't have an Azure account, create a [free account](https://azure.microsoft.com/free/).

## Create an IoT hub in Azure portal

1. Sign in to the [Azure portal](https://portal.azure.com).
1. On the Azure homepage, select the **+ Create a resource** button.
1. From the **Categories** menu, select **Internet of Things**, and then select **IoT Hub**.
1. On the **Basics** tab, complete the fields as follows:

   [!INCLUDE [iot-hub-pii-note-naming-hub](iot-hub-pii-note-naming-hub.md)]

   | Property | Value |
   | ----- | ----- |
   | **Subscription** | Select the subscription to use for your hub. |
   | **Resource group** | Select a resource group or create a new one. To create a new one, select **Create new** and fill in the name you want to use.|
   | **IoT hub name** | Enter a name for your hub. This name must be globally unique, with a length between 3 and 50 alphanumeric characters. The name can also include the dash (`'-'`) character.|
   | **Region** | IoT Hub with ADR is in **preview** and only available in [certain regions](iot-hub-faq.md#what-are-the-supported-regions-for-iot-hub-with-adr). Select the region, closest to you, where you want your hub to be located.|
   | **Tier** | Select the **Preview** tier. To compare the features available to each tier, select **Compare tiers**.|
   | **Daily message limit** | Select the maximum daily quota of messages for your hub. The available options depend on the tier you select for your hub. To see the available messaging and pricing options, select **See all options** and select the option that best matches the needs of your hub. For more information, see [IoT Hub quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling).|
   | **ADR namespace** | Select an existing ADR namespace or create a new one. To create a new one, select **Create new** and fill in the name you want to use. For more information, see [Create and manage namespaces](iot-hub-device-registry-namespaces.md).|
   | **User managed identity** | Select a user-assigned managed identity to link to your IoT hub. This identity is used to securely access other Azure resources, such as ADR namespace and DPS. If you don't have a user-assigned managed identity, you can create one in the Azure portal. For more information, see [Create a user-assigned managed identity in the Azure portal](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal). |
 

   :::image type="content" source="../articles/iot-hub/media/iot-hub-create-hub/iot-hub-gen-2-basics.png" alt-text="Screen capture that shows how to create an IoT hub in the Azure portal.":::

   > [!NOTE]
   > Prices shown are for example purposes only.

## Create a new ADR namespace with system-assigned managed identity

If you select **Create new** for the ADR namespace, complete the following steps to create a new ADR namespace, otherwise skip this section.

1. In the Basics tab of Add a new namespace page, fill in the fields as follows:

    | Property | Value |
    | ----- | ----- |
    | **Subscription** | Select the subscription to use for your ADR namespace. |
    | **Resource group** | Select the resource group you used for your IoT hub. |
    |**Name**| Enter a name for your ADR namespace. Your namespace name can only contain lowercase letters and hyphens ('-') in the middle of the name, but not at the beginning or end. For example, the name "msft-namespace" is valid. |

    :::image type="content" source="../articles/iot-hub/media/iot-hub-create-hub/iot-hub-namespace-1.png" alt-text="Screen capture that shows how to fill the basics tab for an ADR namespace in the Azure portal.":::

1. Select the **Next: Identity >** button to continue creating your ADR namespace.
1. In the Identity tab, select **Enabled** or **Disabled** to enable or disable a system-assigned managed identity for the ADR namespace. You must enable the managed identity to allow Certificate Management integration.

    :::image type="content" source="../articles/iot-hub/media/iot-hub-create-hub/iot-hub-namespace-2.png" alt-text="Screen capture that shows how to enable a system-assigned managed identity for an ADR namespace in the Azure portal.":::

1. Select the **Next: Tags >** button to continue creating your ADR namespace.
1. In the Tags tab, you can optionally add tags to organize your ADR namespace. When you create a tag, you define a name, a value, and a resource for it. You can use tags to filter and group your resources in the Azure portal.

    :::image type="content" source="../articles/iot-hub/media/iot-hub-create-hub/iot-hub-namespace-3.png" alt-text="Screen capture that shows how to create tags for an ADR namespace in the Azure portal.":::

1. Select the **Review + create >** button to continue creating your ADR namespace.
1. Review your settings, and then select **Create** to create your ADR namespace.

    > [!NOTE]
    > The creation of the namespace with system-assigned managed identity might take up to 5 minutes.

1. Once created, you can view and select your ADR namespace from the **ADR namespace** dropdown.
1. Select **Next: Networking** to continue creating your hub.

## Configure the networking, management, and add-ons settings

1. On the **Networking** tab, complete the fields as follows:

   | Property | Value |
   | ----- | ----- |
   | **Connectivity configuration** | Choose the endpoints that devices can use to connect to your IoT hub. Accept the default setting, **Public access**, for this example. You can change this setting after the IoT hub is created. For more information, see [IoT Hub endpoints](/azure/iot-hub/iot-hub-devguide-endpoints). |
   | **Minimum TLS Version** | Select the minimum [TLS version](/azure/iot-hub/iot-hub-tls-support#tls-12-enforcement-available-in-select-regions) supported by your IoT hub. Once the IoT hub is created, this value can't be changed. Accept the default setting, **1.0**, for this example. |

   :::image type="content" source="./media/iot-hub-include-create-hub/iot-hub-create-network-screen.png" alt-text="Screen capture that shows how to choose the endpoints that can connect to a new IoT hub.":::

1. Select **Next: Management** to continue creating your hub.
1. On the **Management** tab, accept the default settings. If desired, you can modify any of the following fields:

   | Property | Value |
   | ----- | ----- |
   | **Permission model** | Part of role-based access control, this property decides how you *manage access* to your IoT hub. Allow shared access policies or choose only role-based access control. For more information, see [Control access to IoT Hub by using Microsoft Entra ID](/azure/iot-hub/iot-hub-dev-guide-azure-ad-rbac). |
   | **Assign me** | You might need access to IoT Hub data APIs to manage elements within an instance. If you have access to role assignments, select **IoT Hub Data Contributor role** to grant yourself full access to the data APIs.<br><br>To assign Azure roles, you must have `Microsoft.Authorization/roleAssignments/write` permissions, such as [User Access Administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](/azure/role-based-access-control/built-in-roles#owner). |
   | **Device-to-cloud partitions** | This property relates the device-to-cloud messages to the number of simultaneous readers of the messages. Most IoT hubs need only four partitions. |

   :::image type="content" source="./media/iot-hub-include-create-hub/iot-hub-management.png" alt-text="Screen capture that shows how to set the role-based access control and scale for a new IoT hub.":::

1. Select **Next: Add-ons** to continue to the next screen.
1. On the **Add-ons** tab, accept the default settings. If desired, you can modify any of the following fields:

   | Property | Value |
   | -------- | ----- |
   | **Enable Device Update for IoT Hub** | Turn on Device Update for IoT Hub to enable over-the-air updates for your devices. If you select this option, you're prompted to provide information to provision a Device Update for IoT Hub account and instance. For more information, see [What is Device Update for IoT Hub?](/azure/iot-hub-device-update/understand-device-update) |
   | **Enable Defender for IoT** | Turn Defender for IoT on to add an extra layer of protection to IoT and your devices. This option isn't available for hubs in the free tier. For more information, see [Security recommendations for IoT Hub](/azure/defender-for-iot/device-builders/concept-recommendations) in [Microsoft Defender for IoT](/azure/defender-for-iot/device-builders) documentation. |

   :::image type="content" source="./media/iot-hub-include-create-hub/iot-hub-create-add-ons.png" alt-text="Screen capture that shows how to set the optional add-ons for a new IoT hub.":::

   > [!NOTE]
   > Prices shown are for example purposes only.

1. Select **Next: Tags** to continue to the next screen.

    Tags are name/value pairs. You can assign the same tag to multiple resources and resource groups to categorize resources and consolidate billing. In this document, you don't add any tags. For more information, see [Use tags to organize your Azure resources and management hierarchy](/azure/azure-resource-manager/management/tag-resources).

    :::image type="content" source="./includes/media/iot-hub-include-create-hub/iot-hub-create-tags.png" alt-text="Screen capture that shows how to assign tags for a new IoT hub.":::

1. Select **Next: Review + create** to review your choices.
1. Select **Create** to start the deployment of your new hub. Your deployment might progress for a few minutes while the hub is being created. Once the deployment is complete, select **Go to resource** to open the new hub.

