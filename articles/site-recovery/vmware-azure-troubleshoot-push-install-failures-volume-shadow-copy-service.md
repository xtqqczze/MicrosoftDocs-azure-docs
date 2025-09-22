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

# Troubleshoot Mobility service push installation

The Mobility service installation is a key step to enable replication. The success of this step depends on meeting prerequisites and working with supported configurations. The most common failures you might face during the Mobility service installation are due to:

* [Credential/Privilege errors](#credentials-check-errorid-95107--95108)
* [Login failures](#login-failures-errorid-95519-95520-95521-95522)
* [Connectivity errors](#connectivity-failure-errorid-95117--97118)
* [File and printer sharing errors](#file-and-printer-sharing-services-check-errorid-95105--95106)
* [Windows Management Instrumentation (WMI) failures](#windows-management-instrumentation-wmi-configuration-check-error-code-95103)
* [Unsupported operating systems](#unsupported-operating-systems)
* [Unsupported boot configurations](#unsupported-boot-disk-configurations-errorid-95309-95310-95311)
* [Volume Shadow copy Service (VSS) installation failures](#vss-installation-failures)
* [Device name in GRUB configuration instead of device UUID](#enable-protection-failed-as-device-name-mentioned-in-the-grub-configuration-instead-of-uuid-errorid-95320)

When you enable replication, Azure Site Recovery tries to install the Mobility service agent on your virtual machine (VM). As part of this process, the configuration server tries to connect with the virtual machine and copy the agent. To enable successful installation, follow the step-by-step troubleshooting guidance.

## Enable protection failed as device name mentioned in the GRUB configuration instead of UUID (ErrorID: 95320)

### Possible Cause

The Grand Unified Bootloader (GRUB) configuration files (_/boot/grub/menu.lst_, _/boot/grub/grub.cfg_, _/boot/grub2/grub.cfg_, or _/etc/default/grub_) may contain the value for the parameters **root** and **resume** as the actual device names instead of a universally unique identifier (UUID). Site Recovery mandates the UUID approach as the device names may change across reboot of the VM. For example, the VM may not come online with the same name on failover and that results in issues.

For example:

- The following line is from the GRUB file _/boot/grub2/grub.cfg_:

  `linux /boot/vmlinuz-3.12.49-11-default root=/dev/sda2  ${extra_cmdline} resume=/dev/sda1 splash=silent quiet showopts`

- The following line is from the GRUB file _/boot/grub/menu.lst_:

  `kernel /boot/vmlinuz-3.0.101-63-default root=/dev/sda2 resume=/dev/sda1 splash=silent crashkernel=256M-:128M showopts vga=0x314`

> [!NOTE]
> The GRUB lines contain actual device names for the parameters **root** and **resume** rather than the UUID.

### How to Fix

The device names should be replaced with the corresponding UUID.

1. Find the UUID of the device by executing the command `blkid \<device name>`.

   For example:

   ```shell
   blkid /dev/sda1
   /dev/sda1: UUID="6f614b44-433b-431b-9ca1-4dd2f6f74f6b" TYPE="swap"
   blkid /dev/sda2
   /dev/sda2: UUID="62927e85-f7ba-40bc-9993-cc1feeb191e4" TYPE="ext3"
   ```

1. Now replace the device name with its UUID in the format like `root=UUID=\<UUID>`. For example, if we replace the device names with UUID for root and resume parameter mentioned in the files _/boot/grub2/grub.cfg_, _/boot/grub2/grub.cfg_, or _/etc/default/grub_ then the lines in the files look like the following line:

   `kernel /boot/vmlinuz-3.0.101-63-default root=UUID=62927e85-f7ba-40bc-9993-cc1feeb191e4 resume=UUID=6f614b44-433b-431b-9ca1-4dd2f6f74f6b splash=silent crashkernel=256M-:128M showopts vga=0x314`

1. Restart the protection.

## Install Mobility service completed with warning to reboot (ErrorID: 95265 & 95266)

Site Recovery Mobility service has many components, one of which is called filter driver. The filter driver is loaded into system memory only during a system reboot. Filter driver fixes can only be realized when a new filter driver is loaded at the time of a system reboot.

> [!IMPORTANT]
> This is a warning and existing replication will work even after the new agent update. You can choose to reboot anytime you want to get the benefits of new filter driver but if you don't reboot, the old filter driver keeps on working. So, after an update without a reboot, except for the filter driver, **benefits of other enhancements and fixes in Mobility service get realized**. Although recommended, it isn't mandatory to reboot after every upgrade. For information about when a reboot is mandatory, set the [Reboot after Mobility service upgrade](service-updates-how-to.md#reboot-after-mobility-service-upgrade) section in Service updates in Azure Site Recovery.

> [!TIP]
>For best practices on scheduling upgrades during your maintenance window, see the [Support for latest operating system/kernel](service-updates-how-to.md#support-for-latest-operating-systemskernels) in Service updates in Azure Site Recovery.


## Next steps

[Learn more](vmware-azure-tutorial.md) about how to set up disaster recovery for VMware VMs.
