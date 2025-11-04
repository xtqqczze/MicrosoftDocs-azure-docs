---
title: Hosting MCP on Azure Functions tutorial
description: "E2E tutorial on hosting MCP servers on Azure Functions"
ms.topic: how-to
ms.date: 10/31/2025
zone_pivot_groups: programming-languages-set-functions
#Customer intent: As a developer, I want to learn how to create and host remote and secured MCP servers on Azure Functions. 
---

In this tutorial, you'll learn how to create and host remote MCP servers on Azure Functions. You'll also see how to leverage a feature called Easy Auth to configure server authorization. 

There are two types of MCP servers that can be hosted remotely on Azure Functions:
1. Servers built with the [Azure Functions MCP extension](./functions-bindings-mcp.md), referred to as _MCP extension servers_ below.
1. Servers built with the [official MCP SDKs](./self-hosted-mcp-servers.md), referred to as _self-hosted servers_ below.

The choice of which to use depends on your scenario and preference. If you're an existing Azure Functions user and are familiar with the triggers and bindings programming model, then you might want to build and host your server using the extension. 

If you've already built servers using the official MCP SDKs and are simply looking for a hosting platform, then the second option may be better for you. Note this option is currently in **public preview**. 

## Prerequisites 
+ An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

+ [Azure Developer CLI](/azure/developer/azure-developer-cli/install-azd)

