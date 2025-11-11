---
author: dlepow
ms.service: azure-api-management
ms.topic: include
ms.date: 11/10/2025
ms.author: danlep
---

In the v2 tiers, when configuring token limits at multiple scopes using the same `counter-key`, ensure that the `tokens-per-minute` value is consistent across all policy instances. Inconsistent values may result in unpredictable behavior due to changes in the rate-limiting implementation in v2 compared to classic tiers. [Learn more](../articles/api-management/api-management-sample-flexible-throttling.md#rate-limits)