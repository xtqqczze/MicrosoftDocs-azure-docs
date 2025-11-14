---
title: 'Tutorial: Host an MCP server on Azure Functions'
description:
author: lilyjma
ms.author: jiayma
ms.topic: tutorial
ms.date: 11/14/2025
zone_pivot_groups: programming-languages-set-functions

#Customer intent: As a developer, I want to learn how to create and host remote and secured MCP servers on Azure Functions. 
---

# Tutorial: Host an MCP server on Azure Functions

This article shows you how to host remote [Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro) (MCP) servers on Azure Functions. You also learn how to leverage built-in authentication to configure server endpoint authorization and better secure your AI tools. 

There are two ways to host a remote MCP server in Azure Functions:
<!-- Tables are great for AI ingestion. Maybe also share this into the MCP overview article. -->
| MCP server option | Description | Best for... |
| ---- | ---- | ---- | 
| [**MCP extension server**](functions-mcp-tutorial.md?tabs=mcp-extension) | Uses the [Azure Functions MCP extension](./functions-bindings-mcp.md) to create custom MCP servers, where the extension trigger lets you define your tool endpoints. These servers are supported in all Functions languages and are developed, deployed, and managed as any other function app. | When you're already familiar with Functions and its [bindings-based programming model](./functions-triggers-bindings.md). |
| [**Self-hosted server**](functions-mcp-tutorial.md?tabs=self-hosted) | Functions can host an MCP server project created using the standard MCP SDKs. | When you've already built your server using the official MCP SDKs and are looking for event-driven, serverless, and scalable hosting in Azure. |

[!INCLUDE [functions-custom-handler-mcp-preview](../../includes/functions-custom-handler-mcp-preview.md)]

This tutorial covers both MCP server options supported by Functions. Select the tab that best fits your scenario. 

### [MCP extension server](#tab/mcp-extension)

In this tutorial, you use Visual Studio Code to:

> [!div class="checklist"]
> * Create an MCP server project using the MCP extension.
> * Run and verify your MCP server locally.
> * Create a function app in Azure.
> * Deploy your MCP server project.
> * Enable built-in authentication.

### [Self-hosted server](#tab/self-hosted)

> [!div class="checklist"]
> * Create a self-hosted MCP server project.
> * Run and verify your MCP server locally.
> * Create a function app in Azure.
> * Deploy your MCP server project.
> * Enable built-in authentication.

---

::: zone pivot="programming-language-java,programming-language-javascript,programming-language-powershell"  
> [!IMPORTANT]  
> This article currently supports only C#, Python, and TypeScript. To complete the quickstart, select one of these supported languages at the top of the article.
::: zone-end  
::: zone pivot="programming-language-typescript"
This article supports version 4 of the Node.js programming model for Azure Functions.
::: zone-end
::: zone pivot="programming-language-python"
This article supports version 2 of the Python programming model for Azure Functions.
::: zone-end
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 
## Prerequisites 

