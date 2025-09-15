---
title: Call custom web APIs & REST APIs
description: Learn how to call your own web APIs and REST APIs from Azure Logic Apps by using the Azure App Service.
services: logic-apps
ms.suite: integration
ms.reviewer: estfan, azla
ms.topic: how-to
ms.custom: sfi-image-nochange
ms.date: 09/15/2025
#Customer intent: As an integration developer working with Azure Logic Apps, I want to create and make available my own API by using Azure App Service.
---

# Deploy and call custom APIs from workflows in Azure Logic Apps

[!INCLUDE [logic-apps-sku-consumption](includes/logic-apps-sku-consumption.md)]

After you [create your own APIs](./logic-apps-create-api-app.md) to use in logic app workflows, you need to deploy those APIs before you can call them. You can host your APIs on [Azure App Service](../app-service/overview.md), a platform-as-a-service (PaaS) offering that provides highly scalable, easy API hosting.

You can deploy your APIs as [web apps](../app-service/overview.md). Consider instead deploying your APIs as [API apps](../app-service/app-service-web-tutorial-rest-api.md), which make your job easier when you build, host, and consume APIs in the cloud and on premises. You don't have to change any code in your APIs to deploy your code to an API app. 

Although you can call any API from a logic app workflow, for the best experience, add [Swagger metadata](https://swagger.io/specification/) that describes your API's operations and parameters. This Swagger document helps your API integrate more easily and work better with logic app workflows.

## Deploy your API as a web app or API app

Before you can call your custom API from a logic app workflow, deploy your API as a web app or API app to Azure App Service. To make your Swagger document readable by your workflow, set the API definition properties and turn on cross-origin resource sharing (CORS) for your web app or API app.

1. In the [Azure portal](https://portal.azure.com), select your web app or API app.

1. In the app menu that opens, under **API**, select **API definition**. Set the **API definition location** to the URL for your swagger JSON file.

   :::image type="content" source="./media/logic-apps-custom-api-deploy-call/custom-api-swagger-url.png" alt-text="Screenshot shows the Azure portal with web app's API definition pane open with the API definition URL of a Swagger document for your custom API.":::

   To get your site URL, go to the **Overview** page and copy **Default domain**. The location is based on that value, such as: `https://<your-app-location>/swagger/docs/v1`.

1. Select **Save**.

1. Under **API**, select **CORS**. Set the CORS policy for **Allowed Origins** to **'*'** (allow all) and select **Save**.

   :::image type="content" source="./media/logic-apps-custom-api-deploy-call/custom-api-cors.png" alt-text="Screenshot shows web app's CORS pane with Allowed Origins set to *, which allows all.":::

   This setting permits requests from the workflow designer.

For more information, see [Host a RESTful API with CORS in Azure App Service](../app-service/app-service-web-tutorial-rest-api.md).

## Call your custom API from logic app workflows

After you set up the API definition properties and CORS, your custom API's triggers and actions should be available for you to include in your logic app workflow. 

- To view websites that have OpenAPI URLs, you can browse your subscription websites in the workflow designer.

- To view available actions and inputs by pointing at a Swagger document, use the [HTTP + Swagger](../connectors/connectors-native-http-swagger.md) trigger or action.

- To call any API, including APIs that don't have or expose a Swagger document, you can always create a request with the [HTTP action](../connectors/connectors-native-http.md).

## Next step

- [Custom connectors in Azure Logic Apps](../logic-apps/custom-connector-overview.md)
