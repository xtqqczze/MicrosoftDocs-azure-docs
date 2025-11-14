---
title: Build scheduled tasks using Azure Functions
description: "Learn how to use the Azure Developer CLI (azd) to create resources and deploy a scheduled task project to a Flex Consumption plan on Azure."
ms.date: 11/14/2025
ms.topic: quickstart
zone_pivot_groups: programming-languages-set-functions
#Customer intent: As a developer, I need to know how to use the Azure Developer CLI to create and deploy scheduled tasks using Timer triggers to a new function app in the Flex Consumption plan in Azure.
---

# Build scheduled tasks using Azure Functions

In this article, you use Azure Developer command-line tools to build scheduled tasks that run automatically based on a timer schedule. After testing the code locally, you deploy it to a new serverless function app you create running in a Flex Consumption plan in Azure Functions.

The project source uses the Azure Developer CLI (azd) to simplify deploying your code to Azure. This deployment follows current best practices for secure and scalable Azure Functions deployments.

By default, the Flex Consumption plan follows a _pay-for-what-you-use_ billing model, which means to complete this article incurs a small cost of a few USD cents or less in your Azure account.

## Prerequisites

+ An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

+ [Azure Developer CLI](/azure/developer/azure-developer-cli/install-azd)

+ [Azure Functions Core Tools](functions-run-local.md#install-the-azure-functions-core-tools)

[!INCLUDE [functions-requirements-azure-cli](../../includes/functions-requirements-azure-cli.md)]

## Initialize the project

You can use the `azd init` command to create a local Azure Functions code project from a template.

::: zone pivot="programming-language-csharp"  
1. In your local terminal or command prompt, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template functions-quickstart-dotnet-azd-timer -e scheduled-dotnet
    ```

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-dotnet-azd-timer) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment is used to maintain a unique deployment context for your app, and you can define more than one. It's also used in the name of the resource group you create in Azure. 

1. Run this command to navigate to the app folder:

    ```console
    cd src
    ```

1. Create a file named _local.settings.json_ in the `src` folder that contains this JSON data:

    ```json
    {
        "IsEncrypted": false,
        "Values": {
            "AzureWebJobsStorage": "UseDevelopmentStorage=true",
            "FUNCTIONS_WORKER_RUNTIME": "dotnet-isolated",
            "TIMER_SCHEDULE": "*/30 * * * * *"
        }
    }
    ```

    This file is required when running locally.
::: zone-end  
::: zone pivot="programming-language-java"  
Timer trigger templates for Java aren't currently available. For now, you can create a Timer trigger function in Java by following these steps:

1. Use the Maven archetype to create a new Java Functions project with an HTTP trigger
1. Add a Timer trigger function to your project
1. Configure the `@TimerTrigger` annotation with your desired schedule
1. Test locally using Azure Functions Core Tools
1. Deploy using `azd` with custom Bicep templates

For detailed instructions, see [Create your first Java function in Azure](create-first-function-cli-java.md).
::: zone-end  
::: zone pivot="programming-language-javascript"  
Timer trigger templates for JavaScript aren't currently available. For now, you can create a Timer trigger function in JavaScript by following these steps:

1. Create a new Functions project using Core Tools
1. Add a Timer trigger function using `func new`
1. Configure the schedule in your function.json file
1. Test locally using Azure Functions Core Tools
1. Deploy using `azd` with custom Bicep templates

For detailed instructions, see [Create your first JavaScript function in Azure](create-first-function-cli-node.md).
::: zone-end  
::: zone pivot="programming-language-powershell"  
Timer trigger templates for PowerShell aren't currently available. For now, you can create a Timer trigger function in PowerShell by following these steps:

1. Create a new Functions project using Core Tools
1. Add a Timer trigger function using `func new`
1. Configure the schedule in your function.json file
1. Test locally using Azure Functions Core Tools
1. Deploy using `azd` with custom Bicep templates

For detailed instructions, see [Create your first PowerShell function in Azure](create-first-function-cli-powershell.md).
::: zone-end  
::: zone pivot="programming-language-typescript"  
1. In your local terminal or command prompt, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template functions-quickstart-typescript-azd-timer -e scheduled-ts
    ```

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-typescript-azd-timer) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment is used to maintain a unique deployment context for your app, and you can define more than one. It's also used in the name of the resource group you create in Azure. 

1. Create a file named _local.settings.json_ in the `src` folder that contains this JSON data:

    ```json
    {
        "IsEncrypted": false,
        "Values": {
            "AzureWebJobsStorage": "UseDevelopmentStorage=true",
            "FUNCTIONS_WORKER_RUNTIME": "node",
            "TIMER_SCHEDULE": "*/30 * * * * *"
        }
    }
    ```

    This file is required when running locally.
