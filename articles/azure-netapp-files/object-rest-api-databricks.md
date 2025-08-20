---
title: Connect Azure Databricks to an Azure NetApp Files volume using object REST API 
description: Learn how to connect Azure Databricks to an Azure NetApp Files volume using object REST API 
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 07/31/2025
ms.author: anfdocs
---

# Connect Azure Databricks to an Azure NetApp Files volume using object REST API 

The [object REST API feature](object-rest-api-introduction.md) enables Azure Databricks and Azure Machine Learning to read and write data to Azure NetApp Files volumes, supporting end-to-end data science workflows from ingestion to model deployment.

To connect to Azure Databricks, you run an `init` script to load the SSL certificate for compute endpoints. Using this setup ensures secure communication between Azure Databricks and your Azure NetApp Files object REST API-enabled volume. 

## Before you begin 

Ensure you have the following: 

- An active [Azure Databricks workspace](/azure/databricks/workspace/workspace-browser)
- An [Azure NetApp Files object REST API-enabled volume](object-rest-api-access-configure.md)
- SSL certificate for the compute endpoints
- Necessary permissions to access Azure Databricks and the Azure NetApp Files volume

### Create the `init` script 

1. Write a bash script to load the SSL certificate. Save the script with an .sh extension. For example:

````bash
#!/bin/bash 
CERT_PATH="/dbfs/path/to/your/certificate.crt" 
cp $CERT_PATH /etc/ssl/certs/ 
update-ca-certificates 
````

1. Use the Databricks CLI or the Databricks UI to upload the bash script to the Databricks File System (DBFS). For more information, see, [work with files on Azure Databricks](/azure/databricks/files/).

### Configure the cluster 

1. Navigate to your Azure Databricks workspace. Open the cluster configuration settings. 
1. In the **Advanced Options** section, add the path to the init script under **Init Scripts**. For example: `dbfs:/path/to/your/script.sh`
<!-- add the /etc/hosts/ files to the `init` script -->
1. Restart the cluster to apply the changes and load the SSL certificate. 
1. Validate in the logs if the certificate is placed correctly. 
1. Create a notebook and attempt to connect to the bucket. Select the VM which had the init script while booting up.
<!-- need details -->

###  Connect to Azure NetApp Files bucket 

Review the [recommendations to access S3 buckets with URIs and AWS keys](/azure/databricks/connect/storage/amazon-s3#access-s3-buckets-with-uris-and-aws-keys)

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

 

 