---
title: Enable Availability Zones for Azure API Management Instances
description: Learn how to enable and configure availability zone support on your Premium tier Azure API Management instances to help ensure reliability.
author: dlepow 
ms.service: azure-api-management
ms.topic: how-to
ms.date: 11/12/2025
ms.author: danlep
ms.custom: references_regions, subject-reliability
#Customer intent: As an engineer responsible for business continuity, I want to learn how to enable zone redundancy for my Azure API Management instances. 
---

# Enable availability zone support on Azure API Management instances

[!INCLUDE [premium.md](../../includes/api-management-availability-premium.md)]

This article describes how to enable and configure availability zones on an Azure API Management instance.

For more detailed information about reliability features of API Management, such as availability zones and multiregion deployments, see [Reliability in API Management](../reliability/reliability-api-management.md).


## Availability zone support

While instances in the Premium and Premium v2 tiers benefit from availability zone support, the implementation differs between the two tiers.

| Premium | Premium v2 |
|---------|------------|
| Zone redundancy enabled automatically when you create a new instance or add a new location to an existing instance in a supported region.<br/><br/> Zonal or zone-redundant settings can also be manually configured. | Zone redundancy can optionally be enabled when creating an instance in a supported region.<br/><br/>Configuration in an existing instance isn't supported. |

#### [Premium](#tab/prem)

When you create a new API Management instance in the **Premium** tier in a region that supports availability zones, or you [deploy API Management to multiple regions](api-management-howto-deploy-multi-region.md), API Management provides two types of availability zone support:

- **Automatic:** API Management provides automatic availability zone support when you don't specify which availability zones to use.

- **Manual:** API Management provides manual availability zone support when you explicitly specify which availability zones to use.

> [!IMPORTANT]
> To ensure the reliability of your API Management instance, use the automatic availability zone support. To achieve maximum zone redundancy, deploy a minimum of two units in each region where you deploy API Management to ensure that an availability zone outage doesn't affect your instance. For more information, see [Reliability in API Management](../reliability/reliability-api-management.md).

## Manual availability zone support

We recommend automatic availability zone configuration, but you can manually configure or update availability zones for an existing location of your API Management instance. The following sections provide steps for manually configuring zone redundancy on an existing location of your API Management instance, depending on whether the instance is injected in a virtual network.

> [!NOTE]
> You can optionally enable a *zonal* configuration, where the API Management instance or location is deployed in a single availability zone. Because it doesn't provide resiliency to an outage in that zone, this configuration generally isn't recommended except for specific scenarios. For more information, see [Reliability in API Management](../reliability/reliability-api-management.md).

> [!CAUTION]
> If you manually configure availability zones on an API Management instance that's configured with autoscaling, you might need to adjust your autoscale settings after configuration. In this case, the number of API Management units in autoscale rules and limits must be a multiple of the number of zones. If you use the automatic availability zone support, you don't need to adjust your autoscale settings. 

#### [Premium v2](#tab/premv2)

In the **Premium v2** tier, you can enable availability zone support only when you create a new API Management instance in a supported region. Enabling zone redundancy is optional In this service tier, you don't have the option to view or modify availability zone settings on an existing instance.

## Prerequisites

#### [Premium](#tab/prem)

* Your instance must be in one of the [Azure regions that support availability zones](../reliability/regions-list.md).

* If you don't have an API Management instance, create one by following the [create a new API Management instance by using the Azure portal](../api-management/get-started-create-service-instance.md) quickstart. Select the **Premium** service tier.

