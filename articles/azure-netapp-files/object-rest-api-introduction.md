---
title: Understand Azure NetApp Files object REST API access
description: Learn about object REST API access management for S3 workloads in Azure NetApp Files. 
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: conceptual
ms.date: 12/02/2024
ms.author: anfdocs
---
# Understand Azure NetApp Files object REST API (preview)

Azure NetApp Files supports the Object REST API, an S3-comptabile REST API. The object REST API extends your file-based storage, enabling native S3 read access. You can integrate Azure NetApp Files with service including OneLake to accelerate innovation and create new use cases for your data. 

## Requirements and considerations

* Object REST API support is currently only supported for NFS volumes. 
* Object REST API buckets are associated with volumes. Deleting the volume associated with a bucket permanently deletes the bucket. This action can't be undone. 
* Access is currently read-only. 
* Buckets are supported with cool access-enabled volumes and with large volumes. 
* You can only create one bucket per volume. 
<!-- user limit of 1?-->
* You are responsible for maintaining the lifecycle of your bucket certificates. To check the expiration and renew certificates, view the **Bucket** menu then check the **Certificate** status and **Certificate expiration date** fields. 

## Next steps 

* [Configure object REST API access](configure-object-rest-api-access.md)