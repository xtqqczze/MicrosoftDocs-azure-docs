---
title: Get started with azureblobcontainer-to-azureblobcontainer migration in Azure Storage Mover
description: The Blob-to-Blob Migration feature in Azure Storage mover allows you to securely transfer data from a Blob container in Azure Storage to another Blob container in any storage account in a public Azure region.
author: madhurinms
ms.author: madhn
ms.service: azure-storage-mover
ms.topic: quickstart
ms.date: 12/04/2025
---

# Get started with blob-to-blob migration in Azure Storage Mover

The Azure-to-Azure Migration feature in Azure Storage Mover allows you to securely transfer large datasets between Blob containers across different Azure storage accounts and regions.

This article guides you through the complete process of configuring Storage Mover to migrate your data between two Blob containers. The process consists of configuring endpoints, and creating and running a migration job.

## Prerequisites

Before you begin, ensure that you have: 

- A [Storage Mover resource](storage-mover-create.md) deployed in your Azure subscription.

## Limits

The Cloud-to-Cloud Migration feature in Azure Storage Mover has the following limits:

- Each migration job supports the transfer of 500 million objects.
- A maximum of 10 concurrent jobs is supported per subscription. If you need to run more than 10, you can do so by creating a support request.
- Azure Storage Mover doesn't support automatic rehydration of archived objects. Data stored in Azure Blob Archive must be restored before migration. Migration jobs should only be initiated after the data is fully restored.
- Blob container-to-container migration does not allow you to select the same Source and Target Endpoint in the same Migration Job Creation.
- Blobs will not be truly moved rather copied, as the Blob container will continue to exist in it’s current location along with the Target location set


## Configure Source and Target Endpoints
In the context of the Azure Storage Mover service, an *endpoint* is a resource that contains the path to either a source or target location and other relevant information. Storage Mover *job definitions* use endpoints to define the source and target locations for copy operations.

Follow the steps in this section to configure an Azure Blob container source and target endpoints. To learn more about Storage Mover endpoints, refer to the [Manage Azure Storage Mover endpoints](endpoint-manage.md) article.

### Configure an Azure Blob Storage Source Endpoint

### [Azure portal](#tab/portal)
1. Navigate to your Storage mover instance in Azure.
1. From the **Resource management** group within the left navigation, select **Storage endpoints**. Select the **Source endpoints** tab, and then **Add endpoint** to open the **Create source endpoint** pane.
1. In the **Create source endpoint** pane:

    - Select **Blob container** as the **Source type**.
    - Optionally, provide a description for the endpoint in the **Description** field.
    - Select your subscription and storage account from the respective **Subscription** and **Storage account** drop-down lists.
    - Choose the **Blob container** from which you want to migrate from the **Blob container** drop-down list.
    - Optionally, provide a description for the endpoint in the **Description** field.
    - Verify that your selections are correct and select **Create** to create the endpoint as shown in the following image.

### Configure an Azure Blob Storage Target Endpoint

### [Azure portal](#tab/portal)
1. From the **Resource management** group within the left navigation, select **Storage endpoints**. Select the **Target endpoints** tab, and then **Add endpoint** to open the **Create target endpoint** pane.
1. In the **Create target endpoint** pane:
 
    - Select your subscription and storage account from the respective **Subscription** and **Storage account** drop-down lists.
    - Select *Blob container* button from the **Target type** field.
    - Choose the **Blob container** to which you want to migrate from the **Blob container** drop-down list.
    - Optionally, provide a description for the endpoint in the **Description** field.
    - Verify that your selections are correct and select **Create** to create the endpoint as shown in the following image.

        :::image type="content" source="media/cloud-to-cloud-migration/endpoint-target-create-sml.png" alt-text="A screen capture showing the Endpoints page containing the Create Target Endpoint pane with required fields displayed." lightbox="media/cloud-to-cloud-migration/endpoint-target-create.png":::

### Assign RBAC Role to Source and Target Endpoints

### [Azure portal](#tab/portal)

When you create an Azure Blob Storage source or target endpoint through the Azure portal, the **Storage Blob Data Contributor** RBAC role is automatically assigned to the system-assigned managed identity of the endpoint. No other steps are required.


