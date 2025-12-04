---
title: Attestation Document
description: This article provides attestation document for Business Process Solutions.
author: mohitmakhija1
ms.service: sap-on-azure
ms.subservice:
ms.topic: overview
ms.custom: subject-monitoring
ms.date: 11/07/2025
ms.author: momakhij
---

# Attestation Document

This document provides details on how our BPS workload complies with the requirements for publishing in the Microsoft Fabric Workload Hub. The information outlined here will be kept up-to-date and linked in the Workload metadata manifest.

## Section I (ISV Information)

BPS workload is developed and maintained by Microsoft.

## Section II (Attestation Declaration)

Microsoft confirms that the requirements in Section III have been reviewed. We attest that the BPS workload meets and complies with all listed requirements.

## Section III (Requirements Checklist)

The following section address the Attestation of the publication requirements outlined in the Microsoft Fabric Workload Development Kit (WDK).

**Business Requirements**:
Value To Customers: The workload provides the following value to customers -
Business Process Solutions delivers a unified data foundation for business applications that accelerates AI adoption, simplifies automation and reduces risk – empowering businesses to unlock the full potential of unified data analytics and agentic intelligence. It includes prebuilt data models in Microsoft Fabric, data mapping and transformations, as well as prebuilt PowerBI dashboards and data agents. With Business Process Solutions we ensure data can be interacted with in a reliable and high-performant way, whether working with massive volumes or complex data structures.

**Trial**: We provide an easy and fast trial experience. The trial is available to the customer without waiting time (less than 5 seconds) and provides a free and easy way to explore the offered workload for a limited time in accordance with Microsoft guidelines for Trials.

- [] Yes
- [✔] No

**Monetization**: The workload is available on the marketplace for the customer to procure with or without a trial in accordance with the monetization guidelines

- [] Yes
- [✔] No

**Technical Requirements**:
Microsoft Entra Access: The workload(s) use Microsoft Entra authentication and authorization.

- [✔] No additional authentication and authorization mechanisms are used
- [] Additional authentication and authorization mechanisms are used for stored data In Fabric

**One Lake**: Workloads integrate with One Lake to store data in the standard formats supported by the Fabric platform so that other services can take advantage of it.

- [] All data and metadata is stored in One Lake or Fabric Data Stores
- [✔]  Not all data and metadata is stored in One Lake or Fabric Data Stores[AJ1.1][BM1.2][AJ1.3]

**Microsoft Entra Conditional Access**: Enterprise customers require centralized control and management of the identities and credentials used to access their resources and data and via Microsoft Entra to further secure their environment via conditional access⁵.

- [✔] The service works in its entirety even if customers enable this functionality
- []  The service works in with limitations if customers enable this functionality
- [] The service does not work with Microsoft Entra Conditional Access

**Admin REST API**: Admin REST APIs are an integral part of Fabric admin and governance process.

