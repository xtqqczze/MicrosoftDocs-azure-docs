---
title: Configure SAP source system with Open Mirroring
description: Learn how to configure SAP S/4HANA and SAP ECC source systems with Open Mirroring in Business Process Solutions, including setting up source system connections.
author: mohitmakhija1
ms.service: sap-on-azure
ms.subservice:
ms.topic: overview
ms.custom: subject-monitoring
ms.date: 11/07/2025
ms.author: momakhij
---

# Configure SAP source system with Open Mirroring

In this article, we'll describe the steps required to configure SAP S/4 Hana and SAP ECC source system with Open Mirroring. This document contains details on how to set up the source system connection in your Business Process Solution item.

## Configure SAP S/4 HANA source system with Open Mirroring

Follow the steps below to configure your SAP S/4 HANA source system with Open Mirroring.

1. On the home screen, click on Configure source system button.
2. Click on the New source system button.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/create-source-system.png" alt-text="New source system button" lightbox="./media/configure-source-system-with-open-mirroring/create-source-system.png":::
3. Provide the inputs for the fields.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/create-om-source-system.png" alt-text="Provide SAP S4 HANA inputs for source system" lightbox="./media/configure-source-system-with-open-mirroring/create-om-source-system.png":::
4. In the System connection section, Select the name of the mirroring partner, you can also enter a custom name here, and add the connection id for the connection we created in the prerequisite step. Finally click on Create button to start the deployment.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/enter-om-details.png" alt-text="Enter SQL connection details" lightbox="./media/configure-source-system-with-open-mirroring/enter-om-details.png":::
5. You can monitor the deployment status by refreshing the page using the refresh button.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/source-system-creating.png" alt-text="Monitor deployment status" lightbox="./media/configure-source-system-with-open-mirroring/source-system-creating.png":::
6. Once the deployment is done, you should be able to see the resources deployed to your workspace.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/deployed-resources.png" alt-text="Deployed resources" lightbox="./media/configure-source-system-with-open-mirroring/deployed-resources.png":::

## Configure SAP ECC source system with Open Mirroring

1. On the home screen, click on Configure source system button.
2. Click on the New source system button.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/create-source-system.png" alt-text="Click on new source system button" lightbox="./media/configure-source-system-with-open-mirroring/create-source-system.png":::
3. Provide the inputs for the fields.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/enter-system-details.png" alt-text="Provide SAP ECC inputs for source system" lightbox="./media/configure-source-system-with-open-mirroring/enter-system-details.png":::
4. In the System connection section, Select the name of the mirroring partner, you can also enter a custom name here, and add the connection id for the connection we created in the prerequisite step. Finally click on Create button to start the deployment.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/enter-system-details.png" alt-text="Enter SQL connect for open mirroringion details" lightbox="./media/configure-source-system-with-open-mirroring/enter-system-details.png":::
5. You can monitor the deployment status by refreshing the page using the refresh button.
   :::image type="content" source="./media/configure-source-system-with-open-mirroring/source-system-creating.png" alt-text="Monitor deployment status" lightbox="./media/configure-source-system-with-open-mirroring/source-system-creating.png":::
6. Once the deployment is done, you should be able to see the resources deployed to your workspace.

## Next steps

With this configuration, we are ready to proceed with the next steps to configure dataset and relationships.

- [Configure Dataset in Business Process Solutions](configure-dataset.md)
