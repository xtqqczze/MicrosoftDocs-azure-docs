---
title: Sync and manage Arc resources in Azure Migrate
description: Learn how to sync Arc-enabled resources, manage project scope, and configure automatic synchronization in Azure Migrate.
author: snehithm
ms.author: snehithm
ms.service: azure-migrate
ms.topic: how-to
ms.date: 10/23/2025
ms.custom: engagement-fy25
---

# Sync and manage Arc resources in Azure Migrate

This article describes how to sync Arc-enabled resources in Azure Migrate, manage project scope, and configure automatic synchronization.

When you create an Azure Migrate project for Arc resources, it automatically syncs metadata from your Arc-enabled servers and SQL Server instances. As your environment changes, you need to sync the project to ensure assessments and business cases reflect the current state of your infrastructure.

## Prerequisites

- An existing Azure Migrate project created for Arc resources. If you don't have one, see [Create a migrate project for Arc resources](quickstart-create-migrate-project-for-arc-resources.md).
- **Migrate Arc Discovery Reader - Preview** role on subscriptions containing Arc resources you want to sync.

## Manual sync

Manual sync allows you to immediately refresh your Azure Migrate project with the latest data from your Arc-enabled resources.

### When to use manual sync

Use manual sync when:
- New Arc-enabled servers or SQL Server instances have been added to subscriptions in scope
- Servers or SQL Server instances have been removed from your environment
- Configuration changes have occurred (CPU, memory, disk changes)
- You've updated the Arc agent version on servers
- You want to ensure the latest data before creating an assessment or business case

### Perform a manual sync

1. In the Azure portal, search for **Azure Arc** and select **Azure Arc** under Services.

2. Under **Migration**, select **Savings and Readiness (Preview)**.

3. On the toolbar, select **Sync Arc data**.

    :::image type="content" source="./media/how-to-sync-arc-resources/sync-arc-data-button.png" alt-text="Screenshot showing the Sync Arc data button in the Savings and Readiness page.":::

4. The sync process begins. Depending on the number of Arc resources in your subscriptions, this may take several minutes.

5. You'll see a notification when the sync completes successfully.

> [!NOTE]
> During sync, Azure Migrate collects metadata about your Arc-enabled resources but doesn't make any changes to the resources themselves.

## Automatic sync (Preview)

Automatic sync configures your Azure Migrate project to periodically sync Arc resource data without manual intervention. This ensures your assessments and business cases always reflect current infrastructure state.

### How automatic sync works

When you enable automatic sync:
- Azure Migrate uses the project's managed identity to access Arc resources
- The managed identity is automatically enabled when you create a project with Arc resources
- Sync runs on a configurable schedule (daily, weekly, or monthly)
- You're notified if sync fails due to permission or connectivity issues

### Configure automatic sync

#### Step 1: Assign managed identity permissions

The Azure Migrate project has a system-assigned managed identity that must be granted access to your Arc resources.

1. Navigate to your Azure Migrate project in the Azure portal.

2. Note the **Project name** as you'll need it to find the managed identity.

3. For each subscription containing Arc resources in your project scope:

   a. Navigate to the subscription in the Azure portal.
   
   b. Select **Access control (IAM)** from the left menu.
   
   c. Select **+ Add** > **Add role assignment**.
   
   d. On the **Role** tab, search for and select **Migrate Arc Discovery Reader - Preview**.
   
   e. Select **Next**.
   
   f. On the **Members** tab, select **Managed identity**.
   
   g. Select **+ Select members**.
   
   h. In the **Managed identity** dropdown, select **Migrate Project**.
   
   i. Search for and select your Azure Migrate project name.
   
   j. Select **Select**.
   
   k. Select **Review + assign** and complete the role assignment.

4. Repeat for all subscriptions in your project scope.

> [!IMPORTANT]
> Automatic sync won't work until the managed identity has the **Migrate Arc Discovery Reader - Preview** role on all subscriptions containing Arc resources in your project scope.

#### Step 2: Enable automatic sync

1. In the Azure portal, search for **Azure Arc** and select **Azure Arc** under Services.

