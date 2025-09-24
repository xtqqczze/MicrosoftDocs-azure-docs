---
title: Bindings for Durable Functions - Azure
description: How to use triggers and bindings for the Durable Functions extension for Azure Functions.
ms.topic: conceptual
ms.custom: devx-track-extended-java, devx-track-js, devx-track-python
ms.date: 03/22/2023
ms.author: azfuncdf
zone_pivot_groups: programming-languages-set-functions-lang-workers
---

# Bindings for Durable Functions (Azure Functions)

The [Durable Functions](durable-functions-overview.md) extension introduces three trigger bindings that control the execution of orchestrator, entity, and activity functions. It also introduces an output binding that acts as a client for the Durable Functions runtime.

Make sure to choose your Durable Functions development language at the top of the article.

::: zone pivot="programming-language-python" 

> [!IMPORTANT]   
> This article supports both Python v1 and Python v2 programming models for Durable Functions.  

## Python v2 programming model

Durable Functions is supported in the [Python v2 programming model](../functions-reference-python.md?pivots=python-mode-decorators). To use the v2 model, you must install the Durable Functions SDK, which is the Python Package Index (PyPI) package `azure-functions-durable`, version `1.2.2` or a later version. You must also check `host.json` to make sure your app references [Extension Bundles](../extension-bundles.md) version 4.x. 

