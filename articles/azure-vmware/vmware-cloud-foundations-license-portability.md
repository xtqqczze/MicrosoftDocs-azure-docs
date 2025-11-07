---
title: Use Portable VMware Cloud Foundations (VCF) on Azure VMware Solution
ms.author: saloniyadav
description: Bring your own portable VMware Cloud Foundations (VCF) on Azure VMware Solution
ms.topic: how-to
ms.service: azure-vmware
ms.date: 11/04/2025
# Customer intent: As a cloud administrator, I want to register and integrate my portable VMware Cloud Foundations with Azure VMware Solution, so that I can leverage my existing licenses and optimize costs while modernizing my VMware workloads in a fully managed environment.
---

# Use Portable VMware Cloud Foundations (VCF) on Azure VMware Solution

This document will help navigate the changes based on Broadcom’s new VMware licensing model for hyperscalers. Customers must purchase VMware Cloud Foundations (VCF) subscriptions directly from Broadcom to use hyperscaler cloud services. This means that Microsoft will no longer include VCF license/subscription with new Azure VMware Solution node purchases starting Nov 1, 2025. If you have any active Reservated Instance (RI) purchased for VCF-included hosts, you can continue using the VCF-included solution until the end of your RI term. After which, you will be required to bring your own VCF subscription. At any point, if your usage exceeds the active VCF-included RIs purchased, you must bring your own VCF (BYOL) for that surplus usage.

Azure VMware Solution already supports the VCF portability (BYOL) option which enables you to bring your own VCF subscription to Azure VMware Solution. However, until now, the VCF portability (BYOL) option was supported at an Azure subscription level through support-based registration.   

Now, you can enable VCF portability (BYOL) directly through the Azure portal when creating or managing an Azure VMware Solution private cloud. This self-service model also enables you to continue using your existing VCF-included deployments and add your own portable VCF (BYOL) only for the new hosts that are **not** covered under the VCF-included offering.  

## New Scope
You now have full flexibility to apply portable VCF (BYOL) on a per–Azure VMware Solution private cloud basis, instead of your entire Azure subscription. This means you can run some Azure VMware Solution private clouds with your own portable VCF (BYOL) and others with Microsoft-provided VCF, all under the same Azure subscription. This enables phased migrations and removes the need to convert everything at once. 

If you have an active RI for VCF-included hosts and want to add new hosts, you can register portable VCF (BYOL) only for those additional hosts. You can continue using your existing VCF-included hosts until the end of their RI term. 

The VMware vDefend Firewall is an add-on feature for Azure VMware Solution. Those with active RIs for VCF-included hosts and vDefend Firewall enabled prior to October 16th may continue to use the same number of eligible vDefend firewall cores until the RI expires. After your RI expires, or if your vDefend Firewall core usage exceeds the eligible VCF-included cores as of October 15th, 2025, you must provide your own VCF vDefend Firewall add-on license key for continued or additional usage. 

## Quota request for portable VCF (BYOL) 
When using portable VCF (BYOL), you must still request capacity (quotas) for Azure VMware Solution hosts as usual. Microsoft needs to ensure you don’t deploy more nodes than you have licensed, so the approved quota may be capped by your entitled cores.  

Always ensure your Broadcom purchased VCF core count covers the scale you need. 

For further details on how to request host quotas for AVS, refer here. 

## Trials on Azure VMware Solution

Trials on Azure VMware Solution were previously available for partners and customers for 30 days duration. We are now making Azure VMware 3 node trials available for 60 days to customers and partners. You are required to register a valid trial VCF key purchased from Broadcom on your trial Azure VMware Solution private cloud. Refer to this [section]() to see how to register.  

The trials once deployed and reaching the 60-day time limit will automatically switch to billed hosts unless the trial deployment is deleted before the 60th day. If you don’t already have a VCF-included RI purchased, you are required to provide your Broadcom purchased VCF (BYOL) before your trial ends. Lack of compliance can impact the continuity of your Azure VMware Solution private cloud. 

## How to configure Portable VCF (BYOL) on your AVS Private Cloud 

Register the portable VCF details on your Azure VMware Solution private cloud through Azure portal. This feature is currently only available through the Azure portal.
This can be done in one of two ways: 
1. Configure portable VCF (BYOL) while creating a new Azure VMware Solution private cloud.
2. Enable portable VCF (BYOL) on an existing Azure VMware Solution private cloud.
3. 

## What's changing?

You can now bring your VCF subscription to Azure VMware Solution and provision a Private Cloud. Register your VCF subscription with Microsoft start using the Azure VMware Solution offering. 
Private Cloud on the portable VCF offering, must have prepurchase Firewall add-on from Broadcom along with the VCF subscription to use the vDefend Firewall on Azure VMware Solution. Prior to using the vDefend Firewall software on Azure VMware Solution ensure you register your Firewall add-on with Microsoft. For detailed instructions on how to register your portable VCF, see "Register your portable VCF with Azure VMware Solution" later in this article.

>[!IMPORTANT]
>
> Your portable VCF is applied at the host level and must cover all the physical cores on a host. For example, if each host in Azure VMware Solution has 36 cores and you intend to have a Private Cloud with 3 nodes, the portable VCF must cover 108 (3*36) cores. 
>In the current version, if you want to use your own portable VCF on your Azure subscription for the Azure VMware Solution workloads, all the nodes (cores) in that subscription including multiple Private Clouds need to be purchased through Broadcom and covered under your Broadcom portable VCF contract. At the moment, you're required to bring portable VCF entitlements that cover cores for all the nodes deployed within your Azure subscription.

## Purchasing VCF subscription portability offering on Azure VMware Solution

We offer three flexible commitments and pricing options for using your portable VCF on Azure VMware Solution. You can choose from pay-as-you-go, 1-year Reserved Instance (RI), and 3-year RI options. 

