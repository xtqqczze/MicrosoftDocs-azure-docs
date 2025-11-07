---
title: Server redeploy
description: Learn how to prepare Windows Server 2003 servers for migration with Azure Migrate.
author: piyushdhore-microsoft 
ms.author: piyushdhore
ms.manager: kmadnani
ms.topic: how-to
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.date: 11/10/2025
ms.custom: engagement-fy25
# Customer intent: As a system administrator, I want to redeploy Windows Server 2003 machines to Azure using Infrastructure as Code so that I can automate the migration and reduce manual steps.
---

# Redeploy servers by using IaC

Azure Migrate supports server redeployment through Infrastructure as Code (IaC).
You can automate the process of rebuilding and configuring servers in Azure using declarative scripts instead of manual steps. By leveraging IaC, you can:

1. Create IaaS application IaC.
1. Deploy the IaaS application IaC.
1. Migrate the server using the Server Migration tool.
1. Detach the data disk using the disk migration script to generate disk IaC.
1. Merge disk IaC with application IaC.
1. Reapply the application IaC script.

This guide provides detailed instructions for each step.

## Create IaaS Application IaC

Azure Migrate lets you generate Infrastructure as Code (IaC) templates for your assessed workloads or applications. These templates create an application landing zone in Azure, enabling automated deployment and configuration.

### Prerequisites

Before you begin, complete the Azure VM assessment in Azure Migrate.

### Generate Application Landing Zone IaC

Follow these steps to generate Infrastructure as Code (IaC) for your assessed workloads or applications in Azure Migrate:

1.Open the assessment report in the Azure Migrate portal after you complete the workload or application assessment.
1. Select **Generate IaC** at the top of the report to start the code generation process.


:::image type="content" source="./media/server-repdeploy/code-generation-process.png" alt-text="The screenshot shows how to start the code generation process." lightbox="./media/server-repdeploy/code-generation-process.png":::

1. The portal redirects you to the IaC generation flow, where you review and select details before generating the code.

:::image type="content" source="./media/server-repdeploy/iac-generation-flow.png" alt-text="The screenshot shows how to redirect to iac generation flow to review and select details before generating the code." lightbox="./media/server-repdeploy/iac-generation-flow.png":::

1. IaC generation currently supports only IaaS (Infrastructure as a Service) targets.
1. For workload assessments, select the workloads you want to include in the generated application code. 
1. For application assessments, select the application you want to generate IaC for. You can generate code for only one application at a time.


:::image type="content" source="./media/server-repdeploy/generate-application.png" alt-text="The screenshot shows how to select application to generate Iac for." lightbox="./media/server-repdeploy/generate-application.png":::

1. Review the workloads and select **Next**.

:::image type="content" source="./media/server-repdeploy/generate-iac-for-one-application.png" alt-text="The screenshot shows how to iac for one application." lightbox="./media/server-repdeploy/generate-iac-for-one-application.png":::

1. Select **Next** again to go to the **Generate and Download** page, and review the base architecture.

