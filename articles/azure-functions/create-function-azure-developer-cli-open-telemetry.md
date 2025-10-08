---
title: Create functions with OpenTelemetry using the Azure Developer CLI
description: "Learn how to use the Azure Developer CLI (azd) to create a Python function app with OpenTelemetry distributed tracing. Deploy your app to a Flex Consumption plan on Azure."
ms.date: 10/8/2025
ms.topic: quickstart
ms.custom:
  - ignite-2025
---

# Quickstart: Create and deploy functions with OpenTelemetry to Azure Functions using the Azure Developer CLI

In this quickstart, you use Azure Developer command-line tools to create functions that demonstrate OpenTelemetry distributed tracing across multiple function calls. After testing the code locally, you deploy it to a new serverless function app you create running in a Flex Consumption plan in Azure Functions.

The project source uses the Azure Developer CLI (azd) to simplify deploying your code to Azure. This deployment follows current best practices for secure and scalable Azure Functions deployments with integrated Application Insights and OpenTelemetry support.

By default, the Flex Consumption plan follows a _pay-for-what-you-use_ billing model, which means to complete this quickstart incurs a small cost of a few USD cents or less in your Azure account.

## Prerequisites

+ An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

+ [Azure Developer CLI](/azure/developer/azure-developer-cli/install-azd)

