---
title: Memory System in SRE Agent Preview
description: Use the SRE Agent memory system to build team knowledge that agents retrieve during incident handling, enabling context-aware responses that improve over time.
author: craigshoemaker
ms.author: cshoe
ms.reviewer: cshoe
ms.date: 12/17/2025
ms.topic: article
ms.service: azure-sre-agent
ms.collection: ce-skilling-ai-copilot
#customer intent: As an SRE team member, I want to understand how the memory system works so I can add knowledge that helps agents provide better responses during incident handling.
---

# Memory system in SRE Agent preview

The SRE Agent memory system gives agents the knowledge they need to troubleshoot effectively. By adding runbooks, team standards, and service-specific context, you help agents provide better answers during incidents. The system learns from each session to improve over time.

## Memory components

The memory system consists of four complementary components:

| Component | Purpose | Setup | Best for |
|-----------|---------|-------|----------|
| **User Memories** | Quick chat commands for team knowledge | Instant (chat commands) | Team standards, service configurations, workflow patterns |
| **Knowledge Base** | Direct document uploads for runbooks | Quick (file upload) | Static runbooks, troubleshooting guides, internal documentation |
| **Documentation connector** | Automated Azure DevOps synchronization | Configuration required | Living documentation, frequently updated guides |
| **Session Insights** | Agent-generated memories from sessions | Automatic | Learned troubleshooting patterns, past incident resolutions |

### How agents retrieve memory

During conversations, agents retrieve information from memory sources through configured tools.

:::image type="content" source="media/memory-system/azure-sre-agent-memory-system-loop.png" alt-text="Diagram of the Azure SRE Agent memory system loop.":::

<!--
```mermaid
flowchart TD
    subgraph Trigger
        A[User Question / Incident / Scheduled Task]
    end
    
    subgraph Memory Sources
        B[User Memories<br/>chat commands]
        C[Knowledge Base<br/>documents]
        D[Documentation Connector<br/>ADO repos]
        E[Session Insights<br/>auto-generated]
    end
    
    subgraph Retrieval
        F[SearchMemory Tool]
    end
    
    A -- > B & C & D & E
    B & C & D & E -- > F
    F -- > G[Agent Reasoning]
    G -- > H[Relevant Context Retrieved]
    H -- > I[Agent Response]
```
-->

### Tool configuration

The `SearchMemory` tool retrieves all memory components. It searches across User Memories, Knowledge Base, Documentation connector, and Session Insights simultaneously.

- SRE Agent (default): `SearchMemory` is built in
- Custom subagents: Add `SearchMemory` tool to your configuration

> [!IMPORTANT]
> Don't store secrets, credentials, API keys, or sensitive data in any memory component. Memories are shared across your team and indexed for search.

## Quick start

Begin by establishing foundational knowledge with user memories, and then expand to document storage and automated synchronization as your needs grow.

### 1. Start with user memories

Use chat commands to save immediate team knowledge:

```text
#remember Team owns services: app-service-prod, redis-cache-prod, and sql-db-prod

#remember For latency issues, check Redis cache health first

#remember Production deployments happen Tuesdays at 2 PM PST
```

These facts are now available across all conversations.

### 2. Upload key documents

Add critical runbooks and guides to the knowledge base:

1. Open your SRE Agent in the Azure portal.

1. Go to **Settings** > **Knowledge base**.

1. Select **Add file** or drag and drop files into the upload area.

1. Upload `.md` or `.txt` files (up to 16 MB each).

1. The system indexes files and makes them available for retrieval through `SearchMemory`.

### 3. Review session insights

After troubleshooting sessions, check **Settings** > **Session insights** to see what went well and where the agent needs more context. Use the insights to identify knowledge gaps and add targeted memories or documentation.

### 4. Connect repositories (optional)

For teams with existing documentation in Azure DevOps:

1. Go to **Settings** > **Connectors**.

1. Select **Add connector** and select **Documentation connector**.

1. Enter your Azure DevOps repository URL and select a managed identity.

    The connector starts indexing automatically.

## User memories

User memories let you save team facts, standards, and context that agents remember across all conversations. By using simple chat commands (`#remember`, `#forget`, `#retrieve`), you can build a persistent knowledge base that automatically enhances agent responses.

### Chat commands

#### Save information by using `#remember`

Save facts, standards, or context for future conversations.

**Syntax:**

```text
#remember [content to save]
```

**Examples:**

```text
#remember Team owns app-service-prod in East US region
#remember For app-service-prod latency issues, check Redis cache health first
#remember Team uses Kusto for logs. Workspace is "myteam-prod-logs"
```

Content is embedded by using OpenAI, stored in Azure AI Search, and becomes available for automatic retrieval across all conversations. You see a confirmation: `✅ Agent Memory saved.`

#### Remove memories by using `#forget`

Delete previously saved memories by searching for them.

**Syntax:**

```text
#forget [description of what to forget]
```

**Examples:**

```text
#forget NSG rules information
#forget production environment location
```

The system searches your memories semantically for the best match, shows you the content, and deletes it. You see a confirmation: `✅ Agent Memory forgotten: [deleted content]`

#### Query memories by using `#retrieve`

Explicitly search and display saved memories without triggering agent reasoning.

**Syntax:**

```text
#retrieve [search query]
```

**Examples:**

```text
#retrieve production environment
#retrieve deployment process
```

Searches memories semantically, and then uses the top five matches to synthesize a response. Both the individual memories and the synthesized answer are displayed.

### Scope and storage

- **Shared across the team**: All users of the SRE Agent can access it.

- **Persist across all conversations**: Save it once, and it's available forever.

- **Automatically retrieved when relevant**: Agents search memories semantically during reasoning.

## Knowledge base

The knowledge base provides direct document upload capabilities for runbooks, troubleshooting guides, and internal documentation that agents can retrieve during conversations.

### Supported file types and limits

- **Formats**: `.md` (markdown, recommended), `.txt` (plain text)
- **Per file**: 16 MB maximum (Azure AI Search limit)
- **Per request**: 100 MB total for all files in a single upload

### Upload documents

1. Go to **Settings** > **Knowledge Base**.
1. Select **Add file** or drag and drop files into the upload area.

    The portal automatically validates, uploads, and indexes files.

### Manage documents

- **View**: Go to **Settings** > **Knowledge Base** to see all uploaded documents.

- **Update**: To overwrite the previous version, upload a file with the same name.

- **Delete**: Select documents and use the delete action. Changes take effect immediately.

## Related content

- [Documentation connector](./documentation-connector.md)