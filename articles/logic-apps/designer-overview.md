---
title: Navigate the Standard Workflow Designer
description: Learn to open and navigate the designer in the Azure portal so you can create and run Standard workflows in single-tenant Logic Apps.
services: logic-apps
ms.suite: integration
ms.reviewers: estfan, azla
ms.topic: how-to
ms.date: 11/18/2025
ms.custom: sfi-image-nochange
#Customer intent: As an integration developer working with Azure Logic Apps, I want to learn how to navigate the designer and complete basic tasks for creating and managing for Standard workflows.
---

# Navigate the Standard workflow designer for single-tenant Azure Logic Apps

[!INCLUDE [logic-apps-sku-standard](../../includes/logic-apps-sku-standard.md)]

This guide summarizes common tasks for using the designer to create, edit, and run Standard workflows in the Azure portal. The guide also highlights key changes between the classic designer and preview designer.

For example, the preview designer includes the following top significant behavior changes:

- By default, the designer shows and automatically saves your workflow as a *draft* version. This version differs from the published workflow deployed in production.

  - Your production workflow stays unchanged until you publish your draft workflow.

  - When you run the workflow from the designer, the draft workflow runs, not the production workflow.

  - To view the production workflow, in the designer upper-right corner, open the vertical ellipsis menu (**⋮**), and select **Switch to published version**. For more information, see [Ellipsis menu](#ellipsis-menu).
  
     This gesture opens the production workflow in read-only view.

- The designer toolbar options are consolidated. Some options appear at the designer bottom. Most options appear next to the **Publish** button in the vertical ellipsis menu (**⋮**).

- The workflow sidebar no longer exists. Most sidebar options appear either on the designer toolbar or in the vertical ellipsis menu (**⋮**).

- To return to the classic designer, in the designer upper-right corner, open the vertical ellipsis menu (**⋮**), and select **Revert to previous experience**.

For more detailed changes, see [Differences in the preview designer](differences-in-the-preview-designer].

## Prerequisites

- An Azure account and subscription. [Get a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- A Standard logic app resource in single-tenant Azure Logic Apps. This logic app can have either no workflows or existing workflows.

  For more information, see [Create a Standard logic app workflow with the Azure portal](create-single-tenant-workflows-azure-portal.md).
- A workflow for your Standard logic app resource.

## Open the workflow designer

Follow these steps to open the workflow designer.

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource.

1. On the logic app sidebar, under **Workflows**, select **Workflows**.

   > [!NOTE]
   > To enable the [new designer](#changes-in-the-new-designer) (preview), select the **Enable preview** button from the ribbon banner.
   > :::image type="content" source="media/designer-overview/enable-preview.png" alt-text="A screenshot of the Workflows options in the working pane of the Azure portal with the Enable preview button emphasized. ":::

From here, you can [create a new workflow](#create-a-new-workflow) or [access an existing workflow](#access-an-existing-workflow).

## Create a new workflow

Follow these steps to create a new workflow in your logic app.

1. On the **Workflows** page toolbar, select **+ Create** > **+ Create**.

   The **Create workflow** pane with the workflow types appears.

1. For **Workflow name**, enter a name for your workflow.

1. Select from the following workflow types:
   - **Stateful**: Build workflows that include run history. Add agents to build intelligent automation integrations.
   - **Stateless**: Build workflows that don't include run history, by default. Optimized for speed and ideal for request-response and processing IoT events.
   - **Start from template**: Select a prebuilt template that supports a common workflow pattern or scenario.

1. Select **Create**.

1. The workflow designer opens.

The designer opens and shows an empty workflow with the prompt to add a trigger.

## Open an existing workflow in the designer

Follow these steps to open an existing workflow from your logic app.

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource.

1. On the logic app sidebar, under **Workflows**, select **Workflows**.

1. On the **Workflows** page, select your workflow.

1. The workflow designer opens.

   The designer opens and shows the selected workflow so that you can edit the steps, run the draft workflow, view the workflow run history, view the JSON workflow definition in code view, or other tasks.

## Add a trigger or action to a workflow

The designer provides a visual way to add, edit, and delete steps in your workflow. As the first step, always start by adding a [*trigger*](logic-apps-overview.md#logic-app-concepts) to start your workflow. You can then continue building the workflow by adding one or multiple [*actions*](logic-apps-overview.md#logic-app-concepts) that run after the trigger fires.

To add a trigger or an action to your Standard workflow, see [Build a workflow with a trigger or action in Azure Logic Apps](create-workflow-with-trigger-or-action.md). Then, configure your trigger or action as needed.

- Required parameters show a red asterisk (&ast;) next to the parameter name.

- Some triggers and actions might require you to create a connection to another service. You might need to sign in to an account, or enter credentials for a service. For example, if you want to use the Office 365 Outlook connector to send an email, you need to authorize your Outlook email account.

- Some trigger or action parameters let you provide expressions or dynamic content, which are outputs from previous steps, rather than hardcoded or static values.


- Save your changes

  | Designer | Gesture |
  |----------|---------|
  | Classic | You must manually save your changes. On the designer toolbar, select **Save**. |
  | Preview | No separate **Save** option exists. As you edit the workflow, your changes are automatically saved as a draft. |

  If validation errors happen when you save your changes or during auto-save, the designer shows validation messages.

- Run the workflow

  | Designer | Gesture |
  |----------|---------|
  | Classic | On the designer toolbar, select **Run** > **Run with payload**. |
  | Preview | To run the draft workflow, at the designer bottom, select **Run** or **Run with payload**. |

- Validate changes and deploy to production

  | Designer | Gesture |
  |----------|---------|
  | Classic | Saving your workflow automatically validates and publishes your changes to production. |
  | Preview | In the designer upper-right corner, select **Publish**. |

## Differences in the preview designer

To help you quickly learn about the updated layout in the preview designer, this section summarizes the priority differences from classic designer.

The preview designer moves many familiar actions to new locations:

- For different views of your workflow, the simplified designer toolbar provides a [view selector](#view-selector) where you can select **Workflow**, **Code**, or **Run history**.

- The **Run** and **Run with payload** options appear at the designer bottom.

- Several actions that were in the workflow sidebar or toolbar are now available from the vertical [ellipsis menu](#ellipsis-menu) next to **Publish**.

The designer always shows and edits the draft version. All changes are automatically saved to the draft; there's no explicit Save button.

> [!IMPORTANT]
>
> - The production (published) version is unchanged until you select **Publish**. If you run a workflow from the designer, the draft version is executed.
> - If you need to view the published (production) version as read-only, use **Switch to published version** from the [ellipsis menu](#ellipsis-menu).

If you prefer to use the classic designer, select the [ellipsis menu](#ellipsis-menu) > **Revert to previous experience**.

### View selector

The view selector (Workflow, Code, and Run history) is at the top of the designer. Select a view to switch between visual editing, code, and run history.

:::image type="content" source="media/designer-overview/view-selector.png" alt-text="Screenshot showing the view selector at the top of the new designer.":::

- To visually develop, edit, and run your workflow, select the **Workflow** view.
- To edit the workflow in JSON, select **Code**. You can switch between the workflow view and code view at any time.

    > [!TIP]
    > The **Code** view is also an easy way to find and copy the workflow definition, instead of using the Azure CLI or other methods.

- To review your logs, select the **Run history** view.

### Ellipsis menu

In the new designer, you can find many workflow actions in the vertical ellipsis menu (⋮) next to the **Publish** button at the top right. Select this menu to access options.

:::image type="content" source="media/designer-overview/ellipsis.png" alt-text="Screenshot showing the ellipsis menu next to the Publish button in the new designer.":::

### Where to find common actions

 Use the table to quickly find where you can perform each common task.

| Task | Classic designer | Preview designer |
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

## Related content

> [!div class="nextstepaction"]
> [Create an integration workflow with single-tenant Azure Logic Apps (Standard) in the Azure portal](create-single-tenant-workflows-azure-portal.md)
