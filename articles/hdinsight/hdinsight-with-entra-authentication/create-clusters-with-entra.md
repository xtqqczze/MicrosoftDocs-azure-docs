---
title: Create and Manage Azure HDInsight clusters enabled with Entra ID Authentication
description: Learn how to create Azure HDInsight clusters with Microsoft Entra ID Authentication
ms.service: azure-hdinsight
ms.topic: how-to
author: apurbasroy
ms.author: apsinhar
ms.reviewer: nijelsf
ms.date: 10/02/2025
---

# Create and manage Azure HDInsight cluster with Microsoft Entra ID authentication

In this article, you learn how to create and manage Azure HDInsight clusters with Microsoft Entra ID authentication.

Users can employ Entra ID to securely authenticate and manage access to HDInsight clusters, which helps to ensure enterprise-grade security and centralized identity governance.

With this capability, organizations can enforce role-based access, streamline user onboarding and offboarding, and enhance compliance by using existing Entra ID policies. It simplifies cluster security management while providing a seamless sign-in experience for data engineers, analysts, and administrators.

## Prerequisites

Before you begin, ensure the following requirements are met:

- Azure subscription: You must have an active Azure subscription with sufficient permissions to create HDInsight clusters.
- Microsoft Entra ID tenant:
  - Access to an Entra ID tenant linked to your Azure subscription
  - Permissions to create and assign Entra ID groups and roles
- Resource Group: A resource group in Azure where the HDInsight cluster can be deployed.
- HDInsight cluster requirements:
  - HDInsight cluster type (for example, Hadoop, Spark, HBase, or Kafka) that you're using for deployment
  - A region that supports Entra ID integration

## Overview

To set up Entra ID authentication when you create an HDInsight cluster, do the following steps:

1. Select the **Entra ID** authentication method.

1. When you create a cluster, add at least one Entra ID user with **admin** credentials.

   :::image type="content" source="./media/create-clusters-with-entra/creation-cluster.png" alt-text="Screenshot that shows the HDInsight cluster creation landing page." border="true" lightbox="./media/create-clusters-with-entra/creation-cluster.png":::

## User profiles in Ambari

You can assign Entra ID-enabled users one of two profiles:

- **Cluster Admin**: Admin permission.
- **Cluster User**: View-only permission.

>[!Note]
> You can only use one method of authentication for each cluster.
>
> - If you choose Entra ID authentication when you create a cluster, all users in the cluster must be authenticated by using Entra ID. During the entire lifecycle of that particular cluster, only Entra ID authentication can be used.
> - If you choose basic authentication when you create a cluster, all users in the cluster must be authenticated by using basic authentication. During the entire lifecycle of that particular cluster, only basic authentication can be used.

  :::image type="content" source="./media/create-clusters-with-entra/select-entra-button.png" alt-text="Screenshot that shows the HDInsight landing page and the Entra ID option." border="true" lightbox="./media/create-clusters-with-entra/select-entra-button.png":::

  :::image type="content" source="./media/create-clusters-with-entra/select-entra-user.png" alt-text="Screenshot that shows how to select the user's Entra ID when you choose a cluster admin."  border="true" lightbox="./media/create-clusters-with-entra/select-entra-user.png":::

## Sign-in options

Users can sign in via multifactor authentication (MFA) after they enter their Entra ID.

## Add users with an API

Admin can add multiple users at the same time by using an API, which is ideal to manage large clusters.

This operation allows users to change the cluster gateway HTTP credentials.

| **Method** | **Request URI** |
|------------|-----------------|
| POST | `https://management.azure.com/subscriptions/{subscription Id}/resourceGroups/{resourceGroup Name}/providers/Microsoft.HDInsight/clusters/{cluster name}/updateGatewaySettings?api-version={api-version}` |
| Entra cluster API version| Greater than or equal to `2025-01-15-preview`|

```json
		{ 
		"restAuthEntraUsers": [ 
			{ 
				"objectId": "0d7c4bd6-d042-45ec-9ae5-1ed7871c38e0", 
						"displayName": "Hemant Gupta", 
						"upn": "john@contoso.com" 
					} 
				] 
			} 
```

### Response

If the operation completes successfully, you receive the response `HTTP 202` (accepted).

## Authentication process

The authentication process varies based on the method you choose when you create a cluster.

If you choose Entra ID:

- The cluster creator provides an ID for the default cluster administrator user in Ambari.
- The default admin can add Ambari users after they create a cluster. Users might have either **Cluster Administrator** or **Cluster User** permissions. You can set these permissions via the Ambari UI or the REST API.
  - The cluster admin also has to fill in the **Object ID** and **Display name** fields, and then select **Save**.

 	:::image type="content" source="./media/create-clusters-with-entra/add-users.png" alt-text="Screenshot that shows users in the Ambari portal." border="true" lightbox="./media/create-clusters-with-entra/add-users.png":::

   :::image type="content" source="./media/create-clusters-with-entra/user-roles.png" alt-text="Screenshot that shows the Ambari pane where the cluster admin selects roles of newly added users." border="true" lightbox="./media/create-clusters-with-entra/user-roles.png":::

 - A multifactor authentication prompt appears when the user logs in with their Entra ID.

## Basic authentication

If you choose basic authentication

 - The user provides a User ID and password for the default admin user.

 - You can create new users with various roles, similar to current functionality.

 - Users are prompted to enter their User ID and password after they sign in.

## Add object ID in Ambari UI

1. Sign in to the Ambari portal.

   :::image type="content" source="./media/create-clusters-with-entra/login-page.png" alt-text="Screenshot the shows the Ambari landing page."  border="true" lightbox="./media/create-clusters-with-entra/login-page.png":::

1. Navigate to "**Manage Ambari**" option.

  :::image type="content" source="./media/create-clusters-with-entra/click-manage.png" alt-text="Screenshot that shows the Manage Ambari button on the Ambari landing page." border="true" lightbox="./media/create-clusters-with-entra/click-manage.png":::

1. Select the user tab to see all the current users.

  :::image type="content" source="./media/create-clusters-with-entra/open-user-tab.png" alt-text="Screenshot that shows the User tab." border="true" lightbox="./media/create-clusters-with-entra/open-user-tab.png":::

1. To add new users, select the **Add User** tab.

  :::image type="content" source="./media/create-clusters-with-entra/add-users.png" alt-text="Screenshot that shows users in the Ambari portal." border="true" lightbox="./media/create-clusters-with-entra/add-users.png":::

1. Complete the fields for **Object ID** and **Display name**. Define the user's access level by selecting **Cluster Administrator** or **Cluster User**. Select **Save**.

  :::image type="content" source="./media/create-clusters-with-entra/add-object-id.png" alt-text="Screenshot that shows the Add users tab in the Ambari portal."  border="true" lightbox="./media/create-clusters-with-entra/add-object-id.png":::
