---
title: Build a custom remote MCP server using Azure Functions
description: "Learn how to use the Azure Developer CLI (azd) to create resources and deploy a custom Model Context Protocol (MCP) server to a Flex Consumption plan on Azure. The project enables AI assistants to access custom tools hosted on Azure."
ms.date: 11/04/2025
ms.topic: quickstart
ms.custom:
  - ignite-2024
zone_pivot_groups: programming-languages-set-functions
#Customer intent: As a developer, I need to know how to use the Azure Developer CLI to create and deploy my custom MCP server code securely to a new function app in the Flex Consumption plan in Azure by using azd templates and the azd up command.
---

# Quickstart: Build a custom remote MCP server using Azure Functions

In this quickstart, you use Azure Developer command-line tools to build a custom remote Model Context Protocol (MCP) server with function endpoints that provide tools for AI assistants like GitHub Copilot. After testing the code locally, you deploy it to a new serverless function app you create running in a Flex Consumption plan in Azure Functions. 

The project source uses the Azure Developer CLI (azd) to simplify deploying your code to Azure. This deployment follows current best practices for secure and scalable Azure Functions deployments.

By default, the Flex Consumption plan follows a _pay-for-what-you-use_ billing model, which means completing this quickstart incurs a small cost of a few USD cents or less in your Azure account.

::: zone pivot="programming-language-javascript,programming-language-powershell"  
> [!IMPORTANT]  
> This article is currently only supported in C#, Java, Python, and TypeScript. To complete the quickstart, select one of these supported languages at the top of the article.
::: zone-end  
::: zone pivot="programming-language-csharp,programming-language-java,programming-language-python,programming-language-typescript" 
## Prerequisites

+ An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

