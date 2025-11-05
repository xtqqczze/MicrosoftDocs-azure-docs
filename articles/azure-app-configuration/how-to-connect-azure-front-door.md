---
title: Connect Azure App Configuration to Azure Front Door (preview)
description: Learn how to connect Azure App Configuration to Azure Front Door for hyperscale global delivery of configuration and feature flags, using managed identity, caching, and endpoint controls.
#customer intent: As a developer, I want to integrate Azure Front Door with my App Configuration store to improve configuration delivery performance globally and reduce latency for my applications, while managing the setup through a single Azure portal interface.
author: maud-lv
ms.author: malev
ms.date: 10/27/2025
ms.topic: how-to
ms.service: azure-app-configuration
---

# Connect Azure App Configuration to Azure Front Door (preview)

Azure App Configuration supports direct integration with Azure Front Door (preview) to deliver configuration data through Azure's global content delivery network. This integration provides hyperscale global delivery of application settings and feature flags while centralizing configuration management in the Azure portal.

You can connect your App Configuration store to existing Azure Front Door profiles or create new profiles directly from the App Configuration interface for a quick start.

## Prerequisites

Before you begin, ensure you have:

- An active Azure subscription
- An existing Azure App Configuration store
- Permissions to create and manage Azure Front Door resources (Contributor or equivalent)
- Permissions to  assign roles on the App Configuration resource (Owner or User Access Administrator)
- App Configuration Data Owner or App Configuration Data Reader role 
- Basic understanding of [CDN and content delivery concepts](/azure/frontdoor/front-door-overview)

## Set up the Azure Front Door integration

To integrate Azure Front Door with your App Configuration store, follow these steps:

1. In the Azure portal, navigate to your App Configuration store.

1. In the left navigation pane, under **Settings**, select **Azure Front Door (preview)**.

    :::image type="content" source="media/how-to-connect-azure-front-door/select-resource.png" alt-text="Screenshot showing  Azure Front Door resource selection in the App Configuration store."

1. Configure the connection settings:

   - **Subscription**: Select the subscription for your Azure Front Door profile
   - **Resource group**: Select the resource group for the profile
   - **Create new/use existing profile**: Choose whether to create a new profile or use an existing one

1. Continue with the steps that match your selection:

   * To create a new profile, see [Create a new Azure Front Door profile](#create-a-new-azure-front-door-profile).
   * To connect an existing profile, see [Connect to an existing Azure Front Door profile](#connect-to-an-existing-azure-front-door-profile).

### Create a new Azure Front Door profile

Create a new Azure Front Door profile and connect it to your App Configuration store.

1. In **Profile name**, enter a name for your new Azure Front Door profile.

    :::image type="content" source="media/how-to-connect-azure-front-door/create-profile.png" alt-text="Screenshot showing creation of a new Azure Front Door profile in the App Configuration store."

1. Choose a **Pricing tier based on your needs:

   - **Azure Front Door Standard**: Content delivery optimized
   - **Azure Front Door Premium**: Security optimized with enhanced security features

   For a detailed overview and comparison of Azure Front Door pricing tiers, see [Compare pricing between Azure Front Door tiers](/azure/frontdoor/understanding-pricing).

1. Create an endpoint that uses this App Configuration store as origin:

   [!INCLUDE [azure-app-configuration-create-front-door-endpoint-connection](../../includes/azure-app-configuration-create-front-door-endpoint.md)]

   - Select **Create & Connect** to create the profile and establish the connection.

After successfully connecting to Azure Front Door, you might want to [create additional endpoints](#create-endpoints) for different scenarios.

### Connect to an existing Azure Front Door profile

1. In **Profile name**, select your existing Azure Front Door profile from the dropdown.

    :::image type="content" source="media/how-to-connect-azure-front-door/select-profile.png" alt-text="Screenshot showing use of existing profile in the App Configuration store."

1. Select **Connect** to establish the connection.

After successful connection, you see your subscription information, the connected Azure Front Door profile name as a clickable link, and an **Existing Endpoints** section. Any endpoints in the connected Azure Front Door profile that use this App Configuration store or its replicas as an origin appear here.

## Manage endpoints

### Create endpoints

After connecting to an Azure Front Door profile, you can create multiple endpoints, for example, to apply different request scopes for separate applications.

1. From the Azure Front Door page in your App Configuration store, select **Create Endpoint**.

   [!INCLUDE [azure-app-configuration-create-front-door-endpoint-connection](../../includes/azure-app-configuration-create-front-door-endpoint.md)]

   - Select **Create** to create the new endpoint.

The new endpoint appears in the **Existing endpoints** table, showing the endpoint URL, origin URL, origin location, and any configuration warnings that need attention.

### Monitor endpoint status

Use the **Existing Endpoints** table to monitor your Azure Front Door endpoints and identify configuration issues.

:::image type="content" source="media/how-to-connect-azure-front-door/existing-connections.png" alt-text="Screenshot showing Azure Front Door connections in the App Configuration store." lightbox="media/how-to-connect-azure-front-door/existing-connections.png":::

The table displays:
- **Azure Front Door Endpoint**: The endpoint URL (clickable link)
- **Origin**: The origin URL pointing to your App Configuration store or replica
- **Origin Location**: The Azure region where the origin is located
- **Warnings**: Configuration issues that may need attention

Monitor for warnings such as "Identity not configured" which indicate additional setup requirements. Address these warnings promptly to ensure proper functionality.

## Disconnect Azure Front Door integration

When you no longer need to manage your Front Door profile through App Configuration, disconnect your App Configuration store from Azure Front Door.

1. From the Azure Front Door pane in your App Configuration store, select **Disconnect**.

1. Review the confirmation dialog showing:

   - Resource group information
   - Disconnected Azure Front Door profile

1. Confirm the action by selecting **OK**.

> [!WARNING]
> After disconnecting, you won’t be able to manage the Front Door profile or its endpoints through App Configuration. However, your Front Door profile and endpoints will continue to exist in Azure, and your application will keep fetching configuration via Front Door as expected, unless other changes are made.

## Troubleshoot common issues

If you encounter issues while connecting Azure Front Door to your App Configuration store, consider the following troubleshooting steps:

- Ensure that you have sufficient permissions to create and manage Front Door resources (Contributor or equivalent)
- Ensure that you have sufficient permissions to assign roles (Owner or User Access Administrator).
- Ensure that the selected managed identity has the App Configuration Data Reader role assignment.
- From Front Door portal, make sure that the origin is correctly setup to be able to authenticate with the App Configuration origin. Learn how to [use managed identities to authenticate to origins](/azure/frontdoor/origin-authentication-with-managed-identities)
- Verify that the Azure Front Door resource provider is registered in your subscription.

## Related content

- [Learn more about Azure Front Door](/azure/frontdoor/)
- [Configure App Configuration feature flags](/azure/azure-app-configuration/concept-feature-management)
- [Set up managed identities](/azure/active-directory/managed-identities-azure-resources/)
- [Monitor Azure Front Door performance](/azure/frontdoor/front-door-diagnostics)
