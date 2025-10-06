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
| Servers | With security risks 
</br></br> OS end of support 
</br></br> Software end of support 
</br></br> With vulnerabilities 
</br></br> Missing security software| </br></br> Missing patch management software. 
</br> </br> Pending updates| Servers with security risks: These servers have one or more issues, such as outdated operating systems or software, known vulnerabilities, missing security tools, or pending updates. Servers running an end-of-support operating system. </br></br> Servers with end-of-support operating systems: These servers run operating systems that no longer receive vendor support.</br></br> Servers with vulnerabilities: These servers have known vulnerabilities (CVEs) in the operating system or discovered software. Servers missing security software: These servers don't have any discovered software categorized as security software. </br></br> Servers without any discovered patch management software. </br></br> Servers with pending updates or patches. | 
| Software | With security risks </br></br> End of support </br></br> With vulnerabilities| Software with at least one of the following risks: end-of-support status or known vulnerabilities. </br></br> Software that reached end-of-support status as declared by the vendor.</br></br> Software with known vulnerabilities (CVEs). | 

## How Azure Migrate derives Security Insights from datacenter discovery

Azure Migrate identifies potential security risks in your datacenter by analyzing software inventory data collected during the discovery process. When you run a discovery of your on-premises environment, you typically provide guest credentials for Windows and Linux servers. It allows Azure Migrate to collect information about installed software, operating system configurations, and pending updates.
Azure Migrate processes this data to generate key security insights. It doesn't require any other credentials or permissions beyond those used during discovery.

