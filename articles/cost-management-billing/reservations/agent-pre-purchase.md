---
title: Microsoft Agent Pre-Purchase Plan
description: Learn about Microsoft Agent Pre-Purchase Plan in Azure reservations.
author: pri-mittal
ms.reviewer: primittal
ms.service: cost-management-billing
ms.subservice: reservations
ms.topic: conceptual
ms.date: 11/12/2025
ms.author: primittal
---

# Optimize Microsoft Foundry and Copilot Credit costs with Microsoft Agent pre-purchase plan 

Save on your Copilot Credit and Microsoft Foundry costs when you buy a pre-purchase plan. Pre-purchase plans are commit units (CUs) bought at discounted tiers in your purchasing currency for a specific product. The more you buy, the greater the discount. Purchased CUs pay down qualifying costs in US dollars (USD). So, for example if Microsoft Copilot Studio generates a retail cost of $100 based on Copilot Credit and Microsoft Foundry usage, then 100 Agent CUs (ACUs) are consumed.

Your Microsoft Agent pre-purchase plan automatically uses your ACUs to pay for eligible Copilot and AI Foundry usage during its one-year term or until Agent CUs run out. Your pre-purchase plan Agent CUs start paying for your Copilot and AI Foundry usage without having to redeploy or reassign the plan. By default, plans are configured to renew at the end of the one-year term.

## Prerequisites

To buy a pre-purchase plan, you must have one of the following Azure subscriptions and roles:
- For an Azure subscription, the owner role or reservation purchaser role is required.
- For an Enterprise Agreement (EA) subscription, the [**Reserved Instances** policy option](../manage/direct-ea-administration.md#view-and-manage-enrollment-policies) must be enabled. To enable that policy option, you must be an EA administrator of the subscription.
- For a Cloud Solution Provider (CSP) subscription, follow one of these articles:
   - [Buy Azure reservations on behalf of a customer](/partner-center/customers/azure-reservations-buying)
   - [Allow the customer to buy their own reservations](/partner-center/customers/give-customers-permission)

## Determine the right size to buy

To get started, estimate your expected Copilot and Microsoft Foundry usage for the term. This helps you determine the appropriate size for your pre-purchase plan. Each pre-purchase plan has a one-year term.
For example, suppose you expect to consume 1,500,000 Copilot Credit with custom agents created in Microsoft Copilot Studio. Assuming the pay-as-you-go rate for Copilot Credit to be $0.01, then at the pay-as-you-go rate, this will cost $15,000. In addition, if you are using 5000 PTUs and assuming the pay-as-you-go rate for PTU to be $1, then at the pay-as-you-go rate, this will cost $5,000.By purchasing Tier 1 (20,000 CU) pre-purchase plan, let's say the cost of that tier is $19,000, it will give a 5% saving compared to the pay-as-you-go rate for the same usage.

## Purchase Microsoft Agent Pre-Purchase Plan commit units

Purchase Microsoft Agent Pre-Purchase Plans in the [Azure portal reservations](https://portal.azure.com/#view/Microsoft_Azure_Reservations/ReservationsBrowseBlade/productType/Reservations). 

1. Go to the [Azure portal](https://portal.azure.com)
2. Navigate to the **Reservations** service.
3. On the **Purchase reservations page**, select **Microsoft Agent Pre-Purchase Plan**.  
4. On the **Select the product you want to purchase** page, select a subscription. Use the **Subscription** list to select the subscription used to pay for the purchase. The payment method of the subscription is charged the upfront cost for the reservation. Charges are **not** deducted from the enrollment's Azure Prepayment (previously called monetary commitment) balance or charged as overage.
5. Select a scope.
   - **Single resource group scope** - Applies the reservation discount to the matching resources in the selected resource group only.
   - **Single subscription scope** - Applies the reservation discount to the matching resources in the selected subscription.
   - **Shared scope** - Applies the reservation discount to matching resources in eligible subscriptions that are in the billing context. For Enterprise Agreement customers, the billing context is the enrollment.
   - **Management group** - Applies the reservation discount to the matching resource in the list of subscriptions that are a part of both the management group and billing scope.
6. Select how many Agent Credit commit units you want to purchase.
7. Choose to automatically renew the pre-purchase reservation. *The setting is configured to renew automatically by default*. For more information, see [Renew a reservation](reservation-renew.md).

## Change scope and ownership

You can make the following types of changes to a reservation after purchase:

- Update reservation scope
- Update who can view or manage the reservation. For more information, see [Who can manage a reservation by default](manage-reserved-vm-instance.md#who-can-manage-a-reservation-by-default).

You can't split or merge a **Microsoft Agent Pre-Purchase Plan**. For more information about managing reservations, see [Manage reservations after purchase](manage-reserved-vm-instance.md).

## How does benefit application work?

You may have multiple types of purchases that can apply to the same or adjacent AI workloads - for example, a [Microsoft Foundry Provisioned Throughput reservation](microsoft-foundry.md), a [Copilot Credit pre-purchase plan](copilot-credit-p3.md), and the broader Microsoft Agent pre-purchase plan. These benefits can overlap with coverage:

Overlap occurs when more than one benefit is eligible to cover the same meter or usage (e.g., a Copilot credit that is eligible for both Copilot Credit pre-purchase plan and Microsoft Agent pre-purchase plan, or a Microsoft Foundry PTU workload eligible for both a PTU reservation and Microsoft Agent pre-purchase plan).

-	In overlap situations, the platform applies benefits in a deterministic precedence to decide which benefit covers first and what remains for subsequent benefits.
-	Reservations are PTU‑only and always apply before pre-purchase plans. Between the two pre-purchase plans, the more granular Copilot pre-purchase plan applies before Microsoft Agent pre-purchase plan. This preserves specialized benefits and keeps the broader pool available for heterogeneous AI workloads.
-	Microsoft Agent pre-purchase plan does not cover purchase cost for any other reservation or pre-purchase plan.

Here are a few scenarios on how benefit is applied:

### Scenario 1: Customer with Microsoft Foundry reservation Only

**Coverage:**
- Reservation applies only to PTUs for Microsoft Foundry workloads.
- Any usage beyond reserved PTUs is billed at pay-as-you-go rates.

**Example:**
- Customer purchases a reservation for 10 PTUs for GPT-4. If usage requires 12 PTUs, 10 are covered by reservation, 2 are billed at pay-as-you-go rates.

### Scenario 2: Customer with Copilot Credit pre-purchase plan and Microsoft Agent pre-purchase plan

**Coverage:**
- Copilot pre-purchase plan applies first to Copilot workloads.
- Microsoft Agent pre-purchase plan applies next for remaining Copilot usage and Microsoft Foundry workloads (including PTU-based usage if no reservation exists).
  
**Example:**
- Copilot usage draws down Copilot pre-purchase plan first, then Microsoft Agent pre-purchase plan.
- Microsoft Foundry usage (hourly PTUs or token-based) draws from Microsoft Agent pre-purchase plan.

### Scenario 3: Customer with Microsoft Foundry reservation + Microsoft Agent pre-purchase plan
**Coverage:**
- Reservation applies first to hourly PTUs.
- Microsoft Agent pre-purchase plan applies next for any remaining hourly PTU usage and Copilot workloads.

**Example:**
- PTU Reservation consumed first; overflow PTUs and Copilot usage draw from Microsoft Agent pre-purchase plan.

### Scenario 4: Customer with All Three (Microsoft Foundry reservation + Copilot pre-purchase plan + Microsoft Agent pre-purchase plan)
**Coverage:**
- Reservation applies first to PTUs.
- Copilot pre-purchase plan applies next to Copilot workloads.
- Microsoft Agent pre-purchase plan applies last for remaining Copilot and Azure AI usage.

**Example:**
- PTUs covered by reservation; Copilot usage draws down Copilot pre-purchase plan first, then Microsoft Agent pre-purchase plan.

>[!NOTE]
>If you are using products with tiered pricing, Microsoft Agent pre-purchase plan applies based on rates for lowest tier. For example, if you are using Custom Entity Lookup skill, the pre-purchase plan applies based on 0-1M text records price.

## Cancellations and exchanges

Cancel and exchange operations aren't supported for **Microsoft Agent pre-purchase plans**. All purchases are final.

## Related content

To learn more about Azure Reservations, see the following articles:
- [What are Azure Reservations?](save-compute-costs-reservations.md)
- [Manage Reservations for Azure resources](manage-reserved-vm-instance.md)
