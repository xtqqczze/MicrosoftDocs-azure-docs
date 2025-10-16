---
title: Plan and create new waves
description: Learn how to plan Azure migrations with high fidelity. Identify targets, tools, tasks, and prerequisites to ensure predictable modernization without delays.
author: shubhamJain1992
ms.author: shuj
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: concept-article
ms.date: 10/15/2025
# Customer intent: Understand concepts such as migration targets, prerequisites, and wave planning. Also, plan and execute a predictable migration and modernization process using Azure Migrate.
---

# Create migration Waves in Azure Migrate for efficient planning (heading changed)

To create migration waves, group your applicaitons and workloads into logical sets that you can migrated together. These groups called **waves** help you execute migrations in smaller, manageable batches, reduce risk and improving efficiency. The key planning actions include:

*   **Distribute workloads into waves:** Group workloads and applications that share dependencies or business context so they can be migrated together without breaking application functionality.
*   **Sequence waves:** Prioritize waves based on factors such as business criticality, complexity, and migration impact.
*   **Parallelize where safe:** Run independent waves in parallel to accelerate migration velocity without introducing risk.

For detailed guidance on grouping and sequencing, refer to [Azure Cloud Adoption Framework – Migration Wave Planning](https://learn.microsoft.com/azure/cloud-adoption-framework/migrate/migration-wave-planning.)

## Create Waves using Azure Portal

To create Migration Waves manually using Azure Migrate portal, follow these steps:

1. Select your project from All Projects in Azure Migrate page in Azure portal.

<Image 3.1 - Project Listing Page>

2. In the overview page, select **Create Wave**

<Image 3.2 - Project Overview>

3. Specify a unique name of the wave that shall be used execution and tracking purposes in **Wave name**.

4.  Specify the time when you plan to start the migration of the wave as the **Planned start date.**
5.  \[Optional\] Select the **Assessment** for the recommendations on the Azure targets and workload configurations. It is recommended that you use an assessment for accelerated wave planning.  
 Select the **Migration path** of the assessment based on your business strategy. The option would not be available if there is only single path in the assessment.

<Image 3.3 - Wave create screen>

7.  Review, add and remove workloads and applications that need to be part of the wave. You can use filters for selection.  
    If you have selected an assessment the workloads and applications would be limited to the scope of the assessment. You can add more workloads and applications later.

<Image 3.3 - Compelted Wave create screen>

8. Once you have finalized the constituents of the wave, click on **Create Wave**

After few seconds the wave will be created in Azure Migrate project and you can view them by clicking on the **View Waves** in the Project overview. The created wave would contain the selected workloads and applications. If an assessment is selected, the workloads and applications would be defaulted to the migration targets and configurations as per the assessments.
