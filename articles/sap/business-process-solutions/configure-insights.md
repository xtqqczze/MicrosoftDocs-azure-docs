---
title: Configure Insights in Business Process Solutions
description: Learn how to configure insights in Business Process Solutions, including setting up semantic models, deploying Power BI report templates, and establishing connections to refresh reports and models.
author: mohitmakhija1
ms.service: sap-on-azure
ms.subservice:
ms.topic: overview
ms.custom: subject-monitoring
ms.date: 11/07/2025
ms.author: momakhij
---

# Configure Insights in Business Process Solutions

In this article, we'll describe the steps required to configure Insights in Business Process Solutions. This document contains steps on how you can set up the insights using semantic model and Power BI report templates in your Business Process Solution item. We will also cover steps on how to set up connection to refresh the reports and semantic model.

## Import Lakehouse Views

Power BI dashboards which are delivered as part of Enterprise Insights require a set of views created on top of the lakehouse. To deploy these views, we need to run a notebook from our workspace. Follow the steps.

1. Navigate to your workspace
2. Open the notebook ei_gold_view_creation.
   :::image type="content" source="./media/configure-insights/gold-view-notebook.png" alt-text="Open ei_gold_view_creation notebook" lightbox="./media/configure-insights/gold-view-notebook.png":::
3. Click on the Run All button.
   :::image type="content" source="./media/configure-insights/run-gold-view-notebook.png" alt-text="Run ei_gold_view_creation notebook" lightbox="./media/configure-insights/run-gold-view-notebook.png":::
4. Once the notebook run is finished, you should see the sql views in your gold lakehouse.

## Deploy Power BI Report

To create a new Power BI report, make sure you have enabled the dataset for the report and ran the extraction and processing of data successfully. Once that is done, Navigate to the Insights page and follow the instructions.

1. Click on the Deploy Insights tab and click on the New Insights button.
2. Select the report/semantic model you would like to deploy. Click on the Deploy button.
   :::image type="content" source="./media/configure-insights/deploy-insights.png" alt-text="Deploy Insights" lightbox="./media/configure-insights/deploy-insights.png":::
3. Enter a unique name for the report and select the source system for the report. Click on the Deploy button.
   :::image type="content" source="./media/configure-insights/new-insights-details.png" alt-text="Enter report inputs" lightbox="./media/configure-insights/new-insights-details.png":::
4. Once the deployment completes, you should be able to see the report in your workspace.

> [!NOTE]
> Power BI Report deployment automatically deploys the semantic model, you don't need to deploy the semantic model separately.

## Connection for Semantic Model Refresh

To refresh the semantic model, we need to set up a connection in fabric, else we won't be able to automatically refresh the reports via pipelines. To set up the connection, follow the steps.

1. Open the Semantic Model item, Click on File, and then select Settings button.
   :::image type="content" source="./media/configure-insights/model-settings.png" alt-text="open semantic model settings" lightbox="./media/configure-insights/model-settings.png":::
2. Open the Gateway and cloud connections and under cloud connections, click on Create a connection.
3. Now, Enter a unique name for your connection, multiple reports can use this connection. Select Authentication method as OAuth 2.0.
   :::image type="content" source="./media/configure-insights/lakehouse-connection.png" alt-text="Create a Microsoft Fabric lakehouse connection" lightbox="./media/configure-insights/lakehouse-connection.png":::
4. Now, click on Edit credentials and provide the credentials. Click on Create.
5. Once connection is created, navigate back to the semantic model and associate the connection.
   :::image type="content" source="./media/configure-insights/associate-connection.png" alt-text="Associate a connection to semantic model" lightbox="./media/configure-insights/associate-connection.png":::
6. Once done, try to refresh the semantic model and check if it completes successfully.