2. Under **Migration**, select **Savings and Readiness (Preview)**.

3. Select **Settings** from the toolbar or left menu.

4. In the **Automatic sync** section, toggle **Enable automatic sync** to **On**.

5. Select the **Sync frequency**:
   - **Daily**: Syncs once per day at the specified time
   - **Weekly**: Syncs once per week on the specified day and time
   - **Monthly**: Syncs once per month on the specified date and time

6. Configure the sync schedule based on your selected frequency.

7. Select **Save**.

    :::image type="content" source="./media/how-to-sync-arc-resources/configure-automatic-sync.png" alt-text="Screenshot showing the automatic sync configuration settings.":::

### Verify automatic sync status

To verify automatic sync is working correctly:

1. Navigate to **Savings and Readiness (Preview)** in Azure Arc Center.

2. Select **Settings**.

3. In the **Automatic sync** section, view:
   - **Status**: Shows whether automatic sync is enabled
   - **Last sync time**: When the last automatic sync completed
   - **Next scheduled sync**: When the next sync will occur
   - **Last sync status**: Success or failure with error details

### Troubleshoot automatic sync failures

If automatic sync fails:

1. **Check managed identity permissions**:
   - Ensure the managed identity has **Migrate Arc Discovery Reader - Preview** role on all subscriptions in scope
   - Verify the role assignment hasn't been removed

2. **Verify resource provider registration**:
   - Ensure `Microsoft.OffAzure` is registered on all subscriptions in scope
   - Navigate to the subscription > **Resource providers** > Search for **Microsoft.OffAzure** > Select **Register** if needed

3. **Review error messages**:
   - Check the **Last sync status** in Settings for specific error details
   - Common errors include permission issues or network connectivity problems

4. **Manually trigger sync**:
   - If automatic sync continues to fail, perform a manual sync to identify issues
   - Contact support if issues persist

### Disable automatic sync

To disable automatic sync:

1. Navigate to **Settings** in the Savings and Readiness page.

2. Toggle **Enable automatic sync** to **Off**.

3. Select **Save**.

You can still perform manual syncs even when automatic sync is disabled.

## Configure tag synchronization

Azure Migrate can synchronize Azure Resource Manager tags from your Arc-enabled resources to the Migrate inventory. This helps you organize and filter resources in assessments and business cases.

### About tag synchronization

- **Default behavior**: Tag sync is enabled by default when you create a project
- **Sync scope**: Tags are synced from Arc-enabled servers and SQL Server instances
- **Tag format**: Tags appear in Azure Migrate inventory with the same key-value pairs as in Azure Resource Manager
- **Update frequency**: Tags sync during manual or automatic sync operations
- **Use cases**: Filter resources by environment, application, cost center, or other organizational criteria

### Enable or disable tag synchronization

1. In the Azure portal, navigate to **Savings and Readiness (Preview)** in Azure Arc Center.

2. Select **Settings** from the toolbar or left menu.

3. In the **Tag synchronization** section, toggle **Sync Azure tags** to **On** or **Off**.

4. Select **Save**.

5. Perform a manual sync or wait for the next automatic sync to apply the change.

> [!NOTE]
> - Disabling tag sync doesn't remove existing tags from the Migrate inventory. It only stops syncing new or updated tags.
> - To remove existing tags from the inventory, disable tag sync, then manually remove tags from resources in the Migrate inventory view.

### View synced tags

After tags are synced:

1. Navigate to **Savings and Readiness (Preview)** in Azure Arc Center.

2. Select **View/Edit scope** > **View inventory**.

3. In the inventory view, you'll see tags displayed for each resource.

4. Use tags to filter and group resources when creating custom assessments or business cases.

## View and edit project scope

The project scope determines which subscriptions' Arc resources are included in your Azure Migrate project.

### View current scope

1. In the Azure portal, navigate to **Savings and Readiness (Preview)** in Azure Arc Center.

2. Select **View/Edit scope** from the toolbar.

    :::image type="content" source="./media/how-to-sync-arc-resources/view-edit-scope-button.png" alt-text="Screenshot showing the View/Edit scope button in the Savings and Readiness page.":::