## Create a migration project and job definition

After you define source and target endpoints for your migration, the next steps are to create a Storage Mover migration project and job definition.

A *migration project* allows you to organize large migrations into smaller, more manageable units that make sense for your use case. A *job definition* describes resources and migration options for a specific set of copy operations undertaken by the Storage Mover service. These resources include, for example, the source and target endpoints, and any migration settings you want to apply.

Follow the steps in this section to create a migration project and run a migration job.

### Create a Project

### [Azure portal](#tab/portal)
1. Navigate to the **Project explorer** tab in your Storage Mover instance and select **Create project**.
1. Provide values for the following fields:
    - **Name**: A meaningful name for the migration project.
    - **Project description**: A useful description for the project.

    Select **Create** to create the project. It might take a moment for the newly created project to appear in the project explorer.

    :::image type="content" source="media/cloud-to-cloud-migration/project-create-sml.png" alt-text="A screen capture showing the Project Explorer page with the Create a Project pane's fields visible." lightbox="media/cloud-to-cloud-migration/project-create.png":::


### Create a Job Definition

### [Azure portal](#tab/portal)
1.  Select the project after it appears, and then select **Create job definition**. The **Create a Migration Job** page opens to the **Basics** tab. Provide values for the following fields:
    - **Name**: A meaningful name for the migration job.
    - **Migration type**: Select `Azure to Azure`.
    
    :::image type="content" source="media/cloud-to-cloud-migration/create-job-sml.png" alt-text="A screen capture showing the Create a Migration Job page with the Basics tab selected and the required fields displayed." lightbox="media/cloud-to-cloud-migration/create-job.png":::

1. Within the **Source** tab, select the **Existing endpoint** option for the **Endpoint** field. Next, select the **Select an existing endpoint as a source** link to open the **Select an existing endpoint** pane. 

    :::image type="content" source="media/cloud-to-cloud-migration/create-source-sml.png" alt-text="A screen capture showing the Create a Migration Job page with the Source tab selected and the required fields displayed." lightbox="media/cloud-to-cloud-migration/create-source.png":::

    Choose the AWS S3 source endpoint created in the previous section and select **Select** to save your changes.

    :::image type="content" source="media/cloud-to-cloud-migration/select-source-sml.png" alt-text="A screen capture showing the Select an Existing Source Endpoint pane." lightbox="media/cloud-to-cloud-migration/select-source.png":::

1. Within the **Target** tab, select the **Select an existing endpoint reference** option for the **Target endpoint** field. Next, select the **Select an existing endpoint as a target** link to open the **Select an existing endpoint** pane. 

    :::image type="content" source="media/cloud-to-cloud-migration/create-target-sml.png" alt-text="A screen capture showing the Create a Migration Job page with the Target tab selected and the required fields displayed." lightbox="media/cloud-to-cloud-migration/create-target.png"::: 

    Next, select the **Select an existing endpoint as a target** link to open the **Select an existing target endpoint** pane. Choose the Azure Blob Storage target endpoint created in the previous section and select **Select** to save your changes. Verify that the correct target endpoint is displayed in the **Existing target endpoint** field and then select **Next** to continue to the **Settings** tab.

    :::image type="content" source="media/cloud-to-cloud-migration/select-target-sml.png" alt-text="A screen capture showing the Create a Migration Job page with the Select anExisting Target Endpoint pane displayed." lightbox="media/cloud-to-cloud-migration/select-target.png":::

1. Within the **Settings** tab, select **Mirror source to target** from the **Copy mode** drop-down list. Verify that the **Migration outcomes** results are appropriate for your use case, then select **Next** and review your settings.

    :::image type="content" source="media/cloud-to-cloud-migration/project-settings-sml.png" alt-text="A screen capture showing the Create a Migration Job page with the Settings tab selected and migration outcomes displayed." lightbox="media/cloud-to-cloud-migration/project-settings.png":::

1. After confirming that your settings are correct within the **Review** tab, select **Create** to deploy the migration job. You're redirected to the **Project explorer** after the job's deployment begins. After completion, the job appears within the associated migration project.

    :::image type="content" source="media/cloud-to-cloud-migration/job-review-sml.png" alt-text="A screen capture showing the Create a Migration Job page with the Review tab selected and all settings displayed." lightbox="media/cloud-to-cloud-migration/job-review.png":::


