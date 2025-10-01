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
# Customer intent: As a Linux system administrator or developer, I want to install AzCopy using my distribution's package manager, so that I can easily maintain and update the tool while ensuring proper system integration for Azure Storage operations.
---

# Install AzCopy on Linux by using a package manager

Installing AzCopy through your Linux distribution's package manager provides the most convenient and maintainable way to get this tool. Package manager installation offers several advantages over manual downloads, including automatic dependency resolution, simplified updates, and integration with your system's software management.

This article walks you through installing AzCopy using popular Linux package managers (dnf, apt, zypper) via packages hosted on the [Linux Software Repository for Microsoft Products](/linux/packages). Once installed, you'll have AzCopy available system-wide and can easily keep it updated through your regular system maintenance routines.

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
