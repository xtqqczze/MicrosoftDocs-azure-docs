---
title: Security Insights In Azure Migrate – Assess Risks, Plan Secure Cloud Migration
description: Describe Security Insights in Azure Migrate to assess infrastructure and software risks, detect vulnerabilities, and plan a secure migration to Azure.
author: habibaum
ms.author: v-uhabiba
ms.service: azure-migrate 
ms.topic: concept-article 
ms.date: 09/19/2025
ms.custom: engagement-fy24 
# Customer intent: To evaluate how Security Insights (preview) in Azure Migrate helps identify infrastructure and software risks during migration planning, enabling proactive remediation and a secure transition to Azure.
---

# Security Insights (preview) in Azure Migrate 

This article describes the **Security Insights** (preview) feature in Azure Migrate, which provides a security assessment of the infrastructure and software inventory discovered in your datacenter.

Key benefits

- Get early visibility into security risks in your datacenter during the migration planning stage.
- Plan mitigation strategies for identified security issues to ensure a smooth and secure migration to Azure.
- Identify Windows and Linux servers running end-of-support operating systems or software, and plan for upgrades and pending updates.
- Detect vulnerabilities in discovered software and take action to remediate risks.
- Identify servers that lack security or patch management software, and plan to configure of Microsoft Defender for Cloud and Azure Update Manager.


## Security Insights data

Azure Migrate currently focuses on a core set of security risk areas. Each area corresponds to a specific security insight. The following table summarizes the available insights data.

| Resource | Security Insight | Details | 
| --- | --- | --- | 
| Servers  | With security risks </br> </br> OS end of support   | Servers are flagged if they have at least one of the following security risks: End-of-support operating system, End-of-support software, Known vulnerabilities (CVEs), Missing security or patch management software, Pending critical or security updates, Servers with end of support Operating system. </br> </br> Servers with end of support Operating system   | 
| Resource | Security Insight | Details | 

### How Azure Migrate derives Security Insights from datacenter discovery

Azure Migrate identifies potential security risks in your datacenter by analyzing software inventory data collected during the discovery process. When you run a discovery of your on-premises environment, you typically provide guest credentials for Windows and Linux servers. It allows Azure Migrate to collect information about installed software, operating system configurations, and pending updates.
Azure Migrate processes this data to generate key security insights. It doesn't require any other credentials or permissions beyond these used during discovery.

>[!Note]
> Azure Migrate provides limited security insights based on quick discovery of software and operating systems. It doesn’t install agents or perform deep scans, but analyzes inventory data against public vulnerability and lifecycle databases to identify risks.

Security risks are identified through the following analysis:

- **End-of-support software**: Azure Migrate compares discovered software versions against the public [repository](https://endoflife.date/). If a version isn't supported, then the vendor doesn't provide security updates, and it's marked as a security risk. Early identification helps you plan upgrades or mitigations during cloud migration.

*Data is refreshed for every 30 days*.

- **Vulnerabilities**: Azure Migrate identifies installed software and operating systems, maps them to CPE identifiers, and correlates them with known [CVE](https://www.cve.org/) IDs from the National Vulnerability Database [NVD](https://nvd.nist.gov/). Only software metadata is stored—no organization-specific data is captured. The system categorizes vulnerabilities by risk level using [CVSS](https://nvd.nist.gov/vuln-metrics/cvss) scores. CVEs without scores are marked as Unknown. Azure Migrate also captures the age and publish date of each CVE. Data is refreshed to every 30 days. Azure Migrate accesses the NVD API but doesn't receive endorsement from NVD.

- **Pending Updates for servers**: Azure Migrate identifies Windows and Linux servers that aren't fully patched, based on metadata from Windows Update and Linux package managers. It classifies updates as Critical, Security, or Other, and refreshes data every 24 hours. Servers with pending critical or security updates are flagged, indicating they should be updated before or immediately after migration.

- **Missing security and Patch Management Software**: Azure Migrate flags servers as unprotected if no software is detected in the Security & Compliance category.Missing Security and Patch Management Software: Servers without antivirus, threat detection, SIEM, IAM, or patch management software are identified as potential security risks. 

- **Security Insights refresh**: Azure Migrate updates security insights whenever discovery data is refreshed—either through a new discovery run or inventory updates from the appliance. Typically, a full discovery is performed at the start of a project, with optional rescans before finalizing assessments. Any changes, such as new patches or software reaching end-of-life, are reflected in the updated insights. 

>[!Note]
> **Security Insights scope**: Azure Migrate provides guidance on potential security risks in your datacenter but is not a replacement for specialized security tools. For comprehensive protection of your hybrid environment, it's recommended to adopt Azure security services after migration. 

## Prerequisites for reviewing Insights 

- Use [appliance-based discovery in Azure Migrate](how-to-review-discovered-inventory.md) to review Insights (preview). [Import-based discovery](discovery-methods-modes.md) isn't supported.
- Create an [Azure Migrate project using portal](quickstart-create-project.md) by following the steps or use an existing project.
- Ensure all servers are in an active state. Azure Migrate purges data for servers that show no activity in the last 30 days.

## Review Security Insights 

To view security insights in Azure Migrate:

1. Go to the **Azure Migrate** portal.
1. Select your project from **All Projects**.

    :::image type="content" source="./media/security-insights-overview/insights-preview.png" alt-text="Screenshot shows to select Insights." lightbox="./media/security-insights-overview/insights-preview.png":::

1. In the left menu, select **Explore inventory** > **Insights (preview)** to view security insights for the selected project.
    
    This page provides a summary of security risks across discovered servers and software. Select any insight to view detailed information.

    1. The summary highlights critical security risks in your datacenter that need immediate attention. It identifies:
    1. Servers with critical vulnerabilities that benefit from enabling Microsoft Defender for Cloud after migration. 
    1. Servers running end-of-support operating systems, recommending upgrades during migration.
    1. The number of servers with pending critical and security updates, suggesting remediation using Azure Update Manager post-migration.

You can tag servers with critical risks to support effective planning and mitigation during modernization to Azure.

    :::image type="content" source="./media/security-insights-overview/summary-card.png" alt-text="Screenshot shows the summary of critical security risks in the datacenter that needs attention." lightbox="./media/security-insights-overview/summary-card.png":::

1. **Servers** card shows a summary of all discovered servers with security risks. A server is considered at risk if it has at least one of the following issues:

- End-of-support operating system
- End-of-support software
- Known vulnerabilities (CVEs) in installed software or OS
- Missing security or patch management software
- Pending critical or security updates

    :::image type="content" source="./media/security-insights-overview/servers-card.png" alt-text="Screenshot shows the summarized view of all servers with security risks out of total discovered servers." lightbox="./media/security-insights-overview/servers-card.png":::

1. **Software** card shows a summary of all discovered software with security risks. Software is flagged as at risk if it is either end-of-support or has known vulnerabilities (CVEs). The card displays the number of end-of-support software and software with vulnerabilities as fractions of the total at-risk software.

    :::image type="content" source="./media/security-insights-overview/software-card.png" alt-text="Screenshot provides aggregated view of all software with security risks out of total discovered software." lightbox="./media/security-insights-overview/software-card.png":::

## Review detailed security risks 

The process of examining specific security vulnerabilities identified in your environment.

### Review Servers with security risks

To review detailed security risks, follow the below steps:

1. Open the **Insights** (preview) page.
1. In the **Servers** card, select the link that shows the number of servers with security risks.

    :::image type="content" source="./media/security-insights-overview/servers-risk-type.png" alt-text="Screenshot shows the servers with security risks." lightbox="./media/security-insights-overview/servers-risk-type.png":::

1. You can view the detailed list of discovered servers, apply tags to support migration planning, and export the server data as a .csv file.

    :::image type="content" source="./media/security-insights-overview/servers-with-security-risks.png" alt-text="Screenshot shows the detailed list of discovered servers." lightbox="./media/security-insights-overview/servers-with-security-risks.png":::

### View impacted servers by security risk

To view servers impacted by specific security risks, return to the Insights (preview) page. From there, you can access a detailed list of servers affected by:

- End-of-support operating systems
- End-of-support software
- Known vulnerabilities (CVEs) in installed software or operating systems
- Missing security or patch management tools
- Pending critical and security updates

    :::image type="content" source="./media/security-insights-overview/servers-impacted.png" alt-text="Screenshot shows the detailed list of servers impacted by each security risk." lightbox="./media/security-insights-overview/servers-impacted.png":::

1. Alternatively, you can filter servers with security risks from the **Explore inventory** > **All inventory** and **Explore inventory** > **Infrastructure** page.

    :::image type="content" source="./media/security-insights-overview/server-filters-with-security-risks.png" alt-text="Screenshot shows how to filter servers with security risks." lightbox="./media/security-insights-overview/server-filters-with-security-risks.png":::

### Review Software with security risks 

To review software with identified security risks, follow these steps:

1. Open the **Insights** (preview) page.
1. In the **Software** card, select the link that shows the number of software items with security risks.

Add screen

1. You can view the detailed list of discovered software, examine associated metadata, and export the data as a .csv file.

Add screen

1. To view software impacted by specific security risks, return to the Insights (preview) page. From there, you can access a detailed list of software affected by:
    - End-of-support status
    - Known vulnerabilities (CVEs)
Add screen

1. Alternatively, you can filter end-of-support software and software with known vulnerabilities from the **Explore inventory** > **Software** page.

Add screen

### Review detailed Security Insights for a server 

To view detailed security insights for a specific server:

1. Go to the **Infrastructure** page and select the server you want to review.
1. Select the **Insights** (preview) tab.

The tab displays security insights for the selected server, including:

- Operating system support status
- Presence of security and patch management software
- Pending critical and security updates
- End-of-support software
- Software with known vulnerabilities (CVEs)

The summary of the top five pending updates and top five vulnerabilities is provided to help prioritize remediation.

Add screen

## Manage permissions for Security Insights 

Security insights are enabled by default for all users. To manage access, create custom roles and remove the following permissions:

- View security insights
- Access vulnerability data
- View update status

| Resource | Permissions | 
| --- | --- | 
| Pending updates  | `.../machines/inventoryinsights/pendingUpdates`  | 
| Vulnerabilities  | `.../machines/inventoryinsights/vulnerabilities`  | 

>[!Note]
> Support status for operating systems and software is a machine-level property. User access to this information is determined by the permissions assigned at the machine level.