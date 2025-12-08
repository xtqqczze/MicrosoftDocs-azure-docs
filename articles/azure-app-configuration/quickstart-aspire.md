---
title: Quickstart for Azure App Configuration with Aspire
description: Create an Aspire solution with Azure App Configuration to centralize storage and management of application settings.
services: azure-app-configuration
author: zhiyuanliang-ms
ms.service: azure-app-configuration
ms.devlang: csharp
ms.custom: devx-track-csharp, mode-other
ms.topic: quickstart
ms.date: 12/3/2025
ms.author: zhiyuanliang
#Customer intent: As an Aspire developer, I want to learn the centralized configuration cloud-native solution for Aspire.
---

# Quickstart: Create an Aspire solution with Azure App Configuration

In this quickstart, you'll use Azure App Configuration to externalize storage and management of your app settings for an Aspire project. You will use Azure App Configuration Aspire integration libraries to provision an App Configuration resource and use App Configuration in each distributed app.

## Prerequisites

- An Azure account with an active subscription. [Create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- [Set up the development environment](https://aspire.dev/get-started/prerequisites) for Aspire.
- [Create a new Aspire solution](https://aspire.dev/get-started/first-app/?lang=csharp) using the Aspire Starter template.

## Test the app locally

The Aspire Starter template includes a frontend web app that communicates with a Minimal API project. The API project is used to provide fake weather data to the frontend. The frontend app is configured to use service discovery to connect to the API project. There is also an [`AppHost`](/dotnet/aspire/fundamentals/app-host-overview) project which orchestrates all distributed applications in the Aspire solution.

1. Run the `AppHost` project. You see the Aspire dashboard in your browser.

    :::image type="content" source="media/aspire/dashboard.png" alt-text="Screenshot of the Aspire dashboard with web frontend and api service resources.":::

1. Click the URL of the web frontend. You see a page with a welcome message.

    :::image type="content" source="media/aspire/web-app.png" alt-text="Screenshot of a web app with a welcome message.":::

## Add Azure App Configuration to the Aspire solution

1. Go to the `AppHost` project. Add the [`Aspire.Hosting.Azure.AppConfiguration`](https://www.nuget.org/packages/Aspire.Hosting.Azure.AppConfiguration) Nuget package. 

1. Open the *AppHost.csproj*. Make sure that the `Aspire.Hosting.AppHost` package version is not ealier than the version you installed. Otherwise, you need to upgrade the `Aspire.Hosting.AppHost` package.

1. Open the *AppHost.cs* file and add the following code.

    ```csharp
    var builder = DistributedApplication.CreateBuilder(args);

    // Add an Azure App Configuration resource
    var appConfiguration = builder.AddAzureAppConfiguration("appconfiguration");
    ```

1. Add the reference of App Configuration resource and configure the `webfrontend` project to wait for it.

    ```csharp
    builder.AddProject<Projects.AspireApp_Web>("webfrontend")
        .WithExternalHttpEndpoints()
        .WithHttpHealthCheck("/health")
        .WithReference(apiService)
        .WaitFor(apiService)
        .WithReference(appConfiguration) // reference the App Configuration resource
        .WaitFor(appConfiguration); // wait for the App Configuration resource to enter the Running state before starting the resource
    ```

    > [!IMPORTANT]
    > When you call `AddAzureAppConfiguration`, it implicitly calls `AddAzureProvisioning`, which adds support for generating Azure resources dynamically during app startup. The app must configure the appropriate subscription and location. For more information, see [Local Azure provisioning](https://aspire.dev/integrations/cloud/azure/local-provisioning/#configuration).
    > If you are using the latest Aspire SDK, you can configure the subscription information through the aspire dashboard.
    > :::image type="content" source="media/aspire/azure-subscription.png" alt-text="Screenshot of Aspire dashboard asking for Azure Subscription information.":::

    > [!TIPS]
    > You can reference existing App Configuration resources by chaining a call `RunAsExisting()` on `builder.AddAzureAppConfiguration("appconfig")`. For more information, go to [Use existing Azure resources](https://aspire.dev/integrations/cloud/azure/overview/#use-existing-azure-resources).

1. Run the `AppHost` project. You see the Azure App Configuration resource is provisioning.

    :::image type="content" source="media/aspire/resource-provisioning.png" alt-text="Screenshot of Aspire dashboard provisioning Azure App Configuration resource.":::

1. Wait for a few minutes and you see the Azure App Configuration resource is provisioned and is running.

    :::image type="content" source="media/aspire/resource-provisioned.png" alt-text="Screenshot of Aspire dashboard with Azure App Configuration resource running.":::

1. Go to the Azure portal by clicking the deployment URL on the Aspire dashboard. You see the deployment is complete and you can go to your Azure App Configuration resource.

    :::image type="content" source="media/aspire/deployment-complete.png" alt-text="Screenshot of Azure portal showing the App Configuration deployment is complete.":::

> [!TIPS]
> You can use the App Configuration emulator for local development in Aspire. For more information, go to [Use App Configuration emulator in Aspire](./use-emulator-aspire.md).

## Add a key-value

Add the following key-value to your App Configuration store and leave **Label** and **Content Type** with their default values. For more information about how to add key-values to a store using the Azure portal or the CLI, go to [Create a key-value](./quickstart-azure-app-configuration-create.md#create-a-key-value).

| Key                        | Value                                 |
|----------------------------|---------------------------------------|
| *TestApp:Settings:Message* | *Hello from Azure App Configuration!* |

## Use App Configuration in the web application

1. Go to the `Web` project. Add the [`Aspire.Microsoft.Extensions.Configuration.AzureAppConfiguration`](https://www.nuget.org/packages/Aspire.Microsoft.Extensions.Configuration.AzureAppConfiguration) Nuget package. 

1. Open the *Program.cs* file and add the following code.

    ```csharp
    var builder = WebApplication.CreateBuilder(args);

    // Use Azure App Configuration
    builder.AddAzureAppConfiguration("appconfiguration"); // use the resource name defined in AppHost project
    ```

1. Open the *Components/Pages/Home.razor* file and add the following code.

    ```cs
    @page "/"

    @inject IConfiguration Configuration

    <PageTitle>Home</PageTitle>

    <h1>Hello, world!</h1>

    @if (!string.IsNullOrWhiteSpace(message))
    {
        <div class="alert alert-info">@message</div>
    }
    else
    {
        <div class="alert alert-info">Welcome to your new app.</div>
    }

    @code {
        private string? message;

        protected override void OnInitialized()
        {
            var configured = Configuration["TestApp:Settings:Message"];
            message = string.IsNullOrWhiteSpace(configured) ? null : configured;
        }
    }
    ```

1. Restart the `AppHost` project. Go to the Aspire dashboard and click the URL of the web frontend. 

    :::image type="content" source="media/aspire/dashboard-updated.png" alt-text="Screenshot of Aspire dashboard showing resources.":::

1. You see a page with a welcome message from Azure App Configuration.

    :::image type="content" source="media/aspire/web-app-message.png" alt-text="Screenshot of a web app with a welcome message from Azure App Configuration.":::

## Next steps

In this quickstart, you:

* Add an App Configuration store in an Aspire solution.
* Read your App Configuration store's key-values with the App Configuration Aspire integration library.
* Displayed a web page using the settings you configured in your App Configuration store.

To learn how to configure your Aspire app to dynamically refresh configuration settings, continue to the next tutorial.

> [!div class="nextstepaction"]
> [Enable dynamic configuration](./enable-dynamic-configuration-aspire.md)

To learn how to use feature flag in your Aspire app, continue to the next tutorial.

> [!div class="nextstepaction"]
> [Use feature flag in Aspire](./quickstart-feature-flag-aspire.md)