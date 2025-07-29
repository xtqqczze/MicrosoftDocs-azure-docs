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

Azure NetApp Files supports the Object REST API, an S3-compatible REST API. The object REST API extends your file-based storage, enabling native S3 read access. You can integrate Azure NetApp Files with services including OneLake to accelerate innovation and create new use cases for your data. 

Object REST API allows you to present the same data set as a file hierarchy or as objects in a bucket. To do so, object REST API creates buckets that allow S3 clients to read and enumerate files in network attached storage (NAS) storage using S3 object requests. This mapping conforms to the NAS security configuration, observing file and directory access permissions.

This mapping is accomplished by presenting a specified NAS directory hierarchy as an S3 bucket. Each file in the directory hierarchy is represented as an S3 object whose name is relative from the mapped directory downwards; directory boundaries are represented by the slash character (/).

## Requirements and considerations

* Currently, you can only use NFS volumes with the object REST API feature. 
* Object REST API buckets are associated with volumes. Deleting the volume associated with a bucket permanently deletes the bucket. This action can't be undone. 
* Access is currently read-only. 
* Buckets are supported with cool access-enabled volumes and with large volumes. 
* You can only create one bucket per volume. 
<!-- user limit of 1?-->
* You are responsible for maintaining the lifecycle of your bucket certificates. To check the expiration and renew certificates, view the **Bucket** menu then check the **Certificate** status and **Certificate expiration date** fields. 

## Supported actions

The following S3 actions are supported with the object REST API feature:

<!-- list forthcoming -->

## Next steps 

* [Configure object REST API access](object-rest-api-access-configure.md)