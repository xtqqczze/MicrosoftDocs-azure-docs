---
title: Quickstart to create migration business case and assessments for Arc resources
description: In this quickstart, you'll learn how you can use Azure Migrate project to decide, plan and execute migration of your Arc resources. 
author: snehithm
ms.author: v-uhabiba
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.topic: quickstart
ms.date: 10/21/2025
# Customer intent: "As a cloud architect, I want to create a new Azure Migrate project via the portal, so that I can manage the migration of Arc-enabled on-premises assets to Azure effectively."
---

# Quickstart: View migration readiness and potential savings of your Arc enabled machines (Preview). 

In this quickstart, you will use Azure Migrate to view migration readiness and potential migration savings of your Arc-enabled resources

To view potential migration savings and readiness of your Arc-enabled machines for migration, you must first create an Azure Migrate project. 

An Azure Migrate project is used to store discovery, assessment, and migration metadata collected from the environment you're assessing or migrating. In a project, you can track discovered assets, create assessments, and orchestrate migrations to Azure.
 

## Pre-requisites

- You have **Contributor** or **Owner** role on at least one resource group where you will create the Migrate project. 
    - Ensure *Microsoft.OffAzure* and *Microsoft.Migrate* resource providers are registered on the subscription. Follow [this guide to register resource providers](../azure-resource-manager/management/resource-providers-and-types.md#register-resource-provider-1).
- You have **Migrate Arc Discovery Reader - Preview** role or a custom role with equivalent permissions on the subscriptions with Arc resources. 
    - Ensure subscriptions with Arc resources that you want to include in the project also have *Microsoft.OffAzure* resource provider registered. 
- Your Arc-enabled Server machines are running connected machine agents of version [1.46 (September 2024 release)](https://learn.microsoft.com/azure/azure-arc/servers/agent-release-notes-archive#version-146---september-2024) or newer. Machines with older agent versions are excluded from the project as they don’t include all the necessary information for migration assessments.


## Create a migrate project with your Arc resources

1. In the Azure portal, search for *Azure Arc*.
2. In **Services**, select **Azure Arc**.
3. Under **Migration**, select **Savings and Readiness (Preview)**.

    :::image type="content" source="./media/quickstart-create-migrate-project-for-arc-resources/arc-center-migration-savings-readiness.png" alt-text="Screenshot of Azure portal showing Savings and Readiness pane under Migration in Arc Center." lightbox="./media/quickstart-create-project/assess-migrate-servers-expanded.png":::

4. Select **Create a migration project**. 
 
5. Provide a **name** for your migration project
    :::image type="content" source="./media/quickstart-create-migrate-project-for-arc-resources/create-project-form.png" alt-text="Screenshot of Azure portal showing the form to 'Create a migration project'." lightbox="./media/quickstart-create-project/assess-migrate-servers-expanded.png":::
 
6.	Select **Subscription**, **Resource group** and **Region** for your project. All migration related metadata will be stored in this region.
 
7.	Under **Scope**, select one or more **Subscriptions with Arc resources** that you want to include in this project. 
 
8.	Select a **Target region**. This is where you *plan* to migrate these Arc resources. Target region will be used to determine Azure SKU availability and costs in assessment and business case calculation.  

9.	Select **Create**. 

Project will now be created along with default businesscases and asssessments. Depending on the number of Arc resources, this could take up to an hour. 

## View default business cases

When you create a project with Arc resources, two default business cases will be generated, each considering different a migration strategy:

- Modernize strategy (named *default-modernize*)
- Faster migration to Azure strategy (named *default-faster-mgn-az-vm*)

To view the business cases:

1. Navigate to **Savings and Readiness (Preview)** pane in Azure Arc center as described in previous section. You will be taken to the **Business case** tab by default. 

2. View potential savings at a glance on the cards in the **Recently created** section

    :::image type="content" source="./media/quickstart-create-migrate-project-for-arc-resources/default-business-cases.png" alt-text="Screenshot of Savings and Readiness showing the business case tab. The cards highlight potential savings from the default business cases." lightbox="./media/quickstart-create-migrate-project-for-arc-resources/default-business-cases.png":::

3. Select **View** on the card or the name of the business case in the list below.

4. Review the report. To learn more about various reports see [View a business case](how-to-view-a-business-case.md).

## View default assessment

Similarly,when you create a migrate project with Arc resources, a default assessment will be created, encompassing all workloads (Servers and SQL Servers) named *default-all-workloads*.

To view the default assessment:

1. Navigate to **Savings and Readiness (Preview)** pane in Azure Arc center as described in the [Create a migrate project with your Arc resources section](#create-a-migrate-project-with-your-arc-resources) section. You will be taken to the **Business case** tab by default

2. Switch to the **Assessment** tab.

3. View migration readiness percentage for your Arc-enabled resources at a glance on the cards in the **Recently created** section

    :::image type="content" source="./media/quickstart-create-migrate-project-for-arc-resources/default-assessment.png" alt-text="Screenshot of Savings and Readiness showing the assessment tab. The cards highlight migration readiness percentage calculated from the assessment." lightbox="./media/quickstart-create-migrate-project-for-arc-resources/default-assessment.png":::

3. Select **View all strategies** on the card or the name of the assessment in the list below.

4. Review the report. To learn more about the information that an assessment provides, see [Assessment report](assessment-report.md).

## Create custom business cases or assessments
Along with default business cases and assessments, you can also create custom business cases and assessments. For example, you might want to generate a business case or assessment scoped to a specific application or use different settings. 

To create a custom business case:

1. Navigate to **Savings and Readiness (Preview)** pane in Azure Arc center as described in the [Create a migrate project with your Arc resources section](#create-a-migrate-project-with-your-arc-resources) section. 

2. Select **+Create**

3. Select **Business case**

4. Follow the steps in [Build a business case](https://learn.microsoft.com/en-us/azure/migrate/how-to-build-a-business-case?view=migrate) to create a custom business case.


To create a custom assessment:

1. Navigate to **Savings and Readiness (Preview)** pane in Azure Arc center as described in the [Create a migrate project with your Arc resources section](#create-a-migrate-project-with-your-arc-resources) section. 

2. Select **+Create**

3. Select **Assessment**

4. Follow the steps in [Create an application assessment](create-application-assessment.md) to create an assessment.


## Delete the project

If you no longer require the project, delete the project using the following steps:

1. Open the Azure resource group in which the project was created.
2. In the Resource Groups page, select **Show hidden types**.
3. Select the project that you want to delete and its associated resources.
    - The resource type is **Microsoft.Migrate/migrateprojects**.
    - If the resource group is exclusively used by the project, you can delete the entire resource group.

## Next steps

- Set up periodic sync to automatically sync Arc data into
- 
