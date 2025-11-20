---
title: Azure DocumentDB Input Binding for Azure Functions
description: Understand how to use Azure DocumentDB input binding to read items from the database.
author: sajeetharan
ms.author: sasinnat
ms.topic: reference
ms.date: 11/19/2025
ms.custom:
  - sfi-ropc-nochange
---

# Azure DocumentDB input binding for Azure Functions

[!INCLUDE [functions-bindings-documentdb-preview](../../includes/functions-bindings-documentdb-preview.md)]

This article explains how to work with the [Azure DocumentDB](/azure/documentdb/overview) input binding in Azure Functions. 

The Azure DocumentDB input binding lets you retrieve one or more items as documents from the database.

## Example

This example shows a Timer trigger function that uses an input binding to execute a periodic query against the database:

```csharp
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.AzureCosmosDb.Mongo;
using Microsoft.Extensions.Logging;
using MongoDB.Bson;
using MongoDB.Driver;

namespace Sample
{
    public static class Sample
    {
         [FunctionName("InputBindingSample")]
          public static async Task InputBindingRun(
            [TimerTrigger("*/5 * * * * *")] TimerInfo myTimer,
            [CosmosDBMongo("%vCoreDatabaseTrigger%", "%vCoreCollectionTrigger%", ConnectionStringSetting = "vCoreConnectionStringTrigger",
            QueryString = "%queryString%")] List<BsonDocument> docs,
            ILogger log)
          {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");

            foreach (var doc in docs)
            {
                log.LogInformation(doc.ToString());
            }
          }
           
    }
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
| **FunctionId** | (Optional) The ID of the trigger function. |
| **DatabaseName** | The name of the database being monitored by the trigger for changes. |
| **CollectionName** | The name of the collection in the database being monitored by the trigger for changes. |
| **ConnectionStringSetting** | The name of an app setting or setting collection that specifies how to connect to the Azure DocumentDB cluster being monitored. |
| **QueryString** | Defines the Mongo query expression used by the input binding return documents from the database. The query supports binding parameters. |

## Usage

You can use the `CosmosDBMongo` attribute to obtain and work directly with the [MongoDB client](https://mongodb.github.io/mongo-csharp-driver/2.8/apidocs/html/T_MongoDB_Driver_IMongoClient.htm) in your function code:

:::code language="csharp" source="~/azure-functions-mongodb-extension/Sample/Sample.cs" range="17-29" ::: 

## Related articles
 
- [Azure DocumentDB](/azure/documentdb/introduction)
- [Azure DocumentDB bindings for Azure Functions](functions-bindings-documentdb.md)
- [Azure DocumentDB trigger for Azure Functions](functions-bindings-documentdb-trigger.md)
- [Azure DocumentDB output binding for Azure Functions](functions-bindings-documentdb-output.md)
