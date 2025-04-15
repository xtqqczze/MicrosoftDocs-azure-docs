---
title: FIPS 140-2 on Azure Application Gateway
description: Learn how to enable FIPS mode for Azure Application Gateway V2 SKU.
services: application gateway
author: jaesoni
ms.service: azure-application-gateway
ms.topic: concept-article
ms.date: 03/15/2025
ms.author: greglin
---

# FIPS 140 in Application Gateway (Preview)

Application Gateway V2 SKUs can run in a FIPS (Federal Information Processing Standard) 140-2 approved mode of operation, which is commonly referred to as "FIPS mode". With FIPS 140-2, Application Gateway supports cryptographic modules and data encryption with Level 2 validation. The FIPS mode calls a FIPS 140-2 validated cryptographic module that ensures FIPS-compliant algorithms for encryption, hashing, and signing when enabled.

## Clouds and Regions

| Cloud | Status  | Default behavior | 
| ---------- | ---------- | ---------- |
| Azure Government (Fairfax) | Supported (Preview) | Enabled |
| Public | Coming soon | Disabled |
| Microsoft Azure operated by 21Vianet (Mooncake) | Coming soon | Disabled |

Since FIPS 140 is mandatory for US federal agencies, Application Gateway V2 has FIPS mode enabled by default in Azure Government (Fairfax) cloud. Customers can disable FIPS mode if they have legacy clients using older cipher suites, though it is not recommended. For rest of the clouds, customers must opt-in to enable the FIPS mode.

## FIPS mode operation

Application Gateway utilizes a rolling upgrade policy to implement configurations with the FIPS validated cryptographic module across all instances. The duration for enabling or disabling FIPS mode may range from 15 to 60 minutes, depending on the number of configured or currently running instances. Throughout this process, the gateway will operate at a reduced capacity without requiring complete downtime. It is essential to plan this operation carefully to avoid any potential impact, in accordance with your business requirements.

> [!IMPORTANT]
> The FIPS mode configuration change can take anywhere between 15 to 60 minutes depending on the number of instances for your gateway.

Once enabled, the gateway will exclusively support TLS policies and cipher suites that comply with FIPS standards. Consequently, the portal will display only the restricted selection of TLS policies (both Predefined and Custom).

## Supported TLS policies

Application Gateway offers two mechanisms for controlling TLS policy. You can use either a Predefined policy or a Custom policy. For complete details, visit [TLS policy overview](application-gateway-ssl-policy-overview.md). A FIPS-enabled Application Gateway resource only suppports the following policies.

### Predefined
* AppGwSslPolicy20220101
* AppGwSslPolicy20220101S

### Custom V2
**Versions**
* TLS 1.3
* TLS 1.2 

**Cipher suites**

* TLS_AES_128_GCM_SHA256
* TLS_AES_256_GCM_SHA384
* TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
* TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
* TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
* TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256
* TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384
* TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
* TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
* TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 

Due to the restricted compatibility of TLS policies, enabling FIPS automatically selects AppGwSslPolicy20220101 for both "SSL Policy" and "SSL Profile". It can be modified to use other FIPS-compliant TLS policies later. To support legacy clients with other non-compliant cipher suites, it is possible to disable the FIPS mode, although this is not recommended for resources within the scope of FedRAMP infrastructure.

## Next steps

If you want to configure a TLS policy, you can do so via the Portal or use these [PowerShell commands](application-gateway-configure-ssl-policy-powershell.md).
