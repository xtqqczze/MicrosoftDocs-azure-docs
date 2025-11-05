---
title: HTTP DDoS Ruleset (Preview)
titleSuffix: Azure Web Application Firewall
description: Learn about HTTP DDoS Ruleset in Azure Front Door Web Application Firewall (WAF).
author: joeolerich
ms.author: joeolerich
ms.service: azure-web-application-firewall
ms.topic: concept-article
ms.date: 11/18/2025
---

# HTTP DDoS ruleset (preview)

> [!IMPORTANT]
> HTTP DDoS ruleset in the Front Door Web Application Firewall (WAF) is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

HTTP‑layer floods remain the most frequent driver of application availability incidents, and static controls (IP/geo filters, fixed rate limits) often can’t keep pace with distributed botnets. The new HTTP DDoS ruleset is Azure WAF's first automated layer 7 protection model that learns, detects, and defends with minimal user configuration. Once assigned, the ruleset continuously baselines normal traffic for each Azure Front Door profile and when surges indicate an attack, selectively blocks offending clients with no emergency tuning required.

## How HTTP DDoS ruleset works

Once the DDoS Ruleset is applied to a policy that is attached to an Azure Front Door Premium profile, traffic baselines are calculated based on a rolling window.  For profiles which have received traffic for at least 50% of the past seven days, the ruleset will calculate baselines and detect spikes immediately. If the AFD profile has not received traffic for at least 50% of the past seven days, the ruleset will not detect or block attacks until sufficient traffic is present to determine baselines. 

Request thresholds are learned at the global profile level.  If a single WAF Policy configured with the HTTP DDoS Ruleset is assigned to multiple Azure Front Door profiles, the traffic thresholds will be computed separately for each profile the policy is attached too. 

The HTTP DDoS Ruleset learns both a global profile threshold as well as a per IP address threshold.  Until the profile threshold for requests is breached, the IP based thresholds will not trigger.  Once the profile threshold has been breached, the IPs thresholds are enforced and any IP address which breaches the baseline will be throttled at the rate of the learned baseline.  This allows the ruleset to not block spikes from a few IP addresses if they don’t cause the total request rate the profile is seeing to cross the threshold. 

Each rule in the HTTP DDoS Ruleset has three sensitivity levels corresponding with three different thresholds.  A higher sensitivity setting means having a lower threshold for that rule, and a low sensitivity means having a higher threshold.  Medium sensitivity is the default and recommended setting. 

The HTTP DDoS Ruleset is the first ruleset evaluated by the Azure WAF, even before the Custom Rule module.

> [!IMPORTANT]
> Any custom rules configured with *Allow* action won't bypass the HTTP DDoS ruleset, but will bypass all other WAF inspections.

## Ruleset rules

The HTTP DDoS Ruleset currently has two rules, and each can be configured with different sensitivity and action settings.  Each rule will maintain different traffic baselines for traffic which matches the rule criteria. 

- Rule 500100 - Anomaly detected on high rate of client requests – This rule tracks and establishes a baseline for all traffic on the profile a policy is attached to. When a client exceeds the established threshold, the corresponding action configured is triggered. 

- Rule 50110 - Suspected bots sending high rates of requests – This rule allows setting of different sensitivity based on traffic classified as bots by Microsoft Threat Intelligence.  For suspected Bots, the default threshold will be stricter than the default threshold for all other IPs. Bots classified as High Risk are blocked immediately by this rule while the global profile threshold is breached.

## Monitoring the HTTP DDoS ruleset

Some monitoring capabilities are limited during private preview.  Please note the monitoring options currently available for the HTTP DDoS Ruleset. 

- When each IP first breaches a threshold, a log entry will be recorded for that IP Address as a Block action for the HTTP DDoS Ruleset and increment the WAF Managed Rule Match Metric. 

- You can monitor the number of blocks using the Web Application Firewall Request Count metric and splitting it by Rule Name

## Accessing the preview

The ruleset needs to be enabled in each subscription where it will be used. Customers can do so by running the following PowerShell command -

Once a subscription is enabled, the ruleset can be configured via the Azure preview portal at preview.azure.com

## Known limitations during the preview

- No ability for traffic from specific IPs to bypass the DDoS ruleset or penalty box.

- Once the HTTP DDoS ruleset is assigned to a Web Application Firewall policy, any changes made to other managed rulesets using the production portal will remove the HTTP DDoS ruleset from the WAF Policy.

- PowerShell and CLI are currently not supported.

- No metrics are recorded for IPs in the penalty box.

