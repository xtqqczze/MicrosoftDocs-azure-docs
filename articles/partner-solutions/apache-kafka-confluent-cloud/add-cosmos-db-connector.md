---
title: Create a Confluent Connector for Azure Cosmos DB (Preview)
description: Learn how to use Confluent Connectors in Azure (preview) to connect an instance of Apache Kafka & Apache Flink on Confluent Cloud to Azure Cosmos DB.
ms.topic: how-to
ms.date: 10/30/2025
ms.author: malev
author: maud-lv

#customer intent: As a developer, I want learn how to connect an instance of Apache Kafka & Apache Flink on Confluent Cloud to Azure Cosmos DB so that I can use Confluent Connectors in Azure.
---

# Create a Confluent Connector to Azure Cosmos DB (preview)

Confluent Cloud helps you connect your Confluent clusters to popular data sources and sinks. You can take advantage of this solution on Azure by using the Confluent Connectors feature.

In this article, you'll learn how to connect an instance of Apache Kafka & Apache Flink on Confluent Cloud to Azure Cosmos DB.

## Prerequisites

* An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free).
* An [Azure Cosmos DB](/azure/cosmos-db/) resource.
* A [Confluent organization](./create.md) created in Azure Native Integrations.
* The Owner or Contributor role for the Azure subscription. You might need to ask your subscription administrator to assign you one of these roles.  
* A [configured environment, cluster, and topic](https://docs.confluent.io/cloud/current/get-started/index.html) inside the Confluent organization. If you don't have one already, go to Confluent to create these components.

## Create a Confluent sink connector for Azure Cosmos DB (preview) 

To create a sink connector for Azure Cosmos DB:  

1. In the Azure portal, go to your Confluent organization.  
1. In the left pane, select **Data streaming** > **Confluent Connectors (Preview)**.  
1. Select **Create new connector**.  
1. In the **Create a new connector** pane, configure the settings that are described in the next sections.  

### Basics 

On the **Basics** tab, enter or select values for the following settings: 

|Name|Action|
|-|-|
|**Connector Type**| Select **Sink**.| 
|**Connector Class**|Select **Azure Cosmos DB V2**.| 
|**Connector Name** |Enter a name for your connector. For example, *cosmos-sink-connector*. |
|**Environment** |Select the environment where you want to create the connector.| 
|**Cluster** |Select the cluster where you want to create the connector.| 
|**Topics**|Select one or more Kafka topics to pull data from. |
|**Cosmos account endpoint (URI)** |Select the destination Azure Cosmos DB account in your Azure tenant. |
|**Database** |Select the destination Azure Cosmos DB database under the account. |

### Authentication 

On the **Authentication** tab, select an authentication method: **User** or **Service account**. 

- To use a service account (recommended for production), enter a **Service account** name and continue. A new service account will be provisioned in Confluent cloud when the connector is created. 
- To use a user account, leave **User** selected and continue. A user API key and secret will be created for the specific user in Confluent cloud when the connector is created. 

### Configuration 

On the **Configuration** tab, enter or select the following values, and then select **Next**. 

|Setting|Action| 
|-|-|
|**Input Data Format**|Select an input Kafka record data format type: **AVRO**, **JSON**, **string**, or **Protobuf**.|  
|**Id Strategy**|Select the ID strategy used to derive the Azure Cosmos DB item ID.  |
|**Cosmos DB Write Configuration** |Select the write behavior for Azure Cosmos DB items.  |
|**Topic container map**|Map Kafka topics to Azure Cosmos DB containers. Use the format `topic1#container1,topic2#container2...`.| 
|**Number of tasks**|(Optional) Enter the maximum number of simultaneous tasks you want your connector to support. The default is **1**.  |

For more information, see [Azure Cosmos DB Sink V2 Connector for Confluent Cloud](https://docs.confluent.io/cloud/current/connectors/cc-azure-cosmos-sink-v2.html?utm_source=chatgpt.com).

Select **Review + create** to continue.

### Review + create 

Review your settings for the connector to ensure that the details are accurate and complete. Then select **Create** to begin the connector deployment. In the upper-right corner of the Azure portal, a notification displays the deployment status. When it shows that the connector is created, refresh the **Confluent Connectors (Preview)** pane and check for the new connector tile.

## Create a Confluent source connector for Azure Cosmos DB (preview) 

1. In the Azure portal, go to your Confluent organization. 
1. In the left pane, select **Data Streaming** > **Confluent Connectors (Preview)**. 
1. Select **Create new connector**. 
1. In the **Create a new connector** pane, configure the settings that are described in the following sections.   

### Basics 

On the **Basics** tab, enter or select values for the following settings: 

|Setting|Action| 
|-|-|
|**Connector Type**|Select **Source**.| 
|**Connector Class**|Select **Azure Cosmos DB V2**.|
|**Connector Name**|Enter a name for your connector. For example, *cosmos-source-connector*.|
|**Environment**|Select the environment where you want to create the connector. |
|**Cluster**|Select the cluster where you want to create the connector.| 
|**Cosmos account endpoint (URI)**|Select the source Azure Cosmos DB account. |
|**Database**|Select the source Azure Cosmos DB database.| 

### Authentication 

On the **Authentication** tab, select an authentication method: **User** or **Service account**. 

- To use a service account (recommended for production), enter a **Service account** name and continue. A new service account will be  provisioned in Confluent cloud when the connector is created. 
- To use a user account, leave **User** selected and continue. A user API key and secret will be created for the specific user in Confluent cloud when the connector is created. 

### Configuration 

On the **Configuration** tab, enter or select the following values, and then select **Next**. 

|Name|Action|
|-|-|
|**Output Data Format** |Select an output Kafka record data format type: **AVRO**, **JSON**, **string**, or **Protobuf**.|
|**Container topic map**|Map Azure Cosmos DB containers to Kafka topics. Use the format `container1#topic1,container2:topic2…`. |
|**Number of tasks**|(Optional) Enter the maximum number of simultaneous tasks you want your connector to support. The default is **1**. |

Select **Review + create** to continue. 

### Review + create 

Review your settings for the connector to ensure that the details are accurate and complete. Then select **Create** to begin the connector deployment. In the upper-right corner of the Azure portal, a notification displays the deployment status. When it shows that the connector is created, refresh the **Confluent Connectors (Preview)** pane and check for the new connector tile. 

## Related content
manage 