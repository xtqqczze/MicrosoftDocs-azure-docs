---
title: "Quickstart: Add Service Group members using Portal - Azure Governance"
description: In this quickstart, you use REST API to add a resource to a service group with a service group member relationship.
author: rthorn17
ms.author: rithorn
ms.service: azure-policy
ms.topic: quickstart
ms.date: 5/19/2025
ms.custom:
  - build-2025
---


# Quickstart: Add resources or resource containers to service groups with Service Group Member Relationships in Portal 
 
To add resources, resource groups, or subscriptions to a Service Group (preview), you need to create a new Service Group Member Relationship. For more information on service groups, see [Getting started with Service Groups](overview.md).

> [!IMPORTANT]
> Azure Service Groups is currently in PREVIEW. 
> For more information about participating in the preview, see [Azure Service Groups Preview](https://aka.ms/ServiceGroups/PreviewSignup).
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Prerequisites

- If you don't have an Azure subscription, create a [free](https://azure.microsoft.com/free/)
  account before you begin.

- To be able to deploy a service group member relationship, you must have Microsoft.Relationship/ServiceGroupMember/write permissions on the source and Microsoft.ServiceGroup Contributor at the target service group. 

## Add members during service group creation 

1. When creating a new Service Group, there's an available tab to add members. 

[Picture]

2. Select to add individual resources, resource groups, or subscriptions. 

3. Once selected, you can filter the list as needed. 

4. If all members are chosen, select **Add**

5. Continue the service group creation flow. If all information is correct, select **Create**


## Add members to existing service group 

1. Log into the [Azure portal](https://aka.ms/portalfx/service-groups-internal).
2. Select **All services** > **Management + governance**.
3. Select **Service Groups**.
4. Select desired Service Group. 
5. Select **membership tab** on the left hand side. 
[Picture]
6. To add members, select the **+Add** button on the top action bar. Select to add individual resources, resource groups, or subscriptions. On the **Add members** pane, select and filter to the desired resources. Once all members are chosen, select **Add**. 
7. To remove members, select the members from the list of members and click **Delete** from the top action bar. 


## Remove members to existing service group

1. Log into the [Azure portal](https://aka.ms/portalfx/service-groups-internal).
2. Select **All services** > **Management + governance**.
3. Select **Service Groups**.
4. Select desired Service Group. 
5. Select **membership tab** on the left hand side. 
[Picture]
7. To remove members, select the members from the list of members and select **Delete** from the top action bar. 


## Next step

In this quickstart, you added members to service groups.

To learn more about service groups and how to manage your service group hierarchy, continue to:

> [!div class="nextstepaction"]
> [Manage your resources with service groups](manage-service-groups.md)

