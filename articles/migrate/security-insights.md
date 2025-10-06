---
title: Security Insights In Azure Migrate
description: Helps capability in Azure Migrate, which provides security assessment of Infrastructure and Software inventory discovered in your datacenter.
author: habibaum
ms.author: v-uhabiba
ms.service: azure-migrate 
ms.topic: concept-article 
ms.date: 09/19/2025
ms.custom: engagement-fy24 
# Customer intent: .
---

# Security insights (preview) in Azure Migrate 

This article describes the **Security Insights** (preview) feature in Azure Migrate, which provides a security assessment of the infrastructure and software inventory discovered in your datacenter.

Key benefits

- Get early visibility into security risks in your datacenter during the migration planning stage.
- Plan mitigation strategies for identified security issues to ensure a smooth and secure migration to Azure.
- Identify Windows and Linux servers running end-of-support operating systems or software, and plan for upgrades and pending updates.
- Detect vulnerabilities in discovered software and take action to remediate risks.
- Identify servers that lack security or patch management software, and plan to configure of Microsoft Defender for Cloud and Azure Update Manager.


## Security insights data

Azure Migrate currently focuses on a core set of security risk areas. Each area corresponds to a specific security insight. The following table summarizes the available insights data.

| Resource | Security Insight | Details | 
| --- | --- | --- | 
| Servers | With security risks </br> </br> OS end of support </br> </br> Software end of support 
</br></br> With vulnerabilities </br></br> Missing security software| </br></br> Missing patch management software. </br> </br> Pending updates| Servers with security risks: These servers have one or more issues, such as outdated operating systems or software, known vulnerabilities, missing security tools, or pending updates. Servers running an end-of-support operating system. </br></br> Servers with end-of-support operating systems: These servers run operating systems that no longer receive vendor support.</br></br> Servers with vulnerabilities: These servers have known vulnerabilities (CVEs) in the operating system or discovered software. Servers missing security software: These servers don't have any discovered software categorized as security software. </br></br> Servers without any discovered patch management software. </br></br> Servers with pending updates or patches. | 
| Software | With security risks </br></br> End of support </br></br> With vulnerabilities| Software with at least one of the following risks: end-of-support status or known vulnerabilities. </br></br> Software that reached end-of-support status as declared by the vendor.</br></br> Software with known vulnerabilities (CVEs). | 

## How Azure Migrate derives Security Insights from datacenter discovery

Azure Migrate identifies potential security risks in your datacenter by analyzing software inventory data collected during the discovery process. When you run a discovery of your on-premises environment, you typically provide guest credentials for Windows and Linux servers. It allows Azure Migrate to collect information about installed software, operating system configurations, and pending updates.
Azure Migrate processes this data to generate key security insights. It doesn't require any other credentials or permissions beyond those used during discovery.

>[!Note]
> Azure Migrate provides limited security insights based on quick discovery of software and operating systems. It doesn’t install agents or perform deep scans, but analyzes inventory data against public vulnerability and lifecycle databases to identify risks.

Security risks are identified through the following analysis:

- **End-of-support software**: Azure Migrate compares discovered software versions against the public [repository](https://endoflife.date/). If a version is no longer supported—meaning the vendor has stopped providing security updates—it’s flagged as a security risk. Early identification helps you plan upgrades or mitigations during cloud migration.

*Data is refreshed every 30 days*.

- **Vulnerabilities**: Azure Migrate identifies installed software and operating systems, maps them to CPE identifiers, and correlates them with known [CVE](https://www.cve.org/) IDs from the National Vulnerability Database [NVD](https://nvd.nist.gov/). Only software metadata is stored—no organization-specific data is captured. Vulnerabilities are categorized by risk level using [CVSS](https://nvd.nist.gov/vuln-metrics/cvss) scores. CVEs without scores are marked as Unknown. Azure Migrate also captures the age and publish date of each CVE. Data is refreshed every 30 days. Azure Migrate uses the NVD API but is not endorsed by NVD.

- **Pending Updates for servers**: Azure Migrate identifies Windows and Linux servers that aren't fully patched, based on metadata from Windows Update and Linux package managers. It classifies updates as Critical, Security, or Other, and refreshes data every 24 hours. Servers with pending critical or security updates are flagged, indicating they should be updated before or immediately after migration.

- **Missing security and Patch Management Software**: Azure Migrate flags servers as unprotected if no software is detected in the Security & Compliance category. This includes missing antivirus, threat detection, SIEM, IAM, or patch management tools. Such servers are highlighted as potential security risks. 

- **Security Insights refresh**: Azure Migrate updates security insights whenever discovery data is refreshed—either through a new discovery run or inventory updates from the appliance. Typically, a full discovery is performed at the start of a project, with optional re-scans before finalizing assessments. Any changes, such as new patches or software reaching end-of-life, are reflected in the updated insights. 

>[!Note]
> **Security Insights scope**: Azure Migrate provides guidance on potential security risks in your datacenter but is not a replacement for specialized security tools. For comprehensive protection of your hybrid environment, it's recommended to adopt Azure security services after migration. 