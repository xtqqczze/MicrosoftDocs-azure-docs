---
title: Schedule tasks with Azure SRE Agent (Preview)
description: Learn how to use scheduled tasks in Azure SRE Agent to automate monitoring, enforce security, and validate recovery.
author: craigshoemaker
ms.topic: overview
ms.date: 10/27/2025
ms.author: cshoe
ms.service: azure-sre-agent
---

# Scheduled tasks in Azure SRE Agent (Preview)

Use Azure SRE Agent to automate routine monitoring, maintenance, and security tasks in your Azure environment with tasks that run on a schedule you define. You can either create a task manually, ask the agent to create one during a chat, or the agent could autonomously create one for you as the result of an [incident response](incident-response-plan.md).

The following scenarios show you some common use cases for using scheduled tasks:

> [!NOTE]
> This list isn't meant to be comprehensive, but it describes different ways you can use scheduled tasks in your environment.

- **Custom monitoring**: Monitor resource health where alerts aren't configured.
- **Security best practices**: Run vulnerability scans and compliance checks on applications.
- **Post-incident health checks**: Validate database recovery and API health after mitigation.

## Create a scheduled task

1. Open your agent in the Azure portal.

1. Select the **Scheduled Tasks** tab.

1. Select **Create scheduled task**.

1. Enter the following values in the *Create scheduled task* window:

    | Setting | Value |
    |--|--|
    | Name | Enter a name for your task. |
    | Description | Enter a description for your task. |
    | When should this task run? | Enter a description in plain English that describes when you want this task to run. |
    | How often should it run? | Enter a description in plain English that describes how often your task runs. For example, you could enter *Wednesdays at 9am Pacific*.<br><br>Once you enter details on when and how often you want your task to run, you can select the **Draft the cron for me** to have the portal turn your description into a cron expression for use by the agent. |
    | End date | Enter the last date you want this task to run. |
    | Agent instructions | Enter a description of what you want your task to do. See the [examples](#examples) for suggestions on how you can craft your custom instructions.<br><br>You can use the **Polish instructions** button to let the AI model improve the prompt you give it. |
    | Max executions | Enter the maximum number of times you want this task to run.<br><br>The value you enter here takes precedence over the *End date* value. |

1. Select the **Create scheduled task** button.

## Best practices

- Write prompts that are concise and specific.
- Use compliance frameworks for security-related tasks.
- Avoid ambiguous schedules (for example, "every hour" without an end condition).

## Examples

The following examples demonstrate a few sample sets of custom instructions you could define for a scheduled task.

> [!NOTE]
> These custom instructions use placeholders to represent sensitive data.

# [Health check](#tab/health-check)

This task runs every minute (up to 30 times) after a database restart to check that PostgreSQL is healthy, connections succeed, and API/web services have no errors or slow responses.

- On failure, it collects logs, notifies you, and escalates if the database is down.
- On success, it records a summary.
- At completion, it generates a PDF report with metrics, logs, and a pass/fail summary.

```Text
This task runs autonomously every 1 minute for up to 30 
executions to validate post-recovery health after DB startup.

Goal: confirm <APP_NAME> services remain healthy and that 
listings are served. Resources & scope:

- Container Apps: /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.App/containerapps/<APP_NAME>
- Container Apps: /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.App/containerapps/<APP_NAME>
- PostgreSQL Flexible Server: /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.DBforPostgreSQL/flexibleServers/<DATABASE_NAME>

Time window and data range:

Analyze ONLY the last 60 seconds of metrics/logs on each 
run (do NOT scan full history).

Checks (success criteria):

1) PostgreSQL 'is_db_alive' == 1 (healthy)
2) PostgreSQL 'connections_failed' == 0 in last minute
3) PostgreSQL 'connections_succeeded' 0 (indicates traffic)
4) API (<APP_NAME>) Requests 5xx count == 0 in last minute
5) API ResponseTime p95 < 2000 ms (adjust if noisy)
6) Web (<APP_NAME>-web) Requests 5xx count == 0 in last minute

On-breach actions (any check fails):

- Immediately capture last 50 console log lines from 
the impacted container app (web or api) and last 200 
lines from postgres server diagnostic logs (if available).

- Send a notification summary containing the failing 
metric, its current value, and attached logs.

- If the DB shows connections_failed 0 and is_db_alive == 0, 
escalate by creating an incident note (write a short JSON blob) 
and keep running the task until max executions.

On-success actions (all checks pass for the run):

- Record a short summary (timestamp, metric snapshot) to the 
run report.

Idempotence & safety:

- Do not make any destructive changes.

- Avoid duplicate notifications: aggregate consecutive identical
breach events and only notify again if condition persists for 3 
consecutive runs.

- Rate limits: limit API calls to Azure Monitor and Container Apps
logs to once per run per resource.

Output expectations (per run):

- Small JSON summary: {timestampUTC, is_db_alive, 
connections_failed, connections_succeeded, api_5xx_count, 
api_p95_ms, web_5xx_count, actions_taken}

- On completion (after maxExecutions or duration): one PDF 
report (compiled metrics charts and collected logs) and a 
final pass/fail matrix.

Escalation hint:

- If breaches persist for >3 consecutive runs, include 
recommended immediate actions: check DB firewall, confirm 
Key Vault DB credentials, and consider restart of backend 
if DB is healthy but errors persist.

Stop conditions:

- Stop after maxExecutions reached (30) or manual cancel.

Notifications: Send notifications to the user via this 
chat with summarized results and attach the PDF at the end.

Constraints: Keep each run under 30s execution to avoid 
overlapping runs. Use minimal data pull to meet this requirement.
```

# [Security analysis](#tab/security-analysis)

This task automates a scheduled security review of your application, focusing on authentication, secrets, access controls, infrastructure, and dependencies.

```text
Perform security analysis of the my application focusing on:

* Authentication vulnerabilities and credential exposure risks
* Secret management practices in configuration files and environment variables
* Access control implementation and privilege escalation risks
* Infrastructure security posture and network exposure
* Dependency vulnerabilities and supply chain security

Generate prioritized findings with remediation recommendations 
(including code changes if required), emphasizing migration to secure 
authentication patterns.

Create GitHub issues for critical/high findings with actionable implementation steps.

Compliance: OWASP Top 10, Azure Security Benchmark
```

---

## Related content

- [Incident response plans in Azure SRE Agent](incident-response-plan.md)
- [Incident management in Azure SRE Agent](incident-management.md)