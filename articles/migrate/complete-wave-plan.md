---
title: High-Fidelity Azure Migration Planning for Modernization
description: Learn how to plan Azure migrations with high fidelity. Identify targets, tools, tasks, and prerequisites to ensure predictable modernization without delays.
author: shubhamJain1992
ms.author: shuj
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: concept-article
ms.date: 10/15/2025
# Customer intent: Understand concepts such as migration targets, prerequisites, and wave planning. Also, plan and execute a predictable migration and modernization process using Azure Migrate.
---

# High-fidelity migration planning for predictable modernization (changed the heading)

Creating a high-fidelity plan including all the migration details is essential for ensuring predictable migration and modernization without deviations and plans and outcomes. The primary details include:

1. Azure services for hosting my applications and workloads.
1. Tools and the approach required for migration and modernization.
1. Activities to be performed during migration and modernization.
1.  Timeline and prerequisites to prepare for migration.

## Assess Azure migration targets before moving workloads - (Changed the heading)

Before migrating workloads and applications, you should identify the Azure destination and determine the appropriate method for moving them. The assessment provides recommendations and details about migration targets in Azure.

>[!Note]
> At present, the assessment link suggests an Azure target for every workload, but specific configurations, such as storage or compute SKUs are only available for integrated server migrations.

To review and update these settings in Azure Migrate's Wave planning, follow these steps:

1. Go to Azure Targets page and select **Configure** in the **Target Settings** tile.

**<Image 4.1 -Overview with target settings click >**

1. For applications
    1. In **Target Setting** select **Link assessment** to review the link assessment. You can change assessment or link if none is currently linked.  

        Linking an assessment to the application links the assessment to all workloads for that application across waves and reset the tasks.  

**<Image 4.2 - application target settings>**

   1. Select **Add tasks** to add tasks you need to perform as part of migration beyond the workload migrations. These tasks are manual, so you can add, update and track manually.

**<Image 4.3 - Application tasks view>**   

1. For workloads
    1. Select **Configure target** to review and configure the Azure target. The system sets target by default when you select an assessment. 
    1. Select **None** for workloads that are planned for retirement and not to be migrated.
    1. Select the tool in **Migration tool** dropdown to define the migration path and tasks. 
    1. Select **Other** for workloads that you want to migrate outside Azure Migrate.
   
**<Image 4.4 - workload target setings - configure targets**      
 
    1. Select **Save configuration**.
    1. Review and add tasks using **Add tasks** that need to be performed and tracked for migrations.
    1. Select **Save tasks** to save.
    
Refer to the FAQ to learn about the supported tools and targets for the execute phase of migration and modernization [TBD].

## Prepare your Wave for migration: Key prerequisites (heading changed)

Azure Migrate identifies the prerequisites you need to complete before starting migration, based on the migration targets, tools, and tasks you define. To review and add additional prerequisites for tracking and to make the wave ready for migration, do the following:

1. Select **View details** in the Wave settings tile.  

**<Image 4.5 - Wave settings >**  

1. Review the pre-requisites and select **Add Task**  

**<Image 4.6 - Add tasks in Waves settins>**  

1. Provide a description name of the task and **Description** about the task.
1. Select **Add**, and then select **Save changes** to save the tasks as a pre-requisite.

The tasks appear in the Wave configuration stage of the migration and modernization journey. Complete these tasks before the Wave is ready for execution.

After you identify all tasks and activities, review and update the planned start and end dates for the migration in the Wave Settings page.

After you identify the migration and modernization activities, configure the target settings, and complete the prerequisites, the wave transitions to the Ready for Execution stage.

**<Image 4.7 Wave Ready for Execution>>**  

You can perform the wave planning for multiple waves in a similar way.

## Next steps

Add next steps