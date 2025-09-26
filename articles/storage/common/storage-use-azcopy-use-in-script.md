---
title: Use AzCopy v10 in a script
description: Learn how to obtain a static link to a specific AzCopy version and use that link in your scripts.
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

# Use AzCopy v10 in a script

Over time, the AzCopy [download link](#download-and-install-azcopy) will point to new versions of AzCopy. If your script downloads AzCopy, the script might stop working if a newer version of AzCopy modifies features that your script depends upon.

To avoid these issues, obtain a static (unchanging) link to the current version of AzCopy. That way, your script downloads the same exact version of AzCopy each time that it runs.

> [!NOTE]
> The static link to AzCopy binaries is subject to change over time due to our content delivery infrastructure. If you must use a specific version of AzCopy for any reason, we recommend using AzCopy with an operating system that leverages a [published package](#install-azcopy-on-linux-by-using-a-package-manager). This method ensures that you can reliably install and maintain the desired version of AzCopy.

## Obtain a static download link

To obtain the link, run this command:

| Operating system  | Command |
|--------|-----------|
| **Linux** | `curl -s -D- https://aka.ms/downloadazcopy-v10-linux \| grep ^Location` |
| **Windows PowerShell** | `(Invoke-WebRequest -Uri https://aka.ms/downloadazcopy-v10-windows -MaximumRedirection 0 -ErrorAction SilentlyContinue).headers.location` |
| **PowerShell 6.1+** | `(Invoke-WebRequest -Uri https://aka.ms/downloadazcopy-v10-windows -MaximumRedirection 0 -ErrorAction SilentlyContinue -SkipHttpErrorCheck).headers.location` |

> [!NOTE]
> For Linux, `--strip-components=1` on the `tar` command removes the top-level folder that contains the version name, and instead extracts the binary directly into the current folder. This allows the script to be updated with a new version of `azcopy` by only updating the `wget` URL.

The URL appears in the output of this command. Your script can then download AzCopy by using that URL.

**Linux**
```bash
wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy_v10.tar.gz --strip-components=1
```
**Windows PowerShell** 
```PowerShell
Invoke-WebRequest -Uri <URL from the previous command> -OutFile 'azcopyv10.zip'
Expand-archive -Path '.\azcopyv10.zip' -Destinationpath '.\'
$AzCopy = (Get-ChildItem -path '.\' -Recurse -File -Filter 'azcopy.exe').FullName
# Invoke AzCopy 
& $AzCopy
```
**PowerShell 6.1+**
```PowerShell
Invoke-WebRequest -Uri <URL from the previous command> -OutFile 'azcopyv10.zip'
$AzCopy = (Expand-archive -Path '.\azcopyv10.zip' -Destinationpath '.\' -PassThru | where-object {$_.Name -eq 'azcopy.exe'}).FullName
# Invoke AzCopy
& $AzCopy
``` 

### Escape special characters in SAS tokens

In batch files that have the `.cmd` extension, you'll have to escape the `%` characters that appear in SAS tokens. You can do that by adding an extra `%` character next to existing `%` characters in the SAS token string. The resulting character sequence appears as `%%`. Make sure to add an extra `^` before each `&` character to create the character sequence `^&`.

### Run scripts by using Jenkins

If you plan to use [Jenkins](https://jenkins.io/) to run scripts, make sure to place the following command at the beginning of the script.

```
/usr/bin/keyctl new_session
```

## Next steps

If you have questions, issues, or general feedback, submit them [on GitHub](https://github.com/Azure/azure-storage-azcopy) page.
