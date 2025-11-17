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

## Differences in the preview designer

To help you quickly learn about the updated layout in the preview designer, this section summarizes the primary differences from classic designer.

> [!IMPORTANT]
>
> - The production (published) version is unchanged until you select **Publish**. If you run a workflow from the designer, the draft version is executed.
> - If you need to view the published (production) version as read-only, use **Switch to published version** from the [ellipsis menu](#ellipsis-menu).

The preview designer moves many familiar actions to new locations:

- For different views of your workflow, the simplified designer toolbar provides a [view selector](#view-selector) where you can select **Workflow**, **Code**, or **Run history**.

- The **Run** and **Run with payload** options appear at the designer bottom.

- In the designer's top right corner, the new vertical ellipsis menu (**⋮**) appears next to the new **Publish** button. This menu contains other actions that appeared on the workflow sidebar or toolbar.

## Open the workflow designer

Follow these steps to open the workflow designer.

# [Classic designer](#tab/classic)

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource.

1. On the logic app sidebar, under **Workflows**, select **Workflows**.

From here, you can [create a new workflow](#create-a-new-workflow) or [access an existing workflow](#access-an-existing-workflow).

# [Preview designer](#tab/preview)

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource.

1. On the logic app sidebar, under **Workflows**, select **Workflows**.

1. To enable the [new designer](#changes-in-the-new-designer) (preview), select the **Enable preview** button from the ribbon banner.
   
   :::image type="content" source="media/designer-overview/enable-preview.png" alt-text="A screenshot of the Workflows options in the working pane of the Azure portal with the Enable preview button emphasized. ":::

From here, you can [create a new workflow](#create-a-new-workflow) or [access an existing workflow](#access-an-existing-workflow).

---

## Create a new workflow

# [Classic designer](#tab/classic)

Follow these steps to create a new workflow in your logic app.

1. On the **Workflows** page toolbar, select **+ Create**.

   The **Create workflow** pane with the workflow types appears.

1. For **Workflow name**, enter a name for your workflow.

1. Select from the following workflow types:
   - **Autonomous agents**: Stateful workflows use AI agents to complete tasks and can start from any trigger, such as an event, schedule, or API call.
   - **Conversational agents**: Stateful workflows use AI agents to complete interactions through chat interactions or other agents. 
   - **Stateful**: Build workflows that include run history. Add agents to build intelligent automation integrations.
   - **Stateless**: Build workflows that don't include run history, by default. Optimized for speed and ideal for request-response and processing IoT events.

1. Select **Create**.

The designer opens and shows an empty workflow with the prompt to add a trigger.

# [Preview designer](#tab/preview)

Follow these steps to create a new workflow in your logic app.

1. On the **Workflows** page toolbar, select **+ Create**.

   The **Create workflow** pane with the workflow types appears.

1. For **Workflow name**, enter a name for your workflow.

1. Select from the following workflow types:

   > [!IMPORTANT]
   > If you want agent workflows, choose **Stateful**.

   - **Stateful**: Build workflows that include run history. Add agents to build intelligent automation integrations.
   - **Stateless**: Build workflows that don't include run history, by default. Optimized for speed and ideal for request-response and processing IoT events.
   - **Start from template**: Select a prebuilt template that supports a common workflow pattern or scenario.

1. Select **Create**.

The designer opens and shows an empty workflow with the prompt to add a trigger.

---

## Open an existing workflow in the designer

Follow these steps to open an existing workflow from your logic app.

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource.

1. On the logic app sidebar, under **Workflows**, select **Workflows**.

1. On the **Workflows** page, select your workflow.

1. The workflow designer opens.

   The designer opens and shows the selected workflow so that you can edit the steps, run the draft workflow, view the workflow run history, view the JSON workflow definition in code view, or other tasks.

---

## Add a trigger or action to a workflow

The designer provides a visual way to add, edit, and delete steps in your workflow. As the first step, always start by adding a [*trigger*](logic-apps-overview.md#logic-app-concepts) to start your workflow. You can then continue building the workflow by adding one or multiple [*actions*](logic-apps-overview.md#logic-app-concepts) that run after the trigger fires.

To add a trigger or an action to your Standard workflow, see [Build a workflow with a trigger or action in Azure Logic Apps](create-workflow-with-trigger-or-action.md). Then, configure your trigger or action as needed.

- Required parameters show a red asterisk (&ast;) next to the parameter name.

- Some triggers and actions might require you to create a connection to another service. You might need to sign in to an account, or enter credentials for a service. For example, if you want to use the Office 365 Outlook connector to send an email, you need to authorize your Outlook email account.

- Some trigger or action parameters let you provide expressions or dynamic content, which are outputs from previous steps, rather than hardcoded or static values.

## Save your changes

# [Classic designer](#tab/classic)

You must manually save your changes. On the designer toolbar, select **Save**.

# [Preview designer](#tab/preview)

No separate **Save** option exists. As you edit the workflow, your changes are automatically saved as a draft.

---

If validation errors happen when you save your changes or during auto-save, the designer shows validation messages.

## Switch between designer, code, and run history views

# [Classic designer](#tab/classic)

In the Sidebar tools, you can choose between the following views: **Workflow**, **Code**, and **Run history**.

- To build, edit, and run your workflow, select **Workflow**. To edit the workflow definition in JSON, select **Code**.

    > [!TIP]
    >
    > **Code** view is an easy way to find and copy the workflow definition, rather than using Azure CLI or other methods.

- To view your workflow run history, chronological execution, operation status, inputs, and outputs, select **Run history**.

# [Preview designer](#tab/preview)

At the designer top, the view selector shows the following views: **Workflow**, **Code**, and **Run history**. Select a view to switch between the designer, workflow JSON definition, and workflow run history.

:::image type="content" source="media/designer-overview/view-selector.png" alt-text="Screenshot shows the preview designer and the view selector at the top." lightbox="media/designer-overview/view-selector.png":::

- To build, edit, and run your workflow, select **Workflow**. To edit the workflow definition in JSON, select **Code**.

   You can switch between designer view and code view anytime. The preview experience automatically saves your workflow.

    > [!TIP]
    >
    > **Code** view is an easy way to find and copy the workflow definition, rather than using Azure CLI or other methods.

- To view your workflow run history, chronological execution, operation status, inputs, and outputs, select **Run history**.

---

## Run workflow

# [Classic designer](#tab/classic)

To run your workflow, select **Run** / **Run with payload** from the Workflow toolbar.

# [Preview designer](#tab/preview)

To run your workflow, select **Run** / **Run with payload** at the bottom of the designer.

---

## Validate changes and deploy to production

# [Classic designer](#tab/classic)

Saving your workflow automatically validates and publishes your changes to production.

# [Preview designer](#tab/preview)

In the designer upper-right corner, select **Publish**.

---

# [Classic designer](#tab/classic)

## Sidebar Configuration

| Task | Label |
|---|---|
| Access keys | **Access keys** |
| Disable/Enable workflow | **Settings** |
| Properties / Info | **Properties** |

## Workflow toolbar

| Task | Label |
|---|---|
| Connections | **Connections** |
| Discard changes | **Discard** |
| Download workflow summary | **Download workflow summary** |
| Parameters | **Parameters** |

# [Preview designer](#tab/preview)

## Ellipsis menu

The preview designer moves many other actions to the vertical ellipsis menu (**⋮**) next to the **Publish** button in the designer's upper-right corner. To view and select these options, open this menu.

:::image type="content" source="media/designer-overview/ellipsis.png" alt-text="Screenshot show the preview designer and toolbar with vertical ellipsis menu next to the Publish button." lightbox="media/designer-overview/ellipsis.png":::

| Task | Label |
|---|---|
| Access keys | **Settings** > **Access keys** |
| Connections | **Connections** |
| Disable/Enable workflow | **Disable** / **Enable** |
| Discard changes | **Discard changes** |
| Download workflow summary | **Download workflow summary** |
| Parameters | **Parameters** |
| Properties / Info | **Information** |
| View production version | **Switch to published version** |

---

## Related content

> [!div class="nextstepaction"]
> [Create an integration workflow with single-tenant Azure Logic Apps (Standard) in the Azure portal](create-single-tenant-workflows-azure-portal.md)