+ [Visual Studio Code](https://code.visualstudio.com/) on one of the [supported platforms](https://code.visualstudio.com/docs/supporting/requirements#_platforms).

+ The [Azure Functions extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) for Visual Studio Code. This extension requires [Azure Functions Core Tools](functions-run-local.md). When this tool isn't available locally, the extension tries to install it by using a package-based installer. You can also install or update the Core Tools package by running `Azure Functions: Install or Update Azure Functions Core Tools` from the command palette. If you don't have npm or Homebrew installed on your local computer, you must instead [manually install or update Core Tools](functions-run-local.md#install-the-azure-functions-core-tools).

+ [Azurite storage emulator](../articles/storage/common/storage-install-azurite.md?tabs=npm#install-azurite) 

+ The [Azure Developer CLI extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.azure-dev) for Visual Studio Code.
::: zone pivot="programming-language-csharp"  
+ [.NET 8.0 SDK](https://dotnet.microsoft.com/download)
::: zone-end  
::: zone pivot="programming-language-java"  
+ [Java 17 Developer Kit](/azure/developer/java/fundamentals/java-support-on-azure)
    + If you use another [supported version of Java](supported-languages.md?pivots=programming-language-java#languages-by-runtime-version), you must update the project's pom.xml file. 
    + Set the `JAVA_HOME` environment variable to the install location of the correct version of the Java Development Kit (JDK).
+ [Apache Maven 3.8.x](https://maven.apache.org)  
::: zone-end  
<!-- replace when supported 
::: zone pivot="programming-language-javascript,programming-language-typescript" -->
::: zone pivot="programming-language-typescript"
+ [Node.js 20](https://nodejs.org/)  
::: zone-end  
<!--- remove when supported
::: zone pivot="programming-language-powershell"  
+ [PowerShell 7.2](/powershell/scripting/install/installing-powershell-core-on-windows)

+ [.NET 6.0 SDK](https://dotnet.microsoft.com/download)  
::: zone-end 
-->
::: zone pivot="programming-language-python" 
+ [Python 3.11](https://www.python.org/)
::: zone-end  
::: zone pivot="programming-language-csharp,programming-language-java,programming-language-python,programming-language-typescript" 
+ A secure HTTP test tool for sending requests to your MCP endpoints. This article uses `curl` and MCP Inspector.

## Initialize the project

Use the `azd init` command to create a local Azure Functions code project from a template.

1. In Visual Studio Code, open a folder or workspace in which you want to create your project.

::: zone-end  
::: zone pivot="programming-language-csharp"  
1. In the Terminal, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template remote-mcp-functions-dotnet -e mcpserver-dotnet
    ```

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/remote-mcp-functions-dotnet) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment maintains a unique deployment context for your app, and you can define more than one. It's also used in the name of the resource group you create in Azure. 

1. Run this command to navigate to the `src` app folder:

    ```console
    cd src
    ```

    This folder contains the function code for your MCP server.
::: zone-end

::: zone pivot="programming-language-java"  
1. In your local terminal or command prompt, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template remote-mcp-functions-java -e mcpserver-java 
    ```

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/remote-mcp-functions-java) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment maintains a unique deployment context for your app, and you can define more than one. It's also used in the name of the resource group you create in Azure. 

1. Run this command to navigate to the project root folder and review the structure:

    ```console
    ls -la
    ```

    The `src/main/java/com/function/` folder contains the function code for your MCP server.
::: zone-end

::: zone pivot="programming-language-typescript"  
1. In your local terminal or command prompt, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template remote-mcp-functions-typescript -e mcpserver-ts
    ```

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/remote-mcp-functions-typescript) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment maintains a unique deployment context for your app, and you can define more than one. It's also used in the name of the resource group you create in Azure. 

1. Run this command to review the project structure:

    ```console
    ls -la
    ```

    The `src` folder contains the function code for your MCP server.
::: zone-end
::: zone pivot="programming-language-python"  
1. In your local terminal or command prompt, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template remote-mcp-functions-python -e mcpserver-python
    ```

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/remote-mcp-functions-python) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment maintains a unique deployment context for your app, and you can define more than one. It's also used in the name of the resource group you create in Azure. 

1. Run this command to navigate to the `src` app folder:

    ```console
    cd src
    ```

    This folder contains the function code for your MCP server.

::: zone-end

## Set up local storage emulator

Use the Azurite emulator to run your code project locally before having to create and use Azure resources.

1. If you haven't already, [install Azurite](/azure/storage/common/storage-use-azurite#install-azurite).

1. Press <kbd>F1</kbd>. In the command palette, search for and run the command `Azurite: Start` to start the local storage emulator.

## Run your MCP server locally 

Visual Studio Code integrates with [Azure Functions Core tools](functions-run-local.md) to let you run this project on your local development computer by using the Azurite emulator.

1. To start the function locally, press <kbd>F5</kbd> or the **Run and Debug** icon in the left-hand side Activity bar. The **Terminal** panel displays the output from Core Tools. Your app starts in the **Terminal** panel, and you can see the name of the function that's running locally.

    If you have trouble running on Windows, make sure that the default terminal for Visual Studio Code isn't set to **WSL Bash**.

::: zone pivot="programming-language-csharp"
1. From the `src` folder, run this command to start the Functions host locally:

    ```console
    func start
    ```

    When the Functions host starts, it writes the URL endpoints of your MCP server to the terminal output. The MCP endpoint is available at:

    ```
    http://localhost:7071/runtime/webhooks/mcp
    ```
::: zone-end

::: zone pivot="programming-language-java"
1. From the project root, run these commands to build and start the Functions host locally:

    ```console
    mvn clean package
    mvn azure-functions:run
    ```

    When the Functions host starts, it writes the URL endpoints of your MCP server to the terminal output. The MCP endpoint is available at:

    ```
    http://localhost:7071/runtime/webhooks/mcp/sse
    ```
::: zone-end

::: zone pivot="programming-language-python"
1. From the `src` folder, install the Python dependencies:

    ```console
    pip install -r requirements.txt
    ```

1. Start the Functions host locally:

    ```console
    func start
    ```

    When the Functions host starts, it writes the URL endpoints of your MCP server to the terminal output. The MCP endpoint is available at:

    ```
    http://localhost:7071/runtime/webhooks/mcp/sse
    ```
::: zone-end

::: zone pivot="programming-language-typescript"
1. Install the project dependencies:

    ```console
    npm install
    ```

1. Build the project:

    ```console
    npm run build
    ```

1. Start the Functions host locally:

    ```console
    func start
    ```

    When the Functions host starts, it writes the URL endpoints of your MCP server to the terminal output. The MCP endpoint is available at:

    ```
    http://localhost:7071/runtime/webhooks/mcp/sse
    ```
::: zone-end

## Test your local MCP server

Now you can test your MCP server locally by using MCP Inspector or GitHub Copilot in VS Code.

### Test using MCP Inspector

1. In a new terminal window, install and run MCP Inspector:

    ::: zone pivot="programming-language-csharp"
    ```console
    npx @modelcontextprotocol/inspector node build/index.js
    ```
    ::: zone-end
    ::: zone pivot="programming-language-java,programming-language-python,programming-language-typescript"
    ```console
    npx @modelcontextprotocol/inspector
    ```
    ::: zone-end

1. Open the MCP Inspector web app from the URL displayed in the terminal (for example, `http://0.0.0.0:5173/#resources`).

1. Set the transport type to:
   ::: zone pivot="programming-language-csharp"
   - **Streamable HTTP** for .NET
   ::: zone-end
   ::: zone pivot="programming-language-java,programming-language-python,programming-language-typescript"
   - **SSE (Server-Sent Events)** for Java, Python, and TypeScript
   ::: zone-end

1. Set the URL to your running function app's MCP endpoint and select **Connect**:
   ::: zone pivot="programming-language-csharp"
   ```
   http://localhost:7071/runtime/webhooks/mcp
   ```
   ::: zone-end
   ::: zone pivot="programming-language-java,programming-language-python,programming-language-typescript"
   ```
   http://localhost:7071/runtime/webhooks/mcp/sse
   ```
   ::: zone-end

1. Select **List Tools**, then select a tool and **Run Tool** to test the functionality.

### Test using GitHub Copilot in VS Code

1. In VS Code, open the command palette (F1) and run **Add MCP Server**.

1. Choose **HTTP (Server-Sent Events)** for the transport type.

1. Enter the URL to your running function app's MCP endpoint:
   ::: zone pivot="programming-language-csharp"
   ```
   http://localhost:7071/runtime/webhooks/mcp
   ```
   ::: zone-end
   ::: zone pivot="programming-language-java,programming-language-python,programming-language-typescript"
   ```
   http://localhost:7071/runtime/webhooks/mcp/sse
   ```
   ::: zone-end

1. Give the server an ID and save it to your User or Workspace settings.

1. Open the command palette and run **List MCP Servers**, then start your server.

1. In Copilot Chat (agent mode), try these prompts:

    ```
    Say Hello
    ```

    ```
    Save this snippet as snippet1
    ```

    ```
    Retrieve snippet1 and apply to NewFile
    ```

1. When prompted to run the tool, select **Continue** to consent.

1. When you're done testing, press Ctrl+C to stop the Functions host.

## Review the code (optional)

You can review the code that defines the MCP server tools:

::: zone pivot="programming-language-csharp"
The function code for the MCP server tools is defined in the `src` folder. The `McpToolTrigger` attribute exposes the functions as MCP Server tools:

```csharp
[Function(nameof(SayHello))]
public string SayHello(
    [McpToolTrigger(HelloToolName, HelloToolDescription)] ToolInvocationContext context
)
{
    logger.LogInformation("Saying hello");
    return "Hello I am MCP Tool!";
}

[Function(nameof(GetSnippet))]
public object GetSnippet(
    [McpToolTrigger(GetSnippetToolName, GetSnippetToolDescription)] ToolInvocationContext context,
    [BlobInput(BlobPath)] string snippetContent)
{
    return snippetContent;
}

[Function(nameof(SaveSnippet))]
[BlobOutput(BlobPath)]
public string SaveSnippet(
    [McpToolTrigger(SaveSnippetToolName, SaveSnippetToolDescription)] ToolInvocationContext context,
    [McpToolProperty(SnippetNamePropertyName, PropertyType, SnippetNamePropertyDescription)] string name,
    [McpToolProperty(SnippetPropertyName, PropertyType, SnippetPropertyDescription)] string snippet)
{
    return snippet;
}
```
::: zone-end

::: zone pivot="programming-language-java"
The function code for the MCP server tools is defined in the `src/main/java/com/function/` folder. The `@McpToolTrigger` annotation exposes the functions as MCP Server tools:

```java
@FunctionName("HelloWorld")
public void logCustomTriggerInput(
        @McpToolTrigger(
                toolName = "helloWorld",
                description = "Simple hello world MCP Tool.",
                toolProperties = ARGUMENTS
        )
        String triggerInput,
        final ExecutionContext context
) {
    context.getLogger().info("Hello, World!");
}

@FunctionName("SaveSnippets")
@StorageAccount("AzureWebJobsStorage")
public void saveSnippet(
        @McpToolTrigger(
                toolName = "saveSnippets",
                description = "Saves a text snippet to your snippets collection.",
                toolProperties = SAVE_SNIPPET_ARGUMENTS
        )
        String toolArguments,
        @BlobOutput(name = "outputBlob", path = BLOB_PATH)
        OutputBinding<String> outputBlob,
        final ExecutionContext context
) {
    // Parse JSON and save snippet
    outputBlob.setValue(snippet);
}
```
::: zone-end

::: zone pivot="programming-language-python"
The function code for the MCP server tools is defined in the `src/function_app.py` file. The MCP function annotations expose these functions as MCP Server tools:

```python
@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="hello_mcp",
    description="Hello world.",
    toolProperties="[]",
)
def hello_mcp(context) -> None:
    return "Hello I am MCPTool!"

@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="save_snippet",
    description="Save a snippet with a name.",
    toolProperties=tool_properties_save_snippets_json,
)
@app.generic_output_binding(arg_name="file", type="blob", connection="AzureWebJobsStorage", path=_BLOB_PATH)
def save_snippet(file: func.Out[str], context) -> str:
    content = json.loads(context)
    snippet_content_from_args = content["arguments"][_SNIPPET_PROPERTY_NAME]
    file.set(snippet_content_from_args)
    return f"Snippet saved successfully"
```
::: zone-end

::: zone pivot="programming-language-typescript"
The function code for the MCP server tools is defined in the `src` folder. The MCP function registration exposes these functions as MCP Server tools:

```typescript
// Hello function
export async function mcpToolHello(_toolArguments: unknown, context: InvocationContext): Promise<string> {
    return "Hello I am MCP Tool!";
}

// Register the hello tool
app.mcpTool('hello', {
    toolName: 'hello',
    description: 'Simple hello world MCP Tool that responses with a hello message.',
    handler: mcpToolHello
});

// SaveSnippet function
export async function saveSnippet(_toolArguments: unknown, context: InvocationContext): Promise<string> {
    const mcptoolargs = context.triggerMetadata.mcptoolargs as {
        snippetname?: string;
        snippet?: string;
    };
    
    const snippetName = mcptoolargs?.snippetname;
    const snippet = mcptoolargs?.snippet;
    
    context.extraOutputs.set(blobOutputBinding, snippet);
    return snippet;
}
```
::: zone-end

The `host.json` file includes a reference to the experimental extension bundle, which is required for apps using MCP features:

```json
"extensionBundle": {
  "id": "Microsoft.Azure.Functions.ExtensionBundle.Experimental",
  "version": "[4.*, 5.0.0)"
}
```

You can review the complete template projects at these locations:
::: zone pivot="programming-language-csharp"
- [Azure Functions .NET MCP Server](https://github.com/Azure-Samples/remote-mcp-functions-dotnet)
::: zone-end
::: zone pivot="programming-language-java"
- [Azure Functions Java MCP Server](https://github.com/Azure-Samples/remote-mcp-functions-java)
::: zone-end
::: zone pivot="programming-language-python"
- [Azure Functions Python MCP Server](https://github.com/Azure-Samples/remote-mcp-functions-python)
::: zone-end
::: zone pivot="programming-language-typescript"
- [Azure Functions TypeScript MCP Server](https://github.com/Azure-Samples/remote-mcp-functions-typescript)
::: zone-end

After you verify your MCP server locally, it's time to publish it to Azure.

## Deploy to Azure

This project is configured to use the `azd up` command to deploy this project to a new function app in a Flex Consumption plan in Azure.

> [!TIP]
> This project includes a set of Bicep files that `azd` uses to create a secure deployment to a Flex consumption plan that follows best practices.

::: zone pivot="programming-language-java"
> [!NOTE]
> For Java projects, use `azd provision` to create resources, then deploy using Maven and Core Tools as described in the following sections.
::: zone-end

::: zone pivot="programming-language-csharp,programming-language-python,programming-language-typescript"
1. Run this command to have `azd` create the required Azure resources in Azure and deploy your code project to the new function app:

    ```console
    azd up
    ```
::: zone-end

::: zone pivot="programming-language-java"
1. Run this command to create the required Azure resources:

    ```console
    azd provision
    ```

1. After the resources are created, build and deploy your Java code:

    ```console
    mvn clean package
    cd target/azure-functions/[function-app-name]/
    func azure functionapp publish [function-app-name]
    ```

    Replace `[function-app-name]` with your actual function app name from the `azd` output.
::: zone-end

1. If you're not already signed in, authenticate with your Azure account.

1. When prompted, provide these required deployment parameters:

   | Parameter | Description |
   | ---- | ---- |
   | _Environment name_ | An environment that's used to maintain a unique deployment context for your app. You won't be prompted if you created the local project using `azd init`.|
   | _Azure subscription_ | Subscription in which your resources are created.|
   | _Azure location_ | Azure region in which to create the resource group that contains the new Azure resources. Only regions that currently support the Flex Consumption plan are shown.|

   After the command completes successfully, you see links to the resources you created.

## Connect to your remote MCP server

Your MCP server is now running in Azure and requires a system key for access. You can get this key and connect your AI assistant to your remote server.

1. Get the MCP extension system key from your function app:

   ```console
   az functionapp keys list --resource-group [RESOURCE_GROUP] --name [FUNCTION_APP_NAME]
   ```

   Look for the `mcp_extension` key in the system keys section.

1. Your MCP server endpoint is in this format:
   ::: zone pivot="programming-language-csharp"
   ```
   https://[FUNCTION_APP_NAME].azurewebsites.net/runtime/webhooks/mcp
   ```
   ::: zone-end
   ::: zone pivot="programming-language-java,programming-language-python,programming-language-typescript"
   ```
   https://[FUNCTION_APP_NAME].azurewebsites.net/runtime/webhooks/mcp/sse
   ```
   ::: zone-end

### Connect using MCP Inspector

For MCP Inspector, include the key in the URL:

::: zone pivot="programming-language-csharp"
```
https://[FUNCTION_APP_NAME].azurewebsites.net/runtime/webhooks/mcp?code=[MCP_EXTENSION_KEY]
```
::: zone-end
::: zone pivot="programming-language-java,programming-language-python,programming-language-typescript"
```
https://[FUNCTION_APP_NAME].azurewebsites.net/runtime/webhooks/mcp/sse?code=[MCP_EXTENSION_KEY]
```
::: zone-end

### Connect using GitHub Copilot in VS Code

For GitHub Copilot, create or update your `mcp.json` configuration file:

::: zone pivot="programming-language-csharp"
```json
{
    "servers": {
        "remote-mcp-function": {
            "type": "http",
            "url": "https://[FUNCTION_APP_NAME].azurewebsites.net/runtime/webhooks/mcp",
            "headers": {
                "x-functions-key": "[MCP_EXTENSION_KEY]"
            }
        }
    }
}
```
::: zone-end
::: zone pivot="programming-language-java,programming-language-python,programming-language-typescript"
```json
{
    "servers": {
        "remote-mcp-function": {
            "type": "sse",
            "url": "https://[FUNCTION_APP_NAME].azurewebsites.net/runtime/webhooks/mcp/sse",
            "headers": {
                "x-functions-key": "[MCP_EXTENSION_KEY]"
            }
        }
    }
}
```
::: zone-end

Replace `[FUNCTION_APP_NAME]` and `[MCP_EXTENSION_KEY]` with your actual values.

## Verify your deployment

You can now use your MCP tools with AI assistants just as you did locally, but now they're running securely in Azure. Test the same commands you used earlier to ensure everything works correctly.

## Clean up resources

When you're done working with your MCP server and related resources, use this command to delete the function app and its related resources from Azure to avoid incurring further costs:

```console
azd down --no-prompt
```

> [!NOTE]  
> The `--no-prompt` option instructs `azd` to delete your resource group without confirmation from you. This command doesn't affect your local code project.

## Related content

+ [Azure Functions scenarios](functions-scenarios.md)
+ [Flex Consumption plan](flex-consumption-plan.md)
+ [Azure Developer CLI (azd)](/azure/developer/azure-developer-cli/)
+ [Model Context Protocol](https://modelcontextprotocol.io/)
+ [Azure Functions Core Tools reference](functions-core-tools-reference.md)
+ [Code and test Azure Functions locally](functions-develop-local.md)