---
title: Configure Conditional Access Policies for Dev Tunnels
description: Learn how to configure conditional access policies for the Dev tunnels service in Microsoft Entra ID to secure remote development environments and restrict access based on device management and IP ranges.
author: RoseHJM
contributors:
ms.topic: how-to
ms.date: 10/02/2025
ms.author: rosemalcolm
ms.reviewer: rosemalcolm
ms.custom: peer-review-program
---

# Configure conditional access policies for Dev tunnels

Microsoft Dev Box gives you an alternative connectivity method on top of Dev tunnels. You can develop remotely while coding locally or keep development going during Azure Virtual Desktop (AVD) outages or poor network performance. Many large enterprises using Dev Box have strict security and compliance policies, and their code is valuable to their business. Restricting Dev tunnels with conditional access policies is crucial for these controls.

Conditional access policies for the Dev tunnels service:

- Let Dev tunnels connect from managed devices, but deny connections from unmanaged devices.
- Let Dev tunnels connect from specific IP ranges, but deny connections from other IP ranges.
- Support other regular conditional access configurations.
- Apply to both the Visual Studio Code application and VS Code web.

## Configure conditional access

The conditional access policies work correctly for the Dev tunnels service. Because registering the Dev tunnels service app to a tenant and making it available to the conditional access picker is unique, this article documents the steps.

## Enable the Dev tunnels service for the conditional access picker

The Microsoft Entra ID team is working on removing the need to onboard apps for them to appear in the app picker, with delivery expected in May. Therefore, we aren't onboarding Dev tunnel service to the conditional access picker. Instead, target the Dev tunnels service in a conditional access policy using [Custom Security Attributes](/entra/identity/conditional-access/concept-filter-for-applications).

1. Follow [Add or deactivate custom security attribute definitions in Microsoft Entra ID](/entra/fundamentals/custom-security-attributes-add?tabs=ms-powershell) to add the following Attribute set and New attributes.

   :::image type="content" source="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-custom-attributes.png" alt-text="Screenshot of the custom security attribute definition process in Microsoft Entra ID." lightbox="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-custom-attributes.png":::

   :::image type="content" source="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-attribute.png" alt-text="Screenshot of the new attribute creation in Microsoft Entra ID." lightbox="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-attribute.png":::

1. Follow [Create a conditional access policy](/entra/identity/conditional-access/concept-filter-for-applications#create-a-conditional-access-policy) to create a conditional access policy.

   :::image type="content" source="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-conditional-access-policy.png" alt-text="Screenshot of the conditional access policy creation process for Dev tunnels service." lightbox="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-conditional-access-policy.png":::

1. Follow [Configure custom attributes](/entra/identity/conditional-access/concept-filter-for-applications#configure-custom-attributes) to configure the custom attribute for the Dev tunnels service.

   :::image type="content" source="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-security-attributes.png" alt-text="Screenshot of configuring custom attributes for the Dev tunnels service in Microsoft Entra ID." lightbox="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-security-attributes.png":::

## Testing

1. Turn off the BlockDevTunnelCA

1. Create a DevBox in the test tenant and run the following commands inside it. Dev tunnels can be created and connected externally.

   ```
   code tunnel user login --provider microsoft
   code tunnel
   ```

1. Enable the BlockDevTunnelCA.

    1. New connections to the existing Dev tunnels can't be established. Test with an alternate browser if a connection has already been established.

    1. Any new attempts to execute the commands in step #2 will fail. Both errors are:

       :::image type="content" source="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-no-access.png" alt-text="Screenshot of error message when Dev tunnels connection is blocked by conditional access policy." lightbox="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-no-access.png":::

1. The Microsoft Entra ID sign-in logs show these entries.

   :::image type="content" source="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-activity-logs.png" alt-text="Screenshot of Microsoft Entra ID sign-in logs showing entries related to Dev tunnels conditional access policy." lightbox="media/how-to-conditional-access-dev-tunnels-service/dev-tunnels-activity-logs.png":::

## Limitations

With Dev Tunnels, the following limitations apply:
- You can't configure conditional access policies for Dev Box service to manage Dev tunnels for Dev Box users.
- You can't limit Dev tunnels that aren't managed by the Dev Box service. In the context of Dev Boxes, if the Dev tunnels GPO is configured **to allow only selected Microsoft Entra tenant IDs**, Conditional Access policies can also restrict self-created Dev tunnels.

## Related content
- [Conditional Access policies](/entra/identity/conditional-access/concept-conditional-access-policies)