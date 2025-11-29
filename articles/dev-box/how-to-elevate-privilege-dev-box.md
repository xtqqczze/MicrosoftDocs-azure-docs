---
title: Configure Intune Endpoint Privilege Management
description: Learn how to configure Intune Endpoint Privilege Management for dev boxes so that users can manage their dev boxes without needing administrative privileges.
author: RoseHJM
ms.author: rosemalcolm
ms.service: dev-box
ms.topic: how-to
ms.date: 11/29/2025

#customer intent: As a platform engineer, I want to configure elevated privilege management for dev boxes so that users don't need administrative privileges to manage their dev boxes.
---

# Configure Intune Endpoint Privilege Management for dev boxes

By default, Microsoft Dev Box requires local administrative privileges to do common dev box tasks like installing applications, updating device drivers, and running some Windows diagnostics.This article shows you how to configure Intune Endpoint Privilege Management for dev boxes so dev box users don't need local administrative privileges to do these tasks. Intune Endpoint Privilege Management lets your organization's users run as standard, nonadministrative users to complete tasks that require elevated privileges.

Endpoint Privilege Management is part of Intune, and you configure it in the Microsoft Intune admin center. To get started with Endpoint Privilege Management, you [license Endpoint Privilege Management](#license-endpoint-privilege-management) and [deploy an elevation settings policy](#). 

## Prerequisites

- A dev center with a dev box project.
- An Intune subscription.

## Configure Endpoint Privilege Management license and roles

Before you can use Endpoint Privilege Management policies, you must license Endpoint Privilege Management in your tenant as a Microsoft Intune add-on. Endpoint Privilege Management requires either a standalone license or a license as part of the Intune Suite. For more information, see [Use Intune Suite add-on capabilities](/intune/intune-service/fundamentals/intune-add-ons).

Configure an Intune admin role for Endpoint Privilege Management administration:

1. In the Intune admin center, go to **Users** and select the user you want to assign the role to.
1. Select **Assigned roles** in the left navigation menu, select **Add assignments**, and then select and assign the **Intune Administrator** role.

Configure Endpoint Privilege Management licensing:

1. In the [Microsoft Intune admin center](https://intune.microsoft.com), go to **Tenant administration** > **Intune add-ons** and select **Endpoint Privilege Management**.
1. In the [Microsoft 365 admin center](https://admin.microsoft.com/Adminportal/Home?#/catalog), go to **Billing** > **Purchase services** > **Endpoint Privilege Management**, and then select your Endpoint Privilege Management license.

Assign Microsoft 365 E5 and Endpoint Privilege Management licenses to users in Microsoft Entra ID:

1. In the Intune admin center, select **Users** and then select the user you want to assign the Microsoft 365 E5 and Endpoint Privilege Management licenses to.
1. Select **Assigned roles** in the left navigation menu, select **Add assignments**, and then select and assign the **Microsoft 365 E5** and **Endpoint Privilege Management** roles.

## Deploy an elevation settings policy

An elevation settings policy activates Endpoint Privilege Management on a client device. By using this policy, you can configure settings that are specific to the client but aren't necessarily related to the elevation of individual applications or tasks.

To process an elevation rules policy or manage elevation requests, a dev box must have an elevation settings policy that enables support for Endpoint Privilege Management. Enabling support installs the Endpoint Privilege Management agent, which processes the Endpoint Privilege Management policies.

The following procedure:

- - Creates a dev box and an Intune group to test the Endpoint Privilege Management policy configuration.
- - Creates an Endpoint Privilege Management elevation settings policy.
  - Assigns the policy to the group.

Create a dev box definition, pool, and dev box:

1. In the Azure portal, create a [dev box definition](how-to-manage-dev-box-definitions.md), specifying a supported OS. Endpoint Privilege Management supports Windows 11 versions 21H2 and above.

1. In your dev box project, create a [dev box pool](how-to-manage-dev-box-pools.md) that uses the new dev box definition.

1. In the [developer portal](https://aka.ms/devbox-portal), create a dev box by using the dev box pool you just created. Note the dev box host name to use for adding the dev box to the Intune group.

1. Assign the [Dev Box User](how-to-dev-box-user.md) role to a test user.

Create an Intune group and add the dev box to the group:

1. In the [Microsoft Intune admin center](https://intune.microsoft.com), select **Groups** > **New group**.

1. In the **New group** form, complete the following fields:
   - **Group type**: Select **Security**.
   - **Group name**: Enter a name for the group.
   - **Microsoft Entra roles can be assigned to the group**: Select **Yes**.
   - **Membership type**: Select **Assigned**.
   - **Members**: Select the dev box you created.
1. Select **Create**.

Create an Endpoint Privilege Management elevation settings policy and assign it to the group:

1. In the Microsoft Intune admin center, select **Endpoint security** > **Endpoint Privilege Management**, and on the **Policies** tab, select **Create Policy**.

   :::image type="content" source="media/how-to-elevate-privilege-dev-box/intune-endpoint-security.png" alt-text="Screenshot that shows the Microsoft Intune admin center, showing the Endpoint security | Endpoint Privilege Management pane." lightbox="media/how-to-elevate-privilege-dev-box/intune-endpoint-security.png":::

1. On the **Basics** tab of the **Create profile** pane, ensure that **Platform** is **Windows 10 and later** and **Profile type** is **Elevation settings policy**, and enter a name for the policy.
1. On the **Configuration settings** tab, in **Default elevation response**, select **Deny all requests**.

   :::image type="content" source="media/how-to-elevate-privilege-dev-box/deny-all-requests.png" alt-text="Screenshot that shows the Configuration settings tab, with Endpoint Privilege Management enabled and Default elevation response set to Deny all requests.":::

1. On the **Assignments** tab, select **Add groups** and add the Intune group you created earlier.

   :::image type="content" source="media/how-to-elevate-privilege-dev-box/assign-defined-group.png" alt-text="Screenshot that shows the Create profile Assignments tab with Add groups highlighted.":::

1. Select **Create**.

## Verify administrative privilege restrictions

Validate that the Endpoint Privilege Management agent is installed and the policy is applied to the dev box.

Verify that the policy is applied to the dev box:

1. In the [Microsoft Intune admin center](https://intune.microsoft.com), select **Devices**, and select the dev box that you created earlier.
1. On the **Policy** tab of the **Device configuration** screen, select the policy you created earlier.

   :::image type="content" source="media/how-to-elevate-privilege-dev-box/intune-device-configuration.png" alt-text="Screenshot that shows the Microsoft Intune admin center with the Devices pane and Device configuration highlighted.":::

1. On the **Profile settings** page, wait until all the settings report as **Succeeded**.

   :::image type="content" source="media/how-to-elevate-privilege-dev-box/device-profile-settings.png" alt-text="Screenshot that shows Profile Settings with Setting status highlighted." lightbox="media/how-to-elevate-privilege-dev-box/device-profile-settings.png":::

Verify that the Endpoint Privilege Management agent is installed on the dev box:

1. Sign in to the dev box that you created earlier.
1. Go to *c:\\Program Files* and verify that a folder named *Microsoft Endpoint Privilege Management Agent* exists.
1. On the dev box, right-click an application and select **Run with elevated access**. You should get a message that the action is blocked.

## Related content

* [Use Intune Suite add-on capabilities](/mem/intune/fundamentals/intune-add-ons)
* [Use Endpoint Privilege Management with Intune](/mem/intune/protect/epm-overview)