---
title: Connect an S3 browser to an Azure NetApp Files object REST API-enabled volume 
description: Learn how to connect Azure Databricks to an Azure NetApp Files volume using object REST API 
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 07/31/2025
ms.author: anfdocs
---

# Connect an S3 browser to an Azure NetApp Files object REST API-enabled volume 

You can use Azure NetApp Files' object REST API with an S3 Browser, taking advantage of secure SSL communication and seamless data management. 

## Connect to the S3 browser

1. Open the Edge browser on your client system. 
1. Enter the IP address of your object REST API-enabled Azure NetApp Files volumes in the browser. 
1. The browser should display a certificate error. Select the certificate to view details. 
1. Download and install the certificate.
    During installation, select **Trusted Root Certification Authorities** as the destination. 
    Connect S3 Browser to Your Object REST API-Enabled Volume 
1. After the installation completes successfully, configure your S3 Browser connection. Provide the bucket name, access key, and secret key as required. 

## Access files with the AWS CLI

1. [Download and install the AWS CLI.](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
1. Check the version of your AWS CLI with the `aws --version` command.
1. Configure your AWS account with the `aws configure` command. When you enter the command, you are required to provide:
    - AWS access key ID
    - AWS secret access key 
    - Default region name
    - Default output format 
1. Verify access to your bucket by listing the files in your bucket with the command `aws s3 ls <S3URI> --endpoint-url <volumeIPAddress>`. If access is configured correctly, the CLI displays a list of files in your bucket. 
    
    Refer to the [AWS CLI command reference](https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html) for more information about this command. 