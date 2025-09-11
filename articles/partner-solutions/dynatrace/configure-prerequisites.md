---
title: Configure Pre-Deployment for Azure Native Dynatrace Service
description: Learn how to complete the prerequisites for Dynatrace on the Azure portal. 
ms.topic: concept-article
ms.date: 09/15/2025

---

# Configure pre-deployment

This article describes the prerequisites that you must complete in your Azure subscription or Microsoft Entra ID before you create your first Dynatrace resource in Azure.

## Access control

To set up Dynatrace for Azure, you must have **Owner** or **Contributor** access on the Azure subscription. [Confirm that you have the appropriate access](../../role-based-access-control/check-access.md) before you start setup.

## Add an enterprise application

To use the SAML-based single sign-on (SSO) feature in the Dynatrace resource, you must set up an enterprise application. To add an enterprise application, you need either a Cloud Application Administrator or Application Administrator role.

1. Go to Azure portal. Select **Microsoft Entra ID** > **Enterprise App** > **New Application**.

1. Under **Add from the gallery**, enter **Dynatrace**. Select the search result and then select **Create**.

    :::image type="content" source="media/dynatrace-how-to-configure-prereqs/dynatrace-gallery.png" alt-text="Screenshot of the Dynatrace service in the Marketplace gallery." lightbox="media/dynatrace-how-to-configure-prereqs/dynatrace-gallery.png":::

1. After the app is created, go to properties from the side panel, and set the **User assignment required?** to **No**, then select **Save**.

    :::image type="content" source="media/dynatrace-how-to-configure-prereqs/dynatrace-properties.png" alt-text="Screenshot of the Dynatrace service properties.":::

1. Go to **Single sign-on** from the side panel. Then select **SAML**.

    :::image type="content" source="media/dynatrace-how-to-configure-prereqs/dynatrace-single-sign-on.png" alt-text="Screenshot of the Dynatrace single sign-on settings.":::

1. Select **Yes** when prompted to **Save single sign-on settings**.

   :::image type="content" source="media/dynatrace-how-to-configure-prereqs/dynatrace-saml-sign-on.png" alt-text="Screenshot of the Dynatrace S A M L settings.":::

## Next step

> [!div class="nextstepaction"]
> [Quickstart: Create a new Dynatrace environment](dynatrace-create.md)

    
