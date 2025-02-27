---
title: "Orca Security Alerts connector for Microsoft Sentinel"
description: "Learn how to install the connector Orca Security Alerts to connect your data source to Microsoft Sentinel."
author: cwatson-cat
ms.topic: generated-reference
ms.date: 04/26/2024
ms.service: microsoft-sentinel
ms.author: cwatson
ms.collection: sentinel-data-connector
---

# Orca Security Alerts connector for Microsoft Sentinel

The Orca Security Alerts connector allows you to easily export Alerts logs to Microsoft Sentinel.

This is autogenerated content. For changes, contact the solution provider.

## Connector attributes

| Connector attribute | Description |
| --- | --- |
| **Log Analytics table(s)** | OrcaAlerts_CL<br/> |
| **Data collection rules support** | Not currently supported |
| **Supported by** | [Orca Security](https://orca.security/about/contact/) |

## Query samples

**Fetch all service vulnerabilities on running asset**

   ```kusto
OrcaAlerts_CL 
   | where alert_type_s == "service_vulnerability" 
   | where asset_state_s == "running" 
   | sort by TimeGenerated 
   ```

**Fetch all alerts with "remote_code_execution" label**

   ```kusto
OrcaAlerts_CL 
   | where split(alert_labels_s, ",") contains("remote_code_execution") 
   | sort by TimeGenerated 
   ```



## Vendor installation instructions


Follow [guidance](https://docs.orcasecurity.io/docs/integrating-azure-sentinel) for integrating Orca Security Alerts logs with Microsoft Sentinel.





## Next steps

For more information, go to the [related solution](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/orcasecurityinc1621870991703.orca_security_alerts_mss?tab=Overview) in the Azure Marketplace.
