---
title: Use AI tools and models in Azure Functions  
description: "Learn how Azure Functions supports AI integration in your applications, including LLMs, RAG, agentic workflows, and AI frameworks. Build scalable AI-powered serverless solutions."
ms.topic: conceptual
ms.date: 11/03/2025
ms.update-cycle: 180-days
ai-usage: ai-assisted
ms.custom:
  - build-2025
ms.collection: 
  - ce-skilling-ai-copilot 
zone_pivot_groups: programming-languages-set-functions
#Customer intent: As a developer, I want to learn how I can leverage AI models, tools, and other resourtcers so that my function executions can take full advantage of all of the AI-related resources available to an Azure service.
---

# Use AI tools and models in Azure Functions

Azure Functions provides serverless compute resources that integrate with AI and Azure services to streamline building cloud-hosted intelligent applications. This article provides a survey of the breadth of AI-related scenarios, integrations, and other AI resources that you can use in your function apps. 

Consider using Azure Functions in your AI-enabled experiences for the following scenarios:

| Scenario | Description |
| ----- | ----- |
| [Remote MCP servers](#remote-mcp-servers) | Functions lets you host remote MCP servers created using official SDKs, and you can create your own custom MCP servers using the Functions MCP server extension. |
| [Retrieval-augmented generation (RAG)](#retrieval-augmented-generation) | RAG systems require fast data retrieval and processing. Functions can interact with multiple data sources simultaneously and provide the rapid scale required by RAG scenarios. |
| [Agentic workflows](#agentic-workflows) | Durable Functions helps you create multistep, long-running agent operations with built-in fault tolerance. |
| [Function calling](#function-calling) | Whether using built-in extensions or client SDKs, Functions is ideal for implementing function calling in agentic workflows.  |
 
Select one of these scenarios to learn more in this article. 

This article is language-specific, so make sure you choose your programming language at the [top of the page](#top).

## Retrieval-augmented generation

Because Functions can handle multiple events from various data sources simultaneously, it's an effective solution for real-time AI scenarios, like RAG systems that require fast data retrieval and processing. Rapid event-driven scaling reduces the latency your customers experience, even in high-demand situations. 

Here are some reference samples for RAG-based scenarios:

::: zone pivot="programming-language-csharp"   
**[RAG with Azure AI Search](https://github.com/Azure-Samples/azure-functions-openai-aisearch-dotnet)**
::: zone-end  
::: zone pivot="programming-language-python"   
**[RAG with Azure AI Search](https://github.com/Azure-Samples/azure-functions-openai-aisearch-python)**
::: zone-end  
::: zone pivot="programming-language-java,programming-language-typescript,programming-language-powershell"    
**[RAG with Azure AI Search](https://github.com/Azure/azure-functions-openai-extension/tree/main/samples/rag-aisearch)**
::: zone-end  
::: zone pivot="programming-language-javascript"   
**[RAG with Azure AI Search](https://github.com/Azure-Samples/azure-functions-openai-aisearch-node)**
::: zone-end  
> For RAG, you can use SDKs, including Azure Open AI and Azure SDKs, to build your scenarios.
::: zone-end  

::: zone pivot="programming-language-csharp"   
**[Custom chat bot](https://github.com/Azure-Samples/function-dotnet-ai-openai-chatgpt/)**
::: zone-end  
::: zone pivot="programming-language-python"   
**[Custom chat bot](https://github.com/Azure-Samples/function-python-ai-openai-chatgpt)**
::: zone-end   
::: zone pivot="programming-language-java,programming-language-typescript,programming-language-powershell"   
**[Custom chat bot](https://github.com/Azure/azure-functions-openai-extension/tree/main/samples/chat)**
::: zone-end   
::: zone pivot="programming-language-javascript"   
**[Custom chat bot](https://github.com/Azure-Samples/function-javascript-ai-openai-chatgpt)**
::: zone-end  
::: zone pivot="programming-language-csharp,programming-language-javascript,programming-language-python" 
> Shows you how to create a friendly chat bot that issues simple prompts, receives text completions, and sends messages, all in a stateful session using the [OpenAI binding extension].
::: zone-end

## Remote MCP servers

The Model Context Protocol (MCP) provides a standardized way for AI models and agents to communicate with external systems to determine how to best make use of their capabilities. An MCP server lets an AI model or agent (client) make these determinations more efficiently. You can use an MCP server to publicly expose specific resources as tools, which agents call to accomplish specific tasks. 

When you build or host your remote MCP servers in Azure Functions, you get dynamic scaling, serverless pricing models, and platform security features.

Functions supports these options for creating and hosting remote MCP servers:

+ Use the [MCP binding extension](./functions-bindings-mcp.md) to create and host custom MCP servers as you would any other function app. 
+ Self host MCP servers created using the official MCP SDKs. This hosting option is currently in preview.

Here's a comparison of the current MCP server hosting options provided by Functions:

| Feature  | [MCP binding extension] | Self-hosted MCP servers |
| ---- | ----- | ----- |
| Current support level |  GA |Preview<sup>*</sup> |
| Programming model | [Functions triggers and bindings](./functions-triggers-bindings.md) | Standard MCP SDKs |
| Stateful execution | Supported | Not currently supported | 
| Languages currently supported | C# (isolated process)<br/>Python<br/>TypeScript<br/>JavaScript<br/>Java  | C# (isolated process)<br/>Python<br/>TypeScript<br/>JavaScript<br/>Java |
| Other requirements | None | Streamable HTTP transport |
| How implemented | [MCP binding extension] | [Custom handlers](./functions-custom-handlers.md) |

<sup>*</sup>Configuration details for self-hosted MCP servers change during the preview. 

::: zone pivot="programming-language-csharp,programming-language-java,programming-language-typescript,programming-language-python"
Here are some options to help you get started hosting MCP servers in Functions:  
::: zone-end  
::: zone pivot="programming-language-csharp" 
 
| Options  | MCP binding extensions | Self-hosted MCP servers |
| ---- | ----- | ----- |
| Documentation | [MCP binding extension](./functions-bindings-mcp.md?pivots=programming-language-csharp)  | n/a |
| Samples | [Remote custom MCP server](https://github.com/Azure-Samples/remote-mcp-functions-dotnet) | [Weather server](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-dotnet)  |
| Copilot prompts<br/>(Visual Studio Code)| n/a | [Setup prompt](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-dotnet/blob/main/ExistingServer.md)<sup>†</sup>  |
| Templates | [HelloTool](https://github.com/Azure/azure-functions-templates/tree/dev/Functions.Templates/Templates/McpToolTrigger-CSharp-Isolated)  | n/a |

::: zone-end  
::: zone pivot="programming-language-python"  
 
| Options  | MCP binding extensions | Self-hosted MCP servers |
| ---- | ----- | ----- |
| Documentation | [MCP binding extensions](./functions-bindings-mcp.md?pivots=programming-language-python)  | n/a |
| Samples | [Remote custom MCP server](https://github.com/Azure-Samples/remote-mcp-functions-python) | [Weather server](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-python)  |
| Copilot prompts<br/>(Visual Studio Code)| n/a | [Setup prompt](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-python/blob/main/ExistingServer.md)<sup>†</sup>  |

::: zone-end  
::: zone pivot="programming-language-typescript"  
 
| Options  | MCP binding extensions | Self-hosted MCP servers |
| ---- | ----- | ----- |
| Documentation | [MCP binding extensions](./functions-bindings-mcp.md?pivots=programming-language-typescript)  | n/a |
| Samples | [Remote custom MCP server](https://github.com/Azure-Samples/remote-mcp-functions-typescript) | [Weather server](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-node)  |
| Copilot prompts<br/>(Visual Studio Code)| n/a | [Setup prompt](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-node/blob/main/ExistingServer.md)<sup>†</sup>  |

::: zone-end  
::: zone pivot="programming-language-javascript"  
 
| Options  | MCP binding extensions | Self-hosted MCP servers |
| ---- | ----- | ----- |
| Documentation | [MCP binding extensions](./functions-bindings-mcp.md?pivots=programming-language-javascript)  | n/a |
| Samples | n/a | [Weather server](https://github.com/Azure-Samples/mcp-sdk-functions-hosting-node)  |

::: zone-end  
::: zone pivot="programming-language-java"  

| Options  | MCP binding extensions | Self-hosted MCP servers |
| ---- | ----- | ----- |
| Documentation | [MCP binding extensions](./functions-bindings-mcp.md?pivots=programming-language-java)  | n/a |
| Samples | Not yet available | Not yet available |

::: zone-end  
::: zone pivot="programming-language-powershell"  
PowerShell isn't currently supported for either MCP server hosting option.  
::: zone-end  

<sup>†</sup>Currently consider the deployment helper chat prompt _experimental_.

## Agentic workflows

AI-driven processes often determine how to interact with models and other AI assets. However, some scenarios require a higher level of predictability or well-defined steps. These directed agentic workflows orchestrate separate tasks or interactions that agents must follow. 

The [Durable Functions extension](durable/durable-functions-overview.md) helps you take advantage of the strengths of Functions to create multistep, long-running operations with built-in fault tolerance. These workflows work well for your directed agentic workflows. For example, a trip planning solution might first gather requirements from the user, search for plan options, obtain user approval, and finally make required bookings. In this scenario, you can build an agent for each step and then coordinate their actions as a workflow using Durable Functions. 

For more workflow scenario ideas, see [Application patterns](durable/durable-functions-overview.md#application-patterns) in Durable Functions. 

## Function calling

Function calling gives your AI agent the ability to dynamically invoke specific AI tools or APIs based on the context of a conversation or task. These MCP-enabled behaviors let your agents interact with external systems, retrieve data, and perform other actions.

Functions is ideal for implementing function calling in agentic workflows. In addition to scaling efficiently to handle demand, [binding extensions](./functions-triggers-bindings.md) simplify the process of using Functions to connect agents with remote Azure services. If there's no binding for your data source or you need full control over SDK behaviors, you can manage your own client SDK connections in your app.

::: zone pivot="programming-language-java,programming-language-typescript,programming-language-powershell"
Here are some reference samples for function calling scenarios:
::: zone-end
::: zone pivot="programming-language-csharp"  
**[Agent Service function calling](https://github.com/Azure-Samples/foundry-agent-service-remote-mcp-dotnet)**
::: zone-end
::: zone pivot="programming-language-python"  
**[Agent Service function calling](https://github.com/Azure-Samples/foundry-agent-service-remote-mcp-python)**
::: zone-end
::: zone pivot="programming-language-javascript"  
**[Agent Service function calling](https://github.com/Azure-Samples/foundry-agent-service-remote-mcp-javascript)**
::: zone-end
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-javascript"  
> Uses an [Azure AI Foundry Agent Service](/azure/ai-foundry/agents/) client to call a custom remote MCP server implemented using Azure Functions.
::: zone-end
::: zone pivot="programming-language-csharp"  
**[Agents function calling (Azure AI SDKs)](https://github.com/Azure-Samples/azure-functions-ai-services-agent-dotnet)**
::: zone-end
::: zone pivot="programming-language-python"  
**[Agents function calling (Azure AI SDKs)](https://github.com/Azure-Samples/azure-functions-ai-services-agent-python)**
::: zone-end
::: zone pivot="programming-language-javascript"  
**[Agents function calling (Azure AI SDKs)](https://github.com/Azure-Samples/azure-functions-ai-services-agent-javascript)**
::: zone-end
::: zone pivot="programming-language-csharp,programming-language-python,programming-language-javascript"  
> Uses function calling features for agents in Azure AI SDKs to implement custom function calling.  
::: zone-end

## AI tools and frameworks for Azure Functions

Functions lets you build apps in your preferred language and use your favorite libraries. Because of this flexibility, you can use a wide range of AI libraries and frameworks in your AI-enabled function apps. 

Here are some key Microsoft AI frameworks you should be aware of:

| Framework/library | Description |
| ----- | ----- |
| [Agent Framework](/agent-framework/) | Easily build AI agents and agentic workflows. |
| [Azure AI Foundry Agent Service](/azure/ai-foundry/agents/overview) | A fully managed service for building, deploying, and scaling AI agents with enterprise-grade security, built-in tools, and seamless integration with Azure Functions. |
| [Azure AI Services SDKs](/azure/ai-foundry/) | By working directly with client SDKs, you can use the full breadth of Azure AI services functionality directly in your function code. |

Functions also lets your apps reference third-party libraries and frameworks, so you can use all of your favorite AI tools and libraries in your AI-enabled functions.  

## Related articles

+ [Azure Functions scenarios](functions-scenarios.md)
+ [Tutorial: Add Azure OpenAI text completion hints to your functions in Visual Studio Code](functions-add-openai-text-completion.md)

[OpenAI binding extension]: functions-bindings-openai.md
[MCP binding extension]: functions-bindings-mcp.md
