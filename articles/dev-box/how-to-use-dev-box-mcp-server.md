---
title: Use the Microsoft Dev Box MCP Server with AI assistants
titleSuffix: Microsoft Dev Box
description: Learn how to install and use the Microsoft Dev Box Model Context Protocol (MCP) Server to manage Dev Box resources through natural language interactions with AI assistants.
services: dev-box
ms.service: dev-box
ms.custom: devx-track-javascript
ms.topic: how-to
ms.author: rosemalcolm
author: RoseHJM
ms.date: 01/31/2025

#Customer intent: As a developer, I want to use natural language to interact with my Dev Box resources through AI assistants, so that I can efficiently manage my dev boxes without switching contexts.
---

# Use the Microsoft Dev Box MCP Server with AI assistants

The Microsoft Dev Box Model Context Protocol (MCP) Server enables seamless integration between AI assistants and Microsoft Dev Box services. With this server, you can use natural language to manage your dev boxes, check their status, start and stop them, run customization tasks, and more—all through your favorite AI-powered development environment.

The MCP Server provides a bridge between AI agents and the Microsoft Dev Box platform, allowing you to perform developer-focused operations through conversational interactions rather than switching between multiple interfaces.

## Prerequisites

Before you begin, ensure you have the following:

### System requirements

- **Node.js 18 or newer** - The MCP Server is built on Node.js
- **Visual Studio Code** or **Visual Studio 2022** (version 17.14 or later) with GitHub Copilot extension

### Azure resources

- An active Azure subscription
- A Microsoft Dev Box dev center provisioned
- At least one Dev Box project created in your dev center
- Appropriate RBAC permissions on Dev Box resources (such as Dev Box User or DevCenter Project Admin roles)

### Authentication setup

