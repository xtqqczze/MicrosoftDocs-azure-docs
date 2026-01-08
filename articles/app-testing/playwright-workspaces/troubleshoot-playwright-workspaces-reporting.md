---
title: Troubleshoot playwright workspaces reporting
titleSuffix: Playwright Workspaces
description: Troubleshoot errors or issues when running Playwright reporting on Playwright Workspaces.
ms.topic: troubleshooting-reporting
ms.date: 01/08/2026
ms.service: azure-app-testing
ms.subservice: playwright-workspaces
author: Abhinav-Premsekhar
ms.author: apremsekhar
---

# Troubleshoot issues with Playwright Workspaces reporting

This article provides mitigation steps for errors that might arise when you view the test reports in the test runs page in Playwright Workspaces.

## Failed to generate SAS token. The client <client_name> with object id <object_id> does not have authorization to perform action 'Microsoft.Storage/storageAccounts/listServiceSas/action' over scope <storage_path> or the scope is invalid. If access was recently granted, please refresh your credentials. (code: AuthorizationFailed, status: 403)

  :::image type="content" source="./media/troubleshoot-playwright-reporting/no-authorization-to-storage-account.png" alt-text="Screenshot to show the no authorization error" lightbox="./media/troubleshoot-playwright-reporting/no-authorization-to-storage-account.png":::

You may not have access to fetch the reporting artifacts from the storage account. Please check if you "Contributor" role to the linked storage account.
Learn how to [add role assignments to the storage account](https://learn.microsoft.com/en-us/azure/app-testing/playwright-workspaces/quickstart-advanced-diagnostic-with-playwright-workspaces-reporting?tabs=newworkspace%2Cplaywrightcli#add-role-based-access-control-rbac-roles-for-the-linked-storage-account-1).

## Failed to generate container SAS token. Failed to perform 'action' on resource(s) of type 'storageAccounts/listServiceSas', because the parent resource <storage_path> could not be found. (code: ParentResourceNotFound, status: 404)

  :::image type="content" source="./media/troubleshoot-playwright-reporting/storage-account-deleted.png" alt-text="Screenshot to show the no authorization error" lightbox="./media/troubleshoot-playwright-reporting/storage-account-deleted.png":::

The storage account may not exist or may have been deleted. Please check if the storage account exists before trying again.

## HTTP 404: The specified blob does not exist.

  :::image type="content" source="./media/troubleshoot-playwright-reporting/reporter-not-added.png" alt-text="Screenshot to show the no authorization error" lightbox="./media/troubleshoot-playwright-reporting/reporter-not-added.png":::

Reporting artifacts have not been collected for this test run. You may not have configured the Playwright Workspaces reporter correctly. Learn how to [configure the Playwright Workspace reporter](https://learn.microsoft.com/en-us/azure/app-testing/playwright-workspaces/quickstart-advanced-diagnostic-with-playwright-workspaces-reporting?tabs=newworkspace%2Cplaywrightcli#enable-html-and-playwright-workspaces-reporter).

## Diagnostics artifacts were not collected for this test run.

  :::image type="content" source="./media/troubleshoot-playwright-reporting/reporting-disabled.png" alt-text="Screenshot to show the no authorization error" lightbox="./media/troubleshoot-playwright-reporting/reporting-disabled.png":::

Reporting is not enabled for this Playwright Workspace. Learn how to [enable reporting in your Playwright Workspace](https://learn.microsoft.com/en-us/azure/app-testing/playwright-workspaces/quickstart-advanced-diagnostic-with-playwright-workspaces-reporting?tabs=newworkspace%2Cplaywrightcli#enable-reporting-and-link-a-storage-account-to-a-workspace).

## Could not load trace from <storage_path>. Make sure a valid Playwright Trace is accessible over this url.

  :::image type="content" source="./media/troubleshoot-playwright-reporting/cors-error.png" alt-text="Screenshot to show the no authorization error" lightbox="./media/troubleshoot-playwright-reporting/cors-error.png":::

The trace viewer url is not accessible from the storage account. Learn how to [allow-list the url in the storage account](https://learn.microsoft.com/en-us/azure/app-testing/playwright-workspaces/quickstart-advanced-diagnostic-with-playwright-workspaces-reporting?tabs=newworkspace%2Cplaywrightcli#only-if-trace-is-enabled-allow-list-public-trace-viewer-in-the-linked-storage-account).
