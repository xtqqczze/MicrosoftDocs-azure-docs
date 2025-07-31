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

With Azure NetApp Files object REST API, you can use [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) to virtualize Azure NetApp Files into Microsoft Fabric's unified data lake. With this shortcut, Azure AI search can index and retrieve data directly from Azure NetApp Files for semantic search and vector-based retrieval with intelligent applications. 

When creating the OneLake shortcut, sensitive information is protected through Microsoft Virtual Networks and Azure NetApp Files robust security protocols. A virtual data lake design approach simplifies data sharing across Azure's Data and AI services improving collaboration.  

## Before you begin 

Ensure you have the following: 

- An [Azure NetApp Files object REST API-enabled volume](object-rest-api-access-configure.md)
- SSL certificate for the compute endpoints
- You must install and configure an [on-premises data gateway](/data-integration/gateway/service-gateway-install#download-and-install-a-standard-gateway). Create [two gateways](/data-integration/gateway/service-gateway-install#add-another-gateway-to-create-a-cluster), with the second serving as a disaster recovery option. 

## Connect to OneLake

1. Create a workspace in [OneLake](/fabric/onelake/create-lakehouse-onelake#create-a-lakehouse).
1. Load data in the lakehouse by creating a [new S3-compatible shortcut](/onelake/create-on-premises-shortcut). The endpoint must be a URL with the volume's IP address, for example, `http://10.0.1.0:9000`.
1. Creating the shortcut populates the data gateway. After you provide the access key and secret key, the Azure NetApp Files data appears in your OneLake workspace. 

## More information 

* [Configure object REST API access in Azure NetApp Files](object-rest-api-access-configure.md)
* [OneLake shortcuts](/fabric/onelake//onelake-shortcuts)
* [What is an on-premises data gateway?](/data-integration/gateway/service-gateway-onprem)