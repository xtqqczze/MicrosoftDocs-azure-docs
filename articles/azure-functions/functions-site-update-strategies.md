---
title: Site update strategies in Flex Consumption
description: Learn which site update strategy to choose for your Flex Consumption app.
ms.custom: vs-azure
ms.topic: conceptual
ms.date: 10/28/2025
---

# Site update strategies in Flex Consumption

The Flex Consumption plan provides a `SiteUpdateStrategy` property that controls how the platform updates running instances when you deploy code changes or configuration updates. This property determines whether your function app experiences downtime during deployments and how in-flight executions are handled.

Flex Consumption supports two update strategies:

- **Recreate**: Restarts all running instances and replaces them with the latest version. This approach may cause brief downtime while instances are recycled and preserves the default behavior from other Azure Functions hosting plans.
- **RollingUpdate**: Provides zero-downtime deployments by draining and replacing instances in batches. In-progress executions complete naturally without forced termination.

> [!IMPORTANT]
> The rolling update strategy is currently in public preview. Review the limitations and considerations before using this feature in production scenarios.

## Overview of site update strategies

Refer to this table when deciding between the two site update strategies:

| Consideration | Recreate | Rolling Update |
| ------------- | -------- | -------------- |
| Downtime      | Brief downtime as your app scales out from 0 after the restart | No period of downtime |
| In-flight executions | Forcefully terminated | Allowed to complete for the maximum function execution time |
| Speed         | Quick - environment can take up to a minute to update | Gradual - environment can take a couple minutes depending on the number of instances |
| Backwards compatibility | Not necessary as one version will be running at a time | Changes must be backwards compatible, especially with stateful workloads or breaking changes |
| How to set    | Default behavior, consistent with other hosting plans  | Opt-in configuration |

## When to use each strategy

**Use Recreate when:**
- You need fast, straightforward deployments
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
1. At regular intervals, the platform drains one batch of instances. Draining prevents instances from accepting new events while allowing in-progress executions to complete (up to the 1-hour maximum execution time)
1. Simultaneously, the scaling platform provisions new instances running the latest version to replace the draining capacity
1. This process continues until all instances are running the latest version

The platform intelligently manages capacity during rolling updates. If demand increases, more instances are provisioned than were drained. If demand decreases, only the necessary instances are created to meet current needs. This approach ensures continuous availability while optimizing resource usage. 

### RollingUpdate behavior and limitations

**Key behaviors:**
- **Asynchronous operations**: Draining and scale-out happen simultaneously without waiting for each other to complete
- **Overlapping updates**: You can initiate additional rolling updates while one is in progress. All non-latest instances are drained, and only the newest version is scaled out
- **Dynamic scaling**: The platform adjusts instance count based on current demand during the update

**Current limitations (public preview):**
- **Platform-managed parameters**: Batch count, instances per batch, and drain intervals are controlled by the platform
- **No real-time monitoring**: Progress information about batches and instance states isn't available
- **No completion signal**: Monitor instance logs to estimate when the update completes
- **Single-instance scenarios**: Apps running on one instance experience brief downtime similar to recreate, though in-progress executions still complete

**Important considerations:**
- **Durable Functions**: Mixed versions during updates may cause unexpected behavior. Use an explicit [orchestration version match strategy](./durable/durable-functions-orchestration-versioning.md)
- **Infrastructure as Code**: Deploying code and configuration changes together triggers multiple rolling updates that may overlap
- **Backward compatibility**: Ensure your changes work with the previous version during the transition period

> [!IMPORTANT]
> These limitations and behaviors may change when the feature reaches general availability.

## How to configure the site update strategy

The `SiteUpdateStrategy` is a property within the `functionAppConfig`. By default, its `type` is set to `Recreate`. Currently, only Bicep and ARM is supported:

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

Changes to the site update strategy take effect at the next site update. For example, the site update changing from `Recreate` to `RollingUpdate` will be carried out with the recreate strategy. All subsequent site updates will effectively use rolling updates.

## Monitoring

During the Public Preview, there is no first-class monitoring support. You can assume that a recreate is completed one minute after receiving a 202 HTTP response from your site update gesture; rolling updates may take up to three minutes.

## FAQ

**I'm used to deployment slots for zero downtime deployments. How do rolling updates differ?**
- Unlike deployment slots, rolling updates does not require you to manage additional infrastructure such as a staging slot. By setting `siteUpdateStrategy.type` to `"RollingUpdate"`, you unlock the benefits of zero downtime deployments.
- Rolling updates provide a true zero downtime deployment. Deployment slots do not preserve in-flight executions during a swap. Furthermore, certain site properties and sticky settings cannot be swapped. Modifying those required a restart of the production site.
- Unlike deployment slots, rolling updates do not provide a separate environment for you to canary test changes or route a percentage of live traffic to. If you need these features, use a plan that supports deployment slots, like Elastic Premium, or manage separate Flex Consumption apps behind a traffic manager.

**How do I rollback a site update?**
- There is currently no feature to rollback a site update. If a rollback is necessary, initiate another site update with the previous state of code or config.

**How are timer triggers handled?**
- Timer triggers will maintain their singleton nature. Once a timer-triggered function app is marked for drain, new timer functions will run on the latest version. 
- If the next timer interval occurs while the previous execution is draining, it will be handled as it today: the new execution will be delayed until the previous execution is completed.

## Next steps

- [Learn more about the Flex Consumption plan](./flex-consumption-plan.md)
- [Learn more about how deployments differ in Flex Consumption](./flex-consumption-plan#deployment.md)
- [Learn how to write infrastructure-as-code templates](./functions-infrastructure-as-code.md)
