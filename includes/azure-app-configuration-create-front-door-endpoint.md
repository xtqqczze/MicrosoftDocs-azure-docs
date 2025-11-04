---
author: maud-lv
ms.author: malev
ms.service: azure-app-configuration
ms.topic: include
ms.date: 02/14/2023
---

   1. Basic settings:

      - **Endpoint name**: Enter a descriptive name for your endpoint
      - **Endpoint host name**: Automatically generated based on your endpoint name
      - **Origin host name**: Select your App Configuration store and any replicas from the dropdown. These are added to the origin group so Azure Front Door can route traffic to them. For details on how origin groups improve availability and performance, see [Azure Front Door routing methods](/azure/frontdoor/routing-methods).

        :::image type="content" source="media/how-to-connect-azure-front-door/endpoint-details.png" alt-text="Screenshot showing  Azure Front Door endpoint details in the App Configuration store."

   1. **Identity type**: Choose the managed identity type for Azure Front Door to access your App Configuration store:

      - **System assigned managed identity**: Automatically enabled; no additional selection required.
      - **User assigned managed identity**: Select the managed identity from the dropdown.

   1. **Cache Duration for Azure Front Door**: Configure cache duration to balance performance and origin load. We recommend a minimum TTL of 10 minutes, but you can choose a value that fits your application. Content loaded from AFD will be eventually consistent. Setting the cache duration too short may increase origin requests and lead to throttling. For more details about caching, see [Caching with Azure Front Door](/azure/frontdoor/front-door-caching).

   1. **Filter Configuration to scope the request**: Configure one or more filters to control which requests pass through Azure Front Door. This prevents accidental exposure of sensitive configuration and ensures only the settings your application needs are accessible. The filters here must exactly match those used in your application code; otherwise, requests will be rejected by Azure Front Door.
      
      - Specify the **Key**, **Label**, and **Tag** filters to narrow down the key values available for retrieval through Front Door.
      - Select one or more **Snapshot name**s to restrict access to specific snapshots.