::: zone-end  
::: zone pivot="programming-language-python"  
1. In your local terminal or command prompt, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template functions-quickstart-python-azd-timer -e scheduled-py
    ```
        
    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-python-azd-timer) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment is used to maintain a unique deployment context for your app, and you can define more than one. It's also used in the name of the resource group you create in Azure. 

1. Create a file named _local.settings.json_ in the `src` folder that contains this JSON data:

    ```json
    {
        "IsEncrypted": false,
        "Values": {
            "AzureWebJobsStorage": "UseDevelopmentStorage=true",
            "FUNCTIONS_WORKER_RUNTIME": "python",
            "TIMER_SCHEDULE": "*/30 * * * * *"
        }
    }
    ```

    This file is required when running locally.

## Create and activate a virtual environment

In the root folder, run these commands to create and activate a virtual environment named `.venv`:

### [Linux/macOS](#tab/linux)

```bash
python3 -m venv .venv
source .venv/bin/activate
```

If Python didn't install the venv package on your Linux distribution, run the following command:

```bash
sudo apt-get install python3-venv
```

### [Windows (bash)](#tab/windows-bash)

```bash
py -m venv .venv
source .venv/scripts/activate
```

### [Windows (Cmd)](#tab/windows-cmd)

```shell
py -m venv .venv
.venv\scripts\activate
```

---

::: zone-end

## Run in your local environment  

1. Run this command from your app folder in a terminal or command prompt:

    ::: zone pivot="programming-language-csharp,programming-language-python" 
    ```console
    func start
    ``` 
    ::: zone-end  
    ::: zone pivot="programming-language-java"  
    ```console
    mvn clean package
    mvn azure-functions:run
    ```
    ::: zone-end  
    ::: zone pivot="programming-language-javascript"  
    ```console
    npm install
    func start  
    ```
    ::: zone-end  
    ::: zone pivot="programming-language-typescript"  
    ```console
    npm install
    npm start  
    ```
    ::: zone-end  
    ::: zone pivot="programming-language-powershell"  
    ```console
    func start
    ```
    ::: zone-end  

    When the Functions host starts in your local project folder, it writes information about your Timer triggered function to the terminal output. 

1. Watch the terminal output. You should see your Timer triggered function execute based on the schedule defined in your code (typically every few seconds for testing purposes).
    ::: zone pivot="programming-language-csharp"  
    The default schedule is `*/30 * * * * *`, which runs every 30 seconds.
    ::: zone-end  
    ::: zone pivot="programming-language-typescript"  
    The default schedule is `*/30 * * * * *`, which runs every 30 seconds.
    ::: zone-end  
    ::: zone pivot="programming-language-python"  
    The default schedule is `*/30 * * * * *`, which runs every 30 seconds.
    ::: zone-end  

1. When you're done, press Ctrl+C in the terminal window to stop the `func.exe` host process.
::: zone pivot="programming-language-python"
1. Run `deactivate` to shut down the virtual environment.
::: zone-end

## Review the code (optional)

You can review the code that defines the Timer trigger function:
    
::: zone pivot="programming-language-csharp"  
:::code language="csharp" source="~/functions-azd-timer-dotnet/src/timerFunction.cs" :::
::: zone-end  
::: zone pivot="programming-language-java" 
For Java code examples, see the [Timer trigger reference](functions-bindings-timer.md?pivots=programming-language-java).
::: zone-end  
::: zone pivot="programming-language-javascript" 
For JavaScript code examples, see the [Timer trigger reference](functions-bindings-timer.md?pivots=programming-language-javascript).
::: zone-end  
::: zone pivot="programming-language-typescript" 
:::code language="typescript" source="~/functions-azd-timer-typescript/src/src/functions/timerFunction.ts" :::
::: zone-end  
::: zone pivot="programming-language-powershell" 
For PowerShell code examples, see the [Timer trigger reference](functions-bindings-timer.md?pivots=programming-language-powershell).
::: zone-end   
::: zone pivot="programming-language-python" 
:::code language="python" source="~/functions-azd-timer-python/src/function_app.py" :::
::: zone-end  

::: zone pivot="programming-language-csharp"  
You can review the complete template project [here](https://github.com/Azure-Samples/functions-quickstart-dotnet-azd-timer).
::: zone-end  
::: zone pivot="programming-language-java" 
For more examples, see the [Azure Functions Java samples](https://github.com/Azure-Samples/azure-functions-samples-java).
::: zone-end  
::: zone pivot="programming-language-javascript" 
For more examples, see the [Azure Functions JavaScript samples](https://github.com/Azure-Samples/functions-docs-javascript).
::: zone-end  
::: zone pivot="programming-language-typescript" 
You can review the complete template project [here](https://github.com/Azure-Samples/functions-quickstart-typescript-azd-timer).
::: zone-end  
::: zone pivot="programming-language-powershell" 
For more examples, see the [Azure Functions PowerShell samples](https://github.com/Azure-Samples/functions-docs-powershell).
::: zone-end  
::: zone pivot="programming-language-python" 
You can review the complete template project [here](https://github.com/Azure-Samples/functions-quickstart-python-azd-timer).
::: zone-end  

After you verify your function locally, it's time to publish it to Azure. 

## Deploy to Azure

::: zone pivot="programming-language-csharp,programming-language-typescript,programming-language-python"  
This project is configured to use the `azd up` command to deploy this project to a new function app in a Flex Consumption plan in Azure.

>[!TIP]
>This project includes a set of Bicep files that `azd` uses to create a secure deployment to a Flex consumption plan that follows best practices.

1. Run this command to have `azd` create the required Azure resources in Azure and deploy your code project to the new function app:

    ```console
    azd up
    ```

    The root folder contains the `azure.yaml` definition file required by `azd`. 

    If you aren't already signed-in, you're asked to authenticate with your Azure account.

1. When prompted, provide these required deployment parameters:

    | Parameter | Description |
    | ---- | ---- |
    | _Azure subscription_ | Subscription in which your resources are created.|
    | _Azure location_ | Azure region in which to create the resource group that contains the new Azure resources. Only regions that currently support the Flex Consumption plan are shown.|
    
    The `azd up` command uses your response to these prompts with the Bicep configuration files to complete these deployment tasks:

    + Create and configure these required Azure resources (equivalent to `azd provision`):

        + Flex Consumption plan and function app
        + Azure Storage (required) and Application Insights (recommended)
        + Access policies and roles for your account
        + Service-to-service connections using managed identities (instead of stored connection strings)
        + Virtual network to securely run both the function app and the other Azure resources

    + Package and deploy your code to the deployment container (equivalent to `azd deploy`). The app is then started and runs in the deployed package. 

    After the command completes successfully, you see links to the resources you created. 
::: zone-end
::: zone pivot="programming-language-java,programming-language-javascript,programming-language-powershell"  
To deploy your Timer trigger function to Azure, use the Azure Functions Core Tools or create your deployment using Bicep/ARM templates. For detailed deployment instructions, see [Deployment technologies in Azure Functions](functions-deployment-technologies.md).
::: zone-end

## Verify deployment

::: zone pivot="programming-language-csharp,programming-language-typescript,programming-language-python"  
After deployment completes, your Timer trigger function automatically starts running in Azure based on its schedule.

1. In the [Azure portal](https://portal.azure.com), navigate to your new function app.

1. Select **Log stream** from the left menu to monitor your function executions in real-time.

1. You should see log entries showing your Timer trigger function executing according to its schedule.

## Redeploy your code

You can run the `azd up` command as many times as you need to both provision your Azure resources and deploy code updates to your function app. 

>[!NOTE]
>Deployed code files are always overwritten by the latest deployment package.

Your initial responses to `azd` prompts and any environment variables generated by `azd` are stored locally in your named environment. Use the `azd env get-values` command to review all of the variables in your environment that were used when creating Azure resources. 
::: zone-end
::: zone pivot="programming-language-java,programming-language-javascript,programming-language-powershell"  
After deployment, monitor your Timer trigger function in the Azure portal under the **Monitor** section to verify it's running according to schedule.
::: zone-end

## Clean up resources

When you're done working with your function app and related resources, you can use this command to delete the function app and its related resources from Azure and avoid incurring any further costs:

::: zone pivot="programming-language-csharp,programming-language-typescript,programming-language-python"  
```console
azd down --no-prompt
```

>[!NOTE]  
>The `--no-prompt` option instructs `azd` to delete your resource group without a confirmation from you. 
>
>This command doesn't affect your local code project. 
::: zone-end
::: zone pivot="programming-language-java,programming-language-javascript,programming-language-powershell"  
Use the Azure portal or Azure CLI to delete the resource group containing your function app and related resources.
::: zone-end

## Related content

+ [Timer trigger for Azure Functions](functions-bindings-timer.md)
+ [Azure Functions scenarios](functions-scenarios.md)
+ [Flex Consumption plan](flex-consumption-plan.md)
+ [Azure Developer CLI (azd)](/azure/developer/azure-developer-cli/)
+ [azd reference](/azure/developer/azure-developer-cli/reference)
+ [Azure Functions Core Tools reference](functions-core-tools-reference.md)
+ [Code and test Azure Functions locally](functions-develop-local.md)
