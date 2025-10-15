---
title: Prerequisites For Azure Migrate Wave Planning - Complete Discovery & Best Practices
description: Learn the key prerequisites for effective wave planning in Azure Migrate. Complete infrastructure discovery, perform dependency analysis, define applications, and run assessments to ensure accurate migration planning.
author: shubhamJain1992
ms.author: shuj
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: concept-article
ms.date: 10/15/2025
# Customer intent: 
---
# Prerequisites

Wave planning enables you to create an execution plan for your migration and modernization of the applications in your entire inventory. To create an effective wave plan, follow the best practices and perform all the pre-requisites mentioned in the article.

## Complete infrastructure discovery in Azure Migrate for Wave Planning

You must have an active Azure Migrate project and complete discovery of your infrastructure (servers, databases, and workloads). Verify that discovery is complete and inventory data is accurate.

The following are recommended for creating high quality wave plan.

- **Perform dependency analysis**: Use Azure Migrate dependency visualization to identify relationships between workloads. Grouping dependent workloads helps reduce migration risks and prevent application outages.

- **Define applications and enrich metadata**: Create application groupings and capture details such as business criticality, complexity, and technology stack. Add tags for environment, department, and owner to help prioritize and batch workloads effectively.

- **Run assessments for readiness and cost insights**: Assessments provide readiness status, cost estimates, and recommended migration strategies. These insights improve planning accuracy and group based on the migration strategies.

## Next steps

Add next steps