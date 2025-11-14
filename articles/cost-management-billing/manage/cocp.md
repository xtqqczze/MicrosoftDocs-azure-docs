Initiate a Change of Channel Partner (COCP) request

# Summary

From Nov 2025, Enterprise volume licensing customers will be able to initiate Change of Channel Partner via the Microsoft admin center and Azure portals.

This change moves the ability to initiate the CoCP process away from Partners and enables the customers to start the process instead.

Once a COCP is initiated by a customer, the Partner is notified to accept or decline. Once accepted by the Partner, customer admin will get a notification of the accepted request and the effective date from when the new partner will be enabled.

# Prequisite information required from your new partner

Only two pieces of information will be required to initiate a change of channel partner request.

**The new partner PCN number** – Please ask your new partner their partner PCN number. This Is a required information and you will not be able to proceed without it. Partner can get it by opening any existing contract in VLCentral in contracts workspace.

**Partner Notification Contact – What You Need to Know:**

-   When you (the customer admin) start a Change of Channel Partner (COCP) request, you’ll be asked to provide the email address of a “partner notification contact” from your new partner organization.
-   **Ideally**, your new partner should give you this contact information. This person will become your main point of contact for future communications about your agreement.
-   **If you don’t have this information:**
    -   You can enter any email address for the partner notification contact to proceed.
    -   However, if the email address you provide is not verified by Microsoft, your new partner will **not** receive automatic notifications about the COCP request (for privacy reasons).
    -   In this case, you should reach out to your new partner directly (outside the system) and let them know you have started the COCP process.
-   **Why does this matter?**
    -   Using a verified partner contact ensures your new partner is notified promptly and can take action on your request.
    -   If you use an unverified contact, you are responsible for informing your partner about the request.

**Key Takeaway:**  
Always try to get the correct partner notification contact from your new partner before starting the COCP request. This helps ensure a smooth and timely transition.

**Please make sure that the partner accepts the request within 10 days.**

In Scope

-   Only Enterprise Admin can initiate COCP requests via Azure Portal.
-   Agreement Type = Enterprise enrolments (EA) and Enterprise Subscription Agreements,
-   Agreement status must be active
-   Trade status must be ‘Approved’.

### Out of Scope for Self-Service COCP

-   Non-EA programs, including Select, Select Plus, Open Value, Open Value Subscription, EDU / Campus, SPLA, IVR, MPSA, and Open license.
-   EA agreements with Microsoft Enterprise Direct Support (MSEDS) as Bill to / Software Advisor
-   EA agreements with expired status
-   EA agreements with ended status.
-   Backdated COCP requests.
-   Early COCP (before anniversary date)
-   A COCP initiated in one portal will not be visible in the other to prevent duplication of requests.

# Azure Portal customer experience

1.  The customer must have enterprise admin role on the billing scopes to initiate the request.
2.  **Customers can initiate the COCP request from 1 entry point**
-   Cost management + Billing -\> Billing Scopes -\> Change partner
3.  Click on change partner

![A screenshot of a computer AI-generated content may be incorrect.](media/4c8cf6ac757a54ac716d903f02bf6d47.png)

4.  After clicking change partner the user will be redirected to a page having only eligible billing accounts on which COCP requests can be initiated. Select the Billing accounts that you want to transfer and click on next.
5.  User may select multiple billing accounts upto a mzaimum of 20 or user may select one billing account and click the three dots to Change Partner on that billing account.

![A screenshot of a computer AI-generated content may be incorrect.](media/47bba1c187178d52bedceea553c275f2.png)

6.  On the **Initiate change of Partner page** user needs to
-   Input the Public Customer Number (PCN) of the new partner.
-   Input the email address of the partner’s Notification contact.
-   Select a reason for changing partner from available drop downs: Unsatisfactory service by current partner, current partner is being offboarded by Microsoft, or Other.

![A screenshot of a computer AI-generated content may be incorrect.](media/9350cd4c52e4430287886bf707b2dd03.png)

-   Partner organisation name displays when user inputs partner PCN and clicks “*confirm partner*” button in bottom left corner of screen.
-   This will verify whether the partner PCN entered is allowed to do business or not. In case of error please reach out to partner to get the correct PCN.
-   The partner notification contact *should* - but does not have to, be the person in the partner organization who access VL Central to accept the COCP request. In case the notification contact is not present in the VL Central, notification is not sent to partner but customer admin can proceed to initiate the request.
-   The effective date defaults to 90 days from the initiation date.
    -   (If customers need a different date, they should ask their partner to submit an Early COCP form to Microsoft Operations Service Center (OSC) – via VL Central My Cases).
-   COCP support scenario: **User selects licenses where CoCP cannot be performed**

**If customer selects agreement that are not eligible for CoCP, admin center displays a message informing the user that licenses are ineligible for a CoCP.**

![A screenshot of a computer AI-generated content may be incorrect.](media/820b2918ede01e74697c136abee4e7cb.png)

User must expand the message to see the reasons blocking CoCP for each impacted license ID.

**Scenario: User selects invalid partner PCN**

It is up to the new partner contact who is directly engaged with the customer to provide their PCN and partner notification contact details to the customer. In case of error please reach out to partner to get the correct PCN.

![A screenshot of a computer AI-generated content may be incorrect.](media/3b28af863e0c5fa273490817eee75660.png)

**Scenario: Partner email address inputted by customer does not have access to VL Central**.

Customer may input an email address in Partner Notification Contact of a partner user who does not have permissions on VLC to accept the CoCP. The Azure Portal will display a warning but will allow the user to proceed.

This means the notification will go to the email address listed on CoCP rather than the partner user who has VL Central access. However, that partner user with VLC access will be able to see and accept the CoCP in VL Central even though they don’t receive the CoCP notification.![A screenshot of a computer AI-generated content may be incorrect.](media/8f74d9f696f134c23bd6ee0f7c2cb752.png)

7.  **Review Change Partner terms**
-   If selected billing accounts are all EA direct – ‘Change of Software Advisor’ form displayed.
-   If selected billing accounts are all EA Indirect – ‘Change of Reseller’ form displayed.
-   If selected licenses are all are a combination of EA direct and Indirect, one form with sections for *Change of SA Advisor* and *Change of Reseller* is displayed. The form is scrollable.
-   User needs to input their first name and last name and agree to terms and conditions by clicking on the checkbox.

![A screenshot of a computer AI-generated content may be incorrect.](media/f076209a9ebd77b5df61d2478b3c2170.png)![A screenshot of a computer screen AI-generated content may be incorrect.](media/76471b6f9a91b163aea5237056d5c87e.png)![A screenshot of a computer AI-generated content may be incorrect.](media/39242bb1fcdf405b3158369556ee7359.png)

8.  **User must agree to terms to initiate the CoCP.**

A message is displayed to indicate the CoCP has been successfully submitted. Please make sure that the partner accepts the request within 10 days.

![A screenshot of a computer AI-generated content may be incorrect.](media/20573885c55ca53207cc946de627c33e.png)

9.  **COCP request is sent to Partner Notification contact identified in COCP**

![A screenshot of a computer screen AI-generated content may be incorrect.](media/ee41aefe5f112ad5ec0c473f184aa929.png)

#### 

#### How to Track CoCP status CoCP request ID in Azure portal

Enterprise admin may see the status of the request in cost management + billing track changes page.

A ‘**Request ID’** is displayed for each billing account included in the CoCP request. Where multiple licenses were in the same CoCP package, the same request ID is displayed.

The **status** for each COCP is displayed per billing account

-   A status of ‘in progress’ means the COCP has been sent to the new partner who must accept/decline the CoCP before it will becomes completed.
-   A status of Accepted means the Partner has accepted the COCP and a request will be processed by Microsoft Operations Service Center. (This process typically takes 24-48 hours for OSC to complete)
-   A status of declined means the Partner declined the COCP
-   A status of pending MS review means that the request is currently under processing by Microsoft operations center.
-   A status of in grace period meands that the request is currently in grace period during which new partner will not have access to agreements and old partner will remain the partner on record. The grace period is 90 days for enterprise.
-   A status of cancellation in progress means that the customer has cancelled the COCP request and the request is in queue to be cancelled.
-   A status of cancelled means that the request has been successfully cancelled by customer
-   A status of expired means that the partner did not accept the COCP request in 30 days.
-   A status of completed means Microsoft has completed the COCP

The **effective date** is the date from which the new partner may place orders on the agreement.

![A screenshot of a computer AI-generated content may be incorrect.](media/285d6a5992c75cef93ec0e4e273ce53b.png)

#### How to download CoCP request ID in Azure portal

Customer admin must navigate to track changes page.

-   Cost Management + billing\> Billing Scopes \> Track Change
-   User can click on the downward arrow button which is the download button to get the COCP form.
-   The COCP form can only be downloaded once partner accepts the request or the request is not cancelled.

![A screenshot of a computer AI-generated content may be incorrect.](media/d61eab87c8bb7c2f8eadafadeaccaaa7.png)

#### How to cancel COCP request in Azure Portal

A COCP Request with a status of In Process may be cancelled in full or partially (remove just some billing accounts from the request).

-   Go to Cost Management + billing\> Billing Scopes \> Track Change, select the billing scopes you wish not to proceed with a CoCP for.
-   Select Cancel Request from the action menu at the top, or the 3 dots next to billing scope,

![A screenshot of a computer AI-generated content may be incorrect.](media/70d4d272274e6e5374095722b4a09c86.png)

This will initiate a notification to the partner to let them know that the request has been cancelled.
