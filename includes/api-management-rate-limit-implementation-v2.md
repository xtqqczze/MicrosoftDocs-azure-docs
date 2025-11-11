---
author: dlepow
ms.service: azure-api-management
ms.topic: include
ms.date: 11/10/2025
ms.author: danlep
---

In the v2 tiers, when using this policy to set token limits at more than one scope and using the same `counter-key` value, you must configure the same `tokens-per-minute` value in all instances of the policy. Otherwise, policy instances will behave unpredictably. This additional restriction is because of a change to the underlying rate-limiting implementation in the v2 tiers.