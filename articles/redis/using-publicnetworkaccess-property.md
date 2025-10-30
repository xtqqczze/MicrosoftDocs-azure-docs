---
title: how to use the property
description: how to use the property
ms.date: 10/30/2025
ms.topic: conceptual
---

# Introducing the PublicNetworkAccess property to Azure Managed Redis 

Customers noted that Azure Managed Redis couldn't disable public traffic without a private endpoint or allow both public and private access simultaneously—issues during scenarios like migrations. With the new PublicNetworkAccess property, you can now restrict public IP traffic independently of Private Links to Virtual Networks. The following network configurations are now supported:

- Public traffic without Private Links

- Public traffic with Private Links

- Private traffic without Private Links

- Private traffic with Private Links

## API changes

The Public Network Access property is introduced in [Microsoft.Cache redisEnterprise 2025-07-01](/azure/templates/microsoft.cache/2025-07-01/redisenterprise?pivots=deployment-language-bicep). Since this is a security-related breaking change, we will deprecate older API versions before 2025-07-01 in October 2026. This means after October 2026:

- You can only set PublicNetworkAccess property using API versions 2025-07-01 or later

- you can no longer send API calls with older versions prior to 2025-07-01

- your older caches provisioned with the older versions of the APIs will continue to work, but additional operations on it will require calls to be made with API versions 2025-07-01 or later

## Migrate Existing Azure Managed Redis to Use PublicNetworkAccess property

Follow the instructions below to add PublicNetworkAccess config to your existing Azure Managed Redis.

1.  Navigate to [Azure Portal](https://aka.ms/publicportal)

1.  Browse to your **Azure Managed Redis resource \| Administration \| Networking** UI

1.  The PublicNetworkAccess property is a required property with no value. Please set Allow or Disallow in the UI and save. NOTE that it is a irreversible operation – once set you cannot go back to unset state.

> **Figure 1: Set PublicNetworkAccess in existing Azure Managed Redis by choosing 'Disable' or 'Enable' public network access**
>
> :::image type="content" source="media/using-publicnetworkaccess-property/public-access-setting.png" alt-text="Screenshot of the Azure portal showing the PublicNetworkAccess property settings with options to disable or enable public network access.":::

## Best practices

We advise disabling PublicNetworkAccess and protecting your Azure Managed Redis by using a Virtual Network along with Private Endpoint and Private Links. A Virtual Network enables network controls and adds an extra layer of security. Private Links restrict traffic to one-way communication from the Virtual Network, offering enhanced network isolation. This means that even if the Azure Managed Redis resource is compromised, other resources within the Virtual Network remain secure.
