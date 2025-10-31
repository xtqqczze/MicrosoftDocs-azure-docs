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
- Basic understanding of CDN and content delivery concepts

## Set up the Azure Front Door integration

To integrate Azure Front Door with your App Configuration store, follow these steps:

1. In the Azure portal, navigate to your App Configuration store.

1. In the left navigation pane, under **Settings**, select **Azure Front Door (preview)**.

1. Configure the connection settings:

   - **Subscription**: Select the subscription for your Azure Front Door profile
   - **Resource group**: Select the resource group for the profile
   - **Create new/use existing profile**: Choose whether to create a new profile or use an existing one

Continue with the steps that match your selection:

* To create a new profile, see [Create a new Azure Front Door profile](#create-a-new-azure-front-door-profile).
* To connect an existing profile, see [Connect to an existing Azure Front Door profile](#connect-to-an-existing-azure-front-door-profile).

### Create a new Azure Front Door profile

1. In **Profile name**, enter a name for your new Azure Front Door profile.

1. Choose a pricing tier based on your needs:

   - **Azure Front Door Standard**: Content delivery optimized
   - **Azure Front Door Premium**: Security optimized with enhanced security features

   For a detailed overview and comparison of Azure Front Door pricing tiers, see [Compare pricing between Azure Front Door tiers](/azure/frontdoor/understanding-pricing).

1. Create an endpoint that uses this App Configuration store as origin:

   1. Basic settings:

   - **Endpoint name**: Enter a descriptive name for your endpoint
   - **Endpoint host name**: Automatically generated based on your endpoint name
   - **Origin host name**: Select your App Configuration store and any replicas from the dropdown. These are added to the origin group so Azure Front Door can route traffic to them. For details on how origin groups improve availability and performance, see [Azure Front Door routing methods](/azure/frontdoor/routing-methods).

   1. **Identity type**: Choose the managed identity type for Azure Front Door to access your App Configuration store:

      - **System assigned managed identity**: Automatically enabled; no additional selection required.
      - **User assigned managed identity**: Select the managed identity from the dropdown.

   1. **Cache Duration for Azure Front Door**: Configure caching to improve performance and reduce latency,and typical values range from a few seconds for dynamic content to several hours for static assets. Default duration is 10 minutes. For more details about caching, see [Caching with Azure Front Door](/azure/frontdoor/front-door-caching).

   1. **Filter Configuration to scope the request**: Configure one or more filters to control the requests Azure Front Door, improving security and reducing unnecessary load.
      
      - Specify one or more **Key-values** to restrict access to specific keys.
      - Select one or more **Snapshot name**s to restrict access to specific snapshots.

1. Select **Create & Connect** to create the profile and establish the connection.

After successfully connecting to Azure Front Door, you might want to [create additional endpoints](#create-additional-endpoints) for different scenarios. This section explains how to set up multiple endpoints.

### Connect to an existing Azure Front Door profile

1. In **Profile name**, select your existing Azure Front Door profile from the dropdown.

1. Select **Connect** to establish the connection.

After successful connection, you see your subscription information, the connected Azure Front Door profile name as a clickable link, and an **Existing Endpoints** section. Any endpoints in the connected Azure Front Door profile that use this App Configuration store or its replicas as an origin appear here.

## Create additional endpoints

After connecting to an Azure Front Door profile, you can create multiple endpoints for different scenarios or regions.

1. From the Azure Front Door page in your App Configuration store, select **Create Endpoint**.

1. Configure the new endpoint:

   1. Basic settings:

   - **Endpoint name**: Enter a descriptive name for your endpoint
   - **Endpoint host name**: Automatically generated based on your endpoint name
   - **Origin host name**: Select your App Configuration store and any replicas from the dropdown. These are added to the origin group so Azure Front Door can route traffic to them. For details on how origin groups improve availability and performance, see [Azure Front Door routing methods](/azure/frontdoor/routing-methods).

   1. **Identity type**: Choose the managed identity type for Azure Front Door to access your App Configuration store:

      - **System assigned managed identity**: Automatically enabled; no additional selection required.
      - **User assigned managed identity**: Select the managed identity from the dropdown.

   1. **Cache Duration for Azure Front Door**: Configure caching to improve performance and reduce latency,and typical values range from a few seconds for dynamic content to several hours for static assets. Default duration is 10 minutes. For more details about caching, see [Caching with Azure Front Door](/azure/frontdoor/front-door-caching).

   1. **Filter Configuration to scope the request**: Configure one or more filters to control the requests Azure Front Door, improving security and reducing unnecessary load.
      
      - Specify one or more **Key-values** to restrict access to specific keys.
      - Select one or more **Snapshot name**s to restrict access to specific snapshots.

1. Select **Create** to create the new endpoint.

The new endpoint appears in the **Existing endpoints** table, showing the endpoint URL, origin URL, origin location, and any configuration warnings that need attention.

## Monitor endpoint status

Use the **Existing Endpoints** table to monitor your Azure Front Door endpoints and identify configuration issues.

The table displays:
- **Azure Front Door Endpoint**: The endpoint URL (clickable link)
- **Origin**: The origin URL pointing to your App Configuration store
- **Origin Location**: The Azure region where the origin is located
- **Warnings**: Configuration issues that may need attention

Monitor for warnings such as "Identity not configured" which indicate additional setup requirements. Address these warnings promptly to ensure proper functionality.

## Manage endpoint configuration

From the main Azure Front Door pane in your App Configuration store, you can:

- **Create endpoint**: Add new endpoints to your Azure Front Door profile
- **Refresh**: Update the endpoint list to reflect recent changes
- **Feedback**: Provide feedback on the preview feature
- **Disconnect**: Remove the integration between your App Configuration store and Azure Front Door

Regular monitoring and management ensure optimal performance and security of your content delivery setup.

## Disconnect Azure Front Door integration

When you no longer need the integration, you can disconnect your App Configuration store from Azure Front Door.

1. From the Azure Front Door pane in your App Configuration store, select **Disconnect**.

1. Review the confirmation dialog showing:

   - Resource group information
   - Disconnected Azure Front Door profile

1. Confirm the action by selecting **OK**.

> [!WARNING]
> Disconnecting removes the integration between your App Configuration store and Azure Front Door. Your Front Door profile and endpoints remain in Azure but are no longer managed through App Configuration.

## Troubleshoot common issues

### Resolve identity configuration warnings

If endpoints show identity configuration warnings:

1. Verify that managed identity is properly configured for the endpoint.
1. Ensure the identity has appropriate permissions to access App Configuration.
1. Check that the correct identity type is selected in the endpoint configuration.

### Fix endpoint accessibility issues

If you can't access endpoints:

1. Verify that the origin host name is correctly configured.
1. Check network connectivity between Azure Front Door and App Configuration.
1. Confirm that DNS resolution is working properly.

### Address connection failures

If connection attempts fail:

1. Ensure you have appropriate permissions in the subscription and resource group.
1. Verify that the Azure Front Door resource provider is registered in your subscription.
1. Check for any service-level issues on the Azure status page.

For additional help, use the **Feedback** option to report preview-specific problems or contact Azure support for subscription-related issues.

## Related content

- [Learn more about Azure Front Door](/azure/frontdoor/)
- [Configure App Configuration feature flags](/azure/azure-app-configuration/concept-feature-management)
- [Set up managed identities](/azure/active-directory/managed-identities-azure-resources/)
- [Monitor Azure Front Door performance](/azure/frontdoor/front-door-diagnostics)
