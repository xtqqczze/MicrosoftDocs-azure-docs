---
title: Questions about Wave Planning in Azure Migrate
description: Get answers to common questions about wave planning in Azure Migrate.
author: shubhamJain1992
ms.author: shuj
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: concept-article
ms.date: 10/15/2025
# Customer intent: As a cloud migration specialist, this article help understand and clarify common questions about using Azure Migrate Wave Planning for migration projects.
---


# Wave Planning - Common questions

This article answers common questions about Wave Planning in Azure Migrate. 

## Is wave planning mandatory for migrations?

No, wave planning is not a mandatory step for performing migrations using Azure migrate. However, wave planning provides a guided step by step flow for planning and executing timely migrations helping through perform timely large scale migrations. 

## How do I ensure waves shows latest data? 
Create, edit, delete and other wave operations may take time depending on the size of the wave. To ensure that you are viewing hte latest data, ensure that
1. The deployments for each operation is complete. 
2. You refresh the page using the Refresh action

# Wave Planning

## Explain why am I unable to add applications into the waves?
Each workload in a migration wave can have only a unique  migration plan and be a part of only one wave. So if any workload of the application is part of another wave, then you will not be able to add the application as a whole to another wave. 

You can alternatively, switch to workload selection view, filter by the application name and add remianing workloads of the application to the wave.  

## Explain why workloads and application count added to the wave are different from what I selected in the creation flow?
Followign are hte reasons why the workloads/apps selected for the wave may vary from the count which is actually added to the wave:

1. The workload are not supported in Migration Waves. The workload would be omitted from the wave. Unsupported list includes:  
      1. PostGre SQL
2. The workload is part of multiple applications. In this case migrating the workload will migrate a part of various applications and therefor the compelte list of applications are visible in the wave.
3. The application contains unsupported workload. In this case, the application is split into workloads and the reamining of the worklaods are added to the wave. 

# Wave Execution

## Which migrations executions are supported through Waves?
There are 2 cateogy of tracking supported in Azure Migrate: 
1. Automated tracking: In scenarios where the Migration and modernization tool and approach is supported in Azure Migrate (such as Server Migration), you can perform migration and modernization actions through Waves and the status gets automatically updated
2. Manually tracking: In scenarios where the Migration Tooling is not supported natively in Azure Migrate, (DMS, Others), you can manually udpate the status if the tasks (Mark as complete etc.). This way the waves status is kept latest to reflect hte stage in the migration nd modernization journey.