---
title: Self-hosted remote MCP server on Azure Functions (public preview)
description: Self-hosted remote MCP server on Azure Functions overview
author: lilyjma
ms.author: jiayma
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

:::image type="content" source="./media/functions-mcp/function-hosting.png" alt-text="Diagram showing hosting of Function app and custom handler apps.":::

This article provides an overview of self-hosted MCP servers and links to relevant articles and samples. 

## Custom handlers 

Self-hosted MCP servers are deployed to the Azure Functions platform as _custom handlers_. Custom handlers are lightweight web servers that receive events from the Functions host. They provide a way to run on the Functions platform applications built with frameworks different from the Functions programming model or in languages not supported out-of-the-box. Learn more about [Azure Functions custom handlers](./functions-custom-handlers.md). 

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

The following shows more properties you can set in the _host.json_: 

```json
{
    "version": "2.0",
    "extensions": {
        "http": {
            "routePrefix": ""
        }
    },
    "customHandler": {
        "description": {
            "defaultExecutablePath": "",
            "arguments": [""]
        },
        "http": {
            "enableProxying": true, 
            "defaultAuthorizationLevel": "anonymous", 
            "routes": [ 
                {
                    "route": "{*route}",
                    // Default authorization level is `defaultAuthorizationLevel`
                },
                {
                    "route": "admin/{*route}",
                    "authorizationLevel": "admin"
                }
            ]
        }
    }
}
```

Specify the configuration profile to type `mcp-custom-handler` automatically configure various Azure Functions host settings required for running the server in the cloud: 
* `http.enableProxying` to `true`
* `http.routes` to `[{ "route": "{*route}" }]`
* `extensions.http.routePrefix` to `""`

The table shows what the properties in `customHandler.http` mean and their default value:

| Property | What it does | Default value |
|----------|----------|----------|
| `enableProxying`   | <br>Controls how the Azure Functions host handles HTTP requests to custom handlers. When `enableProxying` is set to `true`, the Functions host acts as a reverse proxy and forwards the entire HTTP request (including headers, body, query parameters, etc.) directly to the custom handler. This gives the custom handler full access to the original HTTP request details. </br> <br>When `enableProxying` is `false`, the Functions host processes the request first and transforms it into the Azure Functions request/response format before passing it to the custom handler.</br>| `false`   |
| `defaultAuthorizationLevel`   | Controls the authentication requirement for accessing custom handler endpoints. For example, `function` requires a function-specific API key to access. Learn more about the different [authorization levels](./functions-bindings-http-webhook-trigger.md#http-auth).  | `function`    |
| `route`    | Specifies the URL path pattern that the custom handler will respond to. `{*route}` means match any URL path (e.g., `/`, `/mcp`, `/api/tools`, `/anything/nested/path`) and forward to the custom handler. | `{*route}` |

## Feature highlights 

#### Built-in server authentication and authorization
The built-in feature implements the requirements of the [MCP authorization specification](https://modelcontextprotocol.io/specification/2025-06-18/basic/authorization), such as issuing 401 challenge and exposing the Protected Resource Metadata (PRM) document. When the feature is enabled, clients attempting to access the server would be redirected to identity providers like Microsoft Entra ID for authentication before connecting.

Learn more about the feature in [Configure built-in server authorization (preview)](../app-service/configure-authentication-mcp.md) and how to configure it in [Hosting MCP servers on Azure Functions tutorial](./functions-mcp-tutorial.md).

#### Using server tools in Azure AI Foundry agents

Agents in Azure AI Foundry can be [configured](./functions-mcp-tutorial.md#configure-azure-ai-foundry-agent-to-user-mcp-server) to use tools exposed by MCP servers hosted in Azure Functions. 

#### Registering server in Azure API Center 

When you register your MCP server in Azure API Center, you create a private organizational tool catalog. This recommended for sharing MCP servers across your organization with consistent governance and discoverability. Learn how to [register MCP servers hosted in Azure Functions in Azure API Center](./register-mcp-servers-in-apic.md). 

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




