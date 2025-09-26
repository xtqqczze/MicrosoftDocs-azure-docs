---
title: Authorize access for AzCopy with a user identity
description: You can provide authorization credentials for AzCopy operations by using a Microsoft Entra ID user identity.
author: normesta
ms.service: azure-storage
ms.topic: how-to
ms.date: 02/26/2025
ms.author: normesta
ms.subservice: storage-common-concepts
ms.custom: devx-track-azurecli, devx-track-azurepowershell
# Customer intent: "As a cloud administrator, I want to authorize access for AzCopy operations using Microsoft Entra ID, so that I can streamline file uploads and downloads without the need for SAS tokens, enhancing security and ease of management."
---

# Authorize access for AzCopy with a user identity

You can provide AzCopy with authorization credentials by using Microsoft Entra user identity.

For more information about AzCopy, [Get started with AzCopy](storage-use-azcopy-v10.md).

## Verify role assignments

The level of authorization that you need is based on whether you plan to upload files or just download them.

If you just want to download files, then verify that the [Storage Blob Data Reader](../../role-based-access-control/built-in-roles.md#storage-blob-data-reader) role (Azure Blob Storage) or the [Storage File Data Privileged Reader](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-reader) role (Azure Files) has been assigned to your user identity, managed identity, or service principal.

If you want to upload files to Azure Blob Storage, then verify that one of these roles has been assigned to your security principal.

- [Storage Blob Data Contributor](../../role-based-access-control/built-in-roles.md#storage-blob-data-contributor)
- [Storage Blob Data Owner](../../role-based-access-control/built-in-roles.md#storage-blob-data-owner)

If you want to upload files to an Azure file share, then verify that the [Storage File Data Privileged Reader](../../role-based-access-control/built-in-roles.md#storage-file-data-privileged-reader) has been assigned to your security principal.

These roles can be assigned to your security principal in any of these scopes:

- Container (file system) or file share
- Storage account
- Resource group
- Subscription

To learn how to verify and assign roles, see [Assign an Azure role for access to blob data](../blobs/assign-azure-role-data-access.md) (Blob Storage) or [Choose how to authorize access to file data in the Azure portal](../files/authorize-data-operations-portal.md) (Azure Files).

> [!NOTE]
> Keep in mind that Azure role assignments can take up to five minutes to propagate.

You don't need to have one of these roles assigned to your security principal if your security principal is added to the access control list (ACL) of the target container or directory. In the ACL, your security principal needs write permission on the target directory, and execute permission on container and each parent directory.

To learn more, see [Access control model in Azure Data Lake Storage](../blobs/data-lake-storage-access-control-model.md).

## Authorize a user identity by environment variables

To authorize access, you'll set in-memory environment variables. Then run any AzCopy command. AzCopy will retrieve the Auth token required to complete the operation. After the operation completes, the token disappears from memory. AzCopy retrieves the OAuth token by using the credentials that you provide. 

After you've verified that your user identity has been given the necessary authorization level, type the following command, and then press the ENTER key.

```bash
export AZCOPY_AUTO_LOGIN_TYPE=DEVICE
```
Then, run any azcopy command (For example: `azcopy list https://contoso.blob.core.windows.net`).

This command returns an authentication code and the URL of a website. Open the website, provide the code, and then choose the **Next** button.

![Create a container](media/storage-use-azcopy-v10/azcopy-login.png)

A sign-in window will appear. In that window, sign into your Azure account by using your Azure account credentials. After you've successfully signed in, the operation can complete.

### Authorize by using the AzCopy login command

As an alternative to using in-memory variables, you authorize access by using the azcopy login command.

The azcopy login command retrieves an OAuth token and then places that token into a secret store on your system. If your operating system doesn't have a secret store such as a Linux keyring, the azcopy login command won't work because there is nowhere to place the token.

After you've verified that your user identity has been given the necessary authorization level, open a command prompt, type the following command, and then press the ENTER key.

```azcopy
azcopy login
```

If you receive an error, try including the tenant ID of the organization to which the storage account belongs.

```azcopy
azcopy login --tenant-id=<tenant-id>
```

Replace the `<tenant-id>` placeholder with the tenant ID of the organization to which the storage account belongs. To find the tenant ID, select **Tenant properties > Tenant ID** in the Azure portal.

This command returns an authentication code and the URL of a website. Open the website, provide the code, and then choose the **Next** button.

![Create a container](media/storage-use-azcopy-v10/azcopy-login.png)

A sign-in window will appear. In that window, sign into your Azure account by using your Azure account credentials. After you've successfully signed in, you can close the browser window and begin using AzCopy.


## Next steps

- For more information about AzCopy, [Get started with AzCopy](storage-use-azcopy-v10.md)

- If you have questions, issues, or general feedback, submit them [on GitHub](https://github.com/Azure/azure-storage-azcopy) page.
