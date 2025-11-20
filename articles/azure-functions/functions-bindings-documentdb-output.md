---
title: Azure DocumentDB Output Binding for Azure Functions
description: Understand how to use Azure DocumentDB output to write new items to the database.
author: sajeetharan
ms.author: sasinnat
ms.topic: reference
ms.date: 11/19/2025
ms.custom:
  - sfi-ropc-nochange
---

# Azure DocumentDB output binding for Azure Functions

[!INCLUDE [functions-bindings-documentdb-preview](../../includes/functions-bindings-documentdb-preview.md)]

This article explains how to work with the [Azure DocumentDB](/azure/documentdb/overview) output binding in Azure Functions. 

The Azure DocumentDB output binding lets you write a new document to an Azure DocumentDB collection.

## Example

This example shows a Timer trigger function that uses `CosmosDBMongoCollector` to add an item to the database:

```csharp
[FunctionName("OutputBindingSample")]
    public static async Task OutputBindingRun(
    [TimerTrigger("*/5 * * * * *")] TimerInfo myTimer,
    [CosmosDBMongo("%vCoreDatabaseBinding%", "%vCoreCollectionBinding%", ConnectionStringSetting = "vCoreConnectionStringBinding")] IAsyncCollector<TestClass> CosmosDBMongoCollector,
    ILogger log)
{
    log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");

    TestClass item = new TestClass()
    {
        id = Guid.NewGuid().ToString(),
        SomeData = "some random data"
    };
    await CosmosDBMongoCollector.AddAsync(item);
} 
```

The examples refer to a simple `TestClass` type:

```csharp
namespace Sample
{
    public class TestClass
    {
        public string id { get; set; }
        public string SomeData { get; set; }
    }
}
```

## Attributes

This table describes the binding configuration properties of the `CosmosDBMongoTrigger` attribute.

| Parameter | Description |
| --- | --- |
|**FunctionId** | (Optional) The ID of the trigger function. |
|**DatabaseName** | The name of the database being monitored by the trigger for changes. |
|**CollectionName** | The name of the collection in the database being monitored by the trigger for changes.|
|**ConnectionStringSetting** | The name of an app setting or setting collection that specifies how to connect to the Azure DocumentDB cluster being monitored. |
|**CreateIfNotExists** | (Optional) When set to true, creates the targeted database and collection when they don't already exist. |

## Usage

You can use the `CosmosDBMongo` attribute to obtain and work directly with the [MongoDB client](https://mongodb.github.io/mongo-csharp-driver/2.8/apidocs/html/T_MongoDB_Driver_IMongoClient.htm) in your function code:

:::code language="csharp" source="~/azure-functions-mongodb-extension/Sample/Sample.cs" range="17-29" ::: 

## Related articles
 
- [Azure DocumentDB](/azure/documentdb/overview)
- [Azure DocumentDB bindings for Azure Functions](functions-bindings-documentdb.md)
- [Azure DocumentDB trigger for Azure Functions](functions-bindings-documentdb-trigger.md)
- [Azure DocumentDB input binding for Azure Functions](functions-bindings-documentdb-input.md)
