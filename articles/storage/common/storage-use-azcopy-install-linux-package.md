---
title: Install AzCopy v10 on Linux by using a package manager
description: You can install AzCopy by using a Linux package that is hosted on the Linux Software Repository for Microsoft Products.

author: normesta
ms.service: azure-storage
ms.topic: how-to
ms.date: 10/02/2025
ms.author: normesta
ms.subservice: storage-common-concepts
ms.custom: ai-video-demo
ai-usage: ai-assisted
# Customer intent: As a Linux system administrator or developer, I want to install AzCopy using my distribution's package manager, so that I can easily maintain and update the tool while ensuring proper system integration for Azure Storage operations.
---

# Install AzCopy on Linux by using a package manager

This article helps you install [AzCopy](storage-use-azcopy-v10.md) by using popular Linux package managers (dnf, apt, zypper). Once installed, you'll have AzCopy available system-wide and can easily keep it updated through your regular system maintenance routines.

For more detailed guidance on installing these packages, see [Linux Software Repository for Microsoft Products](/linux/packages).

### [dnf (RHEL)](#tab/dnf)

1. Download the repository configuration package.

   ```bash
   curl -sSL -O https://packages.microsoft.com/config/<distribution>/<version>/packages-microsoft-prod.rpm
   ```

   Replace the `<distribution>` and `<version>` placeholders in this command with the Linux distribution and version that you are running on your machine. See [packages.microsoft.com](https://packages.microsoft.com/) to find the list of supported Linux distributions and versions.

   For example, if you entered `cat /etc/os-release` and saw that Ubuntu, version 20.04, is running, your distribution would be `Ubuntu` and your version would be `20.04`. You would then open the [packages.microsoft.com](https://packages.microsoft.com/) page, select **ubuntu**, and then verify that **20.04** appears in the list. Then, you would use that distribution and version in your comment.

   ````bash
   curl -sSL -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.rpm
   ````

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

   ```bash
   curl -sSL -O https://packages.microsoft.com/config/<distribution>/<version>/packages-microsoft-prod.rpm
   ```

   Replace the `<distribution>` and `<version>` placeholders in this command with the Linux distribution and version that you are running on your machine. See [packages.microsoft.com](https://packages.microsoft.com/) to find the list of supported Linux distributions and versions.

   For example, if you entered `cat /etc/os-release` and saw that Ubuntu, version 20.04, is running, your distribution would be `Ubuntu` and your version would be `20.04`. You would then open the [packages.microsoft.com](https://packages.microsoft.com/) page, select **ubuntu**, and then verify that **20.04** appears in the list. Then, you would use that distribution and version in your comment.

   ````bash
   curl -sSL -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.rpm
   ````

1. Install the repository configuration package.

   ```bash
   sudo rpm -i packages-microsoft-prod.rpm
   ```

1. Delete the repository configuration package after you've installed it.

   ```bash
   rm packages-microsoft-prod.rpm
   ```

1. Update the package index files.

   ```bash
   sudo zypper --gpg-auto-import-keys refresh
   ```

1. Install AzCopy.

   ```bash
   sudo zypper install -y azcopy
   ```

### [apt (Ubuntu, Debian)](#tab/apt)

1. Download the repository configuration package.

   ```bash
   curl -sSL -O https://packages.microsoft.com/config/<distribution>/<version>/packages-microsoft-prod.deb
   ```

   Replace the `<distribution>` and `<version>` placeholders in this command with the Linux distribution and version that you are running on your machine. See [packages.microsoft.com](https://packages.microsoft.com/) to find the list of supported Linux distributions and versions.

   For example, if you entered `cat /etc/os-release` and saw that Ubuntu, version 20.04, is running, your distribution would be `Ubuntu` and your version would be `20.04`. You would then open the [packages.microsoft.com](https://packages.microsoft.com/) page, select **ubuntu**, and then verify that **20.04** appears in the list. Then, you would use that distribution and version in your comment.

   ````bash
   curl -sSL -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
   ````

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
