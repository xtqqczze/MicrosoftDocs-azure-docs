---
title: Import an Azure OpenAI API as REST API - Azure API Management
description: How to import an Azure OpenAI API as a REST API from Azure OpenAI in Foundry Models or from an OpenAPI specification.
ms.service: azure-api-management
author: dlepow
ms.author: danlep
ms.topic: how-to
ms.date: 12/18/2025
ms.update-cycle: 180-days
ms.collection: ce-skilling-ai-copilot
ms.custom:
  - template-how-to
  - build-2024
  - sfi-image-nochange
---

# Import an Azure OpenAI API 

[!INCLUDE [api-management-availability-all-tiers](../../includes/api-management-availability-all-tiers.md)]

You can import AI model endpoints deployed in [Azure OpenAI in Foundry Models](/azure/ai-services/openai/overview) to your API Management instance as a REST API. Use AI gateway policies and other capabilities in API Management to simplify integration, improve observability, and enhance control over the model endpoints.


This article shows two options to import an Azure OpenAI API into an Azure API Management instance as a REST API:

- [Import an Azure OpenAI API directly from a deployment in Microsoft Foundry](#option-1-import-api-from-azure-openai) (recommended)
 
- [Download and edit the OpenAPI specification](#option-2-add-an-openapi-specification-to-api-management) for Azure OpenAI and add it to API Management as an OpenAPI API.

Learn more about managing AI APIs in API Management:

* [AI gateway capabilities in Azure API Management](genai-gateway-capabilities.md)

## Prerequisites

- An existing API Management instance. [Create one if you haven't already](get-started-create-service-instance.md).
- A Microsoft Foundry resource with an Azure OpenAI model     deployed. For more information about model deployment in Azure OpenAI, see the [resource deployment guide](/azure/ai-services/openai/how-to/create-resource).

    Make a note of the ID (name) of the deployment. You'll need it when you test the imported API in API Management.

    > [!NOTE]
    > API Management policies such as [azure-openai-token-limit](azure-openai-token-limit-policy.md) and [azure-openai-emit-token-metric](azure-openai-emit-token-metric-policy.md) are supported for certain API endpoints exposed through specific Azure OpenAI models. For more information, see [Supported Azure OpenAI models](azure-openai-token-limit-policy.md#supported-azure-openai-in-azure-ai-foundry-models).

- Permissions to grant access to the Azure OpenAI resource from the API Management instance.

## Option 1. Import API from Azure OpenAI 
 
You can import an Azure OpenAI model deployment directly from Microsoft Foundry to API Management. For details, see [Import a Microsoft Foundry API](microsoft-foundry-api.md). 

When you import the API:

* Specify the Microsoft Foundry service that hosts the Azure OpenAI model deployment.
* Specify the **Azure OpenAI** client compatibility option. This option configures the API Management API with a `/openai` endpoint.

## Option 2. Add an OpenAPI specification to API Management

Alternatively, manually download the OpenAPI specification for the Azure OpenAI REST API and add it to API Management as an OpenAPI API.

### Download the OpenAPI specification

Download the OpenAPI specification for the Azure OpenAI REST API, such as the [2024-10-21 GA version](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/cognitiveservices/data-plane/AzureOpenAI/inference/stable/2024-10-21/inference.json).

1. In a text editor, open the specification file that you downloaded.
1. In the `servers` element in the specification, substitute the name of your Azure OpenAI endpoint in the placeholder values of `url` and `default` endpoint. For example, if your Azure OpenAI endpoint is `contoso.cognitiveservices.azure.com`, update the `servers` element with the following values:

    * **url**: `https://contoso.cognitiveservices.azure.com/openai`
    * **default** endpoint: `contoso.cognitiveservices.azure.com`
  
    ```json
    [...]
    "servers": [
        {
          "url": "https://contoso.cognitiveservices.azure.com/openai",
          "variables": {
            "endpoint": {
              "default": "contoso.cognitiveservices.azure.com"
            }
          }
        }
      ],
    [...]
    ```
1. Make a note of the value of the API `version` in the specification. You'll need it to test the API. Example: `2024-10-21`.

### Add OpenAPI specification to API Management

1. In the [Azure portal](https://portal.azure.com), navigate to your API Management instance.
1. In the left menu, select **APIs** > **+ Add API**.
1. Under **Define a new API**, select **OpenAPI**. Enter a **Display name** and **Name** for the API.
1. Enter an **API URL suffix** ending in `/openai` to access the Azure OpenAI API endpoints in your API Management instance. Example: `my-openai-api/openai`.  
1. Select **Create**.

The API is imported and displays operations from the OpenAPI specification.

## Configure authentication to Azure OpenAI API

To authenticate to the Azure OpenAI API, you supply an API key or a managed identity. If you imported the Azure OpenAI API directly to your API Management instance, authentication using the API Management instance's managed identity is automatically configured. 

If you added the Azure OpenAI API from its OpenAPI specification, you need to configure authentication. For more information about configuring authentication using API Management policies, see [Authenticate and authorize to AI APIs](api-management-authenticate-authorize-ai-apis.md).

## Test the Azure OpenAI API

To ensure that your Azure OpenAI API is working as expected, test it in the API Management test console. You need to supply a model deployment ID (name) configured in the Azure OpenAI resource and the API version to test the API.

1. Select the API you created in the previous step.
1. Select the **Test** tab.
1. Select an operation that's compatible with the model you deployed in the Azure OpenAI resource. 
    The page displays fields for parameters and headers.
1. In **Template parameters**, enter the following values:
     * `deployment-id` - the ID of a deployment in Azure OpenAI   
     * `api-version` - a valid Azure OpenAI API version, such as the API version you selected when you imported the API.
      :::image type="content" source="media/azure-openai-api-from-specification/test-azure-openai-api.png" alt-text="Screenshot of testing an Azure OpenAI API in the portal." lightbox="media/azure-openai-api-from-specification/test-azure-openai-api.png" :::
1. Enter other parameters and headers as needed. Depending on the operation, you might need to configure or update a **Request body**.
    > [!NOTE]
    > In the test console, API Management automatically populates an **Ocp-Apim-Subscription-Key** header, and configures the subscription key of the built-in [all-access subscription](api-management-subscriptions.md#all-access-subscription). This key enables access to every API in the API Management instance. Optionally display the **Ocp-Apim-Subscription-Key** header by selecting the "eye" icon next to the **HTTP Request**.
1. Select **Send**.

    When the test is successful, the backend responds with a successful HTTP response code and some data. Appended to the response is token usage data to help you monitor and manage your Azure OpenAI API token consumption.

    :::image type="content" source="media/azure-openai-api-from-specification/api-response-usage.png" alt-text="Screenshot of token usage data in API response in the portal." :::

[!INCLUDE [api-management-define-api-topics.md](../../includes/api-management-define-api-topics.md)]
