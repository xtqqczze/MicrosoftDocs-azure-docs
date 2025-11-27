---
title: Configure Dataset in Business Process Solutions
description: Learn how to configure datasets in Business Process Solutions, including importing template datasets, enabling datasets for extraction and processing, and modifying dataset tables and relationships.
author: mohitmakhija1
ms.service: sap-on-azure
ms.subservice:
ms.topic: overview
ms.custom: subject-monitoring
ms.date: 11/07/2025
ms.author: momakhij
---

# Configure Dataset in Business Process Solutions

In this article, we describe the steps required to configure Dataset in Business Process Solutions. This document contains steps on how you can set up the dataset by importing template datasets depending on the source system you configure in your Business Process Solution item.

## Configure dataset

Now before data extraction, we need to enable datasets, which contain solution areas and table we want to enable extraction and processing. Follow the steps to configure a dataset.

1. Open your Business Process Solution item and click on the **Set up your Datasets** button.
   :::image type="content" source="./media/configure-dataset/set-up-datasets.png" alt-text="Navigate to Dataset tab" lightbox="./media/configure-dataset/set-up-datasets.png":::
2. Click on Import from template use an existing template.
3. Once the dialog opens select your source system and enter the name of the dataset, make sure to enter a unique name.
4. Select the dataset you would like to enable. Click on import.
   :::image type="content" source="./media/configure-dataset/import-dataset-template.png" alt-text="Import dataset from template" lightbox="./media/configure-dataset/import-dataset-template.png":::
5. After the dataset creation is completed successfully, the dataset is in Disabled state, we need to enable this dataset. Select the dataset and click on Activate datasets button.
   :::image type="content" source="./media/configure-dataset/enable-dataset.png" alt-text="Activate dataset" lightbox="./media/configure-dataset/enable-dataset.png":::
6. Now, your dataset is ready for extraction and processing.

## Modify dataset tables and relationships

Once the dataset is deployed, you should be able to view the dataset. You can explore the tables, which are enabled for extraction. You can also check the relationship that is created between fact and dimension tables.

### Update dataset tables

To update the dataset tables, follow the steps

1. Open your Business Process Solution item.
2. Click on the 'Set up your datasets' button.
   :::image type="content" source="./media/configure-dataset/set-up-datasets.png" alt-text="Navigate to Dataset tab" lightbox="./media/configure-dataset/set-up-datasets.png":::
3. To view the tables enabled for extraction, expand the source system and dataset in the explorer menu.
   :::image type="content" source="./media/configure-dataset/expand-dataset.png" alt-text="Expand dataset to see tables" lightbox="./media/configure-dataset/expand-dataset.png":::
4. You can delete tables by selecting multiple tables and clicking the **Delete** button.
   :::image type="content" source="./media/configure-dataset/delete-table.png" alt-text="Delete table" lightbox="./media/configure-dataset/delete-table.png":::
5. You can also change the table details by opening the context menu and clicking on Edit.
   :::image type="content" source="./media/configure-dataset/edit-table.png" alt-text="Edit table" lightbox="./media/configure-dataset/edit-table.png":::
6. Click on the **Save** button to save the changes.

### Create new relationships

To create new relationships between tables, follow the steps

1. Open your Business Process Solution item.
2. Click on the 'Set up your datasets' button.
   :::image type="content" source="./media/configure-dataset/set-up-datasets.png" alt-text="Navigate to Dataset tab" lightbox="./media/configure-dataset/set-up-datasets.png":::
3. To view the tables enabled for extraction, expand the source system and dataset in the explorer menu.
4. Click on the Manage relationship button.
   :::image type="content" source="./media/configure-dataset/manage-relationship.png" alt-text="Manage Relationships" lightbox="./media/configure-dataset/manage-relationship.png":::
5. In the Manage Relationships dialog, click on the **New Relationship** button.
   :::image type="content" source="./media/configure-dataset/create-new-relationship.png" alt-text="New Relationship" lightbox="./media/configure-dataset/create-new-relationship.png":::
6. Enter the inputs for the relationship like Fact table name, dimension table name, surrogate column name, which should be created. Enter the join condition referring the example mentioned in the dialog. Finally, if you would like to copy a column from dimension table to fact table, add the column names in import columns input.
   :::image type="content" source="./media/configure-dataset/create-relationship.png" alt-text="Enter inputs for relationship" lightbox="./media/configure-dataset/create-relationship.png":::
7. Click on the **Save** button to create the relationship.

### Delete relationships

To delete existing relationships between tables, you can select the relationship and click on the **Delete** button. This removes the relationship from the dataset, but this won't delete the surrogate keys which are already created in the fact tables.
   :::image type="content" source="./media/configure-dataset/delete-relationship.png" alt-text="Delete Relationship" lightbox="./media/configure-dataset/delete-relationship.png":::

## Next steps

Now that you have configured source system and enabled dataset for extraction in your Business Process Solution item, you can proceed to run data replication and processing.

- [Run extraction and data processing in Business Process Solutions](run-extraction-data-processing.md)