You can provide feedback and suggestions in the [Durable Functions SDK for Python repo](https://github.com/Azure/azure-functions-durable-python/issues).
::: zone-end

## Orchestration trigger

You can use the orchestration trigger to develop [durable orchestrator functions](durable-functions-types-features-overview.md#orchestrator-functions). This trigger runs when a new orchestration instance is scheduled and when an existing orchestration instance receives an event. Examples of events that can trigger orchestrator functions include durable timer expirations, activity function responses, and events raised by external clients.

::: zone pivot="programming-language-csharp"
When you develop functions in .NET, you use the [OrchestrationTriggerAttribute](/dotnet/api/microsoft.azure.webjobs.extensions.durabletask.orchestrationtriggerattribute) .NET attribute to configure the orchestration trigger. 
::: zone-end  
::: zone pivot="programming-language-java"   
For Java, you use the `@DurableOrchestrationTrigger` annotation to configure the orchestration trigger.
::: zone-end  
::: zone pivot="programming-language-javascript,programming-language-powershell" 
When you write orchestrator functions, the orchestration trigger is defined by the following JSON object in the `bindings` array of the *function.json* file:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "orchestration": "<optional-name-of-orchestration>",
    "type": "orchestrationTrigger",
    "direction": "in"
}
```

The `orchestration` value is the name of the orchestration that clients must use when they want to start new instances of the orchestrator function. This property is optional. If you don't specify it, the name of the function is used.
::: zone-end
::: zone pivot="programming-language-python"  
Azure Functions supports two programming models for Python. The way that you define an orchestration trigger depends on the programming model that you select.

### [v2](#tab/python-v2)
When you use the Python v2 programming model, you can define an orchestration trigger by using the `orchestration_trigger` decorator directly in your Python function code. 

In the v2 model, you access the Durable Functions triggers and bindings from an instance of `DFApp`. You can use this subclass of `FunctionApp` to export decorators that are specific to Durable Functions. 

### [v1](#tab/python-v1)
When you write orchestrator functions in the Python v1 programming model, the orchestration trigger is defined by the following JSON object in the `bindings` array of the *function.json* file:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "orchestration": "<optional-name-of-orchestration>",
    "type": "orchestrationTrigger",
    "direction": "in"
}
```

The `orchestration` value is the name of the orchestration that clients must use when they want to start new instances of the orchestrator function. This property is optional. If you don't specify it, the name of the function is used.

---

::: zone-end    

Internally, this trigger binding polls the configured durable store for new orchestration events. Examples of events include orchestration start events, durable timer expiration events, activity function response events, and external events raised by other functions.

### Trigger behavior

Here are some notes about the orchestration trigger:

* **Single-threading**: A single dispatcher thread is used for all orchestrator function execution on a single host instance. For this reason, it's important to ensure that orchestrator function code is efficient and doesn't perform any I/O operations. It's also important to ensure that this thread doesn't do any asynchronous work except when awaiting task types that are specific to Durable Functions.
* **Poison-message handling**: There's no support for poison messages in orchestration triggers.
* **Message visibility**: Orchestration trigger messages are dequeued and kept invisible for a configurable duration. The visibility of these messages is renewed automatically as long as the function app is running and healthy.
* **Return values**: Return values are serialized to JSON and persisted to the orchestration history table in Azure Table Storage. These return values can be queried by the orchestration client binding, described later.

> [!WARNING]
> Orchestrator functions should never use any input or output bindings other than the orchestration trigger binding. Using other bindings can cause problems with the Durable Task extension, because those bindings might not obey the single-threading and I/O rules. If you want to use other bindings, add them to an activity function called from your orchestrator function. For more information about coding constraints for orchestrator functions, see the [Orchestrator function code constraints](durable-functions-code-constraints.md) documentation.

::: zone pivot="programming-language-javascript,programming-language-python"
> [!WARNING]
> Orchestrator functions should never be declared `async`.
::: zone-end

<a name="python-trigger-usage"></a> 
### Trigger usage

The orchestration trigger binding supports both inputs and outputs.

* **Inputs**: You can invoke orchestration triggers with inputs, which are accessed through the context input object. All inputs must be JSON-serializable.
* **Outputs**: Orchestration triggers support both output and input values. The return value of the function is used to assign the output value. The return value must be JSON-serializable.

### Trigger sample

The following code provides an example of a basic *Hello World* orchestrator function. This example orchestrator doesn't schedule any tasks.

::: zone pivot="programming-language-csharp"
The attribute that you use to define the trigger depends on whether you run your C# functions [in the same process as the Functions host process](../functions-dotnet-class-library.md) or in an [isolated worker process](../dotnet-isolated-process-guide.md).

#### [In-process](#tab/in-process)

```csharp
[FunctionName("HelloWorld")]
public static string Run([OrchestrationTrigger] IDurableOrchestrationContext context)
{
    string name = context.GetInput<string>();
    return $"Hello {name}!";
}
```

> [!NOTE]
> The preceding code is for Durable Functions 2.x. For Durable Functions 1.x, you must use `DurableOrchestrationContext` instead of `IDurableOrchestrationContext`. For more information about the differences between versions, see [Durable Functions versions overview](durable-functions-versions.md).

#### [Isolated process](#tab/isolated-process)

```csharp
[Function("HelloWorld")]
public static string Run([OrchestrationTrigger] TaskOrchestrationContext context, string name)
{
    return $"Hello {name}!";
}
```

> [!NOTE]
> In the isolated worker model and the in-process model for .NET durable function apps, you can use `context.GetInput<T>()` to extract the orchestration input. However, the isolated worker model also supports the input being supplied as a parameter, as shown in the preceding code. The input binds to the first parameter, which has no binding attribute on it and isn't a well-known type already covered by other input bindings, such as `FunctionContext`.

---

::: zone-end  
::: zone pivot="programming-language-javascript" 

```javascript
const df = require("durable-functions");

module.exports = df.orchestrator(function*(context) {
    const name = context.df.getInput();
    return `Hello ${name}!`;
});
```

> [!NOTE]
> The `durable-functions` library calls the synchronous `context.done` method when the generator function exits.
::: zone-end  
::: zone pivot="programming-language-python" 
### [v2](#tab/python-v2)

```python
import azure.functions as func
import azure.durable_functions as df

myApp = df.DFApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@myApp.orchestration_trigger(context_name="context")
def my_orchestrator(context):
    result = yield context.call_activity("Hello", "Tokyo")
    return result
```

### [v1](#tab/python-v1)
```python
import azure.durable_functions as df

def orchestrator_function(context: df.DurableOrchestrationContext):
    input = context.get_input()
    return f"Hello {input['name']}!"

main = df.Orchestrator.create(orchestrator_function)
```
::: zone-end  
::: zone pivot="programming-language-powershell" 

```powershell
param($Context)

$InputData = $Context.Input
$InputData
```
::: zone-end  
::: zone pivot="programming-language-java" 

```java
@FunctionName("HelloWorldOrchestration")
public String helloWorldOrchestration(
        @DurableOrchestrationTrigger(name = "ctx") TaskOrchestrationContext ctx) {
    return String.format("Hello %s!", ctx.getInput(String.class));
}
```
::: zone-end

::: zone pivot="programming-language-csharp,programming-language-java,programming-language-javascript"
Most orchestrator functions call activity functions. The following code provides a *Hello World* example that demonstrates how to call an activity function:
::: zone-end
::: zone pivot="programming-language-csharp"
### [In-process](#tab/in-process)

```csharp
[FunctionName("HelloWorld")]
public static async Task<string> Run(
    [OrchestrationTrigger] IDurableOrchestrationContext context)
{
    string name = context.GetInput<string>();
    string result = await context.CallActivityAsync<string>("SayHello", name);
    return result;
}
```

> [!NOTE]
> The preceding code is for Durable Functions 2.x. For Durable Functions 1.x, you must use `DurableOrchestrationContext` instead of `IDurableOrchestrationContext`. For more information about the differences between versions, see [Durable Functions versions overview](durable-functions-versions.md).

### [Isolated process](#tab/isolated-process)

```csharp
[Function("HelloWorld")]
public static async Task<string> Run(
    [OrchestrationTrigger] TaskOrchestrationContext context, string name)
{
    string result = await context.CallActivityAsync<string>("SayHello", name);
    return result;
}
```

---

::: zone-end  
::: zone pivot="programming-language-javascript" 

```javascript
const df = require("durable-functions");

module.exports = df.orchestrator(function*(context) {
    const name = context.df.getInput();
    const result = yield context.df.callActivity("SayHello", name);
    return result;
});
```
::: zone-end  
::: zone pivot="programming-language-java" 

```java
@FunctionName("HelloWorld")
public String helloWorldOrchestration(
        @DurableOrchestrationTrigger(name = "ctx") TaskOrchestrationContext ctx) {
    String input = ctx.getInput(String.class);
    String result = ctx.callActivity("SayHello", input, String.class).await();
    return result;
}
```
::: zone-end

## Activity trigger

You can use an activity trigger to develop functions known as [activity functions](durable-functions-types-features-overview.md#activity-functions) that are called by orchestrator functions.

::: zone pivot="programming-language-csharp"
You use the [ActivityTriggerAttribute](/dotnet/api/microsoft.azure.webjobs.extensions.durabletask.activitytriggerattribute) .NET attribute to configure the activity trigger.
::: zone-end  
::: zone pivot="programming-language-java" 
You use the `@DurableActivityTrigger` annotation to configure the activity trigger.
::: zone-end  
::: zone pivot="programming-language-javascript,programming-language-powershell" 
The activity trigger is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "activity": "<optional-name-of-activity>",
    "type": "activityTrigger",
    "direction": "in"
}
```

The `activity` value is the name of the activity. This value is the name that orchestrator functions use to invoke this activity function. This property is optional. If you don't specify it, the name of the function is used.
::: zone-end
::: zone pivot="programming-language-python"  
The way that you define an activity trigger depends on the programming model that you use.

### [v2](#tab/python-v2)
Using the `activity_trigger` decorator directly in your Python function code. 

### [v1](#tab/python-v1)
The activity trigger is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "activity": "<optional-name-of-activity>",
    "type": "activityTrigger",
    "direction": "in"
}
```

The `activity` value is the name of the activity. This value is the name that orchestrator functions use to invoke this activity function. This property is optional. If you don't specify it, the name of the function is used.

---
::: zone-end    

Internally, this trigger binding polls the configured durable store for new activity execution events.

### Trigger behavior

Here are some notes about the activity trigger:

* **Threading**: Unlike the orchestration trigger, activity triggers don't have any restrictions on threading or I/O operations. They can be treated like regular functions.
* **Poison-message handling**: There's no support for poison messages in activity triggers.
* **Message visibility**: Activity trigger messages are dequeued and kept invisible for a configurable duration. The visibility of these messages is renewed automatically as long as the function app is running and healthy.
* **Return values**: Return values are serialized to JSON and persisted to the configured durable store.

### Trigger usage

The activity trigger binding supports both inputs and outputs, just like the orchestration trigger.

* **Inputs**: Activity triggers can be invoked with inputs from an orchestrator function. All inputs must be JSON-serializable.
* **Outputs**: Activity functions support both output and input values. The return value of the function is used to assign the output value and must be JSON-serializable.
* **Metadata**: .NET activity functions can bind to a `string instanceId` parameter to get the instance ID of the calling orchestration.

### Trigger sample

The following code provides an example of a basic *Hello World* activity function.

::: zone pivot="programming-language-csharp"
### [In-process](#tab/in-process)

```csharp
[FunctionName("SayHello")]
public static string SayHello([ActivityTrigger] IDurableActivityContext helloContext)
{
    string name = helloContext.GetInput<string>();
    return $"Hello {name}!";
}
```

The default parameter type for the .NET `ActivityTriggerAttribute` binding is [IDurableActivityContext](/dotnet/api/microsoft.azure.webjobs.extensions.durabletask.idurableactivitycontext) (or [DurableActivityContext](/dotnet/api/microsoft.azure.webjobs.durableactivitycontext?view=azure-dotnet-legacy&preserve-view=true) for Durable Functions v1). However, .NET activity triggers also support binding directly to JSON-serializeable types (including primitive types), so you can also use the following simplified version of the function:

```csharp
[FunctionName("SayHello")]
public static string SayHello([ActivityTrigger] string name)
{
    return $"Hello {name}!";
}
```

### [Isolated process](#tab/isolated-process)

In the isolated worker model for .NET, only serializable types representing your input are supported for the `[ActivityTrigger]` binding attribute.

```csharp
[Function("SayHello")]
public static string SayHello([ActivityTrigger] string name)
{
    return $"Hello {name}!";
}
```

---

::: zone-end  
::: zone pivot="programming-language-javascript" 
```javascript
module.exports = async function(context) {
    return `Hello ${context.bindings.name}!`;
};
```

JavaScript bindings can also be passed in as extra parameters, so you can also use the following simplified version of the function:

```javascript
module.exports = async function(context, name) {
    return `Hello ${name}!`;
};
```

::: zone-end  
::: zone pivot="programming-language-python" 

### [v2](#tab/python-v2)

```python
import azure.functions as func
import azure.durable_functions as df

myApp = df.DFApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@myApp.activity_trigger(input_name="myInput")
def my_activity(myInput: str):
    return "Hello " + myInput
```

### [v1](#tab/python-v1)

```python
def main(name: str) -> str:
    return f"Hello {name}!"
```

---

::: zone-end  
::: zone pivot="programming-language-powershell" 
```powershell
param($name)

"Hello $name!"
```
::: zone-end  
::: zone pivot="programming-language-java" 
```java
@FunctionName("SayHello")
public String sayHello(@DurableActivityTrigger(name = "name") String name) {
    return String.format("Hello %s!", name);
}
```
::: zone-end

### Use input and output bindings

Besides the activity trigger binding, you can also use regular input and output bindings. 

::: zone pivot="programming-language-javascript" 
For example, an activity function can receive input from an orchestrator function. That activity function can also send a message to an event hub by using the Azure Event Hubs output binding.

```json
{
  "bindings": [
    {
      "name": "message",
      "type": "activityTrigger",
      "direction": "in"
    },
    {
      "type": "eventHub",
      "name": "outputEventHubMessage",
      "connection": "EventhubConnectionSetting",
      "eventHubName": "eh_messages",
      "direction": "out"
  }
  ]
}
```

```javascript
module.exports = async function (context) {
    context.bindings.outputEventHubMessage = context.bindings.message;
};
```
::: zone-end

## Orchestration client

You can use the orchestration client binding to write functions that interact with orchestrator functions. These functions are often referred to as [client functions](durable-functions-types-features-overview.md#client-functions). For example, you can act on orchestration instances in the following ways:

* Start them.
* Query their status.
* Terminate them.
* Send events to them while they're running.
* Purge the instance history.

::: zone pivot="programming-language-csharp"
You can bind to an orchestration client by using the [DurableClientAttribute](/dotnet/api/microsoft.azure.webjobs.extensions.durabletask.durableclientattribute) attribute ([OrchestrationClientAttribute](/dotnet/api/microsoft.azure.webjobs.orchestrationclientattribute?view=azure-dotnet-legacy&preserve-view=true) in Durable Functions v1.x). 
::: zone-end  
::: zone pivot="programming-language-java" 
You can bind to an orchestration client by using the `@DurableClientInput` annotation.
::: zone-end  
::: zone pivot="programming-language-javascript,programming-language-powershell" 
The durable client trigger is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "taskHub": "<optional-name-of-task-hub>",
    "connectionName": "<optional-name-of-connection-string-app-setting>",
    "type": "orchestrationClient",
    "direction": "in"
}
```

* The `taskHub` property is used when multiple function apps share the same storage account but need to be isolated from each other. If you don't specify this property, the default value from *host.json* is used. This value must match the value that the target orchestrator functions use.
* The `connectionName` value is the name of an app setting that contains a storage account connection string. The storage account represented by this connection string must be the same one that the target orchestrator functions use. If you don't specify this property, the default storage account connection string for the function app is used.

> [!NOTE]
> In most cases, we recommend that you omit these properties and rely on the default behavior.
::: zone-end
::: zone pivot="programming-language-python"  
The way that you define a durable client trigger depends on the programming model that you use.

### [v2](#tab/python-v2)
Using the `durable_client_input` decorator directly in your Python function code. 

### [v1](#tab/python-v1)
The durable client trigger is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "taskHub": "<optional-name-of-task-hub>",
    "connectionName": "<optional-name-of-connection-string-app-setting>",
    "type": "orchestrationClient",
    "direction": "in"
}
```

* The `taskHub` property is used when multiple function apps share the same storage account but need to be isolated from each other. If you don't specify this property, the default value from *host.json* is used. This value must match the value that the target orchestrator functions use.
* The `connectionName` value is the name of an app setting that contains a storage account connection string. The storage account represented by this connection string must be the same one that the target orchestrator functions use. If you don't specify this property, the default storage account connection string for the function app is used.

> [!NOTE]
> In most cases, we recommend that you omit these properties and rely on the default behavior.

---
::: zone-end 

### Client usage

::: zone pivot="programming-language-csharp"
You typically bind to [IDurableClient](/dotnet/api/microsoft.azure.webjobs.extensions.durabletask.idurableclient) ([DurableOrchestrationClient](/dotnet/api/microsoft.azure.webjobs.durableorchestrationclient?view=azure-dotnet-legacy&preserve-view=true) in Durable Functions v1.x), which gives you full access to all orchestration client APIs supported by Durable Functions. 
::: zone-end  
::: zone pivot="programming-language-java" 
You typically bind to the `DurableClientContext` class. 
::: zone-end  
::: zone pivot="programming-language-javascript,programming-language-python,programming-language-powershell" 
You must use the language-specific SDK to get access to a client object.
::: zone-end

The following code provides an example of a queue-triggered function that starts a `HelloWorld` orchestration.

::: zone pivot="programming-language-csharp"

#### [In-process](#tab/in-process)

```csharp
[FunctionName("QueueStart")]
public static Task Run(
    [QueueTrigger("durable-function-trigger")] string input,
    [DurableClient] IDurableOrchestrationClient starter)
{
    // Orchestration input comes from the queue message content.
    return starter.StartNewAsync<string>("HelloWorld", input);
}
```

> [!NOTE]
> The preceding C# code is for Durable Functions 2.x. For Durable Functions 1.x, you must use the `OrchestrationClient` attribute instead of the `DurableClient` attribute, and you must use the `DurableOrchestrationClient` parameter type instead of `IDurableOrchestrationClient`. For more information about the differences between versions, see [Durable Functions versions overview](durable-functions-versions.md).

#### [Isolated process](#tab/isolated-process)

```csharp
[Function("QueueStart")]
public static Task Run(
    [QueueTrigger("durable-function-trigger")] string input,
    [DurableClient] DurableTaskClient client)
{
    // Orchestration input comes from the queue message content.
    return client.ScheduleNewOrchestrationInstanceAsync("HelloWorld", input);
}
```

---

::: zone-end  
::: zone pivot="programming-language-javascript,programming-language-powershell" 

**function.json**
```json
{
  "bindings": [
    {
      "name": "input",
      "type": "queueTrigger",
      "queueName": "durable-function-trigger",
      "direction": "in"
    },
    {
      "name": "starter",
      "type": "durableClient",
      "direction": "in"
    }
  ]
}
```

::: zone-end
::: zone pivot="programming-language-javascript"
**index.js**
```javascript
const df = require("durable-functions");

module.exports = async function (context) {
    const client = df.getClient(context);
    return instanceId = await client.startNew("HelloWorld", undefined, context.bindings.input);
};
```
::: zone-end  
::: zone pivot="programming-language-powershell" 

**run.ps1**
```powershell
param([string] $input, $TriggerMetadata)

$InstanceId = Start-DurableOrchestration -FunctionName $FunctionName -Input $input
```
::: zone-end  
::: zone pivot="programming-language-python" 

#### [v2](#tab/python-v2)

```python
import azure.functions as func
import azure.durable_functions as df

myApp = df.DFApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@myApp.route(route="orchestrators/{functionName}")
@myApp.durable_client_input(client_name="client")
async def durable_trigger(req: func.HttpRequest, client):
    function_name = req.route_params.get('functionName')
    instance_id = await client.start_new(function_name)
    response = client.create_check_status_response(req, instance_id)
    return response
```

#### [v1](#tab/python-v1)

**`function.json`**
```json
{
  "bindings": [
    {
      "name": "input",
      "type": "queueTrigger",
      "queueName": "durable-function-trigger",
      "direction": "in"
    },
    {
      "name": "starter",
      "type": "durableClient",
      "direction": "in"
    }
  ]
}
```

**`__init__.py`**
```python
import json
import azure.functions as func
import azure.durable_functions as df

async def main(msg: func.QueueMessage, starter: str) -> None:
    client = df.DurableOrchestrationClient(starter)
    payload = msg.get_body().decode('utf-8')
    instance_id = await client.start_new("HelloWorld", client_input=payload)
```
---

::: zone-end 
::: zone pivot="programming-language-powershell" 

**function.json**
```json
{
  "bindings": [
    {
      "name": "input",
      "type": "queueTrigger",
      "queueName": "durable-function-trigger",
      "direction": "in"
    },
    {
      "name": "starter",
      "type": "durableClient",
      "direction": "in"
    }
  ]
}
```

**run.ps1**
```powershell
param([string]$InputData, $TriggerMetadata)

$InstanceId = Start-DurableOrchestration -FunctionName 'HelloWorld' -Input $InputData
```

::: zone-end  
::: zone pivot="programming-language-java" 

```java
@FunctionName("QueueStart")
public void queueStart(
        @QueueTrigger(name = "input", queueName = "durable-function-trigger", connection = "Storage") String input,
        @DurableClientInput(name = "durableContext") DurableClientContext durableContext) {
    // Orchestration input comes from the queue message content.
    durableContext.getClient().scheduleNewOrchestrationInstance("HelloWorld", input);
}
```
::: zone-end  
For detailed information about starting instances, see [Instance management](durable-functions-instance-management.md).

## Entity trigger

You can use the entity trigger to develop an [entity function](durable-functions-entities.md). This trigger supports processing events for a specific entity instance.

> [!NOTE]
> Entity triggers are available starting in Durable Functions 2.x.

Internally, this trigger binding polls the configured durable store for new entity operations that need to be executed.

::: zone pivot="programming-language-csharp"
You use the [EntityTriggerAttribute](/dotnet/api/microsoft.azure.webjobs.extensions.durabletask.entitytriggerattribute) .NET attribute to configure the entity trigger.

::: zone-end  
::: zone pivot="programming-language-javascript,programming-language-powershell" 
The entity trigger is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "entityName": "<optional-name-of-entity>",
    "type": "entityTrigger",
    "direction": "in"
}
```

By default, the name of an entity is the name of the function.
::: zone-end 
::: zone pivot="programming-language-java" 
> [!NOTE]
> Entity triggers aren't yet supported for Java.
::: zone-end  
::: zone pivot="programming-language-python"  
The way that you define an entity trigger depends on the programming model that you use.

#### [v2](#tab/python-v2)
Using the `entity_trigger` decorator directly in your Python function code. 

#### [v1](#tab/python-v1)
The entity trigger is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "entityName": "<optional-name-of-entity>",
    "type": "entityTrigger",
    "direction": "in"
}
```

