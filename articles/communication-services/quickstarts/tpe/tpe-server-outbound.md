---
title: Azure Communication Services Call Automation How-to for Placing TPE Calls with Call Automation 
titleSuffix: An Azure Communication Services how-to document
description: The article shows how to use call actions to place a server outbound call for Teams Phone extensibility
author: ashwinder
ms.topic: how-to
ms.service: azure-communication-services
ms.subservice: call-automation
ms.date: 10/31/2025
ms.author: henikaraa
services: azure-communication-services
---


# Place Server-Initiated Outbound Calls with Teams Phone Extensibility

Teams Phone Extensibility (TPE) lets applications place outbound calls through Microsoft Teams using **Call Automation APIs**. Use this feature for automated notifications, customer callbacks, or workflow integration.

From **Call Automation version 1.5.0-beta.1**, use the `CreateCallAsync` API to call PSTN endpoints or Teams users from your server application.

## Prerequisites
Before you start:
- Install **Azure.Communication.CallAutomation** version **1.5.0-beta.1** or later.
- You need:
  - A **Teams Resource Account** (caller identity)
  - The **Object ID (OID)** of the Resource Account
  - A valid **callback URI** to receive events
- See:
  - [Call Automation concepts](/azure/communication-services/concepts/call-automation)
  - [Action-event model](/azure/communication-services/concepts/call-automation#action-event-model)
- Learn about the [user identifiers](../../concepts/identifiers.md#the-communicationidentifier-type) like `TeamsExtensionUser` and `PhoneNumberIdentifier`.

For all the code samples, `client` is the `CallAutomationClient` object that you can create. Also, `callConnection` is the `CallConnection` object that you obtain from the `Answer` or `CreateCall` response. You can also obtain it from callback events that your application receives.

## License Requirement

As of **November 1, 2025**, Calling Plan licenses on Teams resource accounts will no longer be supported for On-Behalf-Of PSTN outbound calls as well as server initiated outbound calls. A **[Pay-As-You-Go license](/microsoftteams/calling-plans-for-office-365#pay-as-you-go-calling-plan)** will be required.
Expand the sections below for more information.
<details><summary>For Calling Plan customers who received MC1123835</summary>
Starting November 1, 2025, a Pay-As-You-Go license will be required for Teams Resource Accounts, provisioned for Teams Phone extensibility and that use Calling Plan numbers for outbound PSTN calls.
If Pay-As-You-Go licenses aren't assigned to the relevant Teams Resource Accounts by November 1, 2025, outbound calls will fail.
</details>

<details>
<summary>For Operator Connect customers who received MC1123837</summary>

On November 1, 2025, the On-Behalf-Of PSTN outbound calls as well as server initiated outbound calls, may no longer be available depending on your carrier/operator. Coordinate with your carrier/operator to ensure you continue to have uninterrupted service for these scenarios. If the appropriate arrangements aren't made with your carrier/operator, then outbound calls made by agents on behalf of Teams resource accounts via the Teams Phone Extensibility will fail. Your carrier/operator provides the details on what adjustments may be required.
</details>

**Note:** Direct Routing phone numbers remain unchanged.

**Learn more:**
- [Pay-As-You-Go Calling Plan](/microsoftteams/pay-as-you-go)
- [How to buy Calling Plans](/microsoftteams/calling-plans)
- [Enable pay-as-you-go for your subscription](/microsoftteams/payg-enable)
- [Telco pay-as-you-go overage in new commerce](/microsoftteams/new-commerce-payg)
- [Assign Teams add-on licenses to users](/microsoftteams/assign-licenses)




## How It Works
1. **Create a CallInvite** for the target phone number.
2. **Specify TeamsAppSource** using the Teams Resource Account OID.
3. Invoke `CreateCallAsync` on the `CallAutomationClient`.

When the call connects, you’ll receive events such as:
- **CallConnected**: Indicates the call was successfully established.
- **ParticipantsUpdated**: Provides the current participant list.

If the call fails, you’ll receive:
- **CallDisconnected**
- **CreateCallFailed** (with error codes for troubleshooting).


## Code Example (C#)

```csharp

public async Task PlaceOutboundCallAsync(string targetPhoneNumber, Uri baseUri)
{
    // Initialize CallAutomationClient with your connection string
    var callAutomationClient = new CallAutomationClient("<resource_connection_string>");

    // Convert target number to EL64 format if required by your helper logic
    PhoneNumberIdentifier callee = new PhoneNumberIdentifier(Helper.convertToEl64(targetPhoneNumber));

    // Create CallInvite for the callee
    CallInvite callInvite = new CallInvite(callee, null);

    // Configure call options with TeamsAppSource (Teams Resource Account OID)
    var createCallOptions = new CreateCallOptions(callInvite, baseUri)
    {
        TeamsAppSource = new MicrosoftTeamsAppIdentifier("xxxxxxxxxxxxxxxxxxxxx") // Replace with Teams Resource Account OID
    };

    // Place the call
    CreateCallResult createCallResult = await callAutomationClient.CreateCallAsync(createCallOptions);

    // Use createCallResult.CallConnection for further actions (e.g., play audio, transfer)
}
```

```mermaid
sequenceDiagram
    participant App as Customer's Application
    participant CallAutomation as Call Automation API
    participant PSTN as PSTN Endpoint

    App->>CallAutomation: CreateCallAsync (CallInvite, TeamsAppSource)
    CallAutomation-->>App: CreateCallResult (CallConnection)
    CallAutomation->>PSTN: Initiate outbound call
    PSTN-->>CallAutomation: CallConnected
    CallAutomation-->>App: Event: CallConnected
    CallAutomation-->>App: Event: ParticipantsUpdated
    Note over App,CallAutomation: If failure occurs
    CallAutomation-->>App: Event: CreateCallFailed + CallDisconnected
```

## Next steps

- [Microsoft Teams Phone overview](/microsoftteams/what-is-phone-system-in-office-365)
- [Set up Microsoft Teams Phone in your organization](/microsoftteams/setting-up-your-phone-system)
- [Access a user's Teams Phone separate from their Teams client](../../../quickstarts/tpe/teams-phone-extensibility-access-teams-phone.md)
- [Answer Teams Phone calls from Call Automation](../../../quickstarts/tpe/teams-phone-extensibility-answer-teams-calls.md)

## Related articles

- [Teams Phone extensibility overview](./teams-phone-extensibility-overview.md)
- [Teams Phone extensibility FAQ](./teams-phone-extensibility-faq.md)