+ [Python 3.11 or later](https://www.python.org/downloads/)

## Initialize the project

You can use the `azd init` command to create a local Azure Functions code project from a template that includes OpenTelemetry distributed tracing.

1. In your local terminal or command prompt, run this `azd init` command in an empty folder:
 
    ```console
    azd init --template functions-quickstart-python-azd-otel -e flexquickstart-otel
    ```

    This command pulls the project files from the [template repository](https://github.com/Azure-Samples/functions-quickstart-python-azd-otel) and initializes the project in the current folder. The `-e` flag sets a name for the current environment. In `azd`, the environment is used to maintain a unique deployment context for your app, and you can define more than one. The environment name also appears in the name of the resource group you create in Azure.

## Review the code

This template creates a complete distributed tracing scenario with three functions that work together. Let's examine the key OpenTelemetry-related aspects:

### OpenTelemetry configuration

The `src/host.json` file enables OpenTelemetry for the Functions host:

```json
{
  "version": "2.0",
  "telemetryMode": "OpenTelemetry",
  "extensions": {
    "serviceBus": {
        "maxConcurrentCalls": 10
    }
  },
  "extensionBundle": {
    "id": "Microsoft.Azure.Functions.ExtensionBundle",
    "version": "[4.*, 5.0.0)"
  }
}
```

The key setting `"telemetryMode": "OpenTelemetry"` enables distributed tracing across function calls.

### Dependencies for OpenTelemetry

The `src/requirements.txt` file includes the necessary packages for OpenTelemetry integration:

```text
azure-functions
azure-monitor-opentelemetry
requests
```

The `azure-monitor-opentelemetry` package provides the OpenTelemetry integration with Application Insights.

### Function implementation

The functions in `src/function_app.py` demonstrate a distributed tracing flow:

#### First HTTP Function

```python
@app.function_name("first_http_function")
@app.route(route="first_http_function", auth_level=func.AuthLevel.ANONYMOUS)
def first_http_function(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function (first) processed a request.')
    
    # Call the second function
    base_url = f"{req.url.split('/api/')[0]}/api"
    second_function_url = f"{base_url}/second_http_function"
    
    response = requests.get(second_function_url)
    second_function_result = response.text
    
    result = {
        "message": "Hello from the first function!",
        "second_function_response": second_function_result
    }
    
    return func.HttpResponse(
        json.dumps(result),
        status_code=200,
        mimetype="application/json"
    )
```

#### Second HTTP Function

```python
@app.function_name("second_http_function")
@app.route(route="second_http_function", auth_level=func.AuthLevel.ANONYMOUS)
@app.service_bus_queue_output(arg_name="outputsbmsg", queue_name="%ServiceBusQueueName%",
                              connection="ServiceBusConnection")
def second_http_function(req: func.HttpRequest, outputsbmsg: func.Out[str]) -> func.HttpResponse:
    logging.info('Python HTTP trigger function (second) processed a request.')

    message = "This is the second function responding."
    
    # Send a message to the Service Bus queue
    queue_message = "Message from second HTTP function to trigger ServiceBus queue processing"
    outputsbmsg.set(queue_message)
    logging.info('Sent message to ServiceBus queue: %s', queue_message)
    
    return func.HttpResponse(
        message,
        status_code=200
    )
```

#### Service Bus Queue Trigger

```python
@app.service_bus_queue_trigger(arg_name="azservicebus", queue_name="%ServiceBusQueueName%",
                               connection="ServiceBusConnection") 
def servicebus_queue_trigger(azservicebus: func.ServiceBusMessage):
    logging.info('Python ServiceBus Queue trigger start processing a message: %s',
                azservicebus.get_body().decode('utf-8'))
    time.sleep(5)  # Simulate processing work
    logging.info('Python ServiceBus Queue trigger end processing a message')
```

### Distributed Tracing Flow

This architecture creates a complete distributed tracing scenario:

1. **First HTTP function** receives an HTTP request and calls the second HTTP function
2. **Second HTTP function** responds and sends a message to Service Bus
3. **Service Bus trigger** processes the message with a 5-second delay to simulate processing work

Key aspects of the OpenTelemetry implementation:

+ **OpenTelemetry integration**: The `host.json` file enables OpenTelemetry with `"telemetryMode": "OpenTelemetry"`
+ **Function chaining**: The first function calls the second using HTTP requests, creating correlated traces
+ **Service Bus integration**: The second function outputs to Service Bus, which triggers the third function
+ **Anonymous authentication**: The HTTP functions use `auth_level=func.AuthLevel.ANONYMOUS`, so no function keys are required

You can review the complete template project [here](https://github.com/Azure-Samples/functions-quickstart-python-azd-otel).

After you verify your functions locally, it's time to publish them to Azure.

## Deploy to Azure

This project is configured to use the `azd up` command to deploy this project to a new function app in a Flex Consumption plan in Azure with OpenTelemetry support.

>[!TIP]
>This project includes a set of Bicep files that `azd` uses to create a secure deployment to a Flex consumption plan that follows best practices, including managed identity connections.

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

        + Azure Functions Flex Consumption plan and function app with OpenTelemetry enabled
        + Azure Storage (required) and Application Insights (recommended) 
        + Service Bus namespace and queue for distributed tracing demonstration
        + Access policies and roles for your account
        + Service-to-service connections using managed identities (instead of stored connection strings)

    + Package and deploy your code to the deployment container (equivalent to `azd deploy`). The app is then started and runs in the deployed package. 

    After the command completes successfully, you see links to the resources you created.

## Test distributed tracing

Now you can test the OpenTelemetry distributed tracing functionality by calling your deployed functions and observing the telemetry in Application Insights.

### Invoke the function on Azure

You can now invoke your function endpoints in Azure by making HTTP requests to their URLs. Since the HTTP functions in this template are configured with anonymous access, no function keys are required.

1. In your local terminal or command prompt, run this command to get the function app name and construct the URL:

    ```bash
    APP_NAME=$(azd env get-value AZURE_FUNCTION_NAME)
    echo "Function URL: https://$APP_NAME.azurewebsites.net/api/first_http_function"
    ```

    The `azd env get-value` command gets your function app name from the local environment.

2. Test the function in your browser by navigating to the URL:

    ```
    https://your-function-app.azurewebsites.net/api/first_http_function
    ```

    Replace `your-function-app` with your actual function app name from the previous step. This single request creates a distributed trace that flows through all three functions.

### View distributed tracing in Application Insights

After invoking the function, you can observe the complete distributed trace in Application Insights:

>[!NOTE]
>It may take a few minutes for telemetry data to appear in Application Insights after invoking your function. If you don't see data immediately, wait a few minutes and refresh the view.

1. Navigate to your Application Insights resource in the Azure portal (you can find it in the same resource group as your function app).

2. Open the **Application map** to see the distributed trace across all three functions. You should see the flow from the HTTP request through your functions and to Service Bus.

3. Check the **Transaction search** to find your request and see the complete trace timeline. Search for transactions from your function app.

4. Click on a specific transaction to see the end-to-end trace that shows:
   - The HTTP request to `first_http_function`
   - The internal HTTP call to `second_http_function`
   - The Service Bus message being sent
   - The `servicebus_queue_trigger` processing the message from Service Bus

5. In the trace details, you can see:
   - **Timing information**: How long each step took
   - **Dependencies**: The connections between functions
   - **Logs**: Application logs correlated with the trace
   - **Performance metrics**: Response times and throughput

This example demonstrates end-to-end distributed tracing across multiple Azure Functions with OpenTelemetry integration, providing complete visibility into your application's behavior and performance.

## Redeploy your code

You can run the `azd up` command as many times as you need to both provision your Azure resources and deploy code updates to your function app. 

>[!NOTE]
>The latest deployment package always overwrites deployed code files.

Your initial responses to `azd` prompts and any environment variables generated by `azd` are stored locally in your named environment. Use the `azd env get-values` command to review all of the variables in your environment that were used when creating Azure resources.

## Clean up resources

When you're done working with your function app and related resources, you can use this command to delete the function app and its related resources from Azure and avoid incurring any further costs:

```console
azd down --no-prompt
```

>[!NOTE]  
>The `--no-prompt` option instructs `azd` to delete your resource group without a confirmation from you. 
>
>This command doesn't affect your local code project. 

## Related content

+ [Use OpenTelemetry with Azure Functions](opentelemetry-howto.md)
+ [Monitor Azure Functions with Application Insights](functions-monitoring.md)