---
title: Create Autonomous AI Agent Workflows
description: Learn to build intelligent automation workflows with AI agents and LLMs that automatically perform tasks without human interactions in Azure Logic Apps.
services: logic-apps
ms.suite: integration
ms.reviewers: estfan, divswa, krmitta, LogicApps
ms.topic: how-to
ms.collection: ce-skilling-ai-copilot
ms.date: 11/18/2025
ms.update-cycle: 180-days
# Customer intent: As an AI integration developer who uses Azure Logic Apps, I want to build workflows that complete tasks using AI agents and other AI capabilities without human intervention in my integration solutions.
---

# Create autonomous agent workflows without human interactions in Azure Logic Apps

[!INCLUDE [logic-apps-sku-consumption-standard](../../includes/logic-apps-sku-consumption-standard.md)]

When you need AI-powered automation that runs independently, create *autonomous agent* workflows in Azure Logic Apps. These workflows use agents connected to *large language models* (LLMs) to automatically make decisions and complete tasks without requiring human intervention. Autonomous agent workflows also work well for automation that needs to run for a long time, requires stronger governance, isolation, and supports automated rollback or compensation strategies.

The following example workflow uses an agent to get weather forcasts and send email notifications.

:::image type="content" source="media/create-autonomous-agent-workflows/weather-example.png" alt-text="Screenshot shows Azure portal, workflow designer, and example autonomous agent." lightbox="media/create-autonomous-agent-workflows/weather-example.png":::

This guide shows how to create a Standard or Consumption logic app workflow using the **Autonomous Agents** workflow type. This workflow runs without human interaction and uses tools that you build to automatically complete tasks.

For a high-level overview about agentic workflows, see [AI agent workflows in Azure Logic Apps](/azure/logic-apps/agent-workflows-concepts).

## Prerequisites

