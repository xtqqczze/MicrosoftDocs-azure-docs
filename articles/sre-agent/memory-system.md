---
title: Configure SRE Agent Memory System for Knowledge Retention
description: Configure the SRE Agent memory system to enhance incident handling with knowledge retention, context-aware responses, and seamless access to team documentation.
author: craigshoemaker
ms.author: cshoe
ms.reviewer: cshoe
ms.date: 12/05/2025
ms.topic: article
ms.service: azure-sre-agent
ms.collection: ce-skilling-ai-copilot
#customer intent: As an SRE team lead, I want to configure the memory system for my agents so that they can provide context-aware responses during incident handling.
---

# Configure the SRE Agent Preview memory system

Azure SRE Agent features a memory system that enable knowledge retention and context-aware responses across incident handling sessions. The system allows the agent to remember team knowledge, access documentation, and provide increasingly informed responses over time.

Common uses for the memory system include:

- **Preserve team knowledge**: Store environment details, service ownership, and team preferences so agents provide consistent responses aligned with your operational standards.

- **Accelerate incident response**: Upload runbooks and troubleshooting guides so agents can immediately reference proven procedures during active incidents.

- **Keep documentation current**: Connect Azure DevOps repositories to automatically sync living documentation, ensuring agents always access your latest procedures.

- **Learn from past incidents**: Review session insights after troubleshooting to identify knowledge gaps, then add targeted context to improve future responses.

## About memory components

The SRE Agent memory system consists of four components that work together to provide comprehensive knowledge management:

| Component | Purpose | Setup | Management | Best for |
|-----------|---------|--------|------------|----------|
| **User memories** | Team knowledge via chat commands | Instant | Chat commands | Team preferences, environment facts |
| **Knowledge base** | Document uploads | Quick upload | Portal UI | Static runbooks, guides |
| **TSG crawler** | Azure DevOps integration | Configuration required | Automated sync | Living documentation |
| **Session insights** | Session analysis | [Placeholder] | Automated | Post-incident learning |

### How agents retrieve memory

During conversations agents retrieve information from memory sources through configured tools:

```
User question → Agent reasoning
                     ↓
       ┌─────────────┼─────────────────────┐
       ↓             ↓                     ↓
 SearchMemory    SearchMemory        GetTsgContent
     Tool            Tool                Tool
  (automatic)    (add to agent)      (add to agent)
       ↓             ↓                     ↓
 User memories  Knowledge base       TSG crawler
       ↓             ↓                     ↓
       └─────────────┼─────────────────────┘
                     ↓
         Relevant context retrieved
                     ↓
             Agent response
```

### Enable memory in custom subagents

When building custom subagents with the Sub-Agent Builder, you can enable memory retrieval by adding the `SearchMemory` tool to your subagent's toolset. This feature allows your custom automation to use the knowledge stored in user memories and the knowledge base.

The tool automatically searches across all memory sources by using intelligent retrieval. It provides your subagent with relevant context to inform its responses and actions. Custom subagents that handle specific incident types, automate runbook execution, or perform scheduled health checks can all benefit from your team's accumulated knowledge.

## Choose the right memory component

Select memory components based on your content type and update frequency:

**User memories** for:

- Short, focused facts (one or two sentences)
- Team preferences and standards
- Environment-specific information
- Immediate context that changes occasionally

**Knowledge base** for:

- Well-structured documents with clear headers
- Static runbooks and troubleshooting guides
- Internal documentation and procedures
- Content that updates infrequently

**TSG crawler** for:

- Living documentation in source control
- Frequently updated procedures
- Team libraries and shared repositories
- Content maintained by multiple contributors

## Get started

Begin by establishing foundational knowledge with user memories, then expand to document storage and automated synchronization as your needs grow.

### 1. Start with user memories

Open any chat with your SRE Agent and save immediate team knowledge by using the `#remember` command:

```text
#remember Team owns services: app-service-prod, redis-cache-prod, and sql-db-prod

#remember For latency issues, check Redis cache health first

#remember Team uses East US for production workloads

#remember Production deployments happen Tuesdays at 2 PM PST
```

These facts are now available across all conversations immediately.

### 2. Upload key documents

Add critical runbooks and guides to the knowledge base:

1. Go to **Settings** > **Knowledge base**
1. Upload `.md` or `.txt` files
1. Files are automatically indexed and available immediately

### 3. Review session insights

After troubleshooting sessions, check **Settings** > **Session insights** to see what went well and where the agent needs more context. Use this feedback to identify gaps and add targeted memories or documentation.

### Best practices for knowledge base

- Use well-structured documents with clear headers.
- Maintain content in markdown format for optimal indexing.
- Upload static content that doesn't change frequently.
- Organize documents with descriptive titles.

## Configure TSG crawler

TSG crawler connects your Azure DevOps repositories to automatically index and retrieve documentation, keeping agent knowledge synchronized with your source of truth.

### Prerequisites for TSG crawler

- Azure DevOps repository containing documentation.
- Managed identity for the agent.
- Access to agent data connector settings.

### Setup

Connect your Azure DevOps documentation repositories for automatic synchronization. The TSG crawler continuously indexes troubleshooting guides and runbooks, so agents can access your latest procedures.

1. **Configure repository access**: Add the agent's managed identity to your Azure DevOps project with read permissions.

1. **Add data connector**: Configure the data connector settings to point to your Azure DevOps repository.

1. **Enable retrieval**: Add the GetTsgContent tool to your subagent configuration.

### Best practices for TSG crawler

- Maintain an organized repository structure with a clear folder hierarchy.
- Use descriptive filenames and folder names.
- Keep documentation in markdown format.
- Regularly sync content to maintain current knowledge.

## Monitor memory effectiveness with session insights

Session insights provide an automated analysis of troubleshooting sessions to help you identify knowledge gaps and improve agent effectiveness.

### [Placeholder: Configuration steps]

*Configuration requirements and steps are added here.*

### Review session analysis

After conversations complete, session insights automatically provide:

- **Timeline**: A chronological narrative showing what actions you took and their outcomes
- **What went well**: Highlights correct understanding and effective actions
- **Areas for improvement**: Shows what you could do better with specific remediation steps
- **Key learnings**: Actionable takeaways for future sessions
- **Investigation quality score**: Sessions rated on a 1-5 scale for completeness

You can also manually trigger insight generation for any conversation by selecting the **Generate Session Insights** icon in the chat interface.

### Implement context engineering workflow

To systematically improve your memory system, use session insights:

1. **Identify gaps**: Review where the agent struggled or lacked knowledge
1. **Add targeted context**: Upload runbooks or save facts based on identified needs
1. **Track improvement**: To measure effectiveness, monitor subsequent sessions
1. **Iterate**: Continuously refine based on session data

## Security and compliance

The memory system follows security best practices to protect sensitive information while enabling effective knowledge sharing across your team.

### What not to store

Never store the following information in any memory component:

- Credentials, API keys, or secrets
- Personally identifiable information (PII)
- Customer data or logs
- Confidential business information

### Access control

- All team members share user memories
- All team agents can access knowledge base documents
- TSG crawler uses managed identity for secure repository access

### Regular maintenance

- Review and update stored information regularly
- Remove outdated or duplicate entries
- Audit access permissions periodically

## Technical reference

The memory system uses Azure AI Search and OpenAI embeddings to provide intelligent retrieval across all knowledge sources. Understanding these technical details helps you optimize document formatting and troubleshoot retrieval behavior.

### Search technology

All memory sources use Azure AI Search with the following features:

- **Vector embeddings**: OpenAI `text-embedding-3-large/small` (1,536 dimensions).
- **Hybrid search**: Combines keyword matching and semantic similarity for comprehensive retrieval.
- **Semantic ranker**: The Azure AI Search semantic ranking for relevance scoring.
- **Intelligent chunking**: Documents are split into optimal sections with overlapping content to maintain context.

### Document processing

Documents are automatically processed with the following settings:

- **Chunk size**: 2,000 characters maximum.
- **Overlap**: 500 characters between chunks to preserve context across boundaries.
- **Method**: Page-based splitting respecting sentence boundaries for natural breaks.

### Retrieval behavior

- Agents use the SearchMemory tool during reasoning.
- Searches across all memory sources simultaneously.
- Returns top K most relevant chunks based on semantic and keyword similarity.
- Combines retrieved information with conversation context for informed responses.
