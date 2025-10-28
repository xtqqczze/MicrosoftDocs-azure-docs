---
title: Site update strategies (internal spec)
description: Internal spec for docs updates related to SiteUpdateStrategy and RollingUpdate in Flex Consumption.
ms.custom: vs-azure
ms.topic: conceptual
ms.date: 10/18/2025
---

# Site update strategies — docs update spec

This internal spec records the docs and sections to update to reflect the new `SiteUpdateStrategy` property in Flex Consumption. Delete this file once the changes are made.

## Summary

The Flex Consumption plan now exposes `SiteUpdateStrategy`, which has two values: `Recreate` and `RollingUpdate`. `RollingUpdate` enables zero-downtime updates by draining instances in batches and scaling out new instances running the latest version.

## Public preview limitations

- No user-configurable parameters for rolling updates.
- No completion signal in public preview.
- Multiple rolling updates may overlap; new instances always run the latest version.
- Batched IaC template changes trigger multiple rolling updates.

## Docs and sections to update (action items)

1. `functions-deployment-technologies.md`
   - Update the "One deploy" and "Deployment behaviors" sections to describe RollingUpdate and zero-downtime behavior for Flex Consumption.

2. `flex-consumption-plan.md`
   - Add new subsection explaining `SiteUpdateStrategy` and differences between `Recreate` and `RollingUpdate`.

3. `functions-scale.md`
   - Add notes about scaling behavior during RollingUpdate, particularly the asynchronous nature of draining and scaling.

4. `functions-infrastructure-as-code.md`
   - Add guidance that batching multiple config or code changes in a single IaC template may cause multiple rolling updates.

5. `functions-monitoring.md` and `monitor-functions.md`
   - Add guidance and example log queries for estimating rolling update progress (instanceId-based polling). Consider adding sample Kusto queries to find logs by instance ID.

6. `functions-best-practices.md`
   - Add content for zero-downtime deployments, how to design idempotent and resilient functions for rolling updates.

7. `functions-deployment.md` or `functions-continuous-deployment.md`
   - Add CI/CD guidance and how to avoid unintentionally triggering multiple rolling updates.

## Notes for engineers and docs authors

- RollingUpdate is the default behaviour for Flex Consumption unless explicitly set to `Recreate` (if that option is exposed). Confirm default value with engineering.
- The drain interval is sized to allow both drain and scale operations to complete before the next drain, but the processes are asynchronous.
- Confirm whether a public API or portal indicator will be added in future previews; if so, add a reference to it in monitoring docs.

## Next steps

1. Confirm default `SiteUpdateStrategy` value with engineering.
2. Update docs (one by one), add internal review comments and screenshots if any.
3. Coordinate with engineering for any sample log queries or prototypes for detection of rolling update progress.