- An Azure account and subscription. [Get a free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

- A Standard or Consumption logic app resource, which has different requirements:

  | Logic app | Requirement |
  |-----------|-------------|
  | Standard | Based on your development environment: <br><br>- Azure portal: A Standard logic app resource that has public access enabled for testing or a private endpoint in production. If you don't have this resource, see [Create Standard workflows in the Azure portal](/azure/logic-apps/create-single-tenant-workflows-azure-portal). <br><br>- Visual Studio Code: A Standard logic app project. If you don't have this project, see [Create Standard workflows in Visual Studio Code](/azure/logic-apps/create-standard-workflows-visual-studio-code), and make sure that you have the latest extension. <br><br>After you open the workflow designer, the steps for the designer are mostly similar between the portal and Visual Studio Code. Some interactions have minor differences. |
  | Consumption (preview) | Azure portal only: A Consumption logic app resource that uses the workflow type named **Autonomous Agents**. For more information, see [Create Consumption logic app workflows in the Azure portal](quickstart-create-example-consumption-workflow.md). <br><br>**Note**: Visual Studio Code support is unavailable. |

  The examples in this guide use the Azure portal.

- Based on your logic app, you might or might not need to create and deploy an LLM.

  - **Consumption**
  
    You don't need to bring or deploy a separate AI model. By default, your workflow includes an agent and Azure OpenAI Service model that's automatically hosted in your subscription and logic app region.

  - **Standard**
  
    You need one of the following AI models:

    | Model source | Description |
    |--------------|-------------|
    | [Azure OpenAI Service resource](/azure/ai-services/openai/overview) with a deployed [Azure OpenAI Service model](/azure/ai-services/openai/concepts/models) | You need the resource name when you connect to your deployed model in Azure OpenAI Service from an agent in your workflow. If you don't have this resource and model, see the following articles: <br><br>- [Create and deploy an Azure OpenAI Service resource](/azure/ai-services/openai/how-to/create-resource?pivots=web-portal) <br><br>- [Deploy a model](/azure/ai-services/openai/how-to/create-resource?pivots=web-portal#deploy-a-model) <br><br>Agent workflows support only specific models. For more information, see [Supported models](#supported-models-for-agent-workflows). |
    | [Azure OpenAI Service resource](/azure/ai-services/openai/overview) connected to an [Azure AI Foundry project](/azure/ai-foundry/what-is-azure-ai-foundry) and a deployed [Azure OpenAI model in Azure AI Foundry](/azure/ai-foundry/openai/concepts/models) | Make sure that you have a Foundry project, not a Hub based project. If you don't have this project, resource, and model, see the following articles: <br><br>- [Create and deploy an Azure OpenAI Service resource](/azure/ai-services/openai/how-to/create-resource?pivots=web-portal)<br><br>- [Create a project for Azure AI Foundry](/azure/ai-foundry/how-to/create-projects?tabs=ai-foundry) <br><br>- [Connect Azure AI services after you create a project](/azure/ai-services/connect-services-ai-foundry-portal#connect-azure-ai-services-after-you-create-a-project) or [Create a new connection in Azure AI Foundry portal](/azure/ai-foundry/how-to/connections-add?tabs=aoai%2Cblob%2Cserp&pivots=fdp-project#create-a-new-connection) <br><br>- [Deploy a model](/azure/ai-services/openai/how-to/create-resource?pivots=web-portal#deploy-a-model) <br><br>Agent workflows support only specific models. For more information, see [Supported models](#supported-models-for-agent-workflows). |

- The authentication to use when you set up your agent with an AI model, based on your logic app:

  - **Consumption**

    By default, the connection between your agent and AI model uses [OAuth 2.0 with Microsoft Entra ID](/entra/architecture/auth-oauth2) for authentication and authorization.

  - **Standard**

    - Managed identity authentication

      > [!NOTE]
      >
      > For Azure AI Foundry projects, you must use managed identity authentication.

      This connection supports authentication by using Microsoft Entra ID with a [managed identity](/entra/identity/managed-identities-azure-resources/overview). In production scenarios, Microsoft strongly recommends that you use a managed identity when possible. This option provides optimal and superior security at no extra cost. Azure manages this identity for you, so you don't have to provide or manage sensitive information such as credentials or secrets. This information isn't even accessible to individual users. You can use managed identities to authenticate access for any resource that supports Microsoft Entra authentication.

      To use managed identity authentication, your Standard logic app resource must enable the system-assigned managed identity. By default, the system-assigned managed identity is enabled on a Standard logic app. This release currently doesn't support using the user-assigned managed identity.

      > [!NOTE]
      >
      > If the system-assigned identity is disabled, [reenable the identity](/azure/logic-apps/authenticate-with-managed-identity?tabs=standard#enable-system-assigned-identity-in-the-azure-portal). 

      The system-assigned identity requires one of the following roles for Microsoft Entra role-based access control (RBAC), based on the [principle of least privilege](/entra/identity-platform/secure-least-privileged-access):

      | Model source | Role |
      |--------------|------|
      | Azure OpenAI Service resource | - **Cognitive Services OpenAI User** (least privileged) <br>- **Cognitive Services OpenAI Contributor** |
      | Azure AI Foundry project | **Azure AI User** |

      For more information about managed identity setup, see:

      - [Authenticate access and connections with managed identities in Azure Logic Apps](/azure/logic-apps/authenticate-with-managed-identity?tabs=standard)
      - [Role-based access control for Azure OpenAI Service](/azure/ai-services/openai/how-to/role-based-access-control)
      - [Role-based access control for Azure AI Foundry](/azure/ai-foundry/concepts/rbac-azure-ai-foundry)
      - [Best practices for Microsoft Entra roles](/entra/identity/role-based-access-control/best-practices)

    - URL and key-based authentication

      This connection supports authentication by using the endpoint URL and API key for your deployed AI model. However, you don't have to manually find these values before you create the connection. The values automatically appear when you select your model source.

      > [!IMPORTANT]
      >
      > Use this authentication option only for the examples in this guide, exploratory scenarios, nonproduction scenarios, or if your organization's policy specifies that you can't use managed identity authentication.
      >
      > In general, make sure that you secure and protect sensitive data and personal data, such as credentials, secrets, access keys, connection strings, certificates, thumbprints, and similar information with the highest available or supported level of security. Don't hardcode sensitive data, share with other users, or save in plain text anywhere that others can access. Set up a plan to rotate or revoke secrets in the case they become compromised.
      >
      > For more information, see:
      >
      > - [Best practices for protecting secrets](/azure/security/fundamentals/secrets-best-practices)
      > - [Secrets in Azure Key Vault](/azure/key-vault/secrets/) 
      > - [Automate secrets rotation in Azure Key Vault](/azure/key-vault/secrets/tutorial-rotation)

- To follow along with the examples, you need an email account to send email.

  The examples in this guide use an Outlook.com account. For your own scenarios, you can use any supported email service or messaging app in Azure Logic Apps, such as Office 365 Outlook, Microsoft Teams, Slack, and so on. The setup for other email services or apps are similar to the examples, but have minor differences.

[!INCLUDE [supported-models](includes/supported-models.md)]

## Billing

- Consumption: Billing is charged using the pay-as-you-go model, based on the number of tokens used for each agent action.

- Standard: Although agent workflows don't incur extra charges, AI model usage incurs charges. For more information, see the Azure [Pricing calculator](https://azure.microsoft.com/pricing/calculator/).

## Limitations and known issues

The following sections describe current limitations and any known issues in this release, based on your logic app resource type.

| Logic app | Limitations or known issues |
|-----------|-----------------------------|
| Both | To create tools for your agent, the following limitations apply: <br><br>- You can add only actions, not triggers. <br>- A tool must start with an action and always contains at least one action. <br>- A tool works only inside the agent where that tool exists. <br>- Control flow actions are unsupported. |
| Consumption | - Authentication: The connection between your agent and AI model uses [OAuth 2.0 with Microsoft Entra ID](/entra/architecture/auth-oauth2). |
| Standard | - Unsupported workflow types: **Stateless** <br><br>- Authentication: For managed identity authentication, only the system-assigned managed identity is supported. User-assigned managed identity is currently unsupported. <br><br>**Note**: Azure AI Foundry projects require that you use managed identity authentication. <br><br>- Agent action is throttled based on the number of tokens used. <br><br>- For general limits in Azure OpenAI Service, Azure AI Foundry, and Azure Logic Apps, see: <br><br>- [Azure OpenAI Service quotas and limits](/azure/ai-services/openai/quotas-limits) <br>- [Azure OpenAI in Azure AI Foundry Models quotas and limits](/azure/ai-foundry/openai/quotas-limits) <br>- [Azure Logic Apps limits and configuration](/azure/logic-apps/logic-apps-limits-and-config) |

## Create an autonomous agent workflow

The following section shows how to start creating your autonomous agent workflow.

### [Consumption](#tab/consumption)

For a Consumption logic app, the **Autonomous Agents** workflow type creates a partial workflow that starts with the **Request** trigger. The workflow also includes an **Agent** action.

To open this partial workflow, follow these steps:

1. In the [Azure portal](https://portal.azure.com), open your Consumption logic app resource.

1. On the resource sidebar, under **Development Tools**, select the designer to open the partial agentic workflow.

   The designer shows a partial workflow with the trigger named **When an HTTP request is received**. Under the workflow, an **Agent** action named **Default Agent** appears. For this scenario, you don't need any other trigger setup.

   :::image type="content" source="media/create-autonomous-agent-workflows/agent-workflow-start-consumption.png" alt-text="Screenshot shows workflow designer with trigger When an HTTP request is received and empty Default Agent." lightbox="media/create-autonomous-agent-workflows/agent-workflow-start-consumption.png":::

1. Continue to the next section to set up your agent.

### [Standard](#tab/standard)

For a Standard logic app, start by creating a new workflow or [add an agent to a nonagent **Stateful** workflow](#add-agent-nonagent-workflow).

#### Create a new workflow

To create a workflow with an empty **Agent**, follow these steps:

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource.

1. On the resource sidebar, under **Workflows**, select **Workflows**.

1. On the **Workflows** page toolbar, select **Add** > **Add**.

1. On the **Create workflow** pane, complete the following steps:

   1. For **Workflow name**, provide a name for your workflow.

   1. Select **Autonomous Agents** > **Create**.

      :::image type="content" source="media/create-autonomous-agent-workflows/select-autonomous-agents.png" alt-text="Screenshot shows Standard logic app with open Workflows page and Create workflow pane with workflow name, selected Autonomous Agents option, and Create button." lightbox="media/create-autonomous-agent-workflows/select-autonomous-agents.png":::

      The designer opens and shows a partial workflow, which includes an empty **Agent** action that you need to set up later. 

      :::image type="content" source="media/create-autonomous-agent-workflows/agent-workflow-start-standard.png" alt-text="Screenshot shows workflow designer with Add a trigger and empty Agent." lightbox="media/create-autonomous-agent-workflows/agent-workflow-start-standard.png":::

   Before you can save your workflow, you must complete the following setup tasks for the **Agent** action:

   - Connect your agent to your AI model. You complete this task in a later section.

   - Provide agent instructions that describe the roles that the agent plays, the tasks that the agent can perform, and other information to help the agent better understand how to operate. You also complete this task in a later section.

1. Add a trigger to your workflow.

   Your workflow requires a trigger to control when the workflow starts running. You can use any trigger that fits your scenario. For more information, see [Triggers](/azure/connectors/introduction#triggers).

   1. On the designer, select **Add trigger**.

   1. On the **Add a trigger** pane, follow these [general steps](/azure/logic-apps/create-workflow-with-trigger-or-action?tabs=standard#add-trigger) to add the best trigger for your scenario.

      This example uses the **Request** trigger named **When an HTTP request is received**. For this article, you don't need any other trigger setup.

      :::image type="content" source="media/create-autonomous-agent-workflows/request-trigger.png" alt-text="Screenshot shows workflow designer with Request trigger and Agent action." lightbox="media/create-autonomous-agent-workflows/request-trigger.png":::

   1. Skip the next section so you can set up your agent with an AI model.

<a name="add-agent-nonagent-workflow"></a>

#### Add an agent to a nonagent workflow

If you have an existing **Stateful** workflow, you can add an **Agent** action to include autonomous agent and LLM capabilities by following these steps:

1. In the [Azure portal](https://portal.azure.com), open your Standard logic app resource.

1. On the resource sidebar, under **Workflows**, select **Workflows**.

1. On the **Workflows** page, select the **Stateful** workflow you want.

1. After the designer opens, follow the [general steps](add-trigger-action-workflow.md?tabs=standard#add-action) to add an action named **Agent** to your workflow, for example:

   :::image type="content" source="media/create-autonomous-agent-workflows/add-agent.png" alt-text="Screenshot shows Azure portal, Standard workflow designer, existing workflow, and option to add an agent." lightbox="media/create-autonomous-agent-workflows/add-agent.png":::

1. Continue with the next section to set up your agent with an AI model.

---

> [!NOTE]
>
> If you try to save the workflow now, you get an error that workflow validation failed.
>
> In a Standard workflow, the designer toolbar also shows a red dot on the **Errors** button. The designer alerts you to this error condition because the agent requires setup before you can save any changes. However, you don't have to set up the agent now. You can continue to create your workflow. Just remember to set up the agent before you save your workflow.
>
> :::image type="content" source="media/create-autonomous-agent-workflows/error-missing-agent-settings.png" alt-text="Screenshot shows workflow designer toolbar and Errors button with red dot and error in the agent action information pane." lightbox="media/create-autonomous-agent-workflows/error-missing-agent-settings.png":::

<a name="connect-agent-to-model"></a>

## Set up the agent with an AI model

Follow the corresponding steps to set up your agent with the AI model that you want to use.

### [Consumption](#tab/consumption)

1. On the designer, select the title bar on the **Default Agent** action to open the information pane.

1. On the **Parameters** tab, provide the following information:

   | Parameter | Required | Value | Description |
   |-----------|----------|-------|-------------|
   | **Model Id** | Yes | <*model-version*> | The Azure OpenAI model to use. Some regions support **gpt-4o-mini**, while others support **gpt-5o-mini**. |

   The agent information pane now shows the selected AI model, for example:

   :::image type="content" source="media/create-autonomous-agent-workflows/connected-model-consumption.png" alt-text="Screenshot shows example connected deployed AI model." lightbox="media/create-autonomous-agent-workflows/connected-model-consumption.png":::

1. Continue to the next section to rename the agent.

### [Standard](#tab/standard)

1. On the designer, select the title bar on the **Agent** action to open the **Create connection** pane.

   This pane opens only if you don't have an existing working connection.

1. In the **Create a new connection** section, provide the following information:

   | Parameter | Required | Value | Description |
   |-----------|----------|-------|-------------|
   | **Connection Name** | Yes | <*connection-name*> | The name to use for the connection to your deployed AI model. <br><br>This example uses **fabrikam-azure-ai-connection**. |
   | **Agent Model Source** | Yes | - **Azure OpenAI** <br>- **Foundry Agent Service** | The source for the deployed AI model. |
   | **Authentication Type** | Yes | - **Managed identity** <br><br>- **URL and key-based authentication** | The authentication type to use for validating and authorizing an identity's access to your deployed AI model. <br><br>**Note**: For Azure AI Foundry projects, you must use managed identity authentication. <br><br>- **Managed identity** requires that your Standard logic app have a managed identity enabled and set up with the required roles for role-based access. For more information, see [Prerequisites](#prerequisites). <br><br>- **URL and key-based authentication** requires the endpoint URL and API key for your deployed AI model. These values automatically appear when you select your model source. <br><br>**Important**: For the examples and exploration only, you can use **URL and key-based authentication**. For production scenarios, use **Managed identity**. |
   | **Subscription** | Yes | <*Azure-subscripton*> | Select the Azure subscription associated with your Azure OpenAI Service resource. |
   | **Azure OpenAI Resource** | Yes, only when **Agent Model Source** is **Azure OpenAI** | <*Azure-OpenAI-Service-resource-name*> | Select your Azure OpenAI Service resource. |
   | **AI Foundry Project** | Yes, only when **Agent Model Source** is **Foundry Agent Service** | <*Azure-AI-Foundry-project-name*> | Select your project in Azure AI Foundry. <br><br>**Note**: If you recently assigned the necessary role on your project, you might experience a delay before role permissions take effect. Meanwhile, an error message appears that you don't have correct permissions on the project. |
   | **API Endpoint** | Yes | Automatically populated | The endpoint URL for your deployed AI model in Azure OpenAI Service. <br><br>This example uses **`https://fabrikam-azureopenai.openai.azure.com/`**. |
   | **API Key** | Yes, only when **Authentication Type** is **URL and key-based authentication** | Automatically populated | The API key for your deployed AI model in Azure OpenAI Service. |

   For example, if you select **Azure OpenAI** as your model source and **Managed identity** for authentication, your connection information looks like the following sample:

   :::image type="content" source="media/create-autonomous-agent-workflows/connection-azure-openai.png" alt-text="Screenshot shows example connection details for deployed model in Azure OpenAI Service." lightbox="media/create-autonomous-agent-workflows/connection-azure-openai.png":::

   If you select **Foundry Agent Service** as your model source with **Managed identity** for authentication, your connection information looks like the following sample:

   :::image type="content" source="media/create-autonomous-agent-workflows/connection-ai-foundry.png" alt-text="Screenshot shows example connection details for deployed model in Azure AI Foundry." lightbox="media/create-autonomous-agent-workflows/connection-ai-foundry.png":::

1. When you're done, select **Create new**.

   The agent information pane now shows the connected AI model, for example:

   :::image type="content" source="media/create-autonomous-agent-workflows/connected-model-standard.png" alt-text="Screenshot shows example connected deployed AI model." lightbox="media/create-autonomous-agent-workflows/connected-model-standard.png":::

   If you want to create a different connection, on the **Parameters** tab, scroll down to the bottom, and select **Change connection**.

1. Continue to the next section to rename the agent.

---

## Rename the agent

Update the agent name to clearly identify the agent's purpose by following these steps:

1. On the designer, select the agent title bar to open the agent information pane.

1. On the information pane, select the agent name, and enter the new name, for example, `Weather agent`.

   :::image type="content" source="media/create-autonomous-agent-workflows/rename-agent.png" alt-text="Screenshot shows workflow designer, workflow trigger, and renamed agent." lightbox="media/create-autonomous-agent-workflows/rename-agent.png":::

1. Continue to the next section to provide instructions for the agent.

## Set up agent instructions

The agent requires instructions that describe the roles that the agent can play and the tasks that the agent can perform. To help the agent learn and understand these responsibilities, you can also include the following information:

- Workflow structure
- Available actions
- Any restrictions or limitations
- Interactions for specific scenarios or special cases

For the best results, provide prescriptive instructions and be prepared to iteratively refine your instructions.

1. In the **Instructions for agent** box, enter the instructions that the agent needs to understand its role and tasks.

   For this example, the weather agent example uses the following sample instructions where you later provide a subscriber list with your own email address for testing:

   ```
   You're an AI agent that generates a weather report, which you send in email to each subscriber on a list. This list includes each subscriber's name, location, and email address to use.

   Format the weather report with bullet lists where appropriate. Make your response concise and useful, but use a conversational and friendly tone. You can include suggestions like "Carry an umbrella" or "Dress in layers".
   ```

   Here's an example:

   :::image type="content" source="media/create-autonomous-agent-workflows/weather-agent-instructions.png" alt-text="Screenshot shows workflow designer, and agent instructions." lightbox="media/create-autonomous-agent-workflows/weather-agent-instructions.png":::

1. Optionally, you can provide user instructions that the agent uses as prompts.

   For the best results, make each user instruction focus on a specific task, for example:

   1. On the agent information pane, under **User instructions** section, in the **User instructions Item - 1** box, enter the prompt for the agent.

   1. To add another instruction, select **Add new item**.

   1. In the **User instructions item - 2** box, enter another prompt for the agent.

   1. Repeat until you finish adding all the prompts that you want.

1. Now, you can save your workflow. On the designer toolbar, select **Save**.

## Check for errors

To make sure your workflow doesn't have errors at this stage, follow these steps:

### [Consumption](#tab/consumption)

1. On the designer toolbar, select **Run** > **Run**.

1. On the workflow sidebar, under **Development Tools**, select **Run history**.

1. On the **Run history** page, in the runs table, select the latest workflow run.

   > [!NOTE]
   >
   > If the page doesn't show any runs, on the toolbar, select **Refresh**.
   >
   > If the **Status** column shows a **Running** status, the agent workflow is still working.

   The monitoring view opens and shows the workflow operations with their status. The **Agent log** pane is open and shows the agent instructions that you provided earlier. The pane also shows the agent's response.

   :::image type="content" source="media/create-autonomous-agent-workflows/agent-only-test-consumption.png" alt-text="Screenshot shows monitoring view for Consumption workflow, operation status, and agent log." lightbox="media/create-autonomous-agent-workflows/agent-only-test-consumption.png":::

   The agent doesn't have any tools to use at this time, which means that the agent can't actually take any specific actions, such as send email to a subscriber list, until you create tools that the agent needs to complete tasks.

1. Return to the designer. On the monitoring view toolbar, select **Edit**.

### [Standard](#tab/standard)

1. On the designer toolbar, select **Run** > **Run**.

1. On the workflow sidebar, under **Tools**, select **Run history**.

1. On the **Run history** page, on the **Run history** tab, select the latest workflow run.

   > [!NOTE]
   >
   > If the page doesn't show any runs, on the toolbar, select **Refresh**.
   >
   > If the **Status** column shows a **Running** status, the agent workflow is still working.

   The monitoring view opens and shows the workflow operations with their status. The **Agent log** pane is open and shows the agent instructions that you provided earlier.

   :::image type="content" source="media/create-autonomous-agent-workflows/agent-only-test-standard.png" alt-text="Screenshot shows monitoring view for Standard workflow, operation status, and agent log." lightbox="media/create-autonomous-agent-workflows/agent-only-test-standard.png":::

   The agent doesn't have any tools to use at this time, which means that the agent can't actually take any specific actions, such as send email to a subscriber list, until you create tools that the agent needs to complete tasks.

1. Return to the designer. On the monitoring view toolbar, select **Edit**.

---

<a name="create-tool-weather"></a>

## Create a 'Get weather' tool

For an agent to run prebuilt actions available in Azure Logic Apps, you must create one or more tools for the agent to use. A tool must contain at least one action and only actions. The agent calls the tool by using specific arguments.

In this example, the agent needs a tool that gets the weather forecast. You can build this tool by following these steps:

1. On the designer, inside the agent and under **Add tool**, select the plus sign (**+**) to open the pane where you can browse available actions.

1. On the **Add an action** pane, follow the [general steps](/azure/logic-apps/create-workflow-with-trigger-or-action#add-action) for your logic app to add an action that's best for your scenario.

   This example uses the **MSN Weather** action named **Get current weather**.

   After you select the action, both the **Tool** container and the selected action appear in the agent on the designer. Both information panes also open at the same time.

   :::image type="content" source="media/create-autonomous-agent-workflows/added-tool-get-current-weather.png" alt-text="Screenshot shows workflow designer with the renamed agent, which contains a tool that includes the action named Get current weather." lightbox="media/create-autonomous-agent-workflows/added-tool-get-current-weather.png":::

1. On the tool information pane, rename the tool to describe its purpose. For this example, use `Get weather`.

1. On the **Details** tab, for **Description**, enter the tool description. For this example, use `Get the weather for the specified location.`

   :::image type="content" source="media/create-autonomous-agent-workflows/get-weather-tool.png" alt-text="Screenshot shows completed Get weather tool with description." lightbox="media/create-autonomous-agent-workflows/get-weather-tool.png":::

   Under **Description**, the **Agent Parameters** section applies only for specific use cases. For more information, see [Create agent parameters](#create-agent-parameters-for-the-get-current-weather-action).

1. Continue to the next section to learn more about agent parameters, their use cases, and how to create them, based on these use cases.

<a name="create-agent-parameters-get-weather"></a>

## Create agent parameters for 'Get current weather' action

Actions usually have parameters that require you to specify the values to use. Actions in tools are almost the same except for one difference. You can create agent parameters that the agent uses to specify the parameter values for actions in tools. You can specify model-generated outputs, values from nonmodel sources, or a combination. For more information, see [Agent parameters](agent-workflows-concepts.md#key-concepts).

The following table describes the use cases for creating agent parameters and where to create them, based on the use case:

| To | Where to create agent parameter |
|----|---------------------------------|
| Use model-generated outputs only. <br>Share with other actions in the same tool. | Start from the action parameter. For detailed steps, see [Use model-generated outputs only](#use-model-generated-outputs-only). |
| Use nonmodel values. | No agent parameters needed. <br><br>This experience is the same as the usual action setup experience in Azure Logic Apps but is repeated for convenience in [Use values from nonmodel sources](#use-values-from-nonmodel-sources). |
| Use model-generated outputs with nonmodel values. <br>Share with other actions in the same tool. | Start from the tool, in the **Agent Parameters** section. For detailed steps, see [Use model outputs and nonmodel values](#use-model-outputs-and-nonmodel-values).|

#### Use model-generated outputs only

For an action parameter that uses only model-generated outputs, create an agent parameter by following these steps:

1. In the tool, select the action to open the information pane.

   For this example, the action is **Get current weather**.

1. On the **Parameters** tab, select inside the parameter box to show the parameter options.

1. On the right edge of the **Location** box, select the stars button.

   This button has the following tooltip: **Select to generate the agent parameter**.

   :::image type="content" source="media/create-autonomous-agent-workflows/generate-agent-parameter.png" alt-text="Screenshot shows an action with the mouse cursor inside a parameter box, parameter options, and the selected option to generate an agent parameter." lightbox="media/create-autonomous-agent-workflows/generate-agent-parameter.png":::

   The **Create agent parameter** window shows the **Name**, **Type**, and **Description** fields, which are prepopulated from the source action parameter.

   The following table describes the fields that define the agent parameter:

   | Parameter | Value | Description |
   |-----------|-------|-------------|
   | **Name** | <*agent-parameter-name*> | The agent parameter name. |
   | **Type** | <*agent-parameter-data-type*> | The agent parameter data type. |
   | **Description** | <*agent-parameter-description*> | The agent parameter description that easily identifies the parameter's purpose. |

   > [!NOTE]
   >
   > Microsoft recommends that you follow the action's Swagger definition. For example, 
   > for the **Get current weather** action, which is from the **MSN Weather** "shared" 
   > connector hosted and managed by global, multitenant Azure, see the 
   > [**MSN Weather** connector technical reference article](/connectors/msnweather/#get-current-weather).

1. When you're ready, select **Create**.

   The following example shows the **Get current weather** action with the **Location** agent parameter:

   :::image type="content" source="media/create-autonomous-agent-workflows/get-current-weather-action.png" alt-text="Screenshot shows the Weather agent, Get weather tool, and selected action named Get current weather. The Location action parameter includes the created agent parameter." lightbox="media/create-autonomous-agent-workflows/get-current-weather-action.png":::

1. Save your workflow.

#### Use values from nonmodel sources

For an action parameter value that uses only nonmodel values, choose the option that best fits your use case:

**Use outputs from earlier operations in the workflow**

To browse and select from these outputs, follow these steps:

1. Select inside the parameter box, and then select the lightning icon to open the dynamic content list.

1. From the list, in the trigger or action section, select the output that you want. 

1. Save your workflow.

**Use results from expressions**

To create an expression, follow these steps:

1. Select inside the parameter box, and then select the function icon to open the expression editor.

1. Select from available functions to create the expression.

1. Save your workflow.

For more information, see [Reference guide to workflow expression functions in Azure Logic Apps](/azure/logic-apps/workflow-definition-language-functions-reference).

#### Use model outputs and nonmodel values

Some scenarios might need to specify an action parameter value that uses both model-generated outputs with nonmodel values. For example, you might want to create an email body that uses static text, nonmodel outputs from earlier operations in the workflow, and model-generated outputs.

For these scenarios, create the agent parameter on the tool by following these steps:

1. On the designer, select the tool where you want to create the agent parameter.

1. On the **Details** tab, under **Agent Parameters**, select **Create Parameter**.

1. Expand **New agent parameter**, and provide the following information, but match the action parameter details.

   For this example, the example action is **Get current weather**.

   > [!NOTE]
   >
   > Microsoft recommends that you follow the action's Swagger definition. For example, 
   > to find this information for the **Get current weather** action, see the 
   > [**MSN Weather** connector technical reference article](/connectors/msnweather/#get-current-weather). 
   > The example action is provided by the **MSN Weather** managed "shared" connector, 
   > which is hosted and run in global, multitenant Azure.
  
   | Parameter | Value | Description |
   |-----------|-------|-------------|
   | **Name** | <*agent-parameter-name*> | The agent parameter name. |
   | **Type** | <*agent-parameter-data-type*> | The agent parameter data type. |
   | **Description** | <*agent-parameter-description*> | The agent parameter description that easily identifies the parameter's purpose. You can choose from the following options or combine them to provide a description: <br><br>- Plain literal text with details such as the parameter's purpose, permitted values, restrictions, or limits. <br><br>- Outputs from earlier operations in the workflow. To browse and choose these outputs, select inside the **Description** box, and then select the lightning icon to open the dynamic content list. From the list, select the output that you want. <br><br>- Results from expressions. To create an expression, select inside the **Description** box, and then select the function icon to open the expression editor. Select from available functions to create the expression. |

   When you're done, under **Agent Parameters**, the new agent parameter appears.

1. On the designer, in the tool, select the action to open the action information pane.

1. On the **Parameters** tab, select inside the parameter box to show the parameter options, and then select the robot icon.

1. From the **Agent parameters** list, select the agent parameter that you defined earlier.

   The finished **Get weather** tool looks like the following example:

   :::image type="content" source="media/create-autonomous-agent-workflows/get-weather-tool-complete.png" alt-text="Screenshot shows agent and finished Get weather tool." lightbox="media/create-autonomous-agent-workflows/get-weather-tool-complete.png":::

1. Save your workflow.

## Create a 'Send email' tool

For many scenarios, an agent usually needs more than one tool. In this example, the agent needs a tool that sends the weather report in email.

To build this tool, follow these steps:

1. On the designer, inside the agent, next to the existing tool, select the plus sign (**+**) to add an action.

1. On the **Add an action** pane, follow these [general steps](/azure/logic-apps/create-workflow-with-trigger-or-action?tabs=standard#add-action) to select another action for your new tool.

   This example uses the **Outlook.com** action named **Send an email (V2)**.

   Like before, after you select the action, both the new **Tool** and action appear inside the agent on the designer. Both information panes open at the same time.

   :::image type="content" source="media/create-autonomous-agent-workflows/added-tool-send-email.png" alt-text="Screenshot shows workflow designer with Weather agent, Get weather tool, and new tool with action named Send an email (V2)." lightbox="media/create-autonomous-agent-workflows/added-tool-send-email.png":::

1. On the tool information pane, rename the tool to describe its purpose. For this example, use `Send email`.

1. On the **Details** tab, for **Description**, enter the tool description. For this example, use `Send current weather by email.`

   :::image type="content" source="media/create-autonomous-agent-workflows/send-email-tool.png" alt-text="Screenshot shows completed Send email tool with description." lightbox="media/create-autonomous-agent-workflows/send-email-tool.png":::

1. Save your workflow.

## Create agent parameters for the 'Send an email (V2)' action

The steps in this section are nearly the same as [Create agent parameters for the 'Get current weather' action](#create-agent-parameters-for-the-get-current-weather-action), except that you set up different agent parameters for the **Send an email (V2)** action.

1. Follow the earlier steps to create the following agent parameters for the action parameter values in the action named **Send an email (V2)**.

   The action needs three agent parameters named **To**, **Subject**, and **Body**. For the action's Swagger definition, see [**Send an email (V2)**](/connectors/outlook/#send-an-email-(v2)).

   When you're done, the example action uses the previously defined agent parameters as shown here:

   :::image type="content" source="media/create-autonomous-agent-workflows/send-email-action.png" alt-text="Screenshot shows the information pane for the action named Send an email V2, plus the previously defined agent parameters named To, Subject, and Body." lightbox="media/create-autonomous-agent-workflows/send-email-action.png":::

   The finished **Send email** tool looks like the following example:

   :::image type="content" source="media/create-autonomous-agent-workflows/send-email-tool-complete.png" alt-text="Screenshot shows the agent and finished Send email tool." lightbox="media/create-autonomous-agent-workflows/send-email-tool-complete.png":::

1. Save your workflow.

## Create a subscriber list tool

Finally, for this example, create a tool named **Get subscribers** to provide a subscriber list for the agent parameter values to use. This tool uses the **Compose** action to supply the subscriber name, email address, and location. Or, you might source these inputs from blob storage or a database. Azure Logic Apps offers many options that you can use as data sources.

For this example, follow these steps:

1. Rename the tool to `Get subscribers`.

1. In the **Get subscribers** tool, use the following description:

   `Get the list of subscribers, including their name, location, and email address. To generate the weather report, use the location for each subscriber. To send the weather report, use the email address for each subscriber.`

1. Rename to **Compose** action to `Subscriber list`. In the **Input** box, use the following JSON array but replace the sample subscriber data with the data that you want to use for testing.

   ```json
   [
       {
           "Name": "Fabrikam",
           "Email": "FabrikamGoods@outlook.com",
           "Location": "Boston"
       },
       {
           "Name": "Contoso",
           "Email": "ContosoGoods@outlook.com",
           "Location": "Jaipur"
       },
       {
           "Name": "Sophie Owen",
           "Email": "sophieowen@outlook.com",
           "Location": "Seattle"
       }
   ]
   ```

   The finished **Get subscribers** tool looks like the following example:

   :::image type="content" source="media/create-autonomous-agent-workflows/get-subscribers-tool-complete.png" alt-text="Screenshot shows the agent and finished Get subscribers tool." lightbox="media/create-autonomous-agent-workflows/get-subscribers-tool-complete.png":::

1. Save your workflow, then test the workflow to make sure everything works the way that you expect.

[!INCLUDE [best-practices-agent-workflows](includes/best-practices-agent-workflows.md)]

[!INCLUDE [troubleshoot-agent-workflows](includes/troubleshoot-agent-workflows.md)]

[!INCLUDE [clean-up-resources](includes/clean-up-resources.md)]

## Related content

- [AI agent workflows in Azure Logic Apps](/azure/logic-apps/agent-workflows-concepts)
- [Lab: Build your first autonomous agent workflow in Azure Logic Apps](https://azure.github.io/logicapps-labs/docs/logicapps-ai-course/build_autonomous_agents/create-first-autonomous-agent)
- [Azure Logic Apps limits and configuration](/azure/logic-apps/logic-apps-limits-and-config)
- [Azure OpenAI Service quotas and limits](/azure/ai-services/openai/quotas-limits)
