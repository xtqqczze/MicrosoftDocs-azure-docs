---
author: cephalin
ms.service: azure-app-service
ms.topic: include
ms.date: 11/28/2025
ms.author: cephalin
---

When you clone a configuration from another deployment slot, the cloned configuration is editable. Some configuration elements follow the content across a swap (they're *not slot specific*). Other configuration elements stay in the same slot after a swap (they're *slot specific*).

**When you swap slots, these settings are swapped:**

- Language framework settings (such as .NET version, Java version, PHP version, Python version, Node.js version)
- 32-bit vs 64-bit platform setting
- WebSockets enabled/disabled
- App settings (can be [configured to stick to a slot](../articles/app-service/deploy-staging-slots.md#make-an-app-setting-unswappable))
- Connection strings (can be [configured to stick to a slot](../articles/app-service/deploy-staging-slots.md#make-an-app-setting-unswappable))
- Mounted Azure Storage accounts (can be [configured to stick to a slot](../articles/app-service/deploy-staging-slots.md#make-an-app-setting-unswappable))
- Handler mappings
- Public certificates
- WebJobs content
- Hybrid connections
- Service endpoints
- Azure Content Delivery Network
- Path mappings
- Virtual network integration

**When you swap slots, these settings are not swapped (they remain with the slot):**

- Publishing endpoints
- Custom domain names
- Non-public certificates and TLS/SSL settings
- Scale settings
- WebJobs schedulers
- IP restrictions *
- Always On *
- Diagnostic log settings *
- Cross-origin resource sharing (CORS) *
- Managed identities
- Settings ending with the suffix `_EXTENSION_VERSION`
- Settings that [Service Connector](../articles/service-connector/overview.md) created

> [!NOTE]
> Settings marked with * can be made swappable by adding the app setting `WEBSITE_OVERRIDE_PRESERVE_DEFAULT_STICKY_SLOT_SETTINGS` to every slot of the app and setting its value to `0` or `false`. This reverts to legacy swap behavior from before these settings were made slot-specific. When you use this override, these marked settings become either all swappable or all not swappable. You can't make just some settings swappable and not the others. Managed identities are never swapped and this override app setting doesn't affect them.
>
> Certain app settings that apply to non-swapped settings are also not swapped. For example, because diagnostic log settings aren't swapped, related app settings like `WEBSITE_HTTPLOGGING_RETENTION_DAYS` and `DIAGNOSTICS_AZUREBLOBRETENTIONDAYS` are also not swapped, even if they don't show up as slot settings.
