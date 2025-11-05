---
title: Reference - Azure Policy guest configuration baseline for Windows Server 2025
description: Details of the Windows baseline on Azure implemented through Azure Policy guest configuration.
ms.date: 11/5/2025
author: ABMFST
ms.author: amirbredy
ms.topic: reference
ms.custom: generated
---
# Windows security baseline for Server 2025

This article details the configuration settings for Linux guests as applicable in the following
implementations:

- **Windows machines should meet requirements for the Azure compute security baseline**
  Azure Policy guest configuration definition
- **Vulnerabilities in security configuration on your machines should be remediated** in Microsoft Defender for Cloud

For the remediation checks and suggestions we took a best practices approach - however please always ensure that the commands will be tested and not applied blindly in any production environment. For automatic remediations, we've release in Limited Public Preview our new auto-remediation capability so you can test this policy with "DeployIfNotExist" action as well.

The new release of the policy for both audit and remediation is powered by [azure-osconfig](https://github.com/Azure/azure-osconfig)  our open-source engine.

For more information, see [Azure Policy guest configuration](../concepts/guest-configuration.md) and
[Overview of the Azure Security Benchmark (V2)](/azure/security/benchmarks/overview).


## General security controls


> [!NOTE]
> Availability of specific Azure Policy guest configuration settings may vary in Azure Government
> and other national clouds.

## Next steps

Additional articles about Azure Policy and guest configuration:

- [Azure Policy guest configuration](../concepts/guest-configuration.md).
- [Regulatory Compliance](../concepts/regulatory-compliance.md) overview.
- Review other examples at [Azure Policy samples](./index.md).
- Review [Understanding policy effects](../concepts/effects.md).
- Learn how to [remediate non-compliant resources](../how-to/remediate-resources.md).
