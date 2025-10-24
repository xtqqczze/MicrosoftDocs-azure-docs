---
title: SAP Testing Automation Framework Configuration Checks
description: Learn about configuration validation checks in the SAP Testing Automation Framework
author: devanshjain
ms.author: devanshjain
ms.reviewer: depadia
ms.topic: reference
ms.service: sap-on-azure
ms.subservice: sap-automation
ms.date: 10/19/2025
ms.custom: devx-track-azurecli, devx-track-azurepowershell, linux-related-content
---

# SAP Testing Automation Framework: Configuration Checks (Preview)

The SAP Testing Automation Framework includes comprehensive configuration validation capabilities to ensure SAP systems comply with best practices and guidelines for deployments on Microsoft Azure. These configuration checks help identify potential issues that could impact system performance, reliability, and compliance.

## Overview

Configuration validation is a critical component of the testing framework that performs nonintrusive checks to validate system configurations against SAP on Azure best practices. These checks help identify configuration issues before they impact production systems. The framework validates various aspects of the SAP system, including infrastructure settings, operating system parameters, storage configurations, and cluster resource settings.

These checks are designed to be nonintrusive, meaning they don't modify the system or require downtime. Instead, they analyze existing configurations and provide detailed reports highlighting any deviations from recommended practices.

> [!NOTE]
>
> The configuration checks in SAP Testing Automation Framework is currently in public preview.

### Configuration Validation Checks

Configuration validation acts as a quality gate in the SAP deployment lifecycle by:

- **Validating Azure Infrastructure:** Confirms compute, storage, and network settings align with SAP on Azure best practices.
- **Verifying SAP Parameters:** Checks key SAP HANA and application server parameters for correctness.
- **Assessing Cluster Health:** Validates Pacemaker configuration, fencing, and resource constraints.
- **Ensuring Compliance:** Confirms alignment with SAP and organizational security policies.

## Next Steps

- [Learn about High Availability testing](testing-framework-high-availability.md)
- [Review the framework architecture](testing-framework-architecture.md)
- [Understand supported platforms](testing-framework-supportability.md)