To take advantage of the Reserved Instance (RI) pricing for the portable VCF offering on Azure VMware Solution, purchase an RI under the Product Name- VCF BYOL. For example, if your private cloud uses AV36P nodes, you must [purchase the Reserved Instance](/azure/azure-vmware/reserved-instance?toc=%2Fazure%2Fcost-management-billing%2Freservations%2Ftoc.json#buy-a-reservation) for the Product Name- AV36P VCF BYOL. To use the pay-as-you-go pricing for the portable VCF offering, you only need to register your VCF subscription. 

>[!IMPORTANT]
> If you're converting your existing Azure VMware Solution private cloud to use the portable VCF pricing, you must ensure to exchange the existing Reserve Instance (RI) on your subscription to VCF BYOL RI. **Unless you have RI under \<node-type\>-VCF BYOL, you'll be charged the VCF BYOL pay-as-you-go pricing.**
> Register your VCF subscription with Microsoft before performing any Reservation exchanges.

:::image type="content" source="media/vmware-cloud-foundations-license-portability/reserved-instance-purchase.png" alt-text="Screenshot of what product type to select while purchasing reserved instance for VCF subscription portability offering." border="true":::

## Request host quota with VCF subscription portability

Existing: 
:::image type="content" source="media/vmware-cloud-foundations-license-portability/quota-request-old.png" alt-text="Screenshot of quota request description for existing Azure VMware Solution." border="true":::

To request quota for portable VCF offering, provide the following additional information in the **Description** of the support ticket:

- Region Name 
- Number of hosts 
- Host SKU type  
- Add the following statement as is, by replacing "N" with the "Number of VCF BYOL cores" you purchased from Broadcom for VCF portability to Azure VMware Solution:  
**"I acknowledge that I have procured portable VCF subscription from Broadcom for "N" cores to use with Azure VMware Solution."**
- Any other details, including Availability Zone requirements for integrating with other Azure services; for example, Azure NetApp Files, Azure Blob Storage

:::image type="content" source="media/vmware-cloud-foundations-license-portability/quota-request-license-portability.png" alt-text="Screenshot of the quota request description for VCF subscription portability offering on Azure VMware Solution.":::

>[!NOTE]
>
>Portable VCF is applied at the host level and must cover all the physical cores on a host.
>Hence, quota is approved only for the maximum number of nodes which the portable VCF covers. For example, if you purchase 1000 cores for portability and requesting for AV36P, you can get a maximum of 27 nodes quota approved for your subscription.
>
>That is, 36 physical CPU cores per AV36P node. 27 nodes = 27\*36 = 972 cores. 28 nodes = 28\*36 = 1008 cores. If you purchase 1000 cores for portability, you can only use up to 27 AV36P nodes under your portable VCF.

## Register your portable VCF with Azure VMware Solution

To get your quota request approved, you must first register the portable VCF details with Microsoft. Quota will be approved only after the entitlements are provided. Expect to receive a response in 1 to 2 business days. 

### How to register the VCF subscription keys 

- Email your portable VCF entitlements (and VMware vDefender Firewall license entitlements if to enable vDefender Firewall on Azure VMware Solution) to the following email address: registeravsvcfbyol@microsoft.com. 

- VCF entitlement sample: 
:::image type="content" source="media/vmware-cloud-foundations-license-portability/vcf-entitlements.png" alt-text="Screenshot of how to register your VCF portable subscription entitlements with Microsoft." border="false":::

>[!NOTE]
>
>The "Qty" represents the number of cores eligible for VCF portability. Your quota request shouldn't surpass the number of nodes equivalent to your entitled cores from Broadcom. If your quota request exceeds the approved cores, the quota request will be granted only for the number of nodes that are fully covered by the entitled cores.

- VCF with VMware vDefend entitlement sample: 
:::image type="content" source="media/vmware-cloud-foundations-license-portability/vcf-vdefend-entitlements.png" alt-text="Screenshot of VCF with VMware vDefend entitlement sample format." border="false":::

Sample Email to register portable VCF entitlements: 
:::image type="content" source="media/vmware-cloud-foundations-license-portability/email-register-vcf.png" alt-text="Screenshot of sample email to register portable VCF subscription." border="true":::

The VMware vDefend Firewall add-on CPU cores required on Azure VMware Solution depend on the planned feature usage: 
- For NSX Distributed Firewall: same core count as VCF core count. 
- For NSX Gateway Firewall, it would be 64 cores (with default NSX Edges).
- For both NSX Distributed and Gateway firewall, it should be combined core count of both.

:::image type="content" source="media/vmware-cloud-foundations-license-portability/email-register-vcf-vdefend.png" alt-text="Screenshot of sample email to register portable VCF with VMware vDefend Firewall licenses." border="true":::


>[!NOTE] 
> 
> The portable VCF entitlements submitted to Microsoft is securely retained for reporting purpose only. You can request the permanent deletion of this data from Microsoft's systems at any time. Once the automated validation process is in place, your data is automatically deleted from all Microsoft systems, which may take up to 120 days. Additionally, all your VCF entitlement data is permanently deleted within 120 days any time you migrate to an Azure VMware Solution-owned VCF solution. 

## Creating/scaling a Private Cloud

You can create your Azure VMware Solution private cloud the same way as today regardless of your licensing method, that is, whether you bring your own portable VCF or use the Azure VMware Solution-owned VCF subscription. [Learn more](/azure/azure-vmware/plan-private-cloud-deployment). Your decision of licensing is a cost optimization choice and doesn't affect your deployment workflow.

For example, you want to deploy 10 nodes of AV36P node type.

**Scenario 1:**
"I want to purchase my VCF subscription from Broadcom and use the portable VCF offering on Azure VMware Solution."

1. Create quota request for AV36P nodes. Declare your own VCF portable subscription intent and the number of cores you're entitled for portability. 
2. Register your VCF entitlements via email to Microsoft.  
3. Optional- to use the Reserved Instance pricing purchase AV36P VCF BYOL Reserved Instance. You can skip this step to use the pay-as-you-go pricing for the portable VCF.
4. Create your Private Cloud with AV36P nodes. 

**Scenario 2:**
"I want to let Azure VMware Solution manage my VCF subscription for all my Azure VMware Solution private cloud."

1. Create quota request for AV36P node type. 
2. Optional- Purchase AV36P Reserved Instance.  
3. Create your Private Cloud with AV36P nodes. 

## Moving between the two VCF licensing methods

If you're currently managing your own VCF subscription for Azure VMware Solution and wish to transition to Azure VMware Solution-owned VCF subscription, you can easily make the switch without any changes to your private cloud. 

If you’re an existing Azure VMware Solution customer and wish to transition to the portable VCF (VCF BYOL) offering, you can easily make the switch without any changes to your private cloud deployments by registering your portable VCF entitlements with Microsoft.
**Steps:**

1. Create a support request to inform us of your intent to convert.
2. Exchange RI- If you have any active RI with VCF BYOL, exchange them for non-VCF BYOL RI. For instance, you can [exchange your AV36P VCF BYOL RI for an AV36P or vice versa](/azure/cost-management-billing/reservations/exchange-and-refund-azure-reservations).

**NOTE:** If you have RIs for your current deployments, ensure to exchange RI for the right Product Name to continue to get the discounted RI pricing. Without this step, you'll incur the pay-as-you-go cost.


>[!NOTE]
>
>You need to purchase the portable VCF entitlements from Broadcom for all cores that match your current Azure VMware Solution deployment. For instance, if your Azure subscription has a private cloud with 100 AV36P nodes, you must purchase portable VCF for at least 3600 cores from Broadcom to convert to VCF BYOL offering.

## Frequently Asked Questions

### 1. What if my VCF subscription expires before my AVS Reservation (RI) ends?
If your VCF subscription expires before your AVS Reservation (RI) ends, you have two options:

  1. **Switch to AVS-managed licenses:** Inform Microsoft of your intent to transition to AVS-managed licenses. If you have reservations on the VCF BYOL SKU, you can exchange them for the corresponding AVS SKU without any cancellation or exchange fees, as long as your exchanges comply with the [Azure Reservation Exchange Policies](/azure/cost-management-billing/reservations/exchange-and-refund-azure-reservations#cancel-exchange-and-refund-policies).
  
  2. **Renew your VCF subscription with Broadcom:** Register your new VCF subscription with Microsoft to continue using your Private Cloud without any disruption.

### 2. Can I change back and forth between AVS to AVS VCF BYOL anytime?
Yes, you can switch between AVS and AVS VCF BYOL SKUs anytime. 

### 3. Will the AVS 30-day Pilot Program support AVS VCF BYOL?
The 30-day Pilot Program **does not** require you to bring your own VCF subscription, as you can leverage AVS-owned VCF during the Pilot period. However, if you wish to bring your own VCF subscription instead of continuing with the AVS-owned VCF after the Pilot, you must **register your VCF subscription before the Pilot program ends**. If you don't register before the end of the Pilot program, you'll automatically be converted to AVS pay-as-you-go pricing.

### 4. Is VCF portability available for Gov Cloud as well?**
Yes, VCF portability is **now available in Gov Cloud.** 

## "Onboarding to portable VCF on Azure VMware Solution" Checklist

**Scenario 1:**
"I'm converting existing AVS private cloud to VCF BYOL." 

1. Get your portable VCF subscription from Broadcom.
2. Register your portable VCF with Azure VMware Solution. 
3. If you have an RI purchased, exchange the RI to the corresponding VCF BYOL RI.

**Scenario 2:**
"I'm creating a new AVS private cloud with VCF BYOL." 

1. Get your portable VCF subscription from Broadcom.
2. [Request host quota](/azure/azure-vmware/request-host-quota-azure-vmware-solution) for Azure VMware Solution.
3. If you intend to leverage the RI pricing, purchase the RI under the "VCF BYOL" product name.

**NOTE:** Once your portable VCF is register, you must **immediately** exchange your existing AVS RI to VCF BYOL RI. Failing to do so leads to **VCF BYOL pay-as-you-go** billing for your usage. To leverage the RI pricing, ensure the RI purchase under the right region, host count, and product name (VCF BYOL in this case).
