---
title: Troubleshoot Mobility Service push installation with Azure Site Recovery
description: Troubleshoot Mobility Services installation errors when enabling replication for disaster recovery with Azure Site Recovery.
author: jyothisuri
ms.service: azure-site-recovery
ms.topic: troubleshooting
ms.author: jsuri
ms.date: 09/22/2025
ms.custom: sfi-image-nochange
# Customer intent: "As a system administrator, I want to troubleshoot and resolve Mobility service installation errors during disaster recovery setup, so that I can ensure successful replication and recovery of virtual machines."
---

# Troubleshoot Mobility service push installation - Logical Volume Manager (LVM) volume and Reboot warnings

The Mobility service installation is a key step to enable replication. The success of this step depends on meeting prerequisites and working with supported configurations. 

When you enable replication, Azure Site Recovery tries to install the Mobility service agent on your virtual machine (VM). As part of this process, the configuration server tries to connect with the virtual machine and copy the agent. To enable successful installation, follow the step-by-step troubleshooting guidance.

## LVM support from 9.20 version

Before the 9.20 version, Logical Volume Manager (LVM) was supported for data disks only. The `/boot` partition should be on a disk partition and not an LVM volume.

Beginning with the [9.20 version](https://support.microsoft.com/help/4478871/update-rollup-31-for-azure-site-recovery), the [OS disk on LVM](vmware-physical-azure-support-matrix.md#linux-file-systemsguest-storage) is supported.

## Insufficient space (ErrorID: 95524)

When the Mobility agent is copied to the source machine, at least 100 MB free space is required. Ensure that your source machine has the required amount of free space and retry the operation.

## Low system resources

The possible Error IDs seen for this issue are 95572 and 95573. This issue occurs when the system has low available memory, and is not able to allocate memory for mobility service installation. Ensure that enough memory has been freed up for the installation to proceed and complete successfully.

## VSS Installation failures

The Volume Shadow copy Service (VSS) installation is a part of Mobility agent installation. This service is used in the process to generate application consistent recovery points. Failures during VSS installation can occur due to multiple reasons. To identify the exact errors, refer to _C:\ProgramData\ASRSetupLogs\ASRUnifiedAgentInstaller.log_. Some of the common errors and the resolution steps are highlighted in the following section.

### VSS error -2147023170 [0x800706BE] - exit code 511

This issue is most often seen when antivirus software is blocking the operations of Azure Site Recovery services.

To resolve this issue:

1. Review the list of [folder exclusions from Antivirus program](vmware-azure-set-up-source.md#azure-site-recovery-folder-exclusions-from-antivirus-program).
1. Follow the guidelines published by your antivirus provider to unblock the registration of DLL in Windows.

### VSS error 7 [0x7] - exit code 511

This error is a runtime error that's caused because there's insufficient memory to install VSS. Increase the disk space for successful completion of this operation.

### VSS error -2147023824 [0x80070430] - exit code 517

This error occurs when Azure Site Recovery VSS Provider service is [marked for deletion](/previous-versions/ms838153(v=msdn.10)). Try to install VSS manually on the source machine by running the following command:

`"C:\Program Files (x86)\Microsoft Azure Site Recovery\agent\InMageVSSProvider_Install.cmd"`

### VSS error -2147023841 [0x8007041F] - exit code 512

This error occurs when Azure Site Recovery VSS Provider service database is [locked](/previous-versions/ms833798(v=msdn.10)).Try to install VSS manually on the source machine by running the following command from a command prompt:

`"C:\Program Files (x86)\Microsoft Azure Site Recovery\agent\InMageVSSProvider_Install.cmd"`

When there's a failure, check if any antivirus program or other services are stuck in a **Starting** state. A process in a **Starting** state can retain the lock on database services. It will lead to failures in installing VSS provider. Ensure that no service is in a **Starting** state and then retry the above operation.

### VSS exit code 806

This error occurs when the user account used for installation doesn't have permissions to execute the `CSScript` command. Provide necessary permissions to the user account to execute the script and retry the operation.

### Other VSS errors

Try to install VSS provider service manually on the source machine by running the following command from a command prompt:

`"C:\Program Files (x86)\Microsoft Azure Site Recovery\agent\InMageVSSProvider_Install.cmd"`

## VSS error - 0x8004E00F

This error typically occurs during the installation of the Mobility agent because of issues in `DCOM` and `DCOM` is in a critical state.

Use the following procedure to determine the cause of the error.

### Examine the installation logs

1. Open the installation log located at _C:\ProgramData\ASRSetupLogs\ASRUnifiedAgentInstaller.log_.
2. The presence of the following error indicates this issue:

    ```Output
    Unregistering the existing application...
    Create the catalogue object
    Get the collection of Applications

    ERROR:

    - Error code: -2147164145 [0x8004E00F]
    - Exit code: 802
    ```

To resolve the issue:

Contact the [Microsoft Windows platform team](https://aka.ms/Windows_Support) to obtain assistance with resolving the DCOM issue.

When the DCOM issue is resolved, reinstall the Azure Site Recovery VSS Provider manually using the following command from a command prompt:

`"C:\Program Files (x86)\Microsoft Azure Site Recovery\agent\InMageVSSProvider_Install.cmd"`

If application consistency isn't critical for your disaster recovery requirements, you can bypass the VSS Provider installation.

To bypass the Azure Site Recovery VSS Provider installation and manually install Azure Site Recovery VSS Provider post installation:

1. Install the Mobility service. The Installation will fail at the step: **Post install configuration**.
1. To bypass the VSS installation:
   1. Open the Azure Site Recovery Mobility Service installation directory located at:

      _C:\Program Files (x86)\Microsoft Azure Site Recovery\agent_

   1. Modify the Azure Site Recovery VSS Provider installation scripts _InMageVSSProvider_Install_ and _InMageVSSProvider_Uninstall.cmd_ to always succeed by adding the following lines:

      ```plaintext
      rem @echo off
      setlocal
      exit /B 0
      ```

1. Do a manual installation of the Mobility Agent.
1. When the installation succeeds and moves to the next step, **Configure**, remove the lines you added.
1. To install the VSS provider, open a command prompt as administrator and run the following command:

   `"C:\Program Files (x86)\Microsoft Azure Site Recovery\agent\InMageVSSProvider_Install.cmd"`

1. Verify that the Azure Site Recovery VSS Provider is installed as a service in Windows Services. Open the Component Service MMC to confirm that the VSS Provider is listed.
1. If the VSS Provider install continues to fail, work with technical support to resolve the permissions errors in Cryptographic Application Programming Interface (CAPI2).

## VSS Provider installation fails because the cluster service being enabled on non-cluster machine

This issue causes the Azure Site Recovery Mobility Agent installation to fail during the Azure Site Recovery VSS Provider installation. The failure is because there's an issue with `COM+` that prevents the VSS provider installation.

### To identify the issue

In the log located on configuration server at _C:\ProgramData\ASRSetupLogs\UploadedLogs\<date-time>UA_InstallLogFile.log_ you'll find the following exception:

```plaintext
COM+ was unable to talk to the Microsoft Distributed Transaction Coordinator (Exception from HRESULT: 0x8004E00F)
```

To resolve the issue:

1. Verify that this machine is a non-cluster machine and that the cluster components aren't being used.
1. If the components aren't being used, remove the cluster components from the machine.

## Drivers are missing on the source server

If the Mobility Agent installation fails, examine the logs under _C:\ProgramData\ASRSetupLogs_ to determine if some of the required drivers are missing in some control sets.

To resolve the issue:

1. Using a registry editor such as `regedit.msc`, open the registry.
1. Open the `HKEY_LOCAL_MACHINE\SYSTEM` node.
1. In the `SYSTEM` node, locate the control sets.
1. Open each control set and verify that following Windows drivers are present:

   * Atapi
   * Vmbus
   * Storflt
   * Storvsc
   * Intelide

1. Reinstall any missing drivers.

## Next steps

[Learn more](vmware-azure-tutorial.md) about how to set up disaster recovery for VMware VMs.
