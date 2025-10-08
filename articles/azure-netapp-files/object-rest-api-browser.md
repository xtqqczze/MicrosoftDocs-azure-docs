---
title: Access an Azure NetApp Files object REST API-enabled volume with S3-compatible clients
description: Learn how to access Azure NetApp Files object REST API-enabled volumes from S3-compatible clients
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 07/31/2025
ms.author: anfdocs
---

# Access an Azure NetApp Files object REST API-enabled volume with S3-compatible clients

You can use Azure NetApp Files' object REST API with an S3 Browser, taking advantage of secure SSL communication and seamless data management. 

## Connect to the S3 browser

1. Open the Edge browser on your client system. 
1. Enter the IP address of your object REST API-enabled Azure NetApp Files volumes in the browser. 
1. The browser should display a certificate error. Select the certificate to view details. 
1. Download and install the certificate.
    During installation, select **Trusted Root Certification Authorities** as the destination. 
    Connect S3 Browser to Your Object REST API-Enabled Volume 
1. After the installation completes successfully, configure your S3 browser connection Download the S3 compatible browser, add the bucket, then provide the name of the bucket (`https:<domain-name>`), the access key, and the secret key. 

## Access files with the AWS CLI

1. [Download and install the AWS CLI.](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
1. Verify the AWS CLI installed correctly with the `aws --version` command. If the output displays the AWS CLI version, it has installed correctly. 
1. Configure your AWS account with the `aws configure` command. When you enter the command, you are required to provide:
    - AWS access key ID
    - AWS secret access key 
    - Default region name (for example, `us-east-1`)
    - Default output format (for example, JSON)
1. Verify access to your bucket by listing the files in your bucket with the command `aws s3 ls <S3URI> --endpoint-url <volumeIPAddress>`. If access is configured correctly, the CLI displays a list of files in your bucket. 
    
    Refer to the [AWS CLI command reference](https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html) for more information about this command. 

## More information

* [Configure object REST API](object-rest-api-access-configure.md)
* [Understand object REST API](object-rest-api-introduction.md)