---
title: Manage your certificates and namespaces in IoT Hub (Preview)
titleSuffix: Azure IoT Hub
description: Learn how to create and manage certificate authorities and policies using Certificate Management in Azure IoT Hub.
author: SoniaLopezBravo
ms.author: sonialopez
ms.service: azure-iot-hub
services: iot-hub
ms.topic: how-to
ms.date: 11/05/2025
#Customer intent: As a developer new to IoT, I want to learn how to create and manage certificate authorities and policies using Certificate Management in Azure IoT Hub, so that I can effectively manage device certificates for secure authentication.
---

# Manage your certificates and namespaces in IoT Hub (Preview)

Certificate Management consists of several integrated components that work together to streamline the deployment of public key infrastructure (PKI) across IoT devices. To use Certificate Management with IoT Hub, you must set up both an Azure Device Registry (ADR) namespace and a Device Provisioning Service (DPS) instance.

This article explains how to create and manage certificate authorities, policies, and namespaces using Azure portal.

[!INCLUDE [iot-hub-public-preview-banner](includes/public-preview-banner.md)]

## Prerequisites

- Have an active Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/).
- A resource group to hold your resources. You can create a new resource group or use an existing one. 
- For some tasks, you need an existing [Device Provisioning Service (DPS) instance](../iot-dps/quick-setup-auto-provision.md).

## Assign a namespace to a DPS instance

If you already have an existing Device Provisioning Service (DPS) instance, you can assign an existing namespace or create a new one to your DPS instance to enable Certificate Management for your devices.

