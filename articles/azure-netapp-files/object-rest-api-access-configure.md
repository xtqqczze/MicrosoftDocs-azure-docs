---
title: Configure object REST API access in Azure NetApp Files 
description: Learn how to configure object REST API access to manage S3 objects in Azure NetApp Files. 
services: azure-netapp-files
author: b-ahibbard
ms.service: azure-netapp-files
ms.topic: how-to
ms.date: 03/05/2025
ms.author: anfdocs
---

# Configure object REST API access in Azure NetApp Files (preview)

Azure NetApp Files supports read access to S3 objects with the [object REST API](object-rest-api-introduction.md) feature. With the object REST API feature, you can connect to services including [OneLake](/fabric/onelake/onelake-overview).

To connect to S3 objects, you must create a bucket that is tied to an Azure NetApp Files NFS volume. After configuring the bucket, access is read-only. 

## Register the feature 

The object REST API access feature in Azure NetApp Files is currently in preview. You need to register the feature before using it for the first time. Feature registration can take up to 60 minutes to complete.

1. Register the feature

    ```azurepowershell-interactive
    Register-AzProviderFeature -ProviderNamespace Microsoft.NetApp -FeatureName ANFEnableObjectRESTAPI
    ```

2. Check the status of the feature registration: 

    > [!NOTE]
    > The **RegistrationState** may be in the `Registering` state for up to 60 minutes before changing to `Registered`. Wait until the status is `Registered` before continuing.
    ```azurepowershell-interactive
    Get-AzProviderFeature -ProviderNamespace Microsoft.NetApp -FeatureName ANFEnableObjectRESTAPI
    ```
You can also use [Azure CLI commands](/cli/azure/feature) `az feature register` and `az feature show` to register the feature and display the registration status. 

## Enable object REST API access

>[!IMPORTANT]
>Object REST API access is currently only supported on **NFS** volumes. 

1. From your NetApp account, select **Buckets**. 
1. To create a bucket, select **+Create**. 
1. Provide the following information for the bucket:
    * **Name**
        Specify the name for your bucket. Refer to [Naming rules and restrictions for Azure resources](../azure-resource-manager/management/resource-name-rules.md#microsoftnetapp) for naming conventions.
    * **Path**
        The subdirectory path for object REST API access. For full volume access, leave this field blank or use `/` for the root directory.
    * **UserID (UID)**
        The UID used to read the bucket.
    * **GroupID (GID)**
        The GID used to read the bucket.
    If you haven't provided a certificate, also provide the following information:
    * **Fully qualified domain name**
    * **Certificate source**
        Upload the appropriate certificate. Only `.pem` files are supported. 
    * **Permissions**
        Buckets are currently read-only. You can't modify this field. 
1. Select **Create**. 
    After creating the bucket, you must [generate the access key](#generate-the-access-key-for-a-bucket).

## Generate the access key for a bucket

1. In your NetApp account, navigate to **Buckets**. 
1. For the bucket you want to create an access key for, select **Generate keys**. 
1. In the **Access key lifespan** field, provide a numerical value for the number of days the key is valid. 
<!-- maximum and recommended? -->
1. When the key successfully generates, the portal presents your masked Access key and Secret access key. Display and securely save the information. 

## Edit a bucket

After you create a bucket, you have the option to modify the user identifier (UID or GUID) of the bucket.

1. In your NetApp account, navigate to **Buckets**. 
1. Select the three dots `...` at the end of the line next to the name of the bucket you want to modify then select **Edit**. 
<!-- confirm access keys -->
1. Enter the new User ID or Group User ID for the bucket. 
1. Select **Save**. 

## Delete a bucket

Deleting a bucket is a permanent operation. You can't recover the bucket once it's deleted. 

1. In your NetApp account, navigate to **Buckets**. 
1. Select the checkbox next to the bucket you want to delete. 
1. Select **Delete**. 
1. In the modal, select **Delete** to confirm you want to delete the bucket. 

## Next steps 

* [Install an on-premises data gateway](/data-integration/gateway/service-gateway-install)
* [Create an Amazon S3 compatible shortcut](/fabric/onelake/create-s3-compatible-shortcut)
* [Understand REST API object](object-rest-api-introduction.md)
* [Connecting to Microsoft OneLake](/fabric/onelake/onelake-access-api)