* If you have an existing API Management instance, make sure that it's in the **Premium** (classic) tier. If it isn't, [upgrade to the Premium tier](../api-management/upgrade-and-scale.md#change-your-api-management-service-tier).

#### [Premium v2](#tab/premv2)

* Choose an Azure region that supports both [Premium v2 instances](api-management-region-availability.md) and [availability zones](../reliability/regions-list.md).

* For Azure CLI:
    [!INCLUDE [include](~/reusable-content/azure-cli/azure-cli-prepare-your-environment-no-header.md)]

---

## Configure availability zones

Follow these steps to enable availability zone support on your API Management instance.

#### [Premium](#tab/prem)

[!INCLUDE [api-management-service-update-behavior](../../includes/api-management-service-update-behavior.md)]

### Instance not injected in a virtual network

To manually configure availability zone support on an existing location of an API Management instance, follow these steps:

1. Thoroughly understand all [requirements and considerations for availability zones in API Management](../reliability/reliability-api-management.md).

1. In the Azure portal, go to your API Management instance.

1. On the **Deployment + infrastructure** menu, select **Locations**.

1. Select the location that you want to enable. The location must support availability zones, as mentioned earlier in the [prerequisites](#prerequisites).

1. Under **Units**, select the number of scale [units](../api-management/upgrade-and-scale.md) that you want in the location.

1. Under **Availability zones**, leave the **Automatic** setting (recommended), or optionally select one or more zones. If you select specific zones, the number of units that you select must distribute evenly across the availability zones. For example, if you select three units, you must select three zones so that each zone hosts one unit. 

1. Select **Apply**, then select **Save**.

:::image type="content" alt-text="Screenshot that shows availability zone configuration for an existing location of an API Management instance that's not injected in a virtual network." source ="media/enable-availability-zone-support/option-one-not-injected-in-vnet.png" lightbox="media/enable-availability-zone-support/option-one-not-injected-in-vnet.png":::

### Instance injected in a virtual network

To manually configure availability zone support on an existing location of an API Management instance that's injected in a virtual network, follow these steps:

1. Review all [requirements and considerations for enabling zone redundancy in API Management](../reliability/reliability-api-management.md).

1. Create a public IP address in the location to enable availability zones. For detailed requirements, see the [virtual networking guidance](../api-management/api-management-using-with-vnet.md?tabs=stv2#prerequisites).

1. In the Azure portal, go to your API Management instance.

1. On the **Deployment + infrastructure** menu, select **Locations**.

1. Select the location that you want to enable. The location must support availability zones, as mentioned earlier in the [prerequisites](#prerequisites).

1. Under **Units**, select the number of scale [units](../api-management/upgrade-and-scale.md) that you want in the location.

1. Under **Availability zones**, leave the **Automatic** setting (recommended), or optionally select one or more zones. If you select specific zones, the number of units that you select must distribute evenly across the availability zones. For example, if you select three units, you must select three zones so that each zone hosts one unit.

1. Under **Public IP Address**, select a public IP address in the location.

1. Select **Apply**, then select **Save**.

:::image type="content" alt-text="Screenshot that shows availability zone configuration for an existing location of an API Management instance that's injected in a virtual network." source ="media/enable-availability-zone-support/option-three-stv2-injected-in-vnet.png" lightbox="media/enable-availability-zone-support/option-three-stv2-injected-in-vnet.png":::

## New gateway location

To add a new location to your API Management instance and to configure availability zones in that location, follow these steps:

1. Thoroughly understand all [requirements and considerations for enabling availability zones in API Management](../reliability/reliability-api-management.md).

1. If your API Management instance is deployed in a virtual network in the primary location, set up a [virtual network](../api-management/api-management-using-with-vnet.md), subnet, and optional public IP address in the new location where you plan to enable availability zones.

1. In the Azure portal, go to your API Management instance.

1. On the **Deployment + infrastructure** menu, select **Locations**.

1. Select **+ Add** to add a new location. The location must support availability zones, as mentioned earlier in the [prerequisites](#prerequisites).

1. Under **Units**, select the number of scale [units](../api-management/upgrade-and-scale.md) that you want in the location.

1. Under **Availability zones**, leave the **Automatic** setting (recommended), or optionally select one or more zones. If you select specific zones, the number of units that you select must distribute evenly across the availability zones. For example, if you select three units, you must select three zones so that each zone hosts one unit.

1. If your API Management instance is deployed in a virtual network, under **Network**, select the virtual network, subnet, and public IP address that are available in the location.

1. Select **Add**, and then select **Save**.

:::image type="content" alt-text="Screenshot that shows selections for adding a new location for an API Management instance with or without a virtual network." source ="media/enable-availability-zone-support/option-four-add-new-location.png" lightbox="media/enable-availability-zone-support/option-four-add-new-location.png":::

#### [Premium v2](#tab/premv2)

Enable availability zones when you create a new API Management instance in the **Premium v2** tier by using the [API Management - Create or update service REST API](/rest/api/apimanagement/api-management-service/create-or-update). Set the `zoneRedundant` property to `true` in the request body.

For example, create a file named `request-body.json` with content similar to the following example. The location should be a region where the Premium v2 tier is available and availability zones are supported. Substitute your own values where appropriate:

```json
{
    "location": "East US 2",
    "sku": {
        "name": "PremiumV2",
        "capacity": 1
    },
    "properties": {
        "publisherEmail": "admin@contoso.com",
        "publisherName": "Contoso",
        "zoneRedundant": true
    }
}
```

Then, run the following Azure CLI script to create a new API Management instance in the **Premium v2** tier with zone redundancy enabled:

```azurecli
APIM_NAME={name of your new API Management instance}
# In PowerShell, use the following syntax for variable names: $APIM_NAME={name of your API Management instance}
RG_NAME={name of your resource group}
SUBSCRIPTION_ID={your Azure subscription ID}
# Call REST API to create Premium v2 instance with zone redundancy enabled
az rest --method put --uri "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.ApiManagement/service/$APIM_NAME?api-version=2024-10-01-preview" --body @request-body.json
```

## Related content

- [Reliability in API Management](../reliability/reliability-api-management.md)
- [Architecture best practices for API Management](/azure/well-architected/service-guides/azure-api-management)
- [Design review checklist for reliability](/azure/well-architected/reliability/checklist)
- [Azure services with availability zones](../reliability/availability-zones-service-support.md)
- [Azure regions with availability zones](../reliability/regions-list.md)
