---
title: Load Configuration from Azure Front Door in Client Applications (Preview) 
description: Learn how to setup applications to connect to Azure Front Door.
author: avanigupta
ms.author: avgupta
ms.service: azure-app-configuration
ms.topic: how-to
ms.date: 12/02/2025
---

## Load Configuration from Azure Front Door in Client Applications (Preview) 

Integrating Azure App Configuration with Azure Front Door enables your client applications to retrieve configuration from edge locations worldwide, ensuring optimal performance at any scale. The integration process involves the following steps:

1. **Create configuration data in Azure App Configuration** - Define your application's key-values, feature flags, or snapshots in Azure App Configuration.

1. **Establish Azure Front Door integration** - Configure the connection between your App Configuration store and Azure Front Door through the Azure portal. The portal provides a guided experience to set up the configuration filters to control the data that is exposed through the Azure Front Door endpoint. [Setup Azure Front Door to connect to App Config](./how-to-connect-azure-front-door.md)

1. **Configure application to connect to Azure Front Door** - Use the App Configuration provider in your client application to connect to the Azure Front Door endpoint. The provider handles anonymous authentication and dynamic configuration updates. This document provides detailed steps for implementing this integration.

1. **Deploy and manage configuration** - Deploy your application to production. Your clients now retrieve configuration from the nearest Azure Front Door edge location automatically. Update configuration values in Azure App Configuration as needed - changes propagate globally based on your configured Azure Front Door cache expiration time without requiring application updates or redeployments.

> [!TIP]
> For a visual overview of the end‑to‑end setup, see the [configuration at scale walkthrough video](https://youtu.be/TzXvFgIAhUk).


## Client Application Samples

The following code demonstrates how to load configuration from Azure Front Door. The application retrieves all keys starting with "App1:" prefix and checks for updates every minute. When the application requests updates, Azure Front Door returns cached values if valid, or fetches fresh configuration from App Configuration service if the Azure Front Door cache expired.

Replace `{YOUR-AFD-ENDPOINT}` with your Azure Front Door endpoint, which looks something like `https://xxxx.azurefd.net`.

> [!NOTE]
> If your application loads only feature flags, you should add 2 key filters in the Azure Front Door rules - one for ALL keys with no label and second for all keys starting with ".appconfig.featureflag/{YOUR-FEATURE-FLAG-PREFIX}".

### [.NET MAUI](#tab/dotnet-maui)

    Use the `ConnectAzureFrontDoor` API to load configuration settings from Azure Front Door. 

    ```cs
    builder.Configuration.AddAzureAppConfiguration(options =>
    {
        options.ConnectAzureFrontDoor(new Uri("{YOUR-AFD-ENDPOINT}"))
                .Select("App1:*")
                .ConfigureRefresh(refreshOptions =>
                {
                    refreshOptions.RegisterAll()
                                    .SetRefreshInterval(TimeSpan.FromMinutes(1));
                });
    });
    ```

    For a complete sample app, refer to [MAUI App with Azure App Configuration and Azure Front Door](https://github.com/Azure-Samples/appconfig-maui-app-with-afd/blob/main/README.md).

### [JavaScript](#tab/javascript)

    Use the `loadFromAzureFrontDoor` API to load configuration settings from Azure Front Door. 

    ```javascript
    import { loadFromAzureFrontDoor } from "@azure/app-configuration-provider";
    
    const appConfig = await loadFromAzureFrontDoor("{YOUR-AFD-ENDPOINT}", {
        selectors: [{
            keyFilter: "App1:*"
        }],
        refreshOptions: {
            enabled: true,
            refreshIntervalInMs: 60_000
        }
    });

    const yoursetting = appConfig.get("App1:Version");

    ```

    For a complete sample app, refer to [JavaScript App with Azure App Configuration and Azure Front Door](https://github.com/Azure-Samples/appconfig-javascript-clientapp-with-afd/blob/main/README.md).


> [!NOTE]
> The key-value filters used in your application must match the filters configured while creating the Azure Front Door endpoint. For example, if your endpoint is configured to allow access to keys starting with "App1:" prefix, the application code must also load keys starting with "App1:". If your application attempts to load different keys, such as "App1:Version" when only "App1:" is allowlisted in Azure Front Door rules, the request is rejected.

## Troubleshooting

### Configuration doesn't load
- Verify Azure Front Door endpoint URL is correctly configuration in application code
- Check for warnings in the App Config Portal and fix the issues if any.
- Make sure the correct scoping filters are set when configuring the Azure Front Door endpoint. These filters (for key-values, snapshots, and feature flags) define the regex rules that block requests that don't match specified filters. If your app can’t access its configuration, review Azure Front Door rules to find any blocking regex patterns. Update the rule with the right filter or create a new AFD endpoint from the App Configuration portal. Learn more about [Azure Front Door routing rules](/azure/frontdoor/front-door-rules-engine).

### Configuration doesn't refresh
- Azure Front Door manages caching behavior, so updates from App Configuration aren’t immediately available to the application. Even if your app checks for changes frequently, AFD might serve cached data until its own cache expires. For example, if AFD caches for 10 minutes, your app will not see updates for at least 10 minutes, even though the app might be configured to refresh every minute. This design ensures eventual consistency, not real-time updates, which is expected for any CDN-based solution. Learn more about [Caching with Azure Front Door](/azure/frontdoor/front-door-caching).


## Language availability

| Language    | Minimum version / status  | Package Link |
|-------------|---------------------------|--------------|
| .NET        | 8.5.0-preview             | [Microsoft.Extensions.Configuration.AzureAppConfiguration](https://www.nuget.org/packages/Microsoft.Extensions.Configuration.AzureAppConfiguration/8.5.0-preview) |
| JavaScript  | 2.3.0-preview             | [@azure/app-configuration-provider](https://www.npmjs.com/package/@azure/app-configuration-provider/v/2.3.0-preview) |
| Java        | Work in progress          | N/A |
| Python      | Work in progress          | N/A |
| Go          | Work in progress          | N/A |


## Related Content

- [Hyperscale configuration for client applications](./concept-hyperscale-client-config-afd.md)
- [Setup Azure Front Door to connect to App Config](./how-to-connect-azure-front-door.md)
- [Learn more about Azure Front Door](/azure/frontdoor/)
- [Monitor Azure Front Door performance](/azure/frontdoor/front-door-diagnostics)
