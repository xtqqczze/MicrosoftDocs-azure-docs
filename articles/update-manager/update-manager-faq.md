---
title: Azure Update Manager FAQ
description: This article gives answers to frequently asked questions about Azure Update Manager.
ms.service: azure-update-manager
ms.custom:
  - ignite-2024
ms.topic: faq
ms.date: 04/16/2025
author: habibaum
ms.author: v-uhabiba
# Customer intent: As an IT administrator who manages updates across various environments, I want to find answers to frequently asked questions about Azure Update Manager so that I can effectively use its features for patch management and ensure compliance across my systems.
---

# Azure Update Manager frequently asked questions

This article answers commonly asked questions about Azure Update Manager. If you have any other questions about the service's capabilities, go to the [discussion forum](https://feedback.azure.com/d365community/forum/721a322e-bd25-ec11-b6e6-000d3a4f0f1c) and post them. When a question is frequently asked, we add it to this article so that customers can find the answer quickly and easily.

## Fundamentals

### What are the benefits of using Update Manager?

Update Manager provides a software as a service (SaaS) solution to manage and govern software updates to Windows and Linux machines across Azure, on-premises, and multiple-cloud environments.

Following are the benefits of using Update Manager:

- Oversee update compliance for your entire fleet of machines in Azure (Azure VMs), on premises, and multiple-cloud environments (Azure Arc-enabled Servers).
- View and deploy pending updates to secure your machines [instantly](updates-maintenance-schedules.md#update-nowone-time-update).
- Manage [extended security updates (ESUs)](/azure/azure-arc/servers/prepare-extended-security-updates) for your Azure Arc-enabled Windows Server 2012/2012 R2 machines. Get consistent experience for deployment of ESUs and other updates.
- Define recurring time windows during which your machines receive updates and might undergo reboots using [scheduled patching](scheduled-patching.md). Enforce machines grouped together based on standard Azure constructs (Subscriptions, Location, Resource Group, Tags etc.) to have common patch schedules using [dynamic scoping](dynamic-scope-overview.md). Sync patch schedules for Windows machines in relation to patch Tuesday, the unofficial term for month.
- Enable incremental rollout of updates to Azure VMs in off-peak hours using [automatic VM guest patching](/azure/virtual-machines/automatic-vm-guest-patching) and reduce reboots by enabling [hotpatching](updates-maintenance-schedules.md#hotpatching).
- [assess](assessment-options.md#periodic-assessment) automatically the machines for pending updates every 24 hours, and flag machines that are out of compliance. Enforce enabling periodic assessments on multiple machines at scale using [Azure Policy](periodic-assessment-at-scale.md).
- Create [custom reports](workbooks.md) for deeper understanding of the updates data of the environment.
- Granular access management to Azure resources with Azure roles and identity, to control who can perform update operations and edit schedules.

### How does the new Update Manager work on machines?

Whenever you trigger any Update Manager operation on your machine, it pushes an extension on your machine. It interacts with the VM agent (for Azure machine) or Azure Arc agent (for Azure Arc-enabled machines) to fetch and install updates.

### Is enabling Azure Arc mandatory for patch management for machines not running on Azure?

Yes, machines that aren't running on Azure must be enabled for Azure Arc, for management using Update Manager.

### Is the new Update Manager dependent on Azure Automation and Log Analytics?

No, it's a native capability on a virtual machine.

### Where is updates data stored in Update Manager?

All Update Manager data is stored in Azure Resource Graph (ARG). Custom reports can be generated on the updates data for deeper understanding and patterns using Azure Workbooks [Learn more](query-logs.md).

### Are there programmatic ways to interact with Update Manager?

Yes, Update Manager supports REST API, CLI, and PowerShell for [Azure machines](manage-vms-programmatically.md) and [Azure Arc-enabled machines](manage-arc-enabled-servers-programmatically.md).

### Do I need MMA or AMA for using Update Manager to manage my machines?

No, it's a native capability on a virtual machine and doesn't rely either on MMA or AMA.

### Which operating systems are supported by Update Manager?

For more information, see [Update Manager OS support](support-matrix.md).

### Does Update Manager support Windows 10, 11?

Automation Update Management didn't provide support for patching Windows 10 and 11. The same is true for Update Manager. We recommend that you use Microsoft Intune as the solution for keeping Windows 10 and 11 devices up to date.

## Pricing

### What is the pricing for Update Manager?

Update Manager is available at no extra charge for managing Azure VMs and [Azure Arc-enabled Azure Local VMs](/azure/azure-local/manage/azure-arc-vm-management-overview) (must be created through Azure Arc Resource Bridge on Azure Local). For all other Azure Arc-enabled servers, the price is $5 per server per month (assuming 31 days of usage).

### How is Update Manager price calculated for Azure Arc-enabled servers?

For Azure Arc-enabled servers, Update Manager is charged $5/server/month (assuming 31 days of connected usage). It's charged at a daily prorated value of 0.16/server/day. An Azure Arc-enabled machine would only be charged for the days when it's connected and managed by Update Manager.

### When is an Azure Arc-enabled server considered managed by Update Manager?

An Azure Arc-enabled server is considered managed by Update Manager for days on which the machine fulfills **both** the following conditions:

- *Connected* status for Azure Arc at any time during the day.
- An update operation (patched on demand or through a scheduled job, assessed on demand or through periodic assessment) is triggered on it, or it's associated with a schedule.

### Are there scenarios in which Azure Arc-enabled server isn't charged for Update Manager?

An Azure Arc-enabled server managed with Update Manager isn't charged in following scenarios:

- If the machine is enabled for delivery of Extended Security Updates (ESUs) enabled by Azure Arc.
- Microsoft Defender for Servers Plan 2 is enabled for the subscription hosting the Azure Arc-enabled server. However, if customer is using Defender using Security connector, they'll be charged.
- Windows Server licenses that have active Software Assurances or Windows Server licenses that are active subscription licenses, and Windows Server pay-as-you-go enabled by Azure Arc. For more information, see [Windows Server Management enabled by Azure Arc](/azure/azure-arc/servers/windows-server-management-overview).

### Will I be charged if I move from Automation Update Management to Update Manager?

Customers won't be charged for already existing Azure Arc-enabled servers which were using Automation Update Management for free as of September 1, 2023. Any new Azure Arc-enabled machines which are onboarded to Update Manager in the same subscription will also be exempted from charge. This exception is provided till LA agent retires. Post that date, these customers are charged.

### I'm a Defender for Server customer and use update recommendations powered by Update Manager namely "periodic assessment should be enabled on your machines" and "system updates should be installed on your machines". Would I be charged for Update Manager?

If you have purchased a Defender for Servers Plan 2, then you won't have to pay to remediate the unhealthy resources for the above two recommendations. But if you're using any other Defender for server plan for your Azure Arc machines, then you would be charged for those machines at the daily prorated $0.16/server by Update Manager.

### Is Update Manager chargeable on Azure Local?

Update Manager isn't charged for:

- Management of Azure Local instances via **Azure Local** and [Update Manager on Azure Local](/azure/azure-local/update/azure-update-manager-23h2)
- [Azure Arc-enabled Azure Local VMs](/azure/azure-local/manage/azure-arc-vm-management-overview) created via the Azure Arc Resource Bridge. For example *Machine-Azure Arc (Azure Local)* resource.

All other resources including, but not limited to the following will be charged.

- Management of individual Azure Local machines. For example, *Machine - Azure Arc* resource or *Update Manager - Machines*.
- All VMs on Azure Local that is not created by Azure Arc resource bridge - VMs projected as Azure Arc-enabled servers and/or VMs on Azure Local managed by Azure Arc-enabled System Center Virtual Machine Manager.

### Is there any additional cost associated with Update Manager for any data transfers?

No, there is no extra cost for data transfer when using Update Manager for patch management operations.

## Support and integration

### Does Update Manager support integration with Azure Lighthouse?

Update Manager doesn't currently support Azure Lighthouse integration.

### Does Update Manager support Azure Policy?

Yes, Update Manager supports update features via policies. For more information, see [how to enable periodic assessment at scale using policy](periodic-assessment-at-scale.md) and [how to enable schedules on your machines at scale using Azure Policy](scheduled-patching.md#onboard-to-schedule-by-using-azure-policy).

### I have machines across multiple subscriptions in Automation Update Management. Is this scenario supported in Update Manager?

Yes, Update Manager supports multi-subscription scenarios.

### Is there guidance available to move VMs and schedules from SCCM to Update Manager?

Customers can follow this [guide](guidance-migration-azure.md) to move update configurations from SCCM to Update Manager.

## Miscellaneous

### Can I configure my machines to fetch updates from WSUS (Windows) and private repository (Linux)?

By default, Update Manager relies on Windows Update (WU) client running on your machine to fetch updates. You can configure WU client to fetch updates from Microsoft Update/WSUS repository and manage patch schedules using Update Manager.

Similarly for Linux, you can fetch updates by pointing your machine to a public repository or clone a private repository that regularly pulls updates from the upstream.

Update Manager honors machine settings and installs updates accordingly.

### Does Update Manager store customer data?

Update Manager doesn't move or store customer data out of the region it's deployed in.

## Related content

- [What is Azure Update Manager?](overview.md)
- [What's new in Azure Update Manager](whats-new.md)
