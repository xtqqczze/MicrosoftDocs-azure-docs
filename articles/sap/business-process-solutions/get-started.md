---
title: Business Process Solutions - Get started
description: Learn the prerequisites and steps to get started with Business Process Solutions in Microsoft Fabric, including deployment requirements and initial setup.
author: mohitmakhija1
ms.service: sap-on-azure
ms.subservice:
ms.topic: overview
ms.custom: subject-monitoring
ms.date: 11/07/2024
ms.author: momakhij
---

# Get started with Business Process Solutions

In this article, we'll describe the steps required to get started with Business Process Solutions. This document contains the prerequisites needed before you can start using Business Process Solutions.

## Deploying Business Process Solution in Microsoft Fabric

To deploy Business process solutions, you need:

- A Microsoft Fabric capacity license SKU F2 onwards (F32+ recommended) or Microsoft Power BI Premium license. For more information, see Microsoft Fabric license types.
- You need the Global Administrator role to enable Business Process solutions feature.
- The Power Platform administrator, or the Fabric administrator (Workspace Owner) role to create a new workspace, deploy Business Process solutions in Microsoft Fabric admin portal, and add artifacts in Power BI.
- A workspace in your Fabric environment where you want to deploy Business process solutions.

### Create Microsoft Fabric workspace

Before proceeding with either manual or automated deployment of Enterprise Insights you need to create a Microsoft Fabric workspace. Follow the steps below to set up your workspace.

1. Open Microsoft Fabric: [Power BI](https://app.powerbi.com/)
2. From the left menu choose Workspaces and choose new workspace.
   :::image type="content" source="./media/get-started/new-workspace.jpg" alt-text="Create a new Microsoft Fabric workspace" lightbox="./media/get-started/new-workspace.jpg":::
3. Provide the Name of the workspace. Open the Advanced settings and choose **Large Semantic Model Storage Format**. Confirm by clicking **Apply**
   :::image type="content" source="./media/get-started/workspace-details.jpg" alt-text="New workspace details" lightbox="./media/get-started/workspace-details.jpg":::

### Enable Business Process Solutions workload

To enable Business Process Solutions workload in Microsoft Fabric, follow the steps below:

1. Open the workloads page by clicking on the more option.
   :::image type="content" source="./media/get-started/open-workspace-menu.png" alt-text="Open workloads page" lightbox="./media/get-started/open-workspace-menu.png":::
2. Select the Business Process Solutions workload in the Add more workloads section.
   :::image type="content" source="./media/get-started/bps-workload.png" alt-text="Select Business Process Solutions workload" lightbox="./media/get-started/bps-workload.png":::
3. Once the page opens, click on the Manage button and select 'By workspace'.
   :::image type="content" source="./media/get-started/manage-bps-workload.png" alt-text="Manage Business Process Solutions workload" lightbox="./media/get-started/manage-bps-workload.png":::
4. Select the workspace you created earlier and click on Update button.
    :::image type="content" source="./media/get-started/assign-bps-workload-workspace.png" alt-text="Select workspace for Business Process Solutions workload" lightbox="./media/get-started/assign-bps-workload-workspace.png":::

### Deploy Business Process Solutions

To deploy Business Process Solutions, follow the steps below:

1. Navigate to the workspace you created earlier.
2. Click on the **New Item** button.
3. Select **Business Process Solutions** from the list of available items.
   :::image type="content" source="./media/get-started/bps-workload.png" alt-text="Select Business Process Solutions item" lightbox="./media/get-started/bps-workload.png":::
4. Provide a name of the artifact for the Business Process solution and description (optional) that you want to configure. Provide a unique name for the business process solution item in your workspace.
   :::image type="content" source="./media/get-started/provide-bps-item-name.png" alt-text="Provide Business Process Solutions details" lightbox="./media/get-started/provide-bps-item-name.png":::
5. After the configuration is complete, You should be able to see the new item created.

### Set up Fabric SQL Database Connection

Pipelines in Business Process Solutions use Fabric SQL Database connection to read data and orchestrate data movement. Creating this connection is a pre-requisite before we can configure source system connections. Follow the steps below to create Fabric SQL Database connection.

1. To create a new connection navigate to your workspace and click on the settings button on the top right of the page.
2. Click on the Manage connections and gateways button.
   :::image type="content" source="./media/get-started/open-settings.png" alt-text="Open settings" lightbox="./media/get-started/open-settings.png":::
3. Click on New Button.
   :::image type="content" source="./media/get-started/new-connection.jpg" alt-text="Create new connection" lightbox="./media/get-started/new-connection.jpg":::
4. In the new connection input, select the Type as Cloud.
5. Enter the connection name.
6. Select Connection type as Fabric SQL Database.
7. For the authentication method, select OAuth and click on Edit Credentials and enter the details.
8. Click on Create Button to create the connection.
   :::image type="content" source="./media/get-started/enter-connection-details.jpg" alt-text="Enter connection details for new connection" lightbox="./media/get-started/enter-connection-details.jpg":::
9. Once the connection is created, open the connection and copy the connection id and keep it handy.
    :::image type="content" source="./media/get-started/copy-connection-details.png" alt-text="Copy connection id" lightbox="./media/get-started/copy-connection-details.png":::

## Next Steps

Now that you have deployed Business Process Solutions in your Microsoft Fabric workspace and created Fabric SQL Database connection, you can proceed to configure source system connections.

- [Configure SAP source system with Azure Data Factory](configure-source-system-with-data-factory.md)
- [Configure SAP source system with Open Mirroring](configure-source-system-with-open-mirroring.md)
- [Configure Salesforce source system](configure-salesforce-source-system.md)
