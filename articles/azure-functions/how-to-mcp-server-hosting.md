---
title: Host your existing MCP server on Azure Functions
description: "Learn how to host your existing Model Context Protocol (MCP) server built with official Anthropic MCP SDKs on Azure Functions using custom handlers."
ms.date: 11/12/2025
ms.topic: how-to
ai-usage: ai-assisted
ms.collection: 
  - ce-skilling-ai-copilot
ms.custom:
  - ignite-2025
zone_pivot_groups: programming-languages-set-functions
#Customer intent: As a developer, I need to know how to host my existing MCP server built with official Anthropic MCP SDKs on Azure Functions using custom handlers.
---

# Host your existing MCP server on Azure Functions

This article shows you how to host your existing Model Context Protocol (MCP) server built with official Anthropic MCP SDKs on Azure Functions using custom handlers.

::: zone pivot="programming-language-java,programming-language-javascript,programming-language-powershell"  
> [!IMPORTANT]  
> This article is currently only supported in C#, Python, and TypeScript. To complete these steps, select one of these supported languages at the top of the article.
::: zone-end  

::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 
## Prerequisites

Before you begin, make sure you have:

+ An existing MCP server built with official Anthropic MCP SDKs
+ [Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd) v1.17.2 or above
+ An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

## Host your existing MCP server

If you already have an MCP server built with official Anthropic MCP SDKs, you can host it on Azure Functions by following these steps:

> [!IMPORTANT]  
> Your server must be stateless and use the streamable-http transport to be hosted remotely on Azure Functions.

The following instructions pull in artifacts required for local server testing and deployment. The most important files are `host.json`, `local.settings.json`, and the `infra` directory. Azure Functions only requires the first two JSON files, but the `infra` directory is handy for provisioning Azure resources.

It's unlikely that your project would have files with the same names, but if it does, you'll need to rename them so they won't be overwritten.

::: zone-end  
::: zone pivot="programming-language-csharp"  
1. Inside your existing MCP server project directory, run this command:

    ```bash
    azd init --template self-hosted-mcp-scaffold-dotnet
    ```

2. Answer the prompts:
   + **Continue initializing an app in your project folder?**: Select **Yes**.
   + **Files present both locally and in template**: Likely only the README file exists, and you can keep the existing version.
   + **Enter a unique environment name**: This becomes the name of the resource group where the server is deployed.

3. In `host.json`:
   + Ensure the `arguments` property has the compiled DLL path (for example, `MyMcpServer.dll`)
   + Ensure the `port` value matches the one used by your MCP server

You can find more details about the [.NET hosting template](https://github.com/Azure-Samples/self-hosted-mcp-scaffold-dotnet).
::: zone-end  
::: zone pivot="programming-language-typescript"  
1. Inside your existing MCP server project directory, run this command:

    ```bash
    azd init --template self-hosted-mcp-scaffold-typescript
    ```

2. Answer the prompts:
   + **Continue initializing an app in your project folder?**: Select **Yes**.
   + **Files present both locally and in template**: Likely only the README file exists, and you can keep the existing version.
   + **Enter a unique environment name**: This becomes the name of the resource group where the server is deployed.

3. In `host.json`, ensure the `port` value matches the one used by your MCP server.

You can find more details about the [TypeScript hosting template](https://github.com/Azure-Samples/self-hosted-mcp-scaffold-typescript).
::: zone-end
::: zone pivot="programming-language-python"  
1. Inside your existing MCP server project directory, run this command:

    ```bash
    azd init --template self-hosted-mcp-scaffold-python
    ```

2. Answer the prompts:
   + **Continue initializing an app in your project folder?**: Select **Yes**.
   + **Files present both locally and in template**: Likely only the README file exists, and you can keep the existing version.
   + **Enter a unique environment name**: This becomes the name of the resource group where the server is deployed.

3. In `host.json`:
   + Put the main Python script path as the value of `arguments` (for example, `weather.py`)
   + Ensure the `port` value matches the one used by your MCP server

You can find more details about the [Python hosting template](https://github.com/Azure-Samples/self-hosted-mcp-scaffold-python).
::: zone-end

::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript" 

<!--- moved from the readme generated hosting quickstart
> [!TIP]  
> You can see output of a server by clicking **More...** > **Show Output**. The output provides useful information like why a connection might have failed. You can also click the gear icon to change log levels to **Traces** to get more details on the interactions between the client (Visual Studio Code) and the server. -->

## Next steps

After you've configured your existing MCP server for hosting, you can:

> [!div class="nextstepaction"]
> [Complete the quickstart to deploy and test your server](scenario-host-mcp-server-sdks.md)

> [!div class="nextstepaction"]
> [Configure built-in MCP server authorization](../app-service/configure-authentication-mcp.md)
::: zone-end