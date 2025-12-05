---
title: "Quickstart: Get started with Azure Native New Relic Service"
description: Learn how to create an Azure Native New Relic Service in the Azure portal.
ms.topic: quickstart
ms.date: 12/11/2025
---

# Quickstart: Get started with Azure Native New Relic Service

In this quickstart, you create an instance of Azure Native New Relic Service.

## Prerequisites

[!INCLUDE [create-prerequisites](../includes/create-prerequisites.md)]
- You must [subscribe to New Relic](overview.md#subscribe-to-new-relic).

## Create a New Relic SaaS resource

Begin by signing in to the [Azure portal](https://portal.azure.com/).

1. In the Azure portal, in the search box, enter **Marketplace**. Select **Marketplace**. 
1. In the Marketplace search box, enter **New Relic**.
1. Select the **New Relic Observability Platform - Private Offers** card.
1. On the **New Relice Observability Platform - Private Offers** page, select **Subscribe**.

### Basics tab

The *Basics* tab has two sections:

- Project details
- SaaS details

:::image type="content" source="media/create/basics-tab.png" alt-text="A screenshot of the Create a New Relic resource in Azure options inside of the Azure portal's working pane with the Basics tab displayed.":::

There are required fields (identified with a red asterisk) in each section that you need to fill out.

1. Enter the values for each required setting under *Project details*.

    | Field               | Action                                                    |
    |---------------------|-----------------------------------------------------------|
    | Subscription        | Select a subscription from your existing subscriptions.   |
    | Resource group      | Use an existing resource group or create a new one.       |

1. Enter the values for each required setting under *SaaS details*.

    | Field              | Action                                    |
    |--------------------|-------------------------------------------|
    |     Name   |   Enter a name for the SaaS subscription.  | 

### Tags tab (optional)

Optionally, you can create tags for your resource. Then select **Review + subscribe**.

### Review + subscribe tab 

If the review finds no errors, the **Subscribe** button becomes active. Select Create.

If the review identifies errors, a red dot appears next to each section where errors exist. To fix errors:

1. Open each section that has errors and fix the errors.

1. Fields with errors are highlighted in red.

1. Select **Review + subscribe** again.

1. Select **Subscribe**.

The message "Your SaaS subscription is in progress" appears. When the deployment is complete, the message "Almost done! Next, configure your account on the publisher's website" appears in the upper-right corner of the Azure portal.
 
1. Select **Configure account now**.

1. On the **SaaS Overview** page, you'll see your new resource. Select the checkbox next to the resource, and then select **Activate Resource**. 

1. After the resource is activated,  

### Metrics and logs tab (optional)

If you wish, you can configure resources to send metrics/logs to New Relic. 

> [!TIP]
> You can collect metrics for virtual machines and app services by installing the New Relic agent after you create the New Relic resource.

- Select **Enable metrics collection** to set up monitoring of platform metrics.
- Select **Subscription activity logs** to send subscription-level logs to New Relic.
- Select **Azure resource logs** to send Azure resource lots to New Relic. 

> [!IMPORTANT]
> When the checkbox for Azure resource logs is selected, logs are forwarded for all resources by default.

#### Inclusion and exclusion rules for metrics and logs

To filter the set of Azure resources that send logs to New Relic, use inclusion and exclusion rules and set Azure resource tags:

- All Azure resources with tags defined in include rules send logs to New Relic.
- All Azure resources with tags defined in exclude rules don't send logs to New Relic.

> [!NOTE]
> If there's a conflict between inclusion and exclusion rules, the exclusion rule applies.

-  After you finish configuring metrics and logs, select **Next**.

### Tags tab (optional)

[!INCLUDE [tags](../includes/tags.md)]

### Review + create tab

[!INCLUDE [review-create](../includes/review-create.md)]

## Next steps

- [Set up your New Relic account configuration](https://docs.newrelic.com/docs/infrastructure/microsoft-azure-integrations/get-started/azure-native/#view-your-data-in-new-relic)
- [Manage the New Relic resource in the Azure portal](manage.md)
