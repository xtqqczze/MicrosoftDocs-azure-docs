---
title: Prerequisites For Wave Planning
description: Learn how Azure Migrate – Wave Planning simplifies cloud migration and modernization. Break large projects into manageable waves, reduce risks, and improve execution with structured planning and continuous feedback.
author: shubhamJain1992
ms.author: shuj
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: concept-article
ms.date: 10/15/2025
# Customer intent: Customers want to leverage Azure Migrate’s Wave Planning to simplify large-scale cloud migrations. They’re looking for a structured way to break down complex projects, reduce risks, maintain business continuity, and track progress using integrated planning and execution tools.
---
# Prerequisites

Wave planning enables you to create an execution plan for your migration and modernization of the applications in your entire inventory. To create an effective wave plan, follow the best practices and perform all the pre-requisites mentioned in the article.

## Complete infrastructure discovery in Azure Migrate for Wave Planning

You must have an active Azure Migrate project and complete discovery of your infrastructure (servers, databases, and workloads). Verify that discovery is complete and inventory data is accurate.

The following are recommended for creating high quality wave plan.

- **Perform dependency analysis**: Use Azure Migrate dependency visualization to identify relationships between workloads. Grouping dependent workloads helps reduce migration risks and prevent application outages.

- **Define applications and enrich metadata**: Create application groupings and capture details such as business criticality, complexity, and technology stack. Add tags for environment, department, and owner to help prioritize and batch workloads effectively.

- **Run assessments for readiness and cost insights**: Assessments provide readiness status, cost estimates, and recommended migration strategies. These insights improve planning accuracy and group based on the migration strategies.

## Next steps: