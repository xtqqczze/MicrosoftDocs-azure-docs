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

No, wave planning isn't a mandatory to migrate with Azure Migrate. It's a guided, step by step process that helps you plan and execute large scale migrations on time. 

## How do I ensure waves shows latest data? 

Create, edit, delete and other wave operations can take time depending on the size of the wave. To see the latest data,do the following

1. Ensure deployments for each operation are complete. 
1. Refresh the page using the Refresh action.

## Explain why can't I add an application to a wave?

Each workload in a migration wave can have only unique  migration plan and be part of only one wave. If any workload of an application is part of another wave, you can add the entire application to a different wave. 

Alternatively, switch to workload selection view, filter by the application name, and add the remianing workloads to the wave.  

## Explain why workloads the application count added to the wave are different from what I selected in the creation flow?

Followign are hte reasons why the workloads/apps selected for the wave may vary from the count which is actually added to the wave:

1. The workloads aren't supported in migration Waves. Unsupported workloads are omited from the wave. Unsupported list includes: PostGre SQL.
1. The workload is part of multiple applications. Migrating this workload moves parts of various applications, so the compelet list of applications appears in the wave.
1. The application contains an unsupported workload. This application is split into multiple workloads, and the reamining ofworklaods are added to the wave. 

## Which migration executions are supported through Waves?

There are two types of cateogy tracking in Azure Migrate: 

1. **Automated tracking**: When Azure Migrate supports the migration tool and approach (for example, Server Migration), you can perform migration and modernization tasks through Waves, and the status updates automatically.

1. **Manually tracking**: When Azure Migrate doesn't natively support migration tooling (for example, DMS or other tools), you manually update task status (for example, select **Mark as complete**). This keeps Waves status up to date and reflects the current stage in the migration and modernization journey.