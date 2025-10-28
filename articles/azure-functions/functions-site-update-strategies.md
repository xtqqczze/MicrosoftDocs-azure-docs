---
title: Site update strategies in Flex Consumption
description: Learn which site update strategy to choose for your Flex Consumption app.
ms.custom: vs-azure
ms.topic: conceptual
ms.date: 10/18/2025
---

# Site update strategies in Flex Consumption

Flex Consumption offers a property, `SiteUpdateStrategy`, that controls how the platform updates running instances after a site update is performed. A site update is any change to your function app code or configuration.

The property supports two strategies:

- Recreate: all running instances are restarted and replaced with the latest version. This may cause short downtime while instances are recycled. This preserves the behavior before the site update strategy property was introduced.
- RollingUpdate: a zero-downtime strategy that drains and replaces instances in batches. In-process executions are allowed to finish and are not forcefully terminated.

## How RollingUpdate works

When a site update starts with RollingUpdate enabled, the platform assigns running instances to batches. Every N seconds, the platform drains one batch and scales out replacement instances that run the latest version. Draining prevents an instance from picking up new events and lets in-process executions finish. For Flex Consumption, the maximum execution time for an in-process execution is one hour.

Draining and scale-out are asynchronous operations: the platform doesn't wait for one to complete before starting the other. Overlapping rolling updates are allowed; when they occur, the platform drains all non-latest instances and always provisions the newest version.

## Benefits and considerations

RollingUpdate enables zero-downtime deployments for Flex Consumption by preserving in-flight executions and maintaining throughput through staggered draining. However, there are some public-preview limitations:

- No user configuration: batch count, maximum instances per batch, and drain interval are managed by the platform.
- No explicit completion signal: you can estimate completion by polling instance logs to see whether original instanceIds have stopped emitting logs.
- Batched IaC changes may trigger multiple RollingUpdate operations.

## How to configure a site update strategy

The `SiteUpdateStrategy` is a property within the `functionAppConfig`. In your ARM or Bicep template, you can set the following:

```json
```

## Monitoring and best practices

- Monitor instance IDs and logs to estimate rolling update progress. When the instances that existed at update start stop emitting logs, the rolling update is likely complete.
- Make functions idempotent and stateless where possible. Rolling updates preserve in-flight requests, but long-running in-process executions should be designed to be resilient.
- Prefer smaller, focused deployments to reduce the surface area during rolling updates and to avoid unexpected cascades of multiple update cycles.

## FAQ

- Can I configure the rolling update parameters (batch size, drain interval)?
  - Not in public preview. These parameters are platform-managed.

- How can I know when a rolling update has completed?
  - There's no built-in signal in public preview. You can estimate completion by polling logs for the original instance IDs and waiting until they stop emitting logs.

## Related content

- Flex Consumption plan: `flex-consumption-plan.md`
- Deployment technologies: `functions-deployment-technologies.md`