## Run a migration job

### Start a Job Definition

### [Azure portal](#tab/portal)
1. Navigate to the **Migration Jobs** tab. The **Migration Jobs** tab displays all migration jobs created within your Storage Mover resource, including the one you recently created. It might take a moment for the newly created migration job to appear in the list of migration jobs. Refresh the page if necessary. 

    :::image type="content" source="media/cloud-to-cloud-migration/migration-jobs-sml.png" alt-text="A screen capture showing the Migration Jobs page with the Migration Jobs tab selected and all Migration Jobs displayed." lightbox="media/cloud-to-cloud-migration/migration-jobs.png":::

1. Select your newly created job definition to view its details in the **Properties** tab. Select the **Start job** button to expose the **Start job** pane for the migration job. 

    :::image type="content" source="media/cloud-to-cloud-migration/migration-job-sml.png" alt-text="A screen capture showing the Migration Job details page with the Properties tab and the Start Job button highlighted." lightbox="media/cloud-to-cloud-migration/migration-job.png":::

    The multicloud connector attempts to assign roles to the storage account and blob container. After the roles are assigned, select **Start** to begin the migration job. The job runs in the background, and you can monitor its progress in the **Migration overview** tab.

    :::image type="content" source="media/cloud-to-cloud-migration/migration-job-start-sml.png" alt-text="A screen capture showing the Migration Job page's Start Job pane." lightbox="media/cloud-to-cloud-migration/migration-job-start.png":::


## Monitor migration progress

As you use Storage Mover to migrate your data to your Azure destination targets, you should monitor the copy operations for potential issues. Data relating to the operations being performed during your migration are displayed within the **Migration overview** tab. This data allows you to track the progress of your migration by providing current status and key information such as progress, speed, and estimated completion time.

When configured, Azure Storage Mover can also provide Copy logs and Job run logs. These logs are especially useful because they allow you to trace the migration result of job runs and of individual files.

Follow the steps in this section to monitor the progress of a Storage Mover Migration Job. To learn more about Storage Mover Copy and Job logs, refer to the [How to enable Azure Storage Mover copy and job logs](log-monitoring.md) article.

1. Navigate to the **Migration Jobs** tab.

    :::image type="content" source="media/cloud-to-cloud-migration/migration-overview-sml.png" alt-text="A screen capture showing the Storage Mover page with the Migration Overview tab selected and all Migration Jobs displayed." lightbox="media/cloud-to-cloud-migration/migration-overview.png":::
1. Select your job to view **progress, speed, and estimated completion time**.
1. Select **Logs** to check for any errors or warnings.
1. After the migration is complete, verify the data in **Azure Blob Storage**.

## Post-Migration Validation

Post-migration data validation ensures that your data is accurate and that the transfer from AWS S3 to Azure Blob Storage is complete. This validation process verifies data integrity and consistency by comparing migrated data to the same data from the source. You can also choose to conduct user acceptance tests to further confirm functionality. Validation helps identify and resolve discrepancies, ensuring the migrated data is reliable and meets your business requirements.

Follow the steps in this section to complete manual validation and clean up unused AWS resources.

- Compare source and destination storage to ensure all files are transferred.
- Enable incremental sync if you need to keep AWS S3 and Azure Blob in sync over time.
- Delete the AWS S3 bucket after migration is fully completed and verified.


## Troubleshooting & Support 

Troubleshooting your migration might involve a range of steps, from basic diagnostics to more advanced error handling. If you're encountering issues, begin troubleshooting by taking the following steps.

- Migration job failed? Check the logs for error messages.
- Data transfer is slow? Ensure your network bandwidth is sufficient and AWS S3 rate limits aren’t throttling your transfer.
- Permission issues? Verify that Azure Arc and AWS Identity and Access Management (IAM) roles have the correct access.

## Related content

The following articles can help you become more familiar with the Storage Mover service.

- [Understanding the Storage Mover resource hierarchy](resource-hierarchy.md)
- [Deploying a Storage Mover resource](storage-mover-create.md)
- [Deploying a Storage Mover agent](agent-deploy.md)
