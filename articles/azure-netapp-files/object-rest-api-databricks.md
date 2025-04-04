---
title: Connect Azure Databricks to an Azure NetApp Files volume using object REST API 
description: Learn how to connect Azure Databricks to an Azure NetApp Files volume using object REST API 
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 04/04/2025
ms.author: anfdocs
---

# Connect Azure Databricks to an Azure NetApp Files volume using object REST API 

Azure NetApp Files supports connecting to Azure Databricks via an Azure NetApp Files object REST API-enabled volume with `init` scripts to load the SSL certificate for compute endpoints. Using this setup ensures secure communication between Azure Databricks and your Azure NetApp Files Object REST API-enabled volume. 

## Before you begin 

Ensure you have the following: 

- An active [Azure Databricks workspace](/databricks/workspace/)
- An [Azure NetApp Files object REST API-enabled volume](object-rest-api-access-configure.md)
- SSL certificate for the compute endpoints
- Necessary permissions to access Azure Databricks and the Azure NetApp Files volume

## Steps 

This process requires using both the Azure NetApp Files portal and your Databricks workspace. 

### Prepare the SSL certificate:

1. Obtain the SSL certificate for your S3-compatible storage service's compute endpoints. 
1. Save the SSL certificate in a secure location accessible by Azure Databricks. 

### Create the `init` script 

1. Write a bash script to load the SSL certificate. Save the script with a .sh extension. For example:

````bash
#!/bin/bash 
CERT_PATH="/dbfs/path/to/your/certificate.crt" 
cp $CERT_PATH /etc/ssl/certs/ 
update-ca-certificates 
````

1. Use the Databricks CLI or the Databricks UI to upload the bash script to the Databricks File System (DBFS). 

### Configure the cluster 

1. Navigate to your Azure Databricks workspace and open the cluster configuration settings. 
1. In the **Advanced Options** section, add the path to the init script under **Init Scripts.** For example: `dbfs:/path/to/your/script.sh`
1. Restart the cluster to apply the changes and load the SSL certificate. 

###  Connect to Azure NetApp Files bucket 

1. In your Databricks notebook, configure the Spark session to connect to the Azure NetApp Files bucket. For example: 
```
spark.conf.set("fs.s3a.endpoint", "https://your-s3-endpoint") 
spark.conf.set("fs.s3a.access.key", "your-access-key") 
spark.conf.set("fs.s3a.secret.key", "your-secret-key") 
spark.conf.set("fs.s3a.connection.ssl.enabled", "true") 
```
1.  Verify the connection by performing a simple read operation. For example: 
```
df = spark.read.csv("s3a://your-bucket/path/to/data.csv") 
df.show() 
```

## Next steps 

 

 