The MCP Server uses [DefaultAzureCredential](https://learn.microsoft.com/javascript/api/@azure/identity/defaultazurecredential) with Web Account Manager (WAM) for authentication. Ensure you're signed in through one of these methods:

- Windows Single Sign-On (SSO)
- Azure CLI (`az login`)
- Visual Studio Code Azure account
- Azure PowerShell
- Azure Developer CLI

## Install the Dev Box MCP Server

The Microsoft Dev Box MCP Server can be installed through multiple methods. Choose the approach that works best for your setup.

### Option 1: One-click installation (recommended)

For the fastest setup, use the one-click installation buttons:

- **For VS Code**: [Install with NPX in VS Code](https://insiders.vscode.dev/redirect/mcp/install?name=DevBox&config=%7B%22command%22%3A%22npx%22%2C%22args%22%3A%5B%22-y%22%2C%22%40microsoft%2Fdevbox-mcp%40latest%22%5D%7D)
- **For VS Code Insiders**: [Install with NPX in VS Code Insiders](https://insiders.vscode.dev/redirect/mcp/install?name=DevBox&config=%7B%22command%22%3A%22npx%22%2C%22args%22%3A%5B%22-y%22%2C%22%40microsoft%2Fdevbox-mcp%40latest%22%5D%7D&quality=insiders)

After clicking the appropriate link, the MCP Server is automatically configured in your VS Code environment.

### Option 2: Manual installation in VS Code

If you prefer manual setup, follow these steps:

1. **Add workspace configuration**: Create or update `.vscode/mcp.json` in your workspace root:

   ```json
   {
     "servers": {
       "DevBox": {
         "command": "npx",
         "args": ["-y", "@microsoft/devbox-mcp@latest"]
       }
     }
   }
   ```

2. **Alternative: User settings configuration**: Add to your VS Code user `settings.json`:

   ```json
   {
     "mcp": {
       "servers": {
         "DevBox": {
           "command": "npx",
           "args": ["-y", "@microsoft/devbox-mcp@latest"]
         }
       }
     }
   }
   ```

3. **Command-line installation**: Use the VS Code CLI to add the MCP Server programmatically:

   ```bash
   code --add-mcp '{"name":"DevBox","command":"npx","args":["-y","@microsoft/devbox-mcp@latest"]}'
   ```

### Option 3: Visual Studio 2022 installation

For Visual Studio 2022 users, follow the [MCP Server installation guide](https://learn.microsoft.com/visualstudio/ide/mcp-servers) in the Visual Studio documentation.

## Verify the installation

After installation, restart your IDE and verify the MCP Server is working:

1. **Open GitHub Copilot Chat** in your IDE
2. **Test basic connectivity** by asking: "List my Dev Box projects"
3. **Verify authentication** by asking: "Show me my dev boxes"

If you see a list of your projects or dev boxes, the installation was successful.

## Common use cases

Once installed, you can use natural language to perform various Dev Box operations through your AI assistant:

### Manage dev box lifecycle

- **List dev boxes**: "Show me all my dev boxes" or "What dev boxes do I have in the Marketing project?"
- **Create a dev box**: "Create a new dev box called 'FeatureWork' in the Development project using the Standard pool"
- **Check dev box status**: "What's the status of my ProductionTest dev box?"
- **Start/stop dev boxes**: "Start my dev box called WebDev" or "Stop all my running dev boxes"

### Work with projects and pools

- **Browse projects**: "What projects do I have access to?"
- **View available pools**: "Show me the dev box pools in the Engineering project"
- **Get pool details**: "What's the configuration of the StandardPool in my project?"

### Manage schedules and power state

- **Check schedules**: "When is my dev box scheduled to shut down?"
- **Delay shutdown**: "Delay the shutdown of my WebDev box until 6 PM today"
- **Skip scheduled actions**: "Skip tonight's scheduled shutdown for my TestBox"

### Run customization tasks

- **View available tasks**: "What customization tasks are available for my project?"
- **Run customizations**: "Install the development tools customization on my FeatureDev box"
- **Check task status**: "What's the status of the customization running on my dev box?"

### Monitor operations

- **Check operation status**: "What's the status of the dev box creation I started earlier?"
- **View task logs**: "Show me the logs for the customization task that failed"

## Troubleshooting

### Authentication issues

If you encounter authentication errors:

1. **Verify your login status**:
   ```bash
   az login
   # or for specific tenant
   az login --tenant <tenant-id>
   ```

2. **Check your permissions**: Ensure you have appropriate RBAC roles on the Dev Center resources

3. **Clear credential cache**: Try signing out and back in to Windows or Azure CLI

### Tool registration errors

If you see "Tool xxx does not have an implementation registered" errors:

1. Open the VS Code command palette (`Ctrl+Shift+P`)
2. Run **MCP: Reset cached tools**
3. Restart the MCP server

### Module loading issues

If you encounter "Cannot find module" errors:

1. Clear the NPX cache:
   ```bash
   npx clear-npx-cache
   ```

2. Restart VS Code and try again

## Scope patterns reference

The Dev Box MCP Server uses scope patterns to target specific resources. Understanding these patterns helps you get more precise results:

### Dev Box operations
- `/projects/*/users/me/devboxes/*` - All your dev boxes across projects
- `/projects/ProjectName/users/me/devboxes/*` - Your dev boxes in a specific project
- `/projects/ProjectName/users/me/devboxes/DevBoxName` - A specific dev box

### Project operations
- `/projects/*` - All accessible projects
- `/projects/ProjectName` - A specific project

### Task operations
- `/projects/ProjectName/users/me/devboxes/DevBoxName/tasks/*` - All tasks for a dev box
- `/projects/ProjectName/users/me/devboxes/DevBoxName/tasks/TaskId` - A specific task

## Best practices

- **Be specific in your requests**: Include project names and dev box names when known to get more targeted results
- **Use natural language**: The MCP Server is designed to understand conversational requests
- **Monitor long-running operations**: Operations like creating or starting dev boxes may take time—check their status periodically
- **Handle errors gracefully**: If an operation fails, check the logs or try the operation again

## Related content

- [Model Context Protocol documentation](https://modelcontextprotocol.io/)
- [Authenticate to Microsoft Dev Box REST APIs](how-to-authenticate.md)
- [Install Azure CLI devcenter extension](how-to-install-dev-box-cli.md)
- [Configure Microsoft Dev Box from the command-line with the Azure CLI](how-to-install-dev-box-cli.md)
- [Microsoft Dev Box MCP Server GitHub repository](https://github.com/microsoft/devbox-mcp-server)