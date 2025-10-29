---
title: Site update strategies in Flex Consumption
description: Learn which site update strategy to choose for your Flex Consumption app.
ms.custom: vs-azure
ms.topic: conceptual
ms.date: 10/28/2025
---

# Site update strategies in Flex Consumption

The Flex Consumption plan provides a `SiteUpdateStrategy` property that controls how the platform updates running instances when you deploy code changes or configuration updates. This property determines whether your function app experiences downtime during these updates and how in-flight executions are handled.

Flex Consumption supports two update strategies:

- **Recreate**: Restarts all running instances and replaces them with the latest version. This approach may cause brief downtime while instances are recycled and preserves the default behavior from other Azure Functions hosting plans.
- **RollingUpdate**: Provides zero-downtime deployments by draining and replacing instances in batches. In-flight executions complete naturally without forced termination.

> [!IMPORTANT]
> The rolling update strategy is currently in public preview. Review the limitations and considerations before using this feature in production scenarios.

## Overview of site update strategies

Refer to this table when deciding between the two site update strategies:

| Consideration | Recreate | Rolling Update |
| ------------- | -------- | -------------- |
| Downtime      | Brief downtime as your app scales out from 0 after the restart | No period of downtime |
| In-flight executions | Forcefully terminated | Allowed to complete for the [maximum time-out duration](./functions-scale#function-app-time-out-duration.md) |
| Speed         | Quick - environment can take up to 30 seconds to update | Gradual - environment can take a few minutes depending on the number of instances |
| Backward compatibility | Not necessary as one version will be running at a time | Changes must be backward compatible, especially with stateful workloads or breaking changes |
| How to set    | Default behavior, consistent with other hosting plans  | Opt-in configuration |

## When to use each strategy

**Use Recreate when:**
- You need fast deployments
- Brief downtime is acceptable for your workload
- You're deploying breaking changes that require a clean restart
- Your functions are stateless and can handle interruption

**Use RollingUpdate when:**
- Zero-downtime deployments are required
- You have long-running or critical functions that shouldn't be interrupted
- Your changes are backward-compatible
- You need to preserve in-flight executions

## Recreate strategy

The recreate strategy follows this process:

1. A site update is initiated while your function app has active instances
1. The platform forcefully restarts all live and draining instances
1. Instance count reaches zero, triggering the scaling system to provision new instances with the latest version

### Recreate limitations

The recreate strategy has these characteristics:

- **Brief downtime**: Your app is unavailable while instances restart and scale out
- **Execution interruption**: In-flight executions are terminated immediately
- **No completion signal**: Monitor instance logs to track when original instances stop emitting logs


## RollingUpdate strategy

The rolling update strategy provides zero-downtime deployments through this process:

1. A site update is initiated while your function app has active instances
1. The platform assigns all live instances to batches
1. At regular intervals, the platform drains one batch of instances. Draining prevents instances from accepting new events while allowing in-flight executions to complete (up to the one hour maximum execution time)
1. Simultaneously, the scaling platform provisions new instances running the latest version to replace the draining capacity
1. This process continues until all instances are running the latest version

The platform intelligently manages capacity during rolling updates. If demand increases, more instances are provisioned than were drained. If demand decreases, only the necessary instances are created to meet current needs. This approach ensures continuous availability while optimizing resource usage. 

### RollingUpdate behavior and limitations

**Key behaviors:**
- **Asynchronous operations**: Draining and scale-out happen simultaneously without waiting for each other to complete
- **Overlapping updates**: You can initiate additional rolling updates while one is in progress. All non-latest instances are drained, and only the newest version is scaled out
- **Dynamic scaling**: The platform adjusts instance count based on current demand during the update

**Current limitations (public preview):**
- **Platform-managed parameters**: The platform controls batch count, instances per batch, and drain intervals
- **No real-time monitoring**: No visibility into how many instances are draining, how many batches remain, or current progress percentage
- **No completion signal**: Instance logs can be monitored to estimate when the update completes
- **Single-instance scenarios**: Apps running on one instance experience brief downtime similar to recreate, though in-flight executions still complete

**Important considerations:**
- **Durable Functions**: Mixed versions during updates may cause unexpected behavior. Use an explicit [orchestration version match strategy](./durable/durable-functions-orchestration-versioning.md)
- **Infrastructure as Code**: Deploying code and configuration changes together triggers multiple rolling updates that may overlap
- **Backward compatibility**: Ensure your changes work with the previous version during the transition period

> [!IMPORTANT]
> These limitations and behaviors may change when the feature reaches general availability.

## How to configure the site update strategy

The `SiteUpdateStrategy` is a property within the `functionAppConfig`. By default, its `type` is set to `Recreate`. Currently, only Bicep and ARM are supported with API version `2024-11-01` or later:

### [Bicep](#tab/Bicep)
```bicep
functionAppConfig: {
  ...
  siteUpdateStrategy: {
    type: 'RollingUpdate'
  }
  ...
}
```

### [ARM Template](#tab/json)
```json
"functionAppConfig": {
  ...
  "siteUpdateStrategy": {
    "type": "RollingUpdate"
  }
  ...
}
```

Changes to the site update strategy take effect at the next site update. For example, changing from `Recreate` to `RollingUpdate` uses the recreate strategy for that update. All subsequent site updates use rolling updates.

## Monitoring

During the Public Preview, there's no deterministic completion signal for site updates. You have two options:

1. **Wait a conservative amount of time**: up to 30 seconds for the recreate updates or up to 3 minutes for rolling updates
2. **Estimate completion using queries**: Use the KQL query below to track rolling update progress, but be aware of its limitations

### Query rolling update progress

You can monitor rolling update progress using KQL queries in Application Insights. The following query tracks how many original instances have been replaced and returns `"RollingUpdateComplete": "Yes"` when no original instances remain:

```kusto
// Rolling update completion check
let deploymentStart = datetime('2025-10-29T15:16:00Z'); // Set to your deployment start time
let checkInterval = 10s; // How often you run this query
let buffer = 30s; // Safety buffer for instance detection
//
// Get original instances (active before deployment)
let originalInstances = 
    traces
    | where timestamp between ((deploymentStart - buffer) .. deploymentStart)
    | where cloud_RoleInstance != ""
    | summarize by InstanceId = cloud_RoleInstance;
//
// Get currently active instances
let currentInstances = 
    traces
    | where timestamp >= now() - checkInterval
    | where cloud_RoleInstance != ""
    | summarize by InstanceId = cloud_RoleInstance;
//
// Check completion status
currentInstances
| join kind=leftouter (originalInstances | extend IsOriginal = true) on InstanceId
| extend IsOriginal = isnotnull(IsOriginal)
| summarize 
    OriginalStillActiveInstances = make_set_if(InstanceId, IsOriginal),
    NewInstances = make_set_if(InstanceId, not(IsOriginal)),
    OriginalStillActiveCount = countif(IsOriginal),
    NewCount = countif(not(IsOriginal)),
    TotalOriginal = toscalar(originalInstances | count)
| extend 
    RollingUpdateComplete = iff(OriginalStillActiveCount == 0, "YES", "NO"),
    PercentComplete = round(100.0 * (1.0 - todouble(OriginalStillActiveCount) / todouble(TotalOriginal)), 1)
| project RollingUpdateComplete, PercentComplete, OriginalStillActiveCount, NewCount
```

**How to use this query:**

1. Paste this query in the Logs blade of the Application Insights resource associated with your function app.
2. Set `deploymentStart` to the timestamp when your site update returned success.
3. Run the query periodically to track progress. Set the polling interval to be at least as long as your average function execution time, and ensure the `checkInterval` variable in the query matches this polling frequency
4. The query returns:
   - `RollingUpdateComplete`: Whether all original instances have been replaced
   - `PercentComplete`: Percentage of original instances that have been replaced
   - `OriginalStillActiveCount`: Number of original instances still running
   - `NewCount`: Number of new instances currently active

**Query limitations**

1. **Timing gap**: The `deploymentStart` time represents when your site update returned success, but the actual rolling update may not start immediately. During this gap, any scale-out events provision instances running the original version. Since the query only tracks instances active at `deploymentStart`, these new original-version instances won't be monitored, potentially causing false completion signals.

2. **Log-based detection**: This approach relies on application logs to infer instance state rather than directly querying instance status. Instances may be running but not actively logging, leading to false completion signals when original instances are still active but haven't emitted logs within the `checkInterval` window.

For production scenarios, use rolling updates for zero-downtime deployments without relying on completion detection. For more predictable timing, use the recreate strategy (faster but with brief downtime).


## FAQ

**I'm used to deployment slots for zero downtime deployments. How do rolling updates differ?**
- Unlike deployment slots, rolling updates require no additional infrastructure. Set `siteUpdateStrategy.type` to `"RollingUpdate"` for zero-downtime deployments.
- Rolling updates preserve in-flight executions, while deployment slots terminate them during swaps. [Certain site properties](./functions-deployment-slots#manage-settings.md) and sticky settings can't be swapped and require modifying the production slot directly.
- Unlike deployment slots, rolling updates don't provide a separate environment for you to canary test changes or route a percentage of live traffic to. If you need these features, use a plan that supports deployment slots, like Elastic Premium, or manage separate Flex Consumption apps behind a traffic manager.

**How do I roll back a site update?**
- There's currently no feature to roll back a site update. If a rollback is necessary, initiate another site update with the previous state of code or configuration.

**How are timer triggers handled?**
- Timer triggers maintain their singleton nature. Once a timer-triggered function app is marked for drain, new timer functions run on the latest version. 

## Next steps

- [Learn more about the Flex Consumption plan](./flex-consumption-plan.md)
- [Learn more about how deployments differ in Flex Consumption](./flex-consumption-plan#deployment.md)
- [Learn how to write infrastructure-as-code templates](./functions-infrastructure-as-code.md)
