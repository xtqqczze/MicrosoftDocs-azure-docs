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

This article shows how to use the Standard workflow designer in the Azure portal to visually or programmatically build, edit, and run single-tenant Logic Apps [*workflows*](logic-apps-overview.md#logic-app-concepts). It highlights key changes from the classic experience.

## Prerequisites

- An Azure account and subscription. If you don't have a subscription, [sign up for a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A *Standard* logic app resource [in single-tenant Azure Logic Apps](single-tenant-overview-compare.md). For more information, see [Create an example Standard logic app workflow in single-tenant Azure Logic Apps using the Azure portal](create-single-tenant-workflows-azure-portal.md).
- A workflow for your Standard logic app resource.

## Access the workflow designer

Use the steps below to open the workflow designer for a specific workflow so you can view and edit its cards.

1. In the [Azure portal](https://portal.azure.com), open your [*logic app* resource](logic-apps-overview.md#logic-app-concepts).

1. On the Logic App menu, under **Workflows**, select **Workflows**.

   > [!NOTE]
   > To enable the new Logic Apps designer experience, select the **Enable preview** button from the ribbon banner.
   > :::image type="content" source="media/designer-overview/enable-preview.png" alt-text="A screenshot of the Workflows options in the working pane of the Azure portal with the Enable preview button emphasized. ":::

From here, you can [create a new workflow](#create-a-new-workflow) or [access an existing workflow](#edit-an-existing-workflow). 

## Create a new workflow

1. On the **Workflows** page, select the **+ Create** button to create a new workflow.

1. The Create workflow options appear. 
 
1. Provide a name for your workflow.

1. Select from the available workflow types:
   - Stateful
   - Stateless
   - Start from template

   Compare workflow types to choose the pattern that fits your scenario.

   | Feature | Stateful | Stateless |
   |---|---|---|
   | Support for agents | Yes | - |
   | Support Agent-to-Agent (A2A) protocol | Yes | — |
   | Multi-agent patterns | Yes | — |
   | Any available trigger | Yes | Yes |
   | Run fast | — | Yes |
   | Store workflow run history | Yes | — |
   | Run asynchronously | Yes | — |
   | Support long-running workflows | Yes | — |
   | Handle large data | Yes | — |

1. Select the **Create** button.

1. The workflow designer opens.

   The designer displays the selected workflow as editable cards where you can visually edit steps, run the draft, switch to Code view, or open Run history.

## Edit an existing workflow

1. On the **Workflows** page, select the workflow that you want.

1. The workflow designer opens.

   The designer displays the selected workflow as editable cards where you can visually edit steps, run the draft, switch to Code view, or open Run history.

## Changes in the new designer

This section summarizes the most important changes from the classic designer to help returning users get oriented quickly.

- The new designer moves many familiar actions to new locations.
      - The top of the designer contains the [view selector](#view-selector) (Workflow, Code, and Run history).
      - The Run action is at the bottom of the designer canvas.
- Several actions that were in the workflow sidebar or toolbar are now available from the vertical [ellipsis menu](#ellipsis-menu) next to **Publish**.
- The designer always shows and edits the draft version. All changes are automatically saved to the draft; there's no explicit Save button.

> [!IMPORTANT]
>
> - The production (published) version is unchanged until you select **Publish**. If you run a workflow from the designer, the draft version is executed.
> - If you need to view the published (production) version as read-only, use **Switch to published version** from the [ellipsis menu](#ellipsis-menu).

If you prefer to use the classic designer, select the [ellipsis menu](#ellipsis-menu) > **Revert to previous experience**.

### View selector

The view selector (Workflow, Code, and Run history) is at the top of the designer—select a view to switch between visual editing, code, and run history.

- To visually develop, edit, and run your workflow, select the **Workflow** view.
- To edit the workflow in JSON, select **Code**. You can switch between the workflow view and code view at any time.

    > [!TIP]
    > The **Code** view is also an easy way to find and copy the workflow definition, instead of using the Azure CLI or other methods.

- To review your logs, select the **Run history** view.

### Ellipsis menu

In the new designer, many workflow actions are now found in the vertical ellipsis menu (⋮) next to the **Publish** button at the top right. Select this menu to access options.

:::image type="content" source="media/designer-overview/ellipsis.png" alt-text="Screenshot showing the ellipsis menu next to the Publish button in the new designer.":::

### Where to find common actions

 Use the table to quickly find where each common task is performed.

| Task | Classic designer | New designer |
|---|---|---|
| Access keys | Sidebar Configuration > **Access keys** | Next to **Publish**, ellipsis menu > **Settings** (then **Access keys**) |
| Code view (JSON) | Sidebar Tools > **Code** or toolbar > **Code view** | At the designer top > **Code** |
| Connections | Workflow toolbar: **Connections** | Next to **Publish**, ellipsis menu > **Connections** |
| Designer view | Sidebar Tools > **Designer** or toolbar > **Designer** | At the designer top > **Workflow** |
| Disable/Enable workflow | Sidebar Configuration > **Settings** | Next to **Publish**, ellipsis menu > **Disable** / **Enable** |
| Discard changes | Workflow toolbar: **Discard** | Next to **Publish**, open the vertical ellipsis menu > **Discard changes** |
| Download workflow summary | Workflow toolbar: **Download workflow summary** | Next to **Publish**, ellipsis menu > **Download workflow summary** |
| Parameters | Workflow toolbar: **Parameters** | Next to **Publish**, ellipsis menu > **Parameters** |
| Properties / Info | Sidebar Configuration > **Properties** | Next to **Publish**, ellipsis menu > **Information** |
| Publish draft | N/A | Designer upper-right > **Publish** |
| Run history | Sidebar Tools > **Run history** | Designer top > **Run history** (then select a run to open monitoring view) |
| Run workflow | Workflow toolbar: **Run** / **Run with payload** | At the bottom of the designer: **Run** / **Run with payload** |
| View production version | N/A | Next to **Publish**, ellipsis menu > **Switch to published version** |

## Add steps to workflows

The workflow designer provides a visual way to add, edit, and delete steps in your workflow. As the first step in your workflow, always add a [*trigger*](logic-apps-overview.md#logic-app-concepts). Then, complete your workflow by adding one or more [*actions*](logic-apps-overview.md#logic-app-concepts).

To add a trigger or an action to your Standard workflow, see [Build a workflow with a trigger or action in Azure Logic Apps](create-workflow-with-trigger-or-action.md).

1. Configure your trigger or action as needed.

   - Mandatory fields have a red asterisk (&ast;) in front of the name.

   - Some triggers and actions might require you to create a connection to another service. You might need to sign into an account, or enter credentials for a service. For example, if you want to use the Office 365 Outlook connector to send an email, you need to authorize your Outlook email account.

   - Some triggers and actions use dynamic content, where you can select variables instead of entering information or expressions.

   - Changes are saved automatically to the draft version as you edit. To validate and push your changes to production, select **Publish** in the designer upper-right. Use the Run button at the bottom of the designer to run the draft. If Save/Auto-save errors occur, the designer shows validation messages inline.

## Next steps

> [!div class="nextstepaction"]
> [Create an integration workflow with single-tenant Azure Logic Apps (Standard) in the Azure portal](create-single-tenant-workflows-azure-portal.md)
