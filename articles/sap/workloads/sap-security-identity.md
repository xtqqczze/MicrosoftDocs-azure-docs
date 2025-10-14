# Identity Management, Provisioning and Single Sign-on, multifactor authentication & Global Secure Access SNC  

There are too many complex scenarios covering Identity Management, Authentication, and Authorization and it isn't possible to document generalizable scenarios.     
The links below are intended to be a starting point for developing the appropriate solution for a specific customer scenario.  
## 1.	Identity Management - Provision, Deprovision, Changes, and Workflows for User ID  lifecycle – Microsoft Entra for SAP 
> - Identity and Access Management with Microsoft Entr... - SAP Community (Part I)
> - Identity and Access Management with Microsoft Entr... - SAP Community (Part II)

https://aka.ms/MigrateFromSAPIDM 

## 2.	Authentication – It's recommended to use SSO and/or multifactor authentication for all SAP applications. Traditional User and Password for SAP applications isn't recommended. There are three typical options: User and Password (not recommended), Single Sign On (SSO) or SSO + MFA

### i.	Web Browser based Clients – SAML or OIDC (OpenID Connect)
> - Configure SAP NetWeaver for Single sign-on with Microsoft Entra ID - Microsoft Entra ID | Microsoft Learn
SAML is a well established industry standard but OIDC is a newer solution. This article contains a good comparison between the two technologies OIDC vs. SAML your hybrid SAP Landscape: What You ... - SAP Community


### ii.	SAPGUI – X.509 or Kerberos Tickets
> - SAP Secure Login Client - SNC certificate X.509 and Kerberos Tickets are documented here SNC X.509 Configuration | SAP Help Portal   

Additional information is available here 
> - Exploring SAP Secure Login Service for SAP GUI: A ... - SAP Community
> - SAP GUI MFA with Microsoft Entra (Part I): Integra... - SAP Community
> - How to Configure SSO for SAP GUI Including MFA - SAP Community

### iii.	Mobile Devices – X509 or SAML 
> - SAP discontinued Fiori mobile app as of 2022 and now support native browsers
> - Time for a Fresh-Up: Single sign-on for SAP on Mobile Devices


### iv.	Microsoft Power Platform and Microsoft AI 
> - Principal propagation in a multicloud solution be... - SAP Community
> - Power Platform + SAP OData - single sign-on - Happy path
> - Power Platform + SAP OData - single sign-on - Step by Step
> - 142 - The one with Power Platform and single sign-on (Martin Raepple) | SAP on Azure Video Podcast
> - 211 - The one with SSO with SAP API Management and Power Platform (Vinayak Adkoli & Martin Pankraz)
> - 183 - The one with SAP GUI MFA mit Entra ID (Martin Raepple & Christan Cohrs) | SAP on Azure Video



### v.	Other Client Technologies 
NetWeaver Business Client, Concur, Fiori Mobile App, Business Explorer (BEx), Business Objects, and other non-SAP applications (such as a third party Warehouse Management system) will be added to this documentation later.  Some of these technologies are now out of support.  


For more information on how to configure single sign-on from Microsoft Entra ID, see the following documentation and tutorials.  

  > [!NOTE]
  > Note the preferred strategy is to use the SAP BTP Cloud Identity Services (CIS) where possible.  

It is technically possible to integrate SAP SuccessFactors with the Entra ID directly as described Configure SuccessFactors for Single sign-on with Microsoft Entra ID - Microsoft Entra ID | Microsoft Learn  however the preferred strategy is to use the SAP BTP Cloud Identity Services (CIS) 

More information on Microsoft Entra SSO services for SAP solutions: 

> - SAP Cloud Identity Services
> - SAP SuccessFactors
> - SAP Analytics Cloud
> - SAP Fiori
> - SAP Ariba
> - SAP Concur Travel and Expense
> - SAP Business Technology Platform
> - SAP Business ByDesign
> - SAP HANA
> - SAP Cloud for Customer
> - SAP Fieldglass