1. In the [Azure portal](https://portal.azure.com), search for and select **Device Provisioning Service**.
1. In the **Overview** page, select **Click here to add a namespace**.

    :::image type="content" source="media/device-registry/namespace-linking-1.png" alt-text="Screenshot of Azure Device Registry namespace linking page in the Azure portal." lightbox="media/device-registry/namespace-linking-1.png":::

1. In the new pane, select the **ADR namespace** from the dropdown list or select **Create new** to create a new namespace. If you select to create a new namespace, follow the steps in the section [Create a new ADR namespace](iot-hub-device-registry-setup.md#create-a-new-adr-namespace-with-system-assigned-managed-identity) of the [Getting started with ADR and Certificate Management in IoT Hub](iot-hub-device-registry-setup.md) article to create your namespace.

    :::image type="content" source="media/device-registry/namespace-new-provisioning.png" alt-text="Screenshot of Azure Device Registry namespace linking a new ADR namespace to an existing DPS instance in the Azure portal." lightbox="media/device-registry/namespace-new-provisioning.png":::

1. Select a **user-assigned managed identity** to link to your DPS instance. This identity is used to securely access other Azure resources, such as ADR namespace. If you don't have a user-assigned managed identity, you can create one in the Azure portal. For more information, see [Create a user-assigned managed identity in the Azure portal](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal).
1. Select **Add** to link the namespace to your DPS instance.

    :::image type="content" source="media/device-registry/namespace-linking-2.png" alt-text="Screenshot of Azure Device Registry namespace linking an existing DPS instance in the Azure portal." lightbox="media/device-registry/namespace-linking-2.png":::

## Delete a namespace

When you no longer need the ADR namespace and its related resources, you can delete them to avoid incurring unnecessary costs.

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to delete.
1. In the namespace page, select **Delete**.

    :::image type="content" source="media/device-registry/namespace-delete.png" alt-text="Screenshot of the namespace page in Azure portal that shows the delete option." lightbox="media/device-registry/namespace-delete.png":::

## Create a custom policy for your namespace

You can create custom policies within your ADR namespace to define how certificates are issued and managed for your devices. Policies allow you to set parameters such as certificate validity periods and subjects.

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

## Assign a policy when creating an enrollment group

When creating an enrollment group in Device Provisioning Service (DPS), you can assign a policy created within your ADR namespace to manage certificate issuance and lifecycle.

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure IoT Hub Device Provisioning Services**.
1. Select your DPS instance.
1. In the DPS instance page, under **Settings**, select **Manage enrollment**.
1. In the **Manage enrollments** page, select either the **Enrollment groups** or **Individual enrollments** tab based on your provisioning needs.
1. Select **+ Add enrollment group** or **+ Add individual enrollment** to create a new enrollment.
1. In the **Registration + provisioning** page, complete the fields as follows:
    
    | Property | Value |    
    | -------- | ----- |
    | **Attestation mechanism** | Select **X.509 intermediate certificate** as the attestation method. |
    | **X.509 certificate settings** | Upload the intermediate certificate files. Enrollments have one or two certificates, known as primary and secondary certificate files. |
    | **Group name** | Enter a name for your enrollment group. Skip this field if you're creating an individual enrollment. |
    | **Provisioning status** | Select **Enabled** to enable the enrollment from provisioning. |
    | **Reprovision policy** | Specify the reprovisioning policy for the enrollment. This policy determines how the enrollment behaves during device reprovisioning. |

1. Go to the **Credential policies (Preview)** tab.
1. Select the **policy** you want to assign to the enrollment group or individual enrollment.

    :::image type="content" source="media/device-registry/add-enrollment-group-policy.png" alt-text="Screenshot of Azure Device Registry assigning a policy to an enrollment group in the Azure portal." lightbox="media/device-registry/add-enrollment-group-policy.png":::

1. Complete the remaining fields in the enrollment creation process and select **Create** to finalize the enrollment.

## Assign a policy to an existing enrollment group

You can select a policy from an existing namespace and assign it to an individual enrollment or enrollment groups in Device Provisioning Service (DPS). This allows you to reuse policies and streamline the management of certificate issuance and lifecycle across multiple enrollment groups.

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure IoT Hub Device Provisioning Services**.
1. Select your DPS instance.
1. In the DPS instance page, under **Settings**, select **Manage enrollment**.
1. In the **Manage enrollments** page, select either the **Enrollment groups** or **Individual enrollments** tab based on your provisioning needs.
1. Select the enrollment group or individual enrollment you want to assign a policy to.
1. In the enrollment details page, go to the **Credential policies (Preview)** tab.

    1. If you already have an ADR namespace linked to your DPS instance, select the **policy** you want to assign to other enrollment groups or individual enrollments.

        :::image type="content" source="media/device-registry/enrollment-policy.png" alt-text="Screenshot of Azure Device Registry selecting a policy from an existing enrollment group in the Azure portal." lightbox="media/device-registry/enrollment-policy.png":::
    
    1. If you don't have an ADR namespace linked to your DPS instance, you need to link a namespace first in order to access credential policies. Follow the steps in the section [Assign a namespace to a DPS instance](#assign-a-namespace-to-a-dps-instance) of this article to link a namespace to your DPS instance.

        :::image type="content" source="media/device-registry/enrollment-policy-no-adr.png" alt-text="Screenshot of Azure Device Registry selecting a policy from an existing enrollment group in the Azure portal when no ADR namespace is linked." lightbox="media/device-registry/enrollment-policy-no-adr.png":::

## Sync policies to IoT hubs

You can synchronize a policy created within your ADR namespace to the IoT hubs linked to that namespace. This synchronization enables IoT Hub to trust any devices authenticating with a leaf certificate issued by the policy's issuing CA (ICA).

1. In the [Azure portal](https://portal.azure.com), search for and select **Azure Device Registry**.
1. Go to the **Namespaces** page.
1. Select the namespace you want to sync policies for.
1. In the namespace page, under **Namespace resources**, select **Credential policies (Preview)**.
1. In the **Credential policies** page, you can view your policies, validity periods, intervals, and status.
1. Select the policies you want to sync. You can sync more than one policy at a time.
1. Select **Sync**.

    :::image type="content" source="media/device-registry/sync-policies.png" alt-text="Screenshot of the namespace page in Azure portal that shows the sync option." lightbox="media/device-registry/sync-policies.png":::

> [!NOTE]
> If you select to sync more than one policy, policies are synced to their respective IoT hubs. You can't undo a sync operation once it's done.
