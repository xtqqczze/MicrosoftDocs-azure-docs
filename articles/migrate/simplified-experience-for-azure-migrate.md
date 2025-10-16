---
title: Simplified experience for Azure Migrate
description: Describes the simplified experience an upgraded agent-based migration stack for physical and VMware environments
author: dhananjayanr98
ms.author: dhananjayanr
ms.manager: dhananjayanr
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: how-to
ms.date: 09/22/2025
# Customer intent: As a system administrator managing physical and VMware environments, I want to utilize an upgraded agent-based migration stack so that I can efficiently migrate newer Linux distributions and ensure a seamless migration process to Azure.
---

# Overview of simplified experience for Azure Migrate (agent-based VMware or physical servers)

The simplified experience leverages an enhanced agent-based migration stack tailored for physical and VMware environments, offering several key advantages:
- **Broader OS support**: It enables migration of newer Linux distributions to Azure, expanding compatibility and allowing customers to benefit from the latest innovations in Linux technology.
- **Modern replication appliance**: It utilizes Windows Server 2022 (WS2022) for the replication appliance, ensuring robust and up-to-date infrastructure.
- **Unified OS support matrix**: This provides a consistent and streamlined approach to operating system support across migration workflows, simplifying planning and execution.
  
Overall, the upgraded stack equips customers with powerful tools to efficiently migrate newer Linux distributions, leverage modern Windows Server platform for replication, and benefit from a unified OS support framework, enhancing the entire migration journey to Azure.

## Key differences between classic and simplified experience

The key differences between the Classic and Simplified experience:

| **Aspect** | **Classic experience** | **Simplified experience** |
| --- | --- | --- | 
| Upgrade and replacement | Old version with traditional interface | Upgraded version offering a more streamlined and user-friendly interface
| Enhanced support matrix | Limited support for newer Linux distributions | Supports newer Linux distributions and uses Windows Server 2022 as the replication appliance|
| Easier Onboarding| Extensive number of steps and input for onboarding and setup | Easier onboarding of workloads with 50% fewer configuration steps|
| Automatic updates| Manual upgrades should be performed for both mobility agent and configuration server components| Automatic upgrades are available for both mobility agent and replication appliance|
| Improved performance and reliability | Standard performance and reliability | Leveraging latest technologies for better performance and reliability in physical and VMware agent-based migrations. |
|Streamlined migration process| Traditional migration process	 | Provides a more seamless and efficient migration process, addressing multiple customer concerns. |
| Retirement of classic experience | Existing replication and migrations will be supported until **30 September 2026**. Plan your final migrations for these machines well ahead of the retirement date| Make the switch sooner to gain the richer benefits of simplified experience |

## Retirement of classic experience
**Action required**
- Classic experience is scheduled for retirement on **30 September 2026**. Your existing replications and migrations will be supported till the retirement date. We encourage you to make the switch sooner to gain the richer benefits of simplified experience.
- Existing VMware and physical machines can continue using the classic experience until **September 30, 2026**. Plan your final migrations for these machines before the retirement date. **After September 2026**, continuing replications and triggering migrations will require a move to the new simplified experience.
- You won’t be able to view, manage, or perform replication & migration related operations on these machines through the Azure portal after this retirement date.
- New features, Security updates and enhancements, and mobility agent support for additional Linux distributions will only be made available in the simplified experience.
    
## Next steps

- Learn more about setting up the [Simplified experience](tutorial-migrate-physical-virtual-machines.md#simplified-experience-recommended).
  