Also see the following blog posts and SAP resources:
> - SAP GUI MFA with Microsoft Entra integration with SAP Secure Login Service and integration with Microsoft Entra Private Access
> - Managing access to SAP BTP
> - Azure Application Gateway setup of SAML Single Sign On for Public and Internal SAP URLs
> - Single sign on using Microsoft Entra Domain Services and Kerberos



More information on the SAP BTP Cloud Identity Services (CIS) can be found here: 

> - Identity Provisioning Service (BTP) and Identity Authentication Service (BTP)
> - Getting Started with SAP Cloud Identity Service - ... - SAP Community
> - What Is Identity Provisioning? | SAP Help Portal
> - Explaining Identity and Access Management on SAP BTP
> - A good summary can be found here Navigating SAP SSO: Choosing Between SAP single sign-on 3.0 and SAP Secure Login Service for SAP GUI

https://learn.microsoft.com/entra/id-governance/sap 


3.	Automatic Synchronization of Authorization Attributes 

Authorization attributes can be replicated from Microsoft Entra to target SAP applications such as SAP BTP Role Collections. This is discussed in this link Manage access to your SAP applications - Microsoft Entra ID Governance | Microsoft Learn

There are some limited functionalities available to synchronize Authorization Roles and Profiles for NetWeaver and S/4 systems.  Additional information about S/4, SuccessFactors, Ariba and Fieldglass Authorization attributes will be added to this documentation shortly. 

The diagram here depicts the architecture from a SAP centric point of view:  SAP IAM integration with SAP Cloud Identity Services | SAP Architecture Center.   This diagram shows the concept with reference to Entra Migrate identity management scenarios from SAP IDM to Microsoft Entra | Microsoft Learn

4.	Global Secure Access GSA with SAPGUI SNC  
The video embedded in the following blog is recommended for customers wanting to achieve Network Level Security similar to operating a VPN without the overhead of installing and maintaining a full VPN on client devices.  
The GSA client implements an NDIS 6.0 lightweight filter (LWF) network driver to route any traffic to internal and external applications based on centrally defined access rules at the company's Entra ID tenant level.
  > - SAP GUI MFA with Microsoft Entra (Part II): Integr... - SAP Community
  > - 219 - The one with SSO to SAP GUI using Global Secure Access (Martin Raepple) | SAP on Azure Video

5.	SAP Products Approaching End of Life / Migration
Several SAP security solution products are now end of life. Microsoft and SAP have collaborated to provide a migration path for customers 
> - Migrate identity management scenarios from SAP IDM to Microsoft Entra | Microsoft Learn

> - SAP IDM 8.0 – End of Life December 2027.  More documentation on the migration path can be found here 
> - Update on the SAP Identity Management migration to... - SAP Community
> - Preparing for SAP Identity Management’s End-of-Mai... - SAP Community

SAP SSO Server (Java) – End of Life December 2027  
SAP GUI MFA with Microsoft Entra (Part I): Integra... - SAP Community


Learn more about Microsoft Entra ID Governance: aka.ms/Entra/IdentityGovernance  
View the Microsoft Mechanics video:
aka.ms/IDGovMechanics   
Walk through the Interactive Guides:
aka.ms/EntraIDGovGuides
Read documentation:
aka.ms/Entra/IDGovDocs
1912264 - SAP NetWeaver single sign-on 1.0: Central Note - SAP for Me
2300234 - SAP single sign-on 3.0: Central Note - SAP for Me
single sign-on for SAP GUI | SAP Community
1848999 - Central Note for CommonCryptoLib 8 (SAPCRYPTOLIB) - SAP for Me
510007 - Additional considerations about setting up SSL on Application Server ABAP - SAP for Me
Single Sign On for SAP NetWeaver and Azure Active Directory - YouTube

https://learn.microsoft.com/en-us/power-platform/sap/connect/secure-network-communications
https://learn.microsoft.com/en-us/power-platform/sap/connect/entra-id-kerberos
https://learn.microsoft.com/en-us/power-platform/sap/connect/entra-id-certs
https://learn.microsoft.com/en-us/power-platform/sap/connect/entra-id-using-successfactors