By default, the name of an entity is the name of the function.

---
::: zone-end 

### Trigger behavior

Here are some notes about the entity trigger:

* **Single-threading**: A single dispatcher thread is used to process operations for a particular entity. If multiple messages are sent to a single entity concurrently, the operations are processed one at a time.
* **Poison-message handling**: There's no support for poison messages in entity triggers.
* **Message visibility**: Entity trigger messages are dequeued and kept invisible for a configurable duration. The visibility of these messages is renewed automatically as long as the function app is running and healthy.
* **Return values**: Entity functions don't support return values. There are specific APIs that you can use to save state or pass values back to orchestrations.

Any state changes made to an entity during its execution are automatically persisted after execution is complete.

For more information and examples of defining and interacting with entity triggers, see [Entity functions](durable-functions-entities.md).

## Entity client

You can use the entity client binding to asynchronously trigger [entity functions](#entity-trigger). These functions are sometimes referred to as [client functions](durable-functions-types-features-overview.md#client-functions).

::: zone pivot="programming-language-csharp"
You can bind to the entity client by using the [DurableClientAttribute](/dotnet/api/microsoft.azure.webjobs.extensions.durabletask.durableclientattribute) .NET attribute in .NET class library functions.

> [!NOTE]
> You can also use tThe `[DurableClientAttribute]` to bind to the [orchestration client](#orchestration-client).

::: zone-end  
::: zone pivot="programming-language-javascript,programming-language-powershell" 
The entity client is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "taskHub": "<optional-name-of-task-hub>",
    "connectionName": "<optional-name-of-connection-string-app-setting>",
    "type": "durableClient",
    "direction": "in"
}
```

* The `taskHub` property is used when multiple function apps share the same storage account but need to be isolated from each other. If you don't specify this property, the default value from `host.json` is used. This value must match the value that the target entity functions use.
* The `connectionName` value is the name of an app setting that contains a storage account connection string. The storage account represented by this connection string must be the same one that the target entity functions use. If you don't specify this property, the default storage account connection string for the function app is used.

> [!NOTE]
> In most cases, we recommend that you omit the optional properties and rely on the default behavior.
::: zone-end  
::: zone pivot="programming-language-python"  
The way that you define an entity client depends on the programming model that you use.

#### [v2](#tab/python-v2)
Using the `durable_client_input` decorator directly in your Python function code. 

#### [v1](#tab/python-v1)
The entity client is defined by the following JSON object in the `bindings` array of *function.json*:

```json
{
    "name": "<name-of-input-parameter-in-function-signature>",
    "taskHub": "<optional-name-of-task-hub>",
    "connectionName": "<optional-name-of-connection-string-app-setting>",
    "type": "durableClient",
    "direction": "in"
}
```

* The `taskHub` property is used when multiple function apps share the same storage account but need to be isolated from each other. If you don't specify this property, the default value from `host.json` is used. This value must match the value that the target entity functions use.
* The `connectionName` value is the name of an app setting that contains a storage account connection string. The storage account represented by this connection string must be the same one that the target entity functions use. If you don't specify this property, the default storage account connection string for the function app is used.

> [!NOTE]
> In most cases, we recommend that you omit the optional properties and rely on the default behavior.

---
::: zone-end  
::: zone pivot="programming-language-java" 
> [!NOTE]
> Entity clients aren't yet supported for Java.
::: zone-end  

For more information and examples of interacting with entities as a client, see [Access entities](durable-functions-entities.md#access-entities).

<a name="host-json"></a>
## host.json settings

[!INCLUDE [durabletask](../../../includes/functions-host-json-durabletask.md)]

## Next steps

> [!div class="nextstepaction"]
> [Built-in HTTP API reference for instance management](durable-functions-http-api.md)
