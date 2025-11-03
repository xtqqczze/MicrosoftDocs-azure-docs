---
title: Respond to blob storage events using Azure Functions
description: "Learn how to use the Azure Developer CLI (azd) to create resources and deploy a local project to a Flex Consumption plan on Azure Functions. The project features an Blob Storage trigger that runs in response to blob storage events."
ms.date: 11/02/2025
ms.topic: quickstart
zone_pivot_groups: programming-languages-set-functions
#Customer intent: As a developer, I need to know how to use the Azure Developer CLI to create and deploy an event-based Blob trigger function project securely to a new function app in the Flex Consumption plan in Azure Functions by using azd templates and the azd up command.
---

# Quickstart: Respond to blob storage events by using Azure Functions

In this quickstart, you use Visual Studio Code to build an app that responds to blob storage events by using an Event Grid blob trigger. After testing the code locally with the Azurite emulator, you deploy it to a new serverless function app running in a Flex Consumption plan in Azure Functions.

The project source uses the Azure Developer CLI (azd) extension with Visual Studio Code to simplify initializing and verifying your project code locally, as well as deploying your code to Azure. This deployment follows current best practices for secure and scalable Azure Functions deployments.

The Event Grid blob trigger provides significant advantages over traditional polling-based blob triggers, including near real-time processing, reduced costs, and improved scalability - making it essential for Flex Consumption plans where polling-based triggers aren't available.

::: zone pivot="programming-language-javascript,programming-language-typescript"
This article supports version 4 of the Node.js programming model for Azure Functions.
::: zone-end
::: zone pivot="programming-language-python"
This article supports version 2 of the Python programming model for Azure Functions.
::: zone-end  
[!INCLUDE [functions-scenario-quickstarts-prerequisites-full](../../includes/functions-scenario-quickstarts-prerequisites-full.md)]
+ [Azure Storage extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurestorage)

## Initialize the project

Use the `azd init` command from the command palette to create a local Azure Functions code project from a template.
 
1. In Visual Studio Code, open a folder or workspace where you want to create your project.

1. Press <kbd>F1</kbd> to open the command palette, search for and run the command `Azure Developer CLI (azd): Initialize App (init)`, then choose **Select a template**.

    There might be a slight delay while `azd` initializes the current folder or workspace.  

::: zone pivot="programming-language-csharp"
1. When prompted, choose **Select a template**, then search for and select `Azure Functions C# Event Grid Blob Trigger using Azure Developer CLI`. 

1. When prompted, enter a unique environment name, such as `blobevents-dotnet`.

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-dotnet-azd-eventgrid-blob) and initializes the project in the current folder or workspace.
::: zone-end
::: zone pivot="programming-language-python"
1. When prompted, choose **Select a template**, then search for and select `Azure Functions Python Event Grid Blob Trigger using Azure Developer CLI`. 

1. When prompted, enter a unique environment name, such as `blobevents-python`.

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-python-azd-eventgrid-blob) and initializes the project in the current folder or workspace.
::: zone-end
::: zone pivot="programming-language-javascript,programming-language-typescript"
1. When prompted, choose **Select a template**, then search for and select `Azure Functions TypeScript Event Grid Blob Trigger using Azure Developer CLI`. 

1. When prompted, enter a unique environment name, such as `blobevents-typescript`.

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-typescript-azd-eventgrid-blob) and initializes the project in the current folder or workspace.
::: zone-end
::: zone pivot="programming-language-java"
1. When prompted, choose **Select a template**, then search for and select `Azure Functions Java Event Grid Blob Trigger using Azure Developer CLI`. 

1. When prompted, enter a unique environment name, such as `blobevents-java`.

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-java-azd-eventgrid-blob) and initializes the project in the current folder or workspace.
::: zone-end
::: zone pivot="programming-language-powershell"
1. When prompted, choose **Select a template**, then search for and select `Azure Functions PowerShell Event Grid Blob Trigger using Azure Developer CLI`. 

1. When prompted, enter a unique environment name, such as `blobevents-powershell`.

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-powershell-azd-eventgrid-blob) and initializes the project in the current folder or workspace.
::: zone-end

In `azd`, the environment maintains a unique deployment context for your app, and you can define more than one. It's also part of the name of the resource group you create in Azure.

::: zone pivot="programming-language-csharp,programming-language-java,programming-language-javascript,programming-language-powershell,programming-language-python,programming-language-typescript"
1. Run this command, depending on your local operating system, to grant configuration scripts the required permissions:    ### [Linux/macOS](#tab/linux)
    
    Run this command with sufficient privileges:

    ```bash
    chmod +x ./infra/scripts/*.sh
    ```

    ### [Windows](#tab/windows-cmd)
    
    Run this command from the Windows command prompt:
 
    ```cmd
    pwsh -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    ```

    If prompted, select **Yes** to approve the policy change.     

    ---
