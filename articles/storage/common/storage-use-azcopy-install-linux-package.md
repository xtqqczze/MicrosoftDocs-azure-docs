---
title: Install AzCopy v10 on Linux by using a package manager
description: You can install AzCopy by using a Linux package that is hosted on the Linux Software Repository for Microsoft Products.

author: normesta
ms.service: azure-storage
ms.topic: how-to
ms.date: 09/01/2025
ms.author: normesta
ms.subservice: storage-common-concepts
ms.custom: ai-video-demo
ai-usage: ai-assisted
# Customer intent: As a cloud administrator, I want to use AzCopy to transfer data to and from Azure Storage, so that I can efficiently manage storage operations across my cloud environment.
---

# Install AzCopy on Linux by using a package manager

AzCopy is a command-line utility that you can use to copy blobs or files to or from a storage account. This article helps you download AzCopy, connect to your storage account, and then transfer data.

You can install AzCopy by using a Linux package that is hosted on the [Linux Software Repository for Microsoft Products](/linux/packages).

### [dnf (RHEL)](#tab/dnf)

1. Download the repository configuration package.

   > [!IMPORTANT]
   > Make sure to replace the distribution and version with the appropriate strings.

   ```bash
   curl -sSL -O https://packages.microsoft.com/config/<distribution>/<version>/packages-microsoft-prod.rpm
   ```

2. Install the repository configuration package.

   ```bash
   sudo rpm -i packages-microsoft-prod.rpm
   ````

3. Delete the repository configuration package after you've installed it.

   ```bash
   rm packages-microsoft-prod.rpm
   ````

4. Update the package index files.

   ```bash
   sudo dnf update
   ```
5. Install AzCopy.

   ```bash
   sudo dnf install azcopy
   ```


### [zypper (openSUSE, SLES)](#tab/zypper)

1. Download the repository configuration package.

   > [!IMPORTANT]
   > Make sure to replace the distribution and version with the appropriate strings.

   ```bash
   curl -sSL -O https://packages.microsoft.com/config/<distribution>/<version>/packages-microsoft-prod.rpm
   ```

2. Install the repository configuration package.

   ```bash
   sudo rpm -i packages-microsoft-prod.rpm
   ```

3. Delete the repository configuration package after you've installed it.

   ```bash
   rm packages-microsoft-prod.rpm
   ```

4. Update the package index files.

   ```bash
   sudo zypper --gpg-auto-import-keys refresh
   ```
   
5. Install AzCopy.
   
   ```bash
   sudo zypper install -y azcopy
   ```

### [apt (Ubuntu, Debian)](#tab/apt)

1. Download the repository configuration package.

   > [!IMPORTANT]
   > Make sure to replace the distribution and version with the appropriate strings.

   ```bash
   curl -sSL -O https://packages.microsoft.com/config/<distribution>/<version>/packages-microsoft-prod.deb
   ```

2. Install the repository configuration package.
   
   ```bash
   sudo dpkg -i packages-microsoft-prod.deb
   ```

3. Delete the repository configuration package after you've installed it.

   ```bash
   rm packages-microsoft-prod.deb
   ```

4. Update the package index files.

   ```bash
   sudo apt-get update
   ```

5. Install AzCopy.
   
   ```bash
   sudo apt-get install azcopy
   ```

# [tdnf (Azure Linux)](#tab/tdnf)

Install AzCopy.

```bash
sudo tdnf install azcopy
```

---

## Next steps

If you have questions, issues, or general feedback, submit them [on GitHub](https://github.com/Azure/azure-storage-azcopy) page.
