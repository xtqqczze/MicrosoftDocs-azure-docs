---
title: Connect to Azure AI Search with an Azure NetApp Files volume using object REST API 
description: Learn how to connect an Azure NetApp Files volume to Azure AI Search.
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 10/08/2025
ms.author: anfdocs
---
# Connect to Azure AI Search with an Azure NetApp Files volume using object REST API 

With the Azure NetApp Files object REST API feature, you can connect a volume to [Azure AI Search](/search/search-what-is-azure-search) to create a search service. 

## Before you begin 

You must have configured [OneLake access](object-rest-api-onelake.md) before you can connect to Azure AI Search. 

## Steps

1. In the Azure portal, access the Azure AI Search service. If this is your first time accessing the service, see [Create an Azure AI Search service](/azure/search/search-create-service-portal).
1. In the search management section, navigate to **Data Sources**. Select **Add Data Source**. 
1. In the data source dropdown, select **Fabric OneLake files**.
1. Provide a name for the data source. 
1. Enter the Lakehouse URL that was configured in the OneLake setup. 
1. Validate the connection once your OneLake data appears. 
1. Select **Add Indexer**, then provide your details by selecting your dataset and OneLake details. 
1. Navigate to the 'Index' section and select your data source name. 
1. In the search field, enter the information you want to query or use '*' to view the complete indexing details. 

## More information 

* [What's Azure AI Search?](/search/search-what-is-azure-search)
* [How to index OneLake files](/search/search-how-to-index-onelake-files)
* [Understand Azure NetApp Files object REST API](object-rest-api-introduction.md)