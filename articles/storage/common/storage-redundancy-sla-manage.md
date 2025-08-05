---
title: Managing the Azure Object and Geo-Redundant Storage Replication SLA
titleSuffix: Azure Storage
description: Enable and disable Geo-Redundant Storage Replication.
services: storage
author: stevenmatthew

ms.service: azure-storage
ms.topic: concept-article
ms.date: 08/05/2025
ms.author: shaas
ms.subservice: storage-common-concepts
ms.custom: references_regions, engagement
# Customer intent: "As a cloud architect, I want to understand the Azure Object and Geo-Redundant Storage Replication SLA so that I can understand what to expect in terms of data durability and high availability requirements."
---

<!--
Initial: 98 (896/1)
-->

# Manage Azure Geo-Redundant Storage replication

Geo Priority Replication is a premium feature designed to meet stringent Recovery Point Objectives (RPO) for geo-redundant storage accounts. It guarantees that the Last Sync Time (LST) remains within 15 minutes lag 99.0% of the time during a billing month.

## Enabling Geo-Redundant Storage replication
Geo Priority Replication can be enabled in two primary ways:

1.During Account Creation
Navigate to the Basics tab in the Azure Portal.
Select the checkbox for Priority Replication (Blob only).
📷

Account Creation UI

2.For Existing Accounts
Go to the Redundancy blade of your storage account.
Enable Priority Replication (Blob only).
📷

Redundancy Blade UI

3.Via PSH/CLI
Use PowerShell or CLI scripts to enable or disable the feature programmatically.
📷

CLI Enablement

4.Confirmation and Monitoring
Once enabled, a checkmark appears next to the feature.
Users can view geo lag metrics in the Insights and Metrics blades.
📷

Geo Lag Metrics

📊 Metrics Available
Once Geo Priority Replication is enabled, users gain access to several metrics:

1.Geo Blob Lag
Tracks the replication delay in seconds. SLA compliance requires this to stay under 900s (15 minutes).

📷

Geo Lag Chart - Within SLA

📷

Geo Lag Chart - SLA Breach

2.Reasons for SLA Ineligibility
Indicates guardrail breaches that make the account ineligible for SLA credits.

📷

Ineligibility Reasons

📷

Guardrail Breakdown

3.Historical Tracking
Metrics can be viewed over time, from 5 minutes to multiple months, helping users monitor SLA performance.

📷

Historical Geo Lag

⚠️ Performance Limitations and Guardrails
To ensure SLA eligibility, several guardrails must be respected:

Ingress Limit: Must be < 1 Gbps for block blob accounts.
CopyBlob Requests: Must not exceed 100 requests/sec.
Blob Types: Page and Append Blob API calls within the last 30 days make the account ineligible.
Initial LST: SLA only applies once LST is ≤ 15 minutes.
Catch-Up Time Formula
If ingress exceeds limits, SLA eligibility is paused. The catch-up time is calculated as:

(
r
spike
−
r
allowed
)
×
t
spike
/
(
r
allowed
−
r
final
)
(r 
spike
​
 −r 
allowed
​
 )×t 
spike
​
 /(r 
allowed
​
 −r 
final
​
 )

Example:

Spike: 5 Gbps for 1 hour
Final ingress: 0.5 Gbps
Catch-up time: 8 hours