+ [Azure Functions Core Tools](functions-run-local.md#install-the-azure-functions-core-tools) v4.5.0 or greater

+ [Visual Studio Code](https://code.visualstudio.com/) on one of the [supported platforms](https://code.visualstudio.com/docs/supporting/requirements#_platforms).

+ The [Azure Functions extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) for Visual Studio Code.  

::: zone pivot="programming-language-python" 
+ [uv](https://docs.astral.sh/uv/getting-started/installation/)
::: zone-end  

## Create a local MCP server project 
[TODO: add VSCode instructions when new experience is out]

### [MCP extension server](#tab/extension)

### [Self-hosted server](#tab/extension)

## Start the MCP server locally 

### [MCP extension server](#tab/extension)

Function apps need a storage component to run, so before starting the server you need to start the local storage emulator: 

1. In Visual Studio Code, press <kbd>F1</kbd> to open the command palette. In the command palette, search for and select `Azurite: Start`.

1. Check the bottom bar and verify that Azurite emulation services are running. If so, you can now run the server locally.

1. To start the function locally, press <kbd>F5</kbd> or the triangle button on the top right of the editor

### [Self-hosted server](#tab/extension)

Open a new terminal, start the server by running the following command: 

::: zone pivot="programming-language-python" 
    ```shell
    uv run func start
    ```
::: zone-end  

::: zone pivot="programming-language-csharp, programming-language-typescript" 
    ```shell
    func start
    ``` 
::: zone-end  

### Test the server

1. In Visual Studio Code, open command palette and search for **MCP: Add Server...**

1. Answer the following prompts: 
    - Type of server to be added: Choose "HTTP" 
    - URL of the MCP server: 
        - MCP extension server: `http://localhost:7071/runtime/webhooks/mcp`
        - Self-hosted server: `http://localhost:7071/mcp`
    - Give a server name: "local-mcp-server"
    - Choose "Workspace" to add server to current workspace

1. Visual Studio should open an `mcp.json` for you. Start the server by selecting the **Start** button above the server name. 

1. When successfully connected to the server, you should see the number of tools available above the server name. 

1. Open Visual Studio Code Copilot chat in agent mode, then ask a question. For example, 
    - MCP extension server: "Greet with MCP tool"
    - Self-hosted server: "What's the weather this weekend in New York City?"

## Create the function app in Azure

### [MCP extension server](#tab/extension)
[!INCLUDE [functions-create-azure-resources-vs-code](../../includes/functions-create-azure-resources-vs-code.md)]

### [Self-hosted server](#tab/extension)
>[!NOTE] Self-hosted servers must pick **Flex Consumption** as the hosting plan today. 

[!INCLUDE [functions-create-azure-resources-vs-code](../../includes/functions-create-azure-resources-vs-code.md)]

## Deploy the MCP server project 
### [MCP extension server](#tab/extension)
[!INCLUDE [functions-deploy-project-vs-code](../../includes/functions-deploy-project-vs-code.md)]

### [Self-hosted server](#tab/extension)
Before deploying the server, you need to add the required apps settings: 

1. Log into your account and pick your subscription: 

    ```shell
    az login
    ```
1. Add the setting `AzureWebJobsFeatureFlag` to the app with value `EnableMcpCustomHandlerPreview`: 

    ```shell
    az functionapp config appsettings set --name <function-app-name> --resource-group <resource-group-name> --settings "AzureWebJobsFeatureFlag=EnableMcpCustomHandlerPreview"
    ```
::: zone pivot="programming-language-python" 

3. Python apps also require the setting `"PYTHONPATH=/home/site/wwwroot/.python_packages/lib/site-packages"`.  

::: zone-end  

Now deploy the server project:

[!INCLUDE [functions-deploy-project-vs-code](../../includes/functions-deploy-project-vs-code.md)]

## Server authorization 

The following instruction enables the _Easy Auth_ feature on the server app and configures Microsoft Entra ID as the identity provider. When done, you'll test by connecting to the server in Visual Studio Code and see that you're prompted to authenticate before connecting to the server. This is because Easy Auth has implemented the requirements of the MCP authorization specification such as issuing 401 challenge and hosting the Protected Resource Metadata (PRM). When the feature is enabled, clients attempting to access the server would be redirected to identity providers like Microsoft Entra ID for authentication before connecting. 

### Configure authentication on server app

1. Open the server app on the Azure portal. 
1. Scroll down the left menu to **Settings → Authentication**
1. Click **Add identity provider**
1. Select **Microsoft** as the identity provider
1. Configure the following settings:

    **Choose a tenant for your application and its users**
      Choose the tenant that's appropriate for your use case.

    **App registration:**

      - App registration type: Choose "Create new app registration"
      - Name: Give the app a descriptive name
      - Client secret expiration: Choose "Recommended: 180 days"
      - Supported account types: Choose "Current tenant - Single tenant"

    **Additional checks:**
      - Client application requirement: Choose "Allow requests from specific client applications". Click the pencil icon, then add Visual Studio Code's client ID: `aebc6443-996d-45c2-90f0-388ff96faa56`
      - Leave the other sections as is. 

    **App Service authentication settings:**

      - Restrict access: Choose "Require authentication"
      - Unauthenticated requests: Choose "HTTP 401 Unauthorized: recommended for APIs"
      - Token store: Check "Enabled" (this allows token refresh)

1. Click **Add**. After a bit, you should see the following: 

    ![Identity provider for authentication](./media/functions-mcp/authentication-portal.png)

### Pre-authorize Visual Studio Code as client 

1. Click the name of the Entra app next to "Microsoft". This takes you to the Overview of the Entra app resource. 

1. On the left menu, find **Manage -> Expose an API**

1. Under "Authorized client applications", click **+Add a client application**

1. Enter the Visual Studio Code's client ID: `aebc6443-996d-45c2-90f0-388ff96faa56`

1. Check the box in front of the scope that looks like `api://abcd123-efg456-hijk-7890123/user_impersonation`

1. Click **Add application**

### Set authorization scope related app setting

1. In the same **Expose an API** view, find the "Scopes" section and copy the scope that allows admins and users to consent to the Entra app. The value looks like `api://abcd123-efg456-hijk-7890123/user_impersonation`

1. Run the same command as previous to add the setting `WEBSITE_AUTH_PRM_DEFAULT_WITH_SCOPES`: 

    ```shell
    az functionapp config appsettings set --name <function-app-name> --resource-group <resource-group-name> --settings "WEBSITE_AUTH_PRM_DEFAULT_WITH_SCOPES=<scope>"
    ```

1. Find the "Application ID URI" (looks like `api://abcd123-efg456-hijk-7890123`) on the top and save for later step.

## Connect to server

1. Get the server domain by running the following command:

    ```shell
    az functionapp show --name <function-app-name> --resource-group <resource-group-name> --query "defaultHostName" --output tsv
    ```

1. In Visual Studio Code, open command palette and search for **MCP: Add Server...**

1. Answer the following prompts: 
    - Type of server to be added: Choose "HTTP" 
    - URL of the MCP server: 
        - MCP extension server: `https://<server domain>/runtime/webhooks/mcp`
        - Self-hosted server: `https://<server domain>/mcp`
    - Give a descriptive server name 
    - Choose "Workspace" to add server to current workspace

1. Visual Studio should open an `mcp.json` for you. Start the remote server by selecting the **Start** button above the server name. 

1. When prompted about authenticating with Microsoft, click "Allow", then sign in with your email (the one used to log into Azure portal). 

1. When you successfully connect to the server, you should see the number of tools available above the server name. 

1. Open Visual Studio Code Copilot chat in agent mode, then ask a question. For example, 
    - MCP extension server: "Greet with MCP tool"
    - Self-hosted server: "What's the weather this weekend in New York City?"

>[!TIP]
> Click the tool icon in Copilot chat to see the tools available. Ensure your MCP server is picked when you test. 


## Configure Azure AI Foundry agent to user MCP server

You can configure an agent on Azure AI Foundry to leverage tools exposed by MCP servers hosted on Azure Functions.

1. In the Foundry portal, find the agent you want to be configured with MCP servers hosted on Functions 

1. Under the "Tools" section, click the **Add** button, then **+ Add a new tool**

1. Select the "Custom" tab, then select "Model Context Protocol (MCP)". Click the **Create** button.

1. Fill in the following information:
    - Name: Name of the server
    - Remote MCP Server endpoint: 
        - MCP extension server: `https://<server domain>/runtime/webhooks/mcp`
        - Self-hosted server: `https://<server domain>/mcp`
    - Authentication: Choose "Microsoft Entra"
    - Type: Choose "Project Managed Identity" 
    - Audience: This is the Entra App ID URI from [Set authorization scope related app setting](#set-authorization-scope-related-app-setting)

    For example:
    <div align="center">
      <img src="./media/functions-mcp/foundry-agent-config.png" alt="Diagram showing Foundry agent configuration for connecting to MCP server." width="500">
    </div>

1. Click **Connect**

1. Test by asking a question that can be answered with the help of a server tool in the chat window. 

## Next steps

- Learn how to [register](./functions-mcp-integration.md) Azure Functions-hosted MCP servers on Azure API Center.