+ [Visual Studio Code](https://code.visualstudio.com/) with these extensions:

    + [Azure Functions extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions). This extension requires [Azure Functions Core Tools](functions-run-local.md) and tries to install it when it's not available. 

    + [Azure Developer CLI extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.azure-dev).

+ [Azurite storage emulator](../storage/common/storage-install-azurite.md#install-azurite) 

+ [Azure CLI](/cli/azure/install-azure-cli). You can also run Azure CLI commands in [Azure Cloud Shell](../cloud-shell/overview.md).

+ An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn). 
::: zone-end 
::: zone pivot="programming-language-python" 
+ [uv](https://docs.astral.sh/uv/getting-started/installation/)
::: zone-end  
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 
## Create your MCP server project 

Use Visual Studio Code to locally create an MCP server project in your preferred language. 

1. In Visual Studio Code, press <kbd>F1</kbd> to open the command palette. Search for and run the command `Azure Functions: Create New Project...`.

1. Choose the directory location for your project workspace and choose **Select**. You should either create a new folder or choose an empty folder for the project workspace. Don't choose a project folder that is already part of a workspace.
::: zone-end  
::: zone pivot="programming-language-csharp"  
1. Provide the following information at the prompts:

    ### [MCP extension server](#tab/mcp-extension)

    |Prompt|Selection|
    |--|--|
    |**Select a project type**|Choose `C#`.|
    |**Select a .NET runtime**|Choose `.NET 8.0 LTS`.|
    |**Select a template for your project's first function**|Choose `MCP Tool trigger`.|
    |**Provide a function name**|Type `McpTrigger`.|
    |**Provide a namespace** | Type `My.Functions`. |
    |**Authorization level**|Choose `FUNCTION`, which requires access key when connecting to the remote MCP server.|
    |**Select how you would like to open your project**|Choose `Open in current window`.|

    ### [Self-hosted server](#tab/self-hosted)

    |Prompt|Selection|
    |--|--|
    |**Select a project type**|Choose `Self-hosted MCP server`.|
    |**Select a language for the MCP server**|Choose `C#`.|
    |**Include sample server code**|Choose `Yes`.|
    |**Select how you would like to open your project**|Choose `Open in current window`.|

    --- 
    ::: zone-end  
    ::: zone pivot="programming-language-typescript" 
1. Provide the following information at the prompts:

    ### [MCP extension server](#tab/mcp-extension)

    |Prompt|Selection|
    |--|--|
    |**Select a project type**|Choose `TypeScript`.|
    |**Select a template for your project's first function**|Choose `MCP Tool trigger`.|
    |**Provide a function name**|Type `mcpToolTrigger`.|
    |**Authorization level**|Choose `FUNCTION`, which requires access key when connecting to the remote MCP server.|
    |**Select how you would like to open your project**|Choose `Open in current window`.|

    ### [Self-hosted server](#tab/self-hosted)

    |Prompt|Selection|
    |--|--|
    |**Select a project type**|Choose `Self-hosted MCP server`.|
    |**Select a language for the MCP server**|Choose `TypeScript`.|
    |**Include sample server code**|Choose `Yes`.|
    |**Select how you would like to open your project**|Choose `Open in current window`.|

    --- 
    ::: zone-end  
    ::: zone pivot="programming-language-python" 
1. Provide the following information at the prompts:

    ### [MCP extension server](#tab/mcp-extension)

    |Prompt|Selection|
    |--|--|
    |**Select a project type**| Choose `Python`.|
    |**Select a Python interpreter to create a virtual environment**| Choose your preferred Python interpreter. If an option isn't shown, type in the full path to your Python binary.|
    |**Select a template for your project's first function** | Choose `MCP Tool trigger`. |
    |**Name of the function you want to create**| Enter `mcp_trigger`.|
    |**Authorization level**| Choose `FUNCTION`, which requires access key when connecting to the remote MCP server.|
    |**Select how you would like to open your project** | Choose `Open in current window`.|

    ### [Self-hosted server](#tab/self-hosted)

    |Prompt|Selection|
    |--|--|
    |**Select a project type**|Choose `Self-hosted MCP server`.|
    |**Select a language for the MCP server**|Choose `Python`.|
    |**Include sample server code**|Choose `Yes`.|
    |**Select how you would like to open your project**|Choose `Open in current window`.|

    ---

::: zone-end
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 

### [MCP extension server](#tab/mcp-extension)

Using this information, Visual Studio Code generates a code project for an MCP server trigger. You can view the local project files in the Explorer.

### [Self-hosted server](#tab/self-hosted)

Self-hosted MCP servers run as [custom handlers](./functions-custom-handlers.md) in Azure Functions. You can think of custom handlers as lightweight web servers that receive events from the Azure Functions host. 

Using this information, Visual Studio Code generates an MCP server project, which includes these required files: 

| File | Description |
| ----- | ----- |
| host.json | This file is required by the Azure Functions host to run the server as an MCP custom handler. |
| local.settings.json | This file is required by Azure Functions Core Tools to run the server locally. Core Tools provides a local version of the Functions runtime, and it uses this file for specifying required environment variables. |

The project also includes language specific implementation of a simple MCP server and files required by that language.

--- 

## Start the MCP server locally 

### [MCP extension server](#tab/mcp-extension)

Function apps need a storage component to run. Before starting the server, start the local storage emulator: 

1. In _local.setting.json_, ensure you have `"AzureWebJobsStorage": "UseDevelopmentStorage=true"`.

1. In Visual Studio Code, press <kbd>F1</kbd> to open the command palette. In the command palette, search for and select `Azurite: Start`.

1. Check the bottom bar and verify that Azurite emulation services are running. If so, you can now run the server locally.

1. To start running locally, press <kbd>F5</kbd>. 

### [Self-hosted server](#tab/self-hosted)

Open a new terminal (``Ctrl+Shift+` ``), start the server by running the following command: 
::: zone-end  
::: zone pivot="programming-language-python" 

```shell
uv run func start
```
::: zone-end  
::: zone pivot="programming-language-csharp" 

```shell
func start
``` 
::: zone-end  
::: zone pivot="programming-language-typescript"

```shell
npm install
npm run build
func start
```
::: zone-end  
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 

---

## Test the server

1. Find the `.vscode` directory and open `mcp.json`. The editor should add the server's connection info.  

1. Start the server by selecting the **Start** button above server name.

1. When you connect to the server, you see the number of tools available above the server name. 

1. Open Visual Studio Code Copilot chat in agent mode, then ask a question. For example, "Greet with #your-local-server-name". This question ensures Copilot uses the server to help answer the question. 

1. When Copilot requests to run a tool from the local MCP server, select **Allow**.

1. Disconnect from the server when you finish testing by selecting **Stop**, and `Cntrl+C` to stop running it locally. 

>[!TIP]
>In the Copilot chat window, select the tool icon in the bottom to see the list of servers and tools available for the chat. Ensure the local MCP server is checked when testing.
::: zone-end  
## Remote server authentication options 

Your remote MCP server supports two server authentication options:

1. _Built-in server authorization and authentication (preview)_
    The built-in feature implements the requirements of the [MCP authorization specification](https://modelcontextprotocol.io/specification/2025-06-18/basic/authorization) protocol, such as issuing 401 challenge and hosting the Protected Resource Metadata (PRM). When you enable the feature, clients attempting to access the server are redirected to identity providers like Microsoft Entra ID for authentication before connecting. Continue following instructions in the next section to enable this built-in feature.

1. _Host-based authentication with access key_
    This approach requires an access key in the client request header when connecting to the MCP server. If this approach is sufficient for your needs, you don't need to follow the sections below. Skip directly to [Create the function app in Azure](#create-the-function-app-in-azure).

>[!NOTE]
>This tutorial contains detailed configuration instructions for the built-in server authorization and authentication feature, which might also be referred to as _App Service Authentication_ in other articles. You can find an overview of the feature and some usage guidance in the [Configure built-in server authorization (preview)](../app-service/configure-authentication-mcp.md) article.
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 
## Disable host-based authentication  

The built-in server authorization feature is a component separate from Azure Functions. To configure it, you must first disable Functions host-based authentication and allow anonymous access. 
::: zone-end  
::: zone pivot="programming-language-python" 
### [MCP extension server](#tab/mcp-extension)
To disable host-based authentication in MCP extension servers, set the authentication level to anonymous:

```python
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)
```

### [Self-hosted server](#tab/self-hosted)
To disable host-based authentication for self-hosted MCP servers, add the following code in the `customHandler` section:

```json
"customHandler": {
    // Other properties
    "http": {
        "DefaultAuthorizationLevel": "anonymous"
    }
}
```
---
::: zone-end  
::: zone pivot="programming-language-csharp" 
### [MCP extension server](#tab/mcp-extension)
To disable host-based authentication in MCP extension servers, set the authentication level to anonymous:



### [Self-hosted server](#tab/self-hosted)
To disable host-based authentication for self-hosted MCP servers, add the following code in the `customHandler` section:

```json
"customHandler": {
    // Other properties
    "http": {
        "DefaultAuthorizationLevel": "anonymous"
    }
}
```
---

::: zone-end  
::: zone pivot="programming-language-typescript"  
### [MCP extension server](#tab/mcp-extension)
To disable host-based authentication in MCP extension servers, set the authentication level to anonymous:



### [Self-hosted server](#tab/self-hosted)
To disable host-based authentication for self-hosted MCP servers, add the following code in the `customHandler` section:

```json
"customHandler": {
    // Other properties
    "http": {
        "DefaultAuthorizationLevel": "anonymous"
    }
}
```
---

::: zone-end  
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 
## Create the function app in Azure

Create a [Function app in the Azure portal](./functions-create-function-app-portal.md). 

>[!NOTE] Self-hosted servers must choose **Flex Consumption** as the hosting plan.  

## Deploy the MCP server project 

### [MCP extension server](#tab/mcp-extension)
[!INCLUDE [functions-deploy-project-vs-code](../../includes/functions-deploy-project-vs-code.md)]

### [Self-hosted server](#tab/self-hosted)
Before deploying the server, add the required app settings: 

1. Sign in to your account and select your subscription: 

    ```shell
    az login
    ```
1. Add the setting `AzureWebJobsFeatureFlags` (plural) to the app with the value `EnableMcpCustomHandlerPreview`: 

    ```shell
    az functionapp config appsettings set --name <function-app-name> --resource-group <resource-group-name> --settings "AzureWebJobsFeatureFlags=EnableMcpCustomHandlerPreview"
    ```
::: zone-end  
::: zone pivot="programming-language-python" 

3. Python apps also require you to add this app setting:

    `PYTHONPATH=/home/site/wwwroot/.python_packages/lib/site-packages`.  

::: zone-end  
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 
Now you can deploy the server project:

[!INCLUDE [functions-deploy-project-vs-code](../../includes/functions-deploy-project-vs-code.md)]

---

When deployment finishes, you should see a pop-up in Visual Studio Code about connecting to the server. Select the **Connect** button to have the editor set up server connection information in `mcp.json`.

If you're connecting to the MCP server by using an access key instead of configuring built-in server authorization and authentication, you can now skip to the [Connect to server](#connect-to-server) section. 
::: zone-end  
## Enable built-in server authorization and authentication

The following instruction shows how to enable the built-in authorization and authentication feature on the server app and configures Microsoft Entra ID as the identity provider. When done, you'll test by connecting to the server in Visual Studio Code and see that you're prompted to authenticate before connecting. 

### Configure authentication on server app

1. Open the server app on the Azure portal, and select **Settings** > **Authentication** from the left menu.

1. Select **Add identity provider** > **Microsoft** as the identity provider.

1. For **Choose a tenant for your application and its users**, select **Workforce configuration (current tenant)**.

1. Under **App registration:** use these settings:

    | Setting | Selection |
    | --- | --- |
    | **App registration type** | **Create new app registration** |
    | **Name** | Enter a descriptive name for your app |
    | **Client secret expiration** | **Recommended: 180 days** |
    | **Supported account types** | **Current tenant - Single tenant** |

 1. Under **Additional checks:**, for **Client application requirement** select **Allow requests from specific client applications**, select the pencil icon, add the Visual Studio Code client ID `aebc6443-996d-45c2-90f0-388ff96faa56`, and select **OK**. Leave the other sections as they are. 

1. Under **App Service authentication settings** use these settings:

    | Setting | Selection |
    | --- | --- |
    |  **Restrict access** | **Require authentication** |
    | **Unauthenticated requests** | **HTTP 401 Unauthorized: recommended for APIs** |
    | **Token store** | Check the box, which allows token refresh |

1. Select **Add**. After settings propagate, you should see the following result: 

    :::image type="content" source="./media/functions-mcp/authentication-portal.png" alt-text="Screenshot of App Service authentication settings showing 'Require authentication' selected and 'HTTP 401 Unauthorized' set for unauthenticated requests.":::

### Pre-authorize Visual Studio Code as client 

1. Select the name of the Entra app next to **Microsoft**. This action takes you to the **Overview** of the Entra app resource. 

1. On the left menu, find **Manage -> Expose an API**.

1. Under **Authorized client applications**, select **+Add a client application**.

1. Enter Visual Studio Code's client ID: `aebc6443-996d-45c2-90f0-388ff96faa56`.

1. Select the box in front of the scope that looks like `api://abcd123-efg456-hijk-7890123/user_impersonation`.

1. Select **Add application**.

### Configure protected resource metatdata (preview)

1. In the same **Expose an API** view, find the **Scopes** section and copy the scope that allows admins and users to consent to the Entra app. The value looks like `api://abcd123-efg456-hijk-7890123/user_impersonation`.

1. Run the same command as previous to add the setting `WEBSITE_AUTH_PRM_DEFAULT_WITH_SCOPES`: 

    ```shell
    az functionapp config appsettings set --name <function-app-name> --resource-group <resource-group-name> --settings "WEBSITE_AUTH_PRM_DEFAULT_WITH_SCOPES=<scope>"
    ```

1. Also in the **Expose an API** view, find the **Application ID URI** (looks like `api://abcd123-efg456-hijk-7890123`) on the top and save for later step.

## Connect to server

Open `mcp.json` inside the `.vscode` directory.

If you select **Connect** in the pop-up after deployment, Visual Studio Code populates the file with server connection information. 

If you miss that step, you can also open **Output** (`Ctrl/Cmd+Shift+U`) to find the in-line connection button at the end of deployment logs. 

If you miss both options, you can manually add connection information:

    1. Get the server domain by running the following command:

        ```shell
        az functionapp show --name <function-app-name> --resource-group <resource-group-name> --query "defaultHostName" --output tsv
        ```
    1. In Visual Studio Code, open command palette and search for **MCP: Add Server...**
    1. Answer the following prompts: 
        - Type of server to be added: Choose **HTTP** 
        - URL of the MCP server: 
            - MCP extension server: `https://<server domain>/runtime/webhooks/mcp`
            - Self-hosted server: `https://<server domain>/mcp`
        - Give a server name: **remote-mcp-server**
        - Choose **Workspace** to add server to current workspace
    1. Visual Studio opens an `mcp.json` for you. 

Follow the instructions in the next section to connect to server depending on how you configured the authentication.

### With built-in authentication and authorization 

1. Start the remote server by selecting the **Start** button above the server name. 

1. When prompted about authentication with Microsoft, select **Allow**, then sign in with your email (the one used to log into Azure portal). 

1. When you successfully connect to the server, you see the number of tools available above the server name. 

1. Open Visual Studio Code Copilot chat in agent mode, then ask a question. For example, `Greet with #your-remote-mcp-server-name`.

1. Stop server when finish testing.

To understand in detail what happens when Visual Studio Code tries to connect to the remote MCP server, see [Server authorization protocol](#server-authorization-protocol). 

### With access key

If you don't enable built-in authentication and authorization and instead want to connect to your MCP server by using an access key, the `mcp.json` should contain Functions access key in the request headers of a server registration. 

Visual Studio automatically populates the access key when you start the server. 

### [MCP extension server](#tab/mcp-extension)
The `mcp.json` file should look like the following example: 

```json
{
	"servers": {
		"remote-mcp-server": {
			"type": "http",
			"url": "https://${input:functionapp-domain}/runtime/webhooks/mcp",
			"headers": {
				"x-functions-key": "${input:functions-key}"
			}
		}
	},
	"inputs": [
		{
			"type": "promptString",
			"id": "functions-key",
			"description": "Functions App Key",
			"password": true
		},
		{
			"type": "promptString",
			"id": "functionapp-domain",
			"description": "The domain of the function app.",
			"password": false
		}
	]
}
```

If you want to find the access key yourself, go to the Function app on Azure portal. On the left menu, find **Functions -> App keys**. Under the **System keys** section find the one named _mcp_extension_. 

### [Self-hosted server](#tab/self-hosted)
The `mcp.json` file should look like the following example: 

```json
{
	"servers": {
		"remote-mcp-server": {
			"type": "http",
			"url": "https://${input:functionapp-domain}/mcp",
			"headers": {
				"x-functions-key": "${input:functions-key}"
			}
		}
	},
	"inputs": [
		{
			"type": "promptString",
			"id": "functions-key",
			"description": "Functions App Key",
			"password": true
		},
		{
			"type": "promptString",
			"id": "functionapp-domain",
			"description": "The domain of the function app.",
			"password": false
		}
	]
}
```

To find the access key, go to the Function app on Azure portal. On the left menu, find **Functions -> App keys**. Under the **Host keys (all functions)** section, find the key named _default_. 

---
>[!TIP]
> To see connection logs, go to the server name, then select **More** > **Show Output**. For more details on the interaction between the client (Visual Studio Code) and the remote MCP server, select the gear icon and pick **Trace**. 
>
> :::image type="content" source="./media/functions-mcp/trace-log-setting.png" alt-text="Screenshot of the MCP server settings showing the _Trace_ log level being selected. ":::


## Configure Azure AI Foundry agent to user MCP server

You can configure an [agent on Azure AI Foundry](/azure/ai-foundry/agents/quickstart.md) to leverage tools exposed by MCP servers hosted on Azure Functions.

1. In the Foundry portal, find the agent you want to configure with MCP servers hosted on Functions. 

1. Under **Tools**, select the **Add** button, then select **+ Add a new tool**.

1. Select the **Custom** tab, then select **Model Context Protocol (MCP)** and the **Create** button.

1. Fill in the following information:

    - Name: Name of the server
    - Remote MCP Server endpoint: 
        - MCP extension server: `https://<server domain>/runtime/webhooks/mcp`
        - Self-hosted server: `https://<server domain>/mcp`
    - Authentication: Choose "Microsoft Entra"
    - Type: Choose "Project Managed Identity" 
    - Audience: This is the Entra App ID URI from [Set authorization scope related app setting](#set-authorization-scope-related-app-setting)

    For example:
    ```xml
    <div align="center">
      :::image type="content" source="./media/functions-mcp/foundry-agent-config.png" alt-text="Diagram showing Foundry agent configuration for connecting to MCP server.":::
    </div>
    ```

1. Select **Connect**.

1. Test by asking a question that can be answered with the help of a server tool in the chat window. 

## Server authorization protocol

In the debug output from Visual Studio Code, you see a series of requests and responses as the MCP client and server interact. When you use the built-in MCP server authorization, you see the following sequence of events:

1. The editor sends an initialization request to the MCP server.
1. The MCP server responds with an error indicating that authorization is required. The response includes a pointer to the protected resource metadata (PRM) for the application. The built-in authorization feature generates the PRM for the server app.
1. The editor fetches the PRM and uses it to identify the authorization server.
1. The editor attempts to obtain authorization server metadata (ASM) from a well-known endpoint on the authorization server.
1. Microsoft Entra ID doesn't support ASM on the well-known endpoint, so the editor falls back to using the OpenID Connect metadata endpoint to obtain the ASM. It tries to discover this by inserting the well-known endpoint before any other path information.
1. The OpenID Connect specifications actually defined the well-known endpoint as being after path information, and that is where Microsoft Entra ID hosts it. So the editor tries again with that format.
1. The editor successfully retrieves the ASM. It then uses this information in conjunction with its own client ID to perform a sign-in. At this point, the editor prompts you to sign in and consent to the application.
1. Assuming you successfully sign in and consent, the editor completes the authentication. It repeats the intialization request to the MCP server, this time including an authorization token in the request. This re-attempt isn't visible at the Debug output level, but you can see it in the Trace output level.
1. The MCP server validates the token and responds with a successful response to the initialization request. The standard MCP flow continues from this point, ultimately resulting in discovery of the MCP tool defined in this sample.

## Troubleshooting

If you run into trouble, ask GitHub Copilot for help. Here are some specific ideas for troubleshooting:

### [MCP extension server](#tab/mcp-extension)

No additional ideas at this time. Remember to ask Copilot chat about any errors that occur.

### [Self-hosted server](#tab/self-hosted)

- For C# servers, ensure that the value of the `arguments` property in _host.json_ is the path to the compiled DLL, for example, `["HelloWorld.dll"]`
- If your server isn't deploying properly or the deployed server doesn't work, ensure that you add the required [app setting](#deploy-the-mcp-server-project). Also remember to add the [authorization scope](#set-authorization-scope-related-app-setting) related setting. 

--- 

 ## Next steps

Learn how to [register](./register-mcp-server-api-center.md) Azure Functions-hosted MCP servers on Azure API Center.
