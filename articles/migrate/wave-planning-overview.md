---
title: Wave Planning Overview
description: Learn how Azure Migrate – Wave Planning simplifies cloud migration and modernization. Break large projects into manageable waves, reduce risks, and improve execution with structured planning and continuous feedback.
author: shubhamJain1992
ms.author: shuj
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: concept-article
ms.date: 10/15/2025
# Customer intent: Customers want to leverage Azure Migrate’s Wave Planning to simplify large-scale cloud migrations. They’re looking for a structured way to break down complex projects, reduce risks, maintain business continuity, and track progress using integrated planning and execution tools.
---

# Wave Planning overview in Azure Migrate (Preview)

Wave Planning is a structured approach to cloud migration and modernization, enabling organization to divide large migration projects into manageable groups of workloads or applications. Each wave is a logical group that you can plan, execute and track the migrations and modernizations together.

Azure Migrate – Wave Planning helps cloud architects and migration leads to:
- Accelerate migration and modernization by focusing on smaller and achievable batches and sequencing them logically.
- Reduce migration uncertainty by breaking a large migrations into manageable phases and increasing the fidelity of the execution plan
- Minimize risks and disruptions by grouping dependent systems and enabling iterative planning
- Improves business continuity and migration fidelity through continuous monitoring and feedback.

Add Image 1.1 - Wave Planning Overview

## Azure Migrate – Wave Planning

Wave Planning is a capability in Azure migration that enables end-to-end migration and modernization of all applications running in your infrastructure.

### Key features 

Wave Planning offers a structured set of capabilities to simplify and manage the end-to-end migration and modernization of applications and infrastructure.

- Distribute the applications or the underlying infrastructure such as servers and workloads (servers, databases, web apps) discovered through Azure Migrate into waves.
- Create a high-fidelity migration plan for each wave from their source (On-prem or other cloud) to the Azure destination leveraging azure recommendations through Assessments.
- Visualize the execution plans across the waves using timeline.
- Execute and track the migration of applications in waves
- Monitor the progress, identify risks, and actions as the execution proceeds through different stages of migration.

You can perform migrations using the tools of your choice including Azure Migrate – Server Migration, DMS or others. With Migration Waves extensible tracking capability, you can integrate your migration tooling for centralized tracking of your entire migration and modernization journey.

## Wave Planning concepts

Here are some of the concepts and terminology to help you leverage the Wave Planning in Azure Migrate.

### Wave stages

There are two broad stages as you proceed with them migration of waves:

1. **Configuration**: This stage indicates that wave planning activities are in progress. The goal is to prepare the team and environment for migration and modernization, and to identify all required actions. Generally, activities include defining the migration path, selecting target configurations and tools, and setting up the migration environment. After configuration is complete, the wave is ready for execution.

1. **Execution**: This stage of the wave indicates the application migration is in progress. All migration and modernization activities identified during the configuration stage are executed here. Internally users prepare the environment, migrate workloads and applications, and optimize the set up of end-to-end migration or modernization. After all the applications complete their migration or modernization, the wave execution is considered complete.

### Set planned start and end dates for Azure Migrate Wave execution

The planned start and end dates of the wave defined when you intend to execute the migration or modernization. You can set these dates based on your execution plan and track your migration and modernization journey against the timelines. When you create a new wave, the default planned start date is current date, and the default planned completion date is 3 weeks later.

### Wave status

This section defines the status of the wave migration against the defined plan. Using wave status, you can assess how well the migrations are progressing. Statuses are determined based on the current date, the stage of the migration journey, and the planned start and end dates. Here are the available status types:     


| **S. No** | **Wave status** | **Definition**                                                                           | **Recommendation**                                                                                                                        |
| --------- | --------------- | ---------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| 1         | Not Started     | The execution has not started for this wave and there are more than <**N>** days for it. | Complete the planning activities and be ready for the execution.                                                                          |
| 2         | Off Track       | The planned start or end time of execution has passed.                                   | Relook at the planned timelines and course corrective actions. Actions could be either changing the dates, moving the workloads or others |
| 3         | On Track        | The execution are in progress and there are more than **N** days to complete them      |            Keep going                                                                                                                              |
| 4         | At Risk         | The due date for the migration to start or complete has passed as per the planned dates  | Keep a close track of executions to ensure the migrations complete on time ad don’t go off track.                                         |
| 5         | Completed       | The migration has been completed.                                                        |                                                                                                                                           |

### Execution stages of workloads

The workloads have broadly three stages of execution: Preparation -> Testing -> Completion. The activities to be performed in the three stages may differ for each workload and the kind of execution strategy.   
The **preparation stage** denotes that during this stage; all the activities related to setting up the Azure environment and transfer or data and configuration is performed.  
During the **testing stage**, the application is deployed in an isolated environment for testing purposes, and all the tests are performed.  
In the **completion stage**, the applications are setup in the final environment and the optimization are performed to make it ready for consumption.

### Migration & Modernization Tasks

Tasks are a list of activities that you need to perform to complete the stages of migration/modernization. Each stage contains one or more tasks and once you complete the tasks, the stage is complete. At the wave configuration stage, you can define the tasks for application migration (at different stage of the workload).  Task completion marks the stage complete. You can define manual stages, whereas based on the defined migration approach, Azure Migrate recommends tasks you shall need to perform to complete the journey.
