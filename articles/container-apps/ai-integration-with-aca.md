---
title: AI integration with Azure Container Apps
description: Examples for running AI workloads in Azure Container Apps, including GPU-powered inference, dynamic sessions, and deploying Azure AI Foundry models.
author: jefmarti
ms.author: jefmarti
ms.service: azure-container-apps
ms.date: 07/31/2025
---

# AI Integration with Azure Container Apps

Azure Container Apps is a serverless container platform that simplifies the deployment and scaling of microservices and AI-powered applications. With native support for GPU workloads, seamless integration with Azure AI services, and flexible deployment options, it is an ideal platform for building intelligent, cloud-native solutions.


## GPU-Powered Inference

Use GPU accelerated workload profiles to meet a variety of your AI workload needs, including:

- **Serverless GPUs**: Ideal for variable traffic scenarios and cost-sensitive inference workloads.
- **Dedicated GPUs**: Best for continuous, low-latency inference scenarios.
- **Scale to zero**: Automatically scale down idle GPU resources to minimize costs.

## Dynamic sessions for AI-generated code

Dynamic sessions provide a secure, isolated environment for executing AI-generated code. Perfect for scenarios like sandboxed execution, code evaluation, or AI agents.

Supported session types include:
- Code interpreters
- Custom containers

## Deploying Azure AI Foundry models

Azure Container Apps integrates with Azure AI Foundry, which enables you to deploy curated AI models directly into your containerized environments. This integration simplifies model deployment and management, making it easier to build intelligent applications on Container Apps.

### Sample projects

The following are a few examples that demonstrate AI integration with Azure Container Apps. These samples showcase various AI capabilities, including OpenAI integration, multi-agent coordination, and retrieval-augmented generation (RAG) using Azure AI Search.

| Sample | Description |
|--------|-------------|
| [container-apps-openai](https://github.com/Azure-Samples/container-apps-openai) | ChatGPT-like apps using OpenAI, LangChain, ChromaDB, and Chainlit deployed to ACA using Terraform. |
| [azure-container-apps-ai-mcp](https://github.com/Azure-Samples/azure-container-apps-ai-mcp) | Demonstrates multi-agent coordination using the MCP protocol with Azure OpenAI and GitHub models in ACA. |
| [openai-mcp-agent-dotnet](https://github.com/Azure-Samples/openai-mcp-agent-dotnet) | .NET-based MCP agent app using Azure OpenAI with a TypeScript MCP server, both hosted on ACA. |
| [mcp-container-ts](https://github.com/Azure-Samples/mcp-container-ts) | TypeScript-based MCP server template for ACA, ideal for building custom AI toolchains. |

## Related content
- [Multiple-agent workflow automation](/azure/architecture/ai-ml/idea/multiple-agent-workflow-automation)

