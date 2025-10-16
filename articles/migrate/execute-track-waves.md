---
title: Execute and Track Migration Waves in Azure Migrate
description: Learn how to execute and track migration waves in Azure Migrate. Understand supported and manual execution flows, update statuses, and monitor migration progress efficiently.
author: shubhamJain1992
ms.author: shuj
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: concept-article
ms.date: 10/15/2025
# Customer intent: To understand how to execute and track migration waves in Azure Migrate, including supported and manual execution flows, and learn how to monitor migration progress and update statuses during the migration phase.
---

# Execute and track migration Waves in Azure Migrate (heading changed)

This phase begins when you reach the planned migration start time and perform migration and modernization activities within the scheduled time window.

Azure Migrate provides two types of execution and tracking flows, based on whether the workload migration from source to target is supported:

1. **Azure Migreate supports execution activities**: When Azure Migrate supports execution, Wave Planning enables automated execution and tracking. You can start migration and modernization flows through wave execution, take actions, and track statuses. For example, you can perform server migration tasks such as replication, test migration, and cutover, and monitor progress automatically.
1. **Azure Migrate doesn't support these execution activities**: Azure Migrate doesn’t support several workload and application migration or modernization activities. In such cases, you plan and track the activities in Azure Migrate and manually update their status for centralized tracking. Execute these activities outside Azure Migrate.

## Executing Waves

When the wave is ready, follow these steps to execute it:

1. Select **Execute wave** from **Wave Planning**.

**<Image 5.1 – Overview with Execute Wave>**

For application migration,
1. Select the application name. Azure Migrate groups the workload by source-to-target combinations that share a similar migration and modernization journey.

**<Image 5.2 – Application in Execute Wave>**  
1. For each source to target combination, select **Review and Execute**. If supported, Azure Migrate starts the execution flow for the workload.
1. If the application has tracked tasks, select the number under **Tasks**.
1. After you complete the task out of band, select **Mark as Complete**.

**<Image 5.3 – App Task marked as complete>**

For workload migration
1. For each source target combination select **Review and Execute.**  If supported, Azure Migrate starts the workload execution flow.
1. For unsupported executions, update the tasks by seleting **View Execution Details**.    
1. For supported executions, select **Execute** migrations for all to start the execution flow.
  
## Tracking wave executions

Use the Migrations view in the Wave to track the migration execution of applications and workloads.

**<Image 5.4 – workload tracking view>**

To view detailed workload status, follow the steps:

1. Select **Execution Stage** and review the tasks in each migration and modernization stage. You can also perform activities and update the migration status here.


**<Image 5.5– vertical task view in migration>**

**<Image 5.6– app tracking view>**

## Next steps

Add next steps