3. The dropdown menu shows two options:
   - **View inventory**: See all Arc resources currently in the project
   - **Edit scope**: Modify which subscriptions are included

### View inventory

To view which Arc resources are currently included in your project:

1. Select **View/Edit scope** > **View inventory**.

2. You're redirected to the Azure Migrate inventory page showing:
   - All Arc-enabled servers in scope
   - All Arc-enabled SQL Server instances in scope
   - Configuration details, Arc agent version, and sync status

3. Use filters to view specific resource types or search for specific resources.

### Edit scope

To add or remove subscriptions from your project scope:

1. Select **View/Edit scope** > **Edit scope**.

2. The Edit scope panel opens showing all available subscriptions with Arc resources.

3. **To add subscriptions**:
   - Select the checkbox next to subscriptions you want to add
   - Ensure you have the required permissions on these subscriptions

4. **To remove subscriptions**:
   - Unselect the checkbox next to subscriptions you want to remove
   - Resources from removed subscriptions will be excluded from future syncs

5. Select **Save** to apply changes.

6. The scope update begins. This may take several minutes depending on the number of subscriptions.

7. After the scope update completes, a sync automatically runs to include or exclude resources based on the new scope.

> [!IMPORTANT]
> When you add subscriptions to scope:
> - You must have **Migrate Arc Discovery Reader - Preview** role on the subscription
> - The subscription must have the `Microsoft.OffAzure` resource provider registered
> - If using automatic sync, update the managed identity permissions to include the new subscriptions

### Scope requirements

For each subscription in your project scope, ensure:

- **Resource provider registration**: `Microsoft.OffAzure` must be registered
- **Permissions**: You have at minimum:
  - `Microsoft.HybridCompute/Machines/read`
  - `Microsoft.AzureArcData/SqlInstances/read`
- **Arc agent version**: Servers running Arc agent version 1.46 or higher
- **For automatic sync**: Managed identity has **Migrate Arc Discovery Reader - Preview** role

## Sync behavior and data freshness

### What data is synced

During each sync, Azure Migrate collects:

- **Server metadata**: CPU cores, memory, disk configuration, network adapters, operating system
- **SQL Server metadata**: Instance name, version, edition, databases
- **Arc agent information**: Agent version, status, last heartbeat
- **Azure Resource Manager tags**: If tag sync is enabled
- **Resource state**: Running, stopped, or deallocated status

### Data freshness

- **Manual sync**: Data is current as of the sync time
- **Automatic sync**: Data freshness depends on your configured sync frequency
- **Assessments**: Use data from the most recent sync
- **Business cases**: Calculations use data from the most recent sync

> [!TIP]
> For the most accurate assessments, perform a manual sync immediately before creating or recalculating assessments.

## Sync performance and limitations

### Sync duration

Sync time depends on:
- Number of Arc-enabled servers in scope
- Number of Arc-enabled SQL Server instances in scope
- Number of subscriptions in scope
- Network connectivity

Typical sync times:
- **< 100 resources**: 1-5 minutes
- **100-1,000 resources**: 5-15 minutes
- **1,000-10,000 resources**: 15-60 minutes
- **> 10,000 resources**: Up to several hours

### Concurrent syncs

- Only one sync operation can run at a time per project
- If you trigger a manual sync while automatic sync is running, the manual sync request is queued
- You'll see a notification if a sync is already in progress

### Resource limits

- **Maximum subscriptions in scope**: 100 subscriptions
- **Maximum resources per project**: 50,000 Arc-enabled resources
- **Sync frequency**: Minimum of 1 hour between syncs

## Next steps

- [View and review discovered inventory](how-to-review-discovered-inventory.md)
- [Build a business case](how-to-build-a-business-case.md)
- [Create an application assessment](create-application-assessment.md)
- [Install Azure Migrate Collector VM extension](how-to-install-arc-collector-extension.md)
- [Troubleshoot Arc resources](troubleshoot-arc-resources-migration.md)