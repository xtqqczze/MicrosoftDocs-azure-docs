---
title: Azure DocumentDB Trigger for Azure Functions
description: Understand how to use Azure DocumentDB trigger to monitor change streams for inserts and updates in collections.
author: sajeetharan
ms.author: sasinnat
ms.topic: reference
ms.date: 11/19/2025
ms.custom:
  - sfi-ropc-nochange
---

# Azure DocumentDB trigger for Azure Functions

[!INCLUDE [functions-bindings-documentdb-preview](../../includes/functions-bindings-documentdb-preview.md)]

This article explains how to work with the [Azure DocumentDB](/azure/documentdb/overview) trigger in Azure Functions.

The change feed publishes only new and updated items. Watching for delete operations using change streams is currently not supported.

## Example

This example shows a function that returns a single document that is inserted or updated:

:::code language="csharp" source="~/azure-functions-mongodb-extension/Sample/Sample.cs" range="49-57" ::: 

For the complete example, see [Sample.cs](https://github.com/Azure/Azure-functions-mongodb-extension/blob/main/Sample/Sample.cs) in the extension repository.

## Attributes

This table describes the binding configuration properties of the `CosmosDBMongoTrigger` attribute.

| Parameter | Description |
| --- | --- |
| **FunctionId** | (Optional) The ID of the trigger function. |
| **DatabaseName** | The name of the database being monitored by the trigger for changes. Required unless `TriggerLevel` is set to `MonitorLevel.Cluser`. |
| **CollectionName** | The name of the collection in the database being monitored by the trigger for changes. Required when `TriggerLevel` is set to `MonitorLevel.Collection`.|
| **ConnectionStringSetting** | The name of an app setting or setting collection that specifies how to connect to the Azure DocumentDB cluster being monitored. |
| **TriggerLevel** | Indicates the level at which changes are being monitored. Valid values of `MonitorLevel` are: `Collection`, `Database`, and `Cluster`. |

## Usage

Use the `TriggerLevel` parameter to set the scope of changes being monitored. 

You can use the `CosmosDBMongo` attribute to obtain and work directly with the [MongoDB client](https://mongodb.github.io/mongo-csharp-driver/2.8/apidocs/html/T_MongoDB_Driver_IMongoClient.htm) in your function code:

:::code language="csharp" source="~/azure-functions-mongodb-extension/Sample/Sample.cs" range="17-29" ::: 

## Related articles
 
- [Azure DocumentDB](/azure/documentdb/overview)
- [Azure DocumentDB bindings for Azure Functions](functions-bindings-documentdb.md)
- [Azure DocumentDB input binding for Azure Functions](functions-bindings-documentdb-input.md)
- [Azure DocumentDB output binding for Azure Functions](functions-bindings-documentdb-output.md)
