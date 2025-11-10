---
title: Navigate the Standard Workflow Designer
description: Learn how to open and use the Standard workflow designer in the Azure portal to create and run single-tenant Logic Apps workflows.
services: logic-apps
ms.suite: integration
ms.reviewer: estfan, azla
ms.topic: how-to
ms.date: 11/10/2025
ms.custom: sfi-image-nochange
---

# Navigate the Standard workflow designer (single-tenant)

[!INCLUDE [logic-apps-sku-standard](../../includes/logic-apps-sku-standard.md)]

When you work with Azure Logic Apps in the Azure portal, you can edit your [*workflows*](logic-apps-overview.md#logic-app-concepts) visually or programmatically.

## Prerequisites

- An Azure account and subscription. If you don't have a subscription, [sign up for a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A *Standard* logic app resource [in single-tenant Azure Logic Apps](single-tenant-overview-compare.md). For more information, see [Create an example Standard logic app workflow in single-tenant Azure Logic Apps using the Azure portal](create-single-tenant-workflows-azure-portal.md).
- A workflow for your Standard logic app resource.

## Latest version features

The latest workflow designer offers a new experience with noteworthy features and benefits, for example:

- A new layout engine that supports more complicated workflows.

- You can create and view complicated workflows cleanly and easily, thanks to the new layout engine, a more compact canvas, and updates to the card-based layout.

- Add and edit steps using panels separate from the workflow layout. This change gives you a cleaner and clearer canvas to view your workflow layout. For more information, review [Add steps to workflows](#add-steps-to-workflows).

- Move between steps in your workflow on the designer using keyboard navigation.

  - Move to the next card: **Ctrl** + **Down Arrow (&darr;)**

  - Move to the previous card: **Ctrl** + **Up Arrow (&uarr;)**

## What's changed in the new designer

The new designer changes how you edit and run workflows. Key differences:

- The designer always shows and edits the draft version. All changes are automatically saved to the draft; there is no explicit Save button.
- The production (published) version is unchanged until you select **Publish**. If you run a workflow from the designer, the draft version is executed.
- Several actions that were in the workflow sidebar or toolbar (for example, Connections, Parameters, Discard, Download summary, and Access keys) are now available from the vertical ellipsis menu next to **Publish**.
- The top of the designer contains the view selector (Workflow and Code). The Run action is at the bottom of the designer canvas.
- If you need to view the published (production) version as read-only, use **Switch to published version** from the ellipsis menu.

## Where to find common actions

The new designer moves many familiar actions to new locations. Use the table below to quickly find where each common task is now performed.

| Task | Classic designer | New designer |
|---|---:|---|
| Designer view | Sidebar Tools > **Designer** or toolbar > **Designer** | At the designer top > **Workflow** |
| Code view (JSON) | Sidebar Tools > **Code** or toolbar > **Code view** | At the designer top > **Code** |
| Run history | Sidebar Tools > **Run history** | Designer top > **Run history** (then select a run to open monitoring view) |
| Publish draft | N/A | Designer upper-right > **Publish** |
| Run workflow | Workflow toolbar: **Run** / **Run with payload** | At the bottom of the designer: **Run** / **Run with payload** |

### Ellipsis menu

In the new designer, many workflow actions are now found in the vertical ellipsis menu (⋮) next to the **Publish** button at the top right. Select this menu to access options like Discard changes, Parameters, Connections, Download summary, and more.

:::image type="content" source="media/designer-overview/ellipsis.png" alt-text="":::

| Task | Classic designer | New designer |
|---|---:|---|
| Discard changes | Workflow toolbar: **Discard** | Next to **Publish**, open the vertical ellipsis menu > **Discard changes** |
| Parameters | Workflow toolbar: **Parameters** | Next to **Publish**, ellipsis menu > **Parameters** |
| Connections | Workflow toolbar: **Connections** | Next to **Publish**, ellipsis menu > **Connections** |
| Download workflow summary | Workflow toolbar: **Download workflow summary** | Next to **Publish**, ellipsis menu > **Download workflow summary** |
| Disable/Enable workflow | Sidebar Configuration > **Settings** | Next to **Publish**, ellipsis menu > **Disable** / **Enable** |
| Access keys | Sidebar Configuration > **Access keys** | Next to **Publish**, ellipsis menu > **Settings** (then **Access keys**) |
| Properties / Info | Sidebar Configuration > **Properties** | Next to **Publish**, ellipsis menu > **Information** |
| View production version | N/A | Next to **Publish**, ellipsis menu > **Switch to published version** |

## Open the workflow designer

1. In the [Azure portal](https://portal.azure.com), open your [*logic app* resource](logic-apps-overview.md#logic-app-concepts).

1. On the Logic App menu, under **Workflows**, select **Workflows**.

   - To enable the new Logic Apps experience, select the **Enable preview** button from the ribbon banner.

    :::image type="content" source="media/designer-overview/enable-preview.png" alt-text="A screenshot of the Workflows options in the working pane of the Azure portal with the Enable preview button emphasized. ":::

   > [!TIP]
   > You can return to the previous version of designer at any time by selecting the **Go back to previous version** button from the ribbon banner. 

1. On the **Workflows** page, select the workflow that you want.

1. The workflow designer opens.

   - To visually develop, edit, and run your workflow, select the **Workflow** view. 
   - To edit the workflow in JSON, select [**Code**](#code-view). You can switch between the workflow view and code view at any time.
       > [!TIP]
       > The **Code** view is also an easy way to find and copy the workflow definition, instead of using the Azure CLI or other methods.
   - To review your logs, select the **Run history** view. 

## Add steps to workflows

The workflow designer provides a visual way to add, edit, and delete steps in your workflow. As the first step in your workflow, always add a [*trigger*](logic-apps-overview.md#logic-app-concepts). Then, complete your workflow by adding one or more [*actions*](logic-apps-overview.md#logic-app-concepts).

To add a trigger or an action to your Standard workflow, see [Build a workflow with a trigger or action in Azure Logic Apps](create-workflow-with-trigger-or-action.md).

1. Configure your trigger or action as needed.

   - Mandatory fields have a red asterisk (&ast;) in front of the name.

   - Some triggers and actions might require you to create a connection to another service. You might need to sign into an account, or enter credentials for a service. For example, if you want to use the Office 365 Outlook connector to send an email, you need to authorize your Outlook email account.

   - Some triggers and actions use dynamic content, where you can select variables instead of entering information or expressions.

   - Changes are saved automatically to the draft version as you edit. To validate and push your changes to production, select **Publish** in the designer upper-right. Use the Run button at the bottom of the designer to run the draft. If Save/Auto-save errors occur, the designer shows validation messages inline.

## How draft and publish work

- Editing: All edits in the designer go to a draft copy automatically.
- Running: When you run a workflow from the designer, you run the draft version.
- Publishing: To make draft changes live, select **Publish** in the designer upper-right. Publishing replaces the production version with the current draft.
- View published: To view the published workflow without editing it, choose **Switch to published version** from the vertical ellipsis menu next to **Publish**; this view is read-only.
- Revert: If you need the previous experience or want to go back to the classic UX, use **Revert to previous experience** from the same ellipsis menu.

## Next steps

> [!div class="nextstepaction"]
> [Create an integration workflow with single-tenant Azure Logic Apps (Standard) in the Azure portal](create-single-tenant-workflows-azure-portal.md)
