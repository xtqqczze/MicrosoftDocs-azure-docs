---
title: "Azure System Policy"
description: A guide to understand Azure system policy definitions and assignments.
ms.date: 11/03/2025
ms.topic: how-to
author: nehakulkarni
ms.author: nehakulkarni
---
# What is System Policy?
Azure Policy’s system policy capability enables Microsoft to apply critical, system-level requirements across customer tenants in a safe, controllable manner. Just like existing policy assignments, system policies are applied at a per-tenant basis, and may be applied at any resource hierarchy scope. The rationale for applying system policy assignments is typically due to security.

## What kind of effect can a system policy have on my environment?
System policies can block resource creation or updates depending on resource configuration (for example, resource location). System policy cannot modify resource configuration. System policies do not generate compliance reports. However, they may generate audit or deny events in activity log.
## How can I interact with system policies?
System policies are Microsoft managed. Customers may not edit or delete system policy assignments. Each system policy will surface a violation message that describes the restriction and includes a relevant documentation link.
## How can I see what system policies are applied on my environment?
System policy definitions and assignments are viewable in API, Azure Resource Graph, and other supported SDKs. System policies share a policy definition category of ‘System Policy’, which is found in the policy definition metadata. System policy definitions & assignments are not surfaced in Portal or documentation.
