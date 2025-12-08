---
title: Use App Configuration emulator in an Aspire solution
description: In this tutorial, you learn how to use App Configuration emulator for Aspire solutions.
services: azure-app-configuration
author: zhiyuanliang-ms
ms.service: azure-app-configuration
ms.devlang: csharp
ms.custom: devx-track-csharp, mode-other
ms.topic: quickstart
ms.date: 12/6/2025
ms.author: zhiyuanliang
#Customer intent: As an Aspire developer, I want to use Azure App Configuration emulator for local development and testing.
---

# Use App Configuration emulator in an Aspire solution

Azure App Configuration provides an official local [emulator](./emulator-overview.md) which is a containerized version of the App Configuration service. This tutorial shows how you can use App Configuration emulator in an Aspire solution for local development and testing.

## Prerequisites

- Finish the tutorial [Use dynamic configuration in an Aspire app](./quickstart-aspire.md).
- An OCI compliant container runtime, such as [Docker Desktop](https://www.docker.com/products/docker-desktop).

## Add App Configuration emulator resource

1. Navigate into the `AppHost` project's directory (created in the [Prerequisites](./enable-dynamic-configuration-aspire.md#prerequisites) steps).

1. Open the *AppHost.cs* file and add the following code.

    ```c#
    var appConfiguration = builder.AddAzureAppConfiguration("appconfiguration")
        .RunAsEmulator(); // use the App Configuration emulator
    ```

    When you call `RunAsEmulator`, the Aspire will pull the [App Configuration emulator image](https://mcr.microsoft.com/artifact/mar/azure-app-configuration/app-configuration-emulator/about) and runs a container as the App Configuration resource.

    > [!TIPS]
    > You can call `WithDataBindMount` or `WithDataVolume` to configure the emulator resource for persistent container storage.
    > ```c#
    > var appConfiguration = builder.AddAzureAppConfiguration("appConfiguration")
    >     .RunAsEmulator(emulator => {
    >         emulator.WithDataBindMount("./aace");
    >     });
    > ```

## Run the app locally

1. Start your container runtime. In this tutorial, we use Docker Desktop.

1. Run the `AppHost` project. Go to the Aspire dashboard. You see the App Configuration emulator resource is running.

    :::image type="content" source="media/aspire/dashboard-emulator.png" alt-text="Screenshot of the Aspire dashboard showing the App Configuration emulator resource.":::

   A container is started to run the App Configuration emulator.

   :::image type="content" source="media/aspire/docker.png" alt-text="Screenshot of the docker desktop running a container.":::

1. Click the URL of the `appconfiguration` resource. You see the App Configuration emulator UI.

1. Click the `Create` button on the upper-right corner.

    :::image type="content" source="media/aspire/emulator-ui.png" alt-text="Screenshot of the App Configuration emulator UI.":::

1. Add a new key `TestApp:Settings:Message`. Then, click the `Save` button.

    :::image type="content" source="media/aspire/emulator-create-key.png" alt-text="Screenshot of the App Configuration emulator UI of creating a new key value.":::

1. Go back to the Aspire dashboard and open the web app. Refresh the browser a few times. You see the message from the emulator.

    :::image type="content" source="media/aspire/emulator-message.png" alt-text="Screenshot of a web app with the message from App Configuration emulator.":::

## Next step

To learn more about App Configuration emualtor, continue to the following document.

> [!div class="nextstepaction"]
> [Azure App Configuration emulator overview](./emulator-overview.md)
