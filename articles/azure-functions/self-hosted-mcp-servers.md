---
title: Self-hosted remote MCP server on Azure Functions (public preview)
description: Self-hosted remote MCP server on Azure Functions overview
ms.topic: reference
ms.date: 10/30/2025
ms.update-cycle: 180-days
ms.custom: 
  - ignite-2025
ai-usage: ai-assisted
zone_pivot_groups: programming-languages-set-functions
---
# Self-hosted remote MCP server on Azure Functions (public preview)

Azure Functions provides two ways of hosting remote MCP servers:
1. MCP servers built with the [Functions MCP extension](functions-bindings-mcp.md)
2. MCP servers built with the [official MCP SDKs](https://modelcontextprotocol.io/docs/sdk)

The first approach allows you to leverage the Azure Functions programming model involving triggers and bindings to build the MCP server, and then host remotely by deploying to a Function app. 

If you've already built your MCP server with the official MCP SDKs and just want to host it remotely, then second approach would likely suite your needs. You don't have to make any code changes to the server to host on Azure Functions. Simply add the required Functions artifact, and the server is ready to be deployed. As such, these servers are refered to as _self-hosted MCP servers_. 

<div align="center">
  <img src="./media/functions-mcp/function_hosting.png" alt="Diagram showing hosting of Function app and custom handler apps." width="500">
</div>

This article provides an overview of self-hosted MCP servers and links to relevant articles and samples. 

## Custom handlers 

Self-hosted MCP servers are deployed to the Azure Functions platform as _custom handlers_. Custom handlers are lightweight web servers that receive events from the Functions host. They provide a way to run on the Functions platform applications that are implemented with frameworks different from the Functions programming model or in languages that are not supported out-of-the-box. Learn more about [Azure Functions custom handlers](./functions-custom-handlers.md). 

When deploying an MCP SDK based server to Azure Functions, you must have a _host.json_ in your project. The minimal _host.json_ looks like the following for each language:

### [Python](#tab/python)
```json
{
   "version": "2.0",
    "configurationProfile": "mcp-custom-handler",
    "customHandler": {
        "description": {
            "defaultExecutablePath": "python",
            "arguments": ["Path to main script file, e.g. hello_world.py"] 
        },
        "port": "<MCP server port>"
    }
}
```

### [TypeScript](#tab/typescript)
```json
{
   "version": "2.0",
    "configurationProfile": "mcp-custom-handler",
    "customHandler": {
        "description": {
            "defaultExecutablePath": "npm",
            "arguments": ["run", "start"] 
        },
        "port": "<MCP server port>"
    }
}
```

### [C#](#tab/dotnet)
```json
{
   "version": "2.0",
    "configurationProfile": "mcp-custom-handler",
    "customHandler": {
        "description": {
            "defaultExecutablePath": "dotnet",
            "arguments": ["Path to the compiled DLL, e.g. HelloWorld.dll"] 
        },
        "port": "<MCP server port>"
    }
}
```
>[!NOTE]
>Because the payload deployed to Azure Functions is the content of the `bin/output` directory, the path to the compiled DLL is relative to that directory, _not_ to the project root. 
---

For self-hosted MCP servers, you must specify the configuration profile of type `mcp-custom-handler`. This will automatically configure various Azure Functions host settings required for running the MCP server in the cloud. 

## Feature highlights 

#### Built-in server authentication and authorization
The built-in feature implements the requirements of the [MCP authorization specification](https://modelcontextprotocol.io/specification/2025-06-18/basic/authorization), such as issuing 401 challenge and exposing the Protected Resource Metadata (PRM) document. When the feature is enabled, clients attempting to access the server would be redirected to identity providers like Microsoft Entra ID for authentication before connecting.

Learn more about the feature in [Configure built-in server authorization (preview)](../app-service/configure-authentication-mcp.md) and how to configure it in [Hosting MCP servers on Azure Functions tutorial](./functions-mcp-tutorial.md).

#### Using server tools in Azure AI Foundry agents

Agents in Azure AI Foundry can be [configured](./functions-mcp-tutorial.md#configure-azure-ai-foundry-agent-to-user-mcp-server) to use tools exposed by MCP servers hosted in Azure Functions. 

#### Registering server in Azure API Center 

[TODO]Link to article showing how to configure

## Public preview support  

The hosting capability is currently in public preview and supports the following:

* **Stateless** servers that use the **streamable-http** transport. If you need your server to be stateful, consider using the Functions MCP extension. 
* Servers implemented with the Python, TypeScript, C#, or Java MCP SDK.
* When running the project locally, you must use the Azure Functions Core Tools (`func start` command). You can't press F5 to start running with the debugger right now.  
* Servers must be hosted on the [Flex Consumption plan](./flex-consumption-plan.md).

## Samples 

| Language | Sample |
|------|--------|
| Python | [Quickstart](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-python) <br/> [Tutorial](./functions-mcp-tutorial.md) | 
| TypeScript | [Quickstart](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-node) <br/> [Tutorial](./functions-mcp-tutorial.md) |
| C# | [Quickstart](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-dotnet) <br/> [Tutorial](./functions-mcp-tutorial.md) | 
| Java | Not yet available |




