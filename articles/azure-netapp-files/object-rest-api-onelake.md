---
title: Connect OneLake to an Azure NetApp Files volume using object REST API 
description: Learn how to create a OneLake shortcut to connect Azure NetApp Files to a unified data lake. 
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 07/31/2025
ms.author: anfdocs
---

# Connect OneLake to an Azure NetApp Files volume using object REST API 
<!-- connect to Azure AI service? -->

With Azure NetApp Files object REST API, you can use [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) to virtualize Azure NetApp Files into Microsoft Fabric's unified data lake. With this shortcut, Azure AI search can index and retrieve data directly from Azure NetApp Files for semantic search and vector-based retrieval with intelligent applications. 

When creating the OneLake shortcut, sensitive information is protected through Microsoft Virtual Networks and Azure NetApp Files robust security protocols. A virtual data lake design approach simplifies data sharing across Azure's Data and AI services improving collaboration.  

## Before you begin 

- You must have created an [Azure NetApp Files object REST API-enabled volume](object-rest-api-access-configure.md).
- You must install and configure an [on-premises data gateway](/data-integration/gateway/service-gateway-install#download-and-install-a-standard-gateway). Create [two gateways](/data-integration/gateway/service-gateway-install#add-another-gateway-to-create-a-cluster), with the second serving as a disaster recovery option. 

>[!NOTE]
>When install the data gateway, ensure you're using an [up-to-date release](/data-integration/gateway/service-gateway-install). 

## Connect to OneLake

1. Create a workspace in [OneLake](/fabric/onelake/create-lakehouse-onelake).
1. In OneLake, right-click the workspace then select **New shortcut**. Load data in the lakehouse by creating a [new S3-compatible shortcut](/onelake/create-on-premises-shortcut). The endpoint must be a URL with the volume's IP address, for example, `http://10.0.1.0:9000`.
1. Creating the shortcut populates the data gateway. After you provide the access key and secret key, the Azure NetApp Files data appears in your OneLake workspace. 

## Connect to Azure AI Search 

>[!NOTE]
>You must have configured OneLake access before you can connect to Azure AI Search. 

1. In the Azure portal, access the Azure AI Search service. If this is your first time accessing the service, see [Create an Azure AI Search service](/search/search-create-service-portal).
1. In the search management section, navigate to 'Data Sources'. 
1. Select **Add Data Source**. 
1. In the data source dropdown, select **Fabric OneLake files**.
1. Provide a name for the data source. 
1. Enter the Lakehouse URL that was configured in the OneLake setup. 
1. Validate the connection once your OneLake data is reflected. 
1. Select **Add Indexer** then provide your details by selecting your dataset and OneLake details. 
1. Navigate to the 'Index' section and select your data source name. 
1. In the search field, enter the information you want to query or use '*' to view the complete indexing details. 

## More information 

* [Configure object REST API access in Azure NetApp Files](object-rest-api-access-configure.md)
* [OneLake shortcuts](/fabric/onelake//onelake-shortcuts)
* [What is an on-premises data gateway?](/data-integration/gateway/service-gateway-onprem)
* [What is Azure AI Search?](/search/search-what-is-azure-search)