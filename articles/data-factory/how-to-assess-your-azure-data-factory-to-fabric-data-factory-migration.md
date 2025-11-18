---
title: Assess your Azure Data Factory pipelines for migration to Fabric
description: Learn how to check which pipelines are ready to migrate and which ones need attention 
author: ssindhub
ms.author: ssrinivasara
ms.topic: conceptual
ms.date: 11/18/2024
ms.custom: pipelines
---

# How to assess your Azure Data Factory to Fabric Data Factory Migration
Use the built‑in upgrade assessment to check if your Azure Data Factory pipelines are ready for Fabric. It shows pipeline readiness and highlights activity-level compatibility so you can plan changes before migrating.

In [Azure Data Factory](https://adf.azure.com), open the factory you want to migrate. On the authoring canvas, select Run upgrade assessment (preview) at the top.

:::image type="content" source="media/how-to-assess-your-azure-data-factory-to-fabric-data-factory-migration/run-upgrade-assessment.png" alt-text="Run the Assessment tool":::

This opens a side pane with the preview of list of pipelines and expandable list of activities within the pipeline.

:::image type="content" source="media/how-to-assess-your-azure-data-factory-to-fabric-data-factory-migration/pipeline-assessment.png" alt-text="View the assessment in side pane":::

You can also export the assessment results as an .xlsx file for reference.

Some results point to features that are still in progress or out of scope. Use the results to prioritize the fixes and to decide whether to migrate now using existing tools such as PowerShell upgrade module or wait for upcoming support.


## Understanding the results
You’ll see one of the four results for each pipeline (and summarized at the factory level):

- **Ready** – Good to go for migration.
- **Needs review** – Requires changes (like trigger settings) before migration works.
- **Coming soon** – Support is in progress; migration for these items will be available later.
- **Not compatible** – No equivalent in Fabric for some activities. Remove or replace them before migrating.


### Drill into details
In the assessment side pane, expand each pipeline to see:
:::image type="content" source="media/how-to-assess-your-azure-data-factory-to-fabric-data-factory-migration/detailed-assessment-drilldown.png" alt-text="Drill down the assessment details":::

- Activity‑level status (which activities block migration).
- A summary of Ready/Needs review/Not compatible counts across pipelines and linked services.
- Use this list to build your to‑do plan (what to fix, what to defer, and what to replace).

### Migrate when you’re ready
When your assessment shows acceptable readiness:

Use the Azure Data Factory to Fabric migration flow as it becomes available in the future.
Or see if you could use the [PowerShell upgrade tool](/fabric/data-factory/migrate-pipelines-powershell-upgrade-module-for-azure-data-factory-to-fabric) and the migration planning guides to complete the move. 



## FAQ
**Does the assessment change my factory?**

No. It only scans your configuration and lists findings in the side pane. You can safely run it to understand impact before migration.

**Why do I see Coming soon?**

It means the product team is actively adding support for those items. If they’re critical to your pipeline, see if you could use PowerShell migration tool or plan to migrate later or redesign the affected steps.

**What if only one activity is Not compatible?**

You can still migrate the pipeline after you refactor or replace that activity. The assessment helps you identify exactly where to focus.

## Related content

[Compare Azure Data Factory and Fabric Data Factory](/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory)

[Migration best practices](/fabric/data-factory/migration-best-practices)

[Connector parity](/fabric/data-factory/connector-parity)