- []  Microsoft Fabric Admin API’s are being leveraged (/admin/*)
- [✔] No Microsoft Fabric Admin API’s are being used

**Customer Facing Monitoring & Diagnostic**: Health and telemetry data needs to be stored for a minimum for 30 days including activity ID for customer support purposes.

- [✔] Minimum 30 days requirement is adhered to

**Performance**: The Workload implementation takes measures to test and track performance of their Items

- [] Performance Metrics on workload performance are available via the monitoring hub
- [✔] Performance tracking is not currently available to the end user however workload team support can monitor, test, track performance via their internal instrumentation and monitoring systems.

**Presence**: To ensure that customer expectations independent of their home or capacity region are met, workload team need to align with fabric regions and clouds.

- Service availability and colocation/alignment in the following fabric regions: West Europe, North Europe, EastUS, Germany West Central, Central US.
Public APIs: Fabric Public APIs are the backbone of automation, enabling seamless communication and integration for both customers and partners within the Fabric ecosystem.
- The workload uses Fabric Public APIs

**Design / UX Requirements**:
Common UX: The workload and all item types the partner provides as part of it comply with the Fabric UX guidelines⁹.

- [✔] Yes
- [] No
**Item Creation Experience**: The item creation experience is in accordance with the Fabric UX System.

- [✔] Yes
- [] No

**Monitoring Hub**¹¹: All Long running operations need to integrate with Fabric Monitoring Hub.

- [] Yes
- [✔] No

**Trial Experience**: The workload provides a Trial Experience for users as outlined in the design guidelines¹²

- [] Trial Supported
- [✔] Trial Not Supported

**Monetization Experience**: The monetization experience is in line with the design guidelines¹³ provided

- [] The monetization experience is completely integrated with the marketplace and compliant with the guidelines
- [] Bring Your Own License (BYOL)
- [✔] Free / Freemium
- [] Other

**Accessibility**: The user experience is in compliance with the Fabric UX design guidelines for Accessibility¹⁴

- [✔] The user experience is completely compliant with the guidelines
- [] The following limitations exist

**World Readiness / Internationalization**: English is supported as the default language.

- [✔] English is the only supported language
- [] The following are the additional languages supported

**Item Settings**: Item settings are implemented as a part of the ribbon as outlined in the UX guidelines

- [✔] Yes
- [] No

**Samples**: Samples are optionally provided that preconfigure items of their type their type to help customers get started more easily.

- [✔] Samples not provided
- [] Samples for pre-configuration of items provided

Custom Actions: Custom actions can be optionally provided as a part of the item editor.

- [✔] Custom Actions are not implemented
- [] Custom Actions implemented as part of Workload

**Workspace settings**: Workspace settings provide a way that workloads can be configured on a workspace level.

- [] Supported
- [✔] Not Supported

**Global Search**: Searching for items in Fabric is supported through the top search bar.

- [] Supported
- [✔] Not supported

**Security / Compliance Requirements**:
Security general: Protection of customer data and metadata is of paramount importance. Our process includes comprehensive security reviews and assessments which are periodically performed. Any identified security issues that could impact customers are addressed with priority.
Privacy: Partners that build workloads also have a responsibility to protect that data when they access it.

**Extra Requirements**:

[✔] Publisher attests that only essential HTTP-only cookies are used by the Workload and only after positively authenticating the user.
[✔] Partner workloads aren't to use, write, or rely on third-party cookies
[✔] Publisher attests that is obtaining any Microsoft Entra token using the JavaScript APIs provided by the Fabric Workload Client SDK

**Data Residency**: Microsoft Fabric is making an Enterprise Promise around data not leaving the geography of the tenant.
Our service is deployed in a single region within each geographic area, and service metadata is maintained in accordance with the workspace's designated capacity region.

**Compliance**: The publisher attests to the following security, data and compliance regulations and standards. BPS is committed to ensuring Customers can trust our products and practices and meet their compliance obligations.

**Support**:
Live site: Partner workloads are an integral part of Fabric that requires the Microsoft support teams need to be aware of how to contact you in case customers are reaching out to us directly.

**ICM Contact Team**:  Azure Workloads Platform as Service/Azure Monitor for SAP - Engineering

**Fabric Features**:
Application Life Cycle Management (ALM): Microsoft Fabric's lifecycle management tools enable efficient product development, continuous updates, fast releases, and ongoing feature enhancements.

- [] Supported
- [✔] Not Supported

**Private Links**: In Fabric, you can configure and use an endpoint that allows your organization to access Fabric privately.

- [] Supported
- [✔] Not Supported

**Data Hub**: The OneLake data hub²⁵ makes it easy to find, explore, and use the Fabric data items in your organization that you have access to.

- [] Supported
- [✔] Not Supported

**Data Lineage**: Understanding the flow of data from the data source to its destination.

- [] Supported
- [✔] Not Supported

**Sensitivity labels**: Sensitivity labels from Microsoft Purview Information Protection on items can guard your sensitive content against unauthorized data access and leakage.

- [] Supported
- [✔] Not Supported
