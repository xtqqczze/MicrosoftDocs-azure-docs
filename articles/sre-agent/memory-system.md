---
title: Configure SRE Agent memory system for Knowledge Retention
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

Configure memory components Azure SRE Agent to enable knowledge retention and context-aware responses across incident handling sessions. The memory system allows the agent to remember team knowledge, access documentation, and provide increasingly informed responses over time.

## Prerequisites

- An existing Azure SRE Agent instance
- Appropriate permissions for memory configuration
- [Placeholder: Session insights configuration requirements - to be added]

## About memory components

The SRE Agent memory system consists of four components that work together to provide comprehensive knowledge management:

| Component | Purpose | Setup | Management | Best for |
|-----------|---------|--------|------------|----------|
| **User memories** | Team knowledge via chat commands | Instant | Chat commands | Team preferences, environment facts |
| **Knowledge base** | Document uploads | Quick upload | Portal UI | Static runbooks, guides |
| **TSG crawler** | Azure DevOps integration | Configuration required | Automated sync | Living documentation |
| **Session insights** | Session analysis | [Placeholder] | Automated | Post-incident learning |

### How agents retrieve memory

During conversations, agents retrieve information from memory sources through configured tools:

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

## Configure user memories

User memories store team knowledge through simple chat commands. This component requires no setup and is automatically available across all conversations.

### Add team knowledge

Use the `#remember` command to save facts, preferences, and context.

For example:

```text
#remember Team owns app-service-prod in East US region

#remember For latency issues, check Redis cache first

#remember Production deployments happen Tuesdays at 2 PM PST
```

### Manage stored memories

You can view and manage your team's stored knowledge using the following commands:

- **Retrieve memories**: Use `#retrieve` to view saved information
- **Remove memories**: Use `#forget` to delete outdated facts

### Best practices for user memories

- Keep facts short (1-2 sentences)
- Focus on team-specific information that persists across conversations
- Avoid duplicating information available in other memory sources
- Review and update regularly by using `#retrieve`

## Configure knowledge base

The knowledge base enables you to upload documents directly to your agent for automated indexing and retrieval.

### Upload documents

The knowledge base stores static documents like runbooks, guides, and procedures that your agent can reference during conversations. Upload your documentation and the system automatically indexes it for retrieval.

1. Go to **Settings** > **Knowledge base**.
1. Select **Upload** and choose your files.
1. Upload supported file types (.md, .txt files up to 16 MB).
1. Wait for automatic indexing to complete.

### Enable retrieval

Add the `SearchMemory` tool to your subagent configuration to enable document retrieval during conversations.

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

### Setup steps

Connect your Azure DevOps documentation repositories for automatic synchronization. The TSG crawler continuously indexes troubleshooting guides and runbooks, ensuring agents access your latest procedures.

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

- Chronological timeline of actions taken
- Performance scoring and improvement suggestions  
- Key learnings for future sessions

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

- User memories are shared across all team members
- Knowledge base documents are accessible to all team agents
- TSG crawler uses managed identity for secure repository access

### Regular maintenance

- Review and update stored information regularly.
- Remove outdated or duplicate entries.
- Audit access permissions periodically.

## Technical reference

The memory system uses Azure AI Search and OpenAI embeddings to provide intelligent retrieval across all knowledge sources. Understanding these technical details helps you optimize document formatting and troubleshoot retrieval behavior.

### Search technology

All memory sources use Azure AI Search with the following features:

- **Vector embeddings**: OpenAI `text-embedding-3-large/small` (1,536 dimensions).
- **Hybrid search**: Combines keyword matching and semantic similarity.
- **Semantic ranker**: The Azure AI Search semantic ranking for relevance.

### Document processing

Documents are automatically processed with the following settings:

- **Chunk size**: 2,000 characters maximum.
- **Overlap**: 500 characters between chunks.
- **Method**: Page-based splitting respecting sentence boundaries.

### Retrieval behavior

- Agents use the SearchMemory tool during reasoning.
- Searches across all memory sources simultaneously.
- Returns top K most relevant chunks.
- Combines retrieved information with conversation context.

## Next steps

- TODO