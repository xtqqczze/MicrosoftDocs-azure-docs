---
title: Register and discover agents in your API inventory
description: "How to manually register, publish, and manage A2A agents in API Center."
author: ProfessorKendrick
ms.author: kkendrick
ms.service: API Center
ms.topic: how-to
ms.date: 11/03/2025

#customer intent: As an API platform owner, I want to register and publish A2A agents so that developers can discover and integrate them.

---

# Register and discover agents in your API inventory

The agent registry within Azure API Center provides a centralized platform for discovering, registering, and managing AI agents. It supports first party and third party agents, integrates with API Management for private endpoints and stores customizable metadata to improve discoverability and governance.

## Prerequisites

- Have an Azure account with API platform access.
- Have permission to add or manage APIs in API Center (API platform owner or equivalent).
- Have access to your organization's API Center portal.
- Provide agent endpoint and version information, provider name, and URL (optional).

## Register an A2A agent

Follow these task-oriented steps to add an A2A agent to the API Center inventory so it appears with the correct agent card and skills metadata.

1. Sign in to the Azure portal, then navigate to your API center.

1. In the sidebar menu, under Assets, select **APIs**. 

1. In the Register an API page, select **+ Register an API**.

1. Fill in the required form data. 

1. In the **Register an API** page, add the following information:

    |Setting|Description|
    |-------|-----------|
    |**API title**| Name you choose for the API  |
    |**Identification**| Azure resource name for the API |
    |**API type**| Choose **A2A**. |
    | **Summary** | Summary description of the API  |
    | **Description** | Description of the API |
    | **Version** | |
    |**Version title**|Name you choose for the API version |
    |**Version identification**| Azure resource name for the version |
    |**Version lifecycle**  | Lifecycle stage of the API version |
    |**External documentation**     | Name, description, and URL of documentation for the API     |
    |**License**         | Name, URL, and ID of a license for the API     |
    |**Contact information**         | Name, email, and URL of a contact for the API     |
    | **Line of business** | Custom metadata that identifies the business unit that owns the API  |
    | **Public-facing**  | Custom metadata that identifies whether the API is public-facing or internal only    |

    :::image type="content" source="./media/register-apis/register-api.png" alt-text="Screenshot of the dialog box to register an API in the Azure portal." lightbox="./media/register-apis/register-api.png":::

1. Select **Create** to register the API.

## Discover A2A agents

1. Open API Center portal.
1. Use the search to find your agent.
1. Select an agent to view details: endpoint URL, version, skills, provider, and policies.
1. Use the displayed endpoint and version to integrate or call the agent from clients or other agents.

## Clean up resources

To remove an A2A agent:

1. Open the agent entry in the API Center inventory.
1. Choose Delete or Remove and confirm the action.
1. Verify the agent is removed from inventory and from any dependency maps.

## Troubleshooting



## Related content

- [Tutorial: Register APIs in your API inventory](../tutorials/register-apis.md)
- API Center portal documentation (link)
