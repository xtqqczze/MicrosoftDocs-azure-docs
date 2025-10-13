---
title: Insights In Azure Migrate – Assess Risks, Plan Secure Cloud Migration
description: Discover how Azure Migrate's Insights (preview) feature helps identify vulnerabilities, end-of-support software, and missing security tools in your datacenter. Plan secure and efficient cloud migrations with early risk visibility and actionable insights.
author: habibaum
ms.author: v-uhabiba
ms.service: azure-migrate 
ms.topic: how-to 
ms.date: 09/19/2025
ms.custom: engagement-fy24 
::: moniker range="migrate"
# Customer intent: IT administrators and cloud architects use the Insights (preview) feature in Azure Migrate to identify and mitigate security risks in their datacenter during cloud migration planning. This helps them assess vulnerabilities, outdated software, and missing security tools to ensure a secure and efficient migration to Azure
---

# Insights in Azure Migrate: Assess and mitigate datacenter risks before migration (Preview)

This article describes the **Insights** (preview) feature in Azure Migrate, which provides a security assessment of the infrastructure and software inventory discovered in your datacenter.

## Key benefits of Insights: What users gain 

- See security risks in your datacenter early during migration planning.
- Plan mitigation to fix security issues and make your migration to Azure smooth and secure.
- Identify Windows and Linux servers running end-of-support operating systems or software and plan for upgrades and pending updates.
- Detect vulnerabilities in discovered software and take action to remediate risks.
- Identify servers without security or patch management software, and plan to configure [Microsoft Defender for Cloud](/azure/defender-for-cloud/) and [Azure Update Manager](../update-manager/overview.md).


## Security Insights data

Azure Migrate currently focuses on a core set of security risk areas. Each area corresponds to a specific security insight. The following table summarizes the available insights data.

| Resource | Security Insight | Details | 
| --- | --- | --- | 
| Servers  | With security risks </br> </br> OS end of support  </br> </br> Software end of support </br> </br> With vulnerabilities </br> </br> Missing security software </br> </br> Missing patch management software  </br> </br> Pending updates  | Servers are flagged if they have at least one of the following security risks: End-of-support operating system, End-of-support software, Known vulnerabilities (CVEs), Missing security or patch management software, Pending critical or security updates, Servers with end of support Operating system. </br> </br> Servers with end of support Operating system </br> </br> Servers with end of support Software discovered in Azure Migrate. </br> </br> Servers with known vulnerability (CVE) in OS and discovered software. </br> </br> Servers without any discovered software belonging to Security software category. </br> </br> Servers without any discovered patch management software </br></br> Servers with pending updates or patches.    | 
| Software  | With security risks </br> </br> End of support. </br> </br> With vulnerabilities.  | Software with at least one of the security risks – end of support, vulnerabilities. </br></br> Software declared end of support by vendor. </br> </br> Software with known vulnerability (CVE).   | 

### How Azure Migrate derives Insights from datacenter discovery

Azure Migrate identifies potential security risks in your datacenter by analyzing software inventory data collected during the discovery process. When you run a discovery of your on-premises environment, you provide guest credentials for Windows and Linux servers. It allows Azure Migrate to collect information about installed software, operating system configurations, and pending updates.
Azure Migrate processes this data to generate key security insights. It doesn't require any other credentials or permissions beyond these used during discovery.

>[!Note]
> Azure Migrate provides limited security insights based on quick discovery of software and operating systems. The feature doesn’t install agents or perform deep scans but analyzes inventory data against public vulnerability and lifecycle databases to identify risks.

Security risks are identified through the following analysis:

- **End-of-support software**: Azure Migrate compares discovered software versions against the public [repository](https://endoflife.date/). If a version isn't supported, then the vendor doesn't provide security updates, and it's marked as a security risk. Early identification helps you plan upgrades or mitigations during cloud migration.

    *Data is refreshed for every 30 days*.

- **Vulnerabilities**: Azure Migrate identifies installed software and operating systems, maps them to CPE identifiers, and correlates them with known Common Vulnerabilities and Exposures [CVE](https://www.cve.org/) IDs from the National Vulnerability Database [NVD](https://nvd.nist.gov/). Only software metadata is stored—no organization-specific data is captured. The system categorizes vulnerabilities by risk level using Common Vulnerability Scoring System [CVSS](https://nvd.nist.gov/vuln-metrics/cvss) scores. CVEs without scores are marked as Unknown. Azure Migrate also captures the age and publish date of each CVE. Data is refreshed to every 30 days. Azure Migrate accesses the NVD API but doesn't receive endorsement from NVD.

- **Pending Updates for servers**: Azure Migrate identifies Windows and Linux servers that aren't fully patched, based on metadata from Windows Update and Linux package managers. It classifies updates as Critical, Security, or Other, and refreshes data every 24 hours. Servers with pending critical or security updates are flagged, indicating they should be updated before or immediately after migration.

- **Missing security and Patch Management Software**: Azure Migrate flags servers as unprotected if no software is detected in the Security & Compliance category. Missing Security and Patch Management Software: Servers without antivirus, threat detection, SIEM, IAM, or patch management software are identified as potential security risks. 

- **Security Insights refresh**: Azure Migrate updates security insights whenever discovery data is refreshed—either through a new discovery run or inventory updates from the appliance. A full discovery is performed at the start of a project, with optional rescans before finalizing assessments. Any changes, such as new patches or software reaching end-of-life, are reflected in the updated insights. 

>[!Note]
> Security Insights in Azure Migrate help identify potential risks in your datacenter. They are not a substitute for specialized security tools. For full protection of your hybrid environment after migration, use Azure services such as [Microsoft Defender for Cloud](/azure/defender-for-cloud/) and [Azure Update Manager](../update-manager/overview.md).

## Prerequisites for reviewing Insights 

Ensure the following for reviewing Insights:

- Use [appliance-based discovery in Azure Migrate](how-to-review-discovered-inventory.md) to review Insights. [Import-based discovery](discovery-methods-modes.md) isn't supported.
- Use an existing project or create an [Azure Migrate project using portal](quickstart-create-project.md).
- Ensure all servers are in an active state. Azure Migrate purges data for servers that show no activity in the last 30 days.

## Review Insights 

To review insights in Azure Migrate:

1. Go to the **[Azure Migrate](https://portal.azure.com)** portal.
1. Select your project from **All Projects**.

    :::image type="content" source="./media/security-insights-overview/insights-preview.png" alt-text="Screenshot shows to select Insights." lightbox="./media/security-insights-overview/insights-preview.png":::

1. In the left menu, select **Explore inventory** > **Insights (preview)** to review security insights for the selected project. This page provides a summary of security risks across discovered servers and software. 
1. Select any insight to review detailed information. The summary highlights critical security risks in your datacenter that need immediate attention. It identifies:
    - Servers with critical vulnerabilities that benefit from enabling Microsoft Defender for Cloud after migration. 
    - Servers running end-of-support operating systems, recommending upgrades during migration.
    - The number of servers with pending critical and security updates, suggesting remediation using Azure Update Manager post-migration.

You can tag servers with critical risks to support effective planning and mitigation during modernization to Azure.

:::image type="content" source="./media/security-insights-overview/summary-card.png" alt-text="Screenshot shows the summary of critical security risks in the datacenter that needs attention." lightbox="./media/security-insights-overview/summary-card.png":::

### Review Server risk assessment

The **Servers** shows a summary of all discovered servers with security risks. A server is considered at risk if it has at least one of the following issues:

  - End-of-support operating system
  - End-of-support software
  - Known vulnerabilities (CVEs) in installed software or OS
  - Missing security or patch management software
  - Pending critical or security updates

    :::image type="content" source="./media/security-insights-overview/servers-card.png" alt-text="Screenshot shows the summarized view of all servers with security risks out of total discovered servers." lightbox="./media/security-insights-overview/servers-card.png":::


### Review Software risk assessment 

The **Software** shows a summary of all discovered software with security risks. Software is flagged as at risk if it is either end-of-support or has known vulnerabilities (CVEs). The card displays the number of end-of-support software and software with vulnerabilities as fractions of the total at-risk software.

:::image type="content" source="./media/security-insights-overview/software-card.png" alt-text="Screenshot provides aggregated view of all software with security risks out of total discovered software." lightbox="./media/security-insights-overview/software-card.png":::

## Review detailed Security Insights for a server 

The process of analyzing specific vulnerabilities, threats, or exposures identified within an environment, such as servers, software, or configurations.

### Review Servers with security risks

To review detailed security risks, follow these steps:

1. Open the **Insights** (preview) pane.
1. In the **Servers**, select the link that shows the number of servers with security risks.

    :::image type="content" source="./media/security-insights-overview/servers-risk-type.png" alt-text="Screenshot shows the servers with security risks." lightbox="./media/security-insights-overview/servers-risk-type.png":::

1. You can view the detailed list of discovered servers, apply tags to support migration planning, and export the server data as a .csv file.

    :::image type="content" source="./media/security-insights-overview/servers-with-security-risks.png" alt-text="Screenshot shows the detailed list of discovered servers." lightbox="./media/security-insights-overview/servers-with-security-risks.png":::

### View impacted servers by security risk

To view servers specific security risks, go to the **Insights (preview)** pane. There, you see a detailed list of servers affected due to the following issues:

 - End-of-support operating systems
 - End-of-support software
 - Known vulnerabilities (CVEs) in installed software or operating systems
 - Missing security or patch management tools
 - Pending critical and security updates

:::image type="content" source="./media/security-insights-overview/servers-impacted.png" alt-text="Screenshot shows the detailed list of servers impacted by each security risk." lightbox="./media/security-insights-overview/servers-impacted.png":::

Alternatively, you can filter servers with security risks from the **Explore inventory** > **All inventory** and **Explore inventory** > **Infrastructure** pane.

:::image type="content" source="./media/security-insights-overview/server-filters-with-security-risks.png" alt-text="Screenshot shows how to filter servers with security risks." lightbox="./media/security-insights-overview/server-filters-with-security-risks.png":::

### Review Software with security risks 

To review software with identified security risks, follow these steps:

1. Open the **Insights** (preview) pane.
1. In the **Software** card, select the link that shows the number of software items with security risks.

    :::image type="content" source="./media/security-insights-overview/software-with-security-risks.png" alt-text="Screenshot shows the number of software security risks." lightbox="./media/security-insights-overview/software-with-security-risks.png":::

1. You can view the detailed list of discovered software, examine associated metadata, and export the data as a .csv file.

    :::image type="content" source="./media/security-insights-overview/metadata-export-view.png" alt-text="Screenshot shows detailed list of discovered software and its metadata." lightbox="./media/security-insights-overview/metadata-export-view.png":::


1. To view software with specific security risks, go to the **Insights** (preview) pane. here, you see a detailed list of softwares affected due to the following issues:

    - End-of-support status
    - Known vulnerabilities (CVEs)

    :::image type="content" source="./media/security-insights-overview/software-impacted.png" alt-text="Screenshot shows detailed list of software impacted by each security risk." lightbox="./media/security-insights-overview/software-impacted.png":::

Alternatively, you can filter end-of-support software and software with known vulnerabilities from the **Explore inventory** > **Software** pane.

:::image type="content" source="./media/security-insights-overview/software-with-vulnerabilities.png" alt-text="Screenshot shows how to filter end of support software with vulnerabilities." lightbox="./media/security-insights-overview/software-with-vulnerabilities.png":::

### Review detailed Security Insights for a server 

To view detailed security insights for a specific server:

1. Go to the **Infrastructure** pane from the left menu and select the server you want to review.
1. Select the **Insights** (preview) tab.

The tab displays security insights for the selected server, including:

  - Operating system support status
  - Presence of security and patch management software
  - Pending critical and security updates
  - End-of-support software
  - Software with known vulnerabilities (CVEs)

The summary of the top five pending updates and top five vulnerabilities is provided to help prioritize remediation.

:::image type="content" source="./media/security-insights-overview/pending-updates.png" alt-text="Screenshot shows the top five pending updates." lightbox="./media/security-insights-overview/pending-updates.png":::

## Manage permissions for Security Insights 

Security insights are enabled by default for all users. To manage access, create custom roles and remove the following permissions:

| Resource | Permissions | 
| --- | --- | 
| Pending updates  | `.../machines/inventoryinsights/pendingUpdates`  | 
| Vulnerabilities  | `.../machines/inventoryinsights/vulnerabilities`  | 

>[!Note]
> Support status for operating systems and software is a machine-level property. User access to this information is determined by the permissions assigned at the machine level.

## Next steps

- Learn more about [permissions in Azure Migrate](/azure/role-based-access-control/permissions/migration#microsoftmigrate).
- Learn more about [creating custom role](/azure/role-based-access-control/role-definitions).
- Learn more about [Security cost in Business case](concepts-business-case-calculation.md).
- Learn more about [Assessments](concepts-overview.md).