::: zone-end

## Set up local storage emulator

Unlike the Cosmos DB project, you can fully test this blob storage project locally by using the Azurite emulator before deploying to Azure.

1. If you haven't already, [install Azurite](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite#install-azurite).

1. Press <kbd>F1</kbd>. In the command palette, search for and run the command `Azurite: Start` to start the local storage emulator.

1. Create the required blob containers by using either Azure Storage Explorer or the VS Code Azure Storage extension:
   - Create a container named `unprocessed-pdf`
   - Create a container named `processed-pdf`

1. Upload the PDF files from the `data` folder in your project to the `unprocessed-pdf` container.

## Run the function locally  

Visual Studio Code integrates with [Azure Functions Core tools](functions-run-local.md) to let you run this project on your local development computer by using the Azurite emulator.

1. To start the function locally, press <kbd>F5</kbd> or the **Run and Debug** icon in the left-hand side Activity bar. The **Terminal** panel displays the output from Core Tools. Your app starts in the **Terminal** panel, and you can see the name of the function that's running locally.

    If you have trouble running on Windows, make sure that the default terminal for Visual Studio Code isn't set to **WSL Bash**.

::: zone pivot="programming-language-csharp,programming-language-java"
1. With Core Tools still running in **Terminal**, open the `test.http` file in your project and select **Send Request** to trigger the `ProcessBlobUpload` function with a test blob event. This step simulates an Event Grid blob event locally.
::: zone-end
::: zone pivot="programming-language-python,programming-language-javascript,programming-language-typescript,programming-language-powershell"
1. With Core Tools still running in **Terminal**, you can trigger the function by uploading a file to the `unprocessed-pdf` container in Azurite, or use the provided test script to simulate an Event Grid blob event locally.
::: zone-end

1. Check the `processed-pdf` container by using Azure Storage Explorer or the VS Code Storage extension to verify that the function processed the test file and copied it with a `processed-` prefix.

1. When you're done, press Ctrl+C in the terminal window to stop the `func.exe` host process.

## Review the code (optional)

The function uses an Event Grid blob trigger that responds to blob storage events. These environment variables configure the trigger:

- `PDFProcessorSTORAGE`: The storage account connection string
- The function monitors the `unprocessed-pdf` container and copies processed files to `processed-pdf`

::: zone pivot="programming-language-csharp"
You can review the code that defines the Event Grid blob trigger in the [ProcessBlobUpload.cs project file](https://github.com/Azure-Samples/functions-quickstart-dotnet-azd-eventgrid-blob/blob/main/src/ProcessBlobUpload.cs). The function demonstrates how to:

- Use `BlobTrigger` with `Source = BlobTriggerSource.EventGrid` for near real-time processing
- Bind to `BlobClient` for the source blob and `BlobContainerClient` for the destination
- Process blob content and copy it to another container by using streams
::: zone-end
::: zone pivot="programming-language-python"
You can review the code that defines the Event Grid blob trigger in the [function_app.py project file](https://github.com/Azure-Samples/functions-quickstart-python-azd-eventgrid-blob/blob/main/function_app.py). The function demonstrates how to:

- Use `@app.blob_trigger` with `source="EventGrid"` for near real-time processing
- Access blob content using the `InputStream` parameter
- Copy processed files to the destination container using the Azure Storage SDK
::: zone-end
::: zone pivot="programming-language-javascript,programming-language-typescript"
You can review the code that defines the Event Grid blob trigger in the [processBlobUpload.ts project file](https://github.com/Azure-Samples/functions-quickstart-typescript-azd-eventgrid-blob/blob/main/src/functions/processBlobUpload.ts). The function demonstrates how to:

- Use `app.storageBlob()` with `source: 'EventGrid'` for near real-time processing
- Access blob content using the Node.js Azure Storage SDK
- Process and copy files to the destination container asynchronously
::: zone-end
::: zone pivot="programming-language-java"
You can review the code that defines the Event Grid blob trigger in the [ProcessBlobUpload.java project file](https://github.com/Azure-Samples/functions-quickstart-java-azd-eventgrid-blob/blob/main/src/main/java/com/contoso/ProcessBlobUpload.java). The function demonstrates how to:

- Use `@BlobTrigger` with `source = "EventGrid"` for near real-time processing
- Access blob content using `BlobInputStream` parameter
- Copy processed files to the destination container using Azure Storage SDK for Java
::: zone-end
::: zone pivot="programming-language-powershell"
You can review the code that defines the Event Grid blob trigger in the [ProcessBlobUpload/run.ps1 project file](https://github.com/Azure-Samples/functions-quickstart-powershell-azd-eventgrid-blob/blob/main/ProcessBlobUpload/run.ps1) and the corresponding [function.json](https://github.com/Azure-Samples/functions-quickstart-powershell-azd-eventgrid-blob/blob/main/ProcessBlobUpload/function.json). The function demonstrates how to:

- Configure blob trigger with `"source": "EventGrid"` in function.json for near real-time processing
- Access blob content using PowerShell Azure Storage cmdlets
- Process and copy files to the destination container using Azure PowerShell modules
::: zone-end

After you review and verify your function code locally, it's time to publish the project to Azure.

::: zone pivot="programming-language-csharp,programming-language-java,programming-language-javascript,programming-language-powershell,programming-language-python,programming-language-typescript"
## Create Azure resources and deploy

The `azd up` command creates the required Azure resources and deploys your code in a single step.

1. In Visual Studio Code, press <kbd>F1</kbd> to open the command palette. Search for and run the command `Azure Developer CLI (azd): Sign In with Azure Developer CLI`, then sign in by using your Azure account.

1. Press <kbd>F1</kbd> to open the command palette. Search for and run the command `Azure Developer CLI (azd): Provision and Deploy (up)` to create the required Azure resources and deploy your code.

1. When prompted in the Terminal window, provide these required deployment parameters:

    | Prompt | Description |
    | ---- | ---- |
    | Select an Azure Subscription to use | Choose the subscription in which you want to create your resources.|
    | _Environment name_ | An environment that's used to maintain a unique deployment context for your app.|
    | _Azure location_ | Azure region in which to create the resource group that contains the new Azure resources. Only regions that currently support the Flex Consumption plan are shown.|
    
    The `azd up` command uses your responses to these prompts with the Bicep configuration files to create and configure these required Azure resources, following the latest best practices:

    + Flex Consumption plan and function app
    + Azure Storage account with blob containers
    + Application Insights (recommended)
    + Access policies and roles for your account
    + Event Grid subscription for blob events
    + Service-to-service connections by using managed identities (instead of stored connection strings)

    After the command completes successfully, your app runs in Azure with an Event Grid subscription configured to trigger your function when blobs are added to the `unprocessed-pdf` container.

## Test the deployed function

1. In Visual Studio Code, press <kbd>F1</kbd>. In the command palette, search for and run the command `Azure: Open in portal`. Select `Function app`, and choose your new app. Sign in with your Azure account, if necessary. 

    This command opens your new function app in the Azure portal.

1. In the **Overview** tab on the main page, select your function app name. Then, select the **Monitor** tab to view function execution logs.

1. Upload a PDF file to the `unprocessed-pdf` container in your Azure Storage account by using the Azure portal, Azure Storage Explorer, or Azure CLI:

    ```bash
    # Get the storage account name from your deployment
    STORAGE_ACCOUNT=$(azd env get-values | grep "AZURE_STORAGE_ACCOUNT_NAME" | cut -d'=' -f2 | tr -d '"')
    
    # Upload a test PDF file
    az storage blob upload --account-name $STORAGE_ACCOUNT --container-name unprocessed-pdf --name test.pdf --file ./data/Benefit_Options.pdf --auth-mode login
    ```

1. Verify that the Event Grid blob trigger executed by checking:
   - The function logs in Azure Monitor that show the blob processing
   - The `processed-pdf` container that now contains the file with a `processed-` prefix

The Event Grid blob trigger should process files within seconds of upload, demonstrating the near real-time capabilities of this approach compared to traditional polling-based blob triggers.

## Redeploy your code

Run the `azd up` command as many times as you need to both provision your Azure resources and deploy code updates to your function app.

>[!NOTE]
>Deployed code files are always overwritten by the latest deployment package.

Your initial responses to `azd` prompts and any environment variables generated by `azd` are stored locally in your named environment. Use the `azd env get-values` command to review all of the variables in your environment that were used when creating Azure resources. 

## Clean up resources

When you're done working with your function app and related resources, use this command to delete the function app and its related resources from Azure. This action helps you avoid incurring any further costs:

```console
azd down --no-prompt
```

>[!NOTE]  
>The `--no-prompt` option instructs `azd` to delete your resource group without a confirmation from you. 
>
>This command doesn't affect your local code project. 
::: zone-end

## Related content

+ [Azure Functions scenarios](functions-scenarios.md)
+ [Flex Consumption plan](flex-consumption-plan.md)
+ [Tutorial: Trigger Azure Functions on blob containers using an event subscription](functions-event-grid-blob-trigger.md)
+ [Azure Developer CLI (azd)](/azure/developer/azure-developer-cli/)
+ [azd reference](/azure/developer/azure-developer-cli/reference)
+ [Azure Functions Core Tools reference](functions-core-tools-reference.md)
+ [Code and test Azure Functions locally](functions-develop-local.md)