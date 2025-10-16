---
title: Plan and create new waves
description: Add the description
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

- **Distribute workloads into waves**: Group workloads and applications that share dependencies or business. This ensures they migrate together without breaking application functionality.
- **Sequence waves**: Prioritize waves based on factors such as business criticality, complexity, and migration impact.
- **Parallelize where safe:** Run independent waves in parallel to accelerate migration speed without introducing risk.

For more information on grouping and sequencing, see, [Azure Cloud Adoption Framework – Migration Wave Planning](https://learn.microsoft.com/azure/cloud-adoption-framework/migrate/migration-wave-planning.)

## Create Waves using Azure Portal

To create Migration Waves manually using Azure Migrate portal, follow these steps:

1. Select your project from **All Projects** in Azure portal.

<Image 3.1 - Project Listing Page>

1. In **Overview** pane, select **Create Wave**

<Image 3.2 - Project Overview>

1. Enter a unique name in **Wave name** for execution and tracking purposes.
1. Enter the planned start date for the wave migration in **Planned start date**.
1. *Optional* Select an **Assessment** to get recommendations on the Azure targets and workload configurations. Use an assessment to accelerate wave planning.  
1. Select the **Migration path** of the assessment based on your business strategy. If the assessment includes only single path, this option isn't available.

<Image 3.3 - Wave create screen>

1. Review, add, and remove workloads and applications that you want to include in the wave. You can use filters to refine the selection.  
    If you select an assessment, the workloads and applications are limited to the scope of that assessment. You can add more workloads and applications later.

<Image 3.3 - Compelted Wave create screen>

1. After you finalized the wave components, select **Create Wave**

In a few seconds, Azure Migrate creates the wave project. To view it, select **View Waves** in the Project overview.

The created wave includes the workloads and applications you selected. If you selected an assessment, the workloads and applications default to the migration targets and configurations defined in that assessment.

## Next steps
