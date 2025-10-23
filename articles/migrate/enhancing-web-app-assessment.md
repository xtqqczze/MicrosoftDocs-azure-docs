---
title: Enhancing Web App Assessment by Adding Code Scan Report
description: Learn how to Enhancing Web App Assessment by Adding Code Scan Report
ms.topic: how-to
author: Vikram1988
ms.author: vibansa
ms.service: azure-migrate
ms.reviewer: v-uhabiba
ms.date: 10/23/2025
ms.custom: engagement-fy24
# Customer intent: "As a cloud administrator, I want to deploy an Azure Migrate appliance using a PowerShell script, so that I can facilitate discovery, assessment, and replication of servers in my VMware or Hyper-V environment efficiently."
---


# Enhancing Web app assessment by adding code scan report 

This article describes how to improve web app assessments by including code scan reports when modernising applications for Azure Kubernetes Service (AKS) or Azure App Service. By adding code scan reports, you can better assess migration readiness and receive recommendations for appropriate migration strategies, based on the code changes identified during the scan.

There are two ways to add code scan report to web app assessment. 

- Upload code scan report manually generate using Azure Migrate application and code assessment tool (AppCAT)
- Connect your GitHub repo where the code scan reports will be uploaded using GitHub Copilot app modernization extension. 

In this article, you’ll learn how to:
- How to import code scan reports to Web app assessments
- Methods to generate the code scan report. 
- Calculate assessment to see updated reports.
- View updated assessment along with code insights. 

Method 1: Upload code scan report manually

With this approach, you are required to generate the code scan report using AppCAT and then manually upload the reports to Web Apps as a ZIP file. 

## Prerequisites 

- Ensure a web app assessment exists for each required web app, as code scan reports can only be added to from an existing assessment.
- You have the code scan reports for web apps that you want to add the code scan reports.

### Generate the code scan report please follow below steps.  

1. Install the AppCAT using below steps. 

    - For .NET you can use below command. You can find additional details [here](/azure/migration/appcat/install#install-the-net-global-tool) dotnet tool install -g dotnet-appcat.
    - For Java follow the steps [document](/azure/migrate/appcat/appcat-7-quickstart?view=migrate&tabs=windows#download-and-install).
1. Generate the AppCAT report for all your web app that you have assessed.  
    - For .NET follow the steps in this document [Analyze applications with the .NET CLI](/dotnet/azure/migration/appcat/dotnet-cli). 
    - For Java follow the steps in this document [Run AppCAT against a sample Java project](/azure/migrate/appcat/appcat-7-quickstart?tabs=windows#run-appcat-against-a-sample-java-project).
1. Create a zip file for all the reports that you want to add to assessment. 

### Upload code scan report to web app assessment using zip file 

1. On the Azure Migrate project Overview page, under Decide and Plan, select Assessments. 
1. Search for the assessment using the Workloads filter and select it. 
1. On the assessment Overview page, select the Recommended path tab or View details in the recommended path report.  
1. This screen displays the distribution of the web apps across the Azure targets. Select a line item to drill down further. 
1. Under Add code insights select Using AppCAT reports. 
1. In the Add code insights page, select Upload a zip file.  
1. Click on Browse and select the location where you have stored the zip file containing AppCAT reports that you want to import. Click on upload and wait for upload and validation to complete. 
1. In the Web app list under AppCAT report dropdown, you should see the list of uploaded report under heading Uploaded from zip file. 
1. Select the appropriate report to map to the respective web app. Repeat this steps for all the required web app.  
1. Once the mapping is complete, click on Add. Wait for the mapping to complete. 
1. Once the mapping is complete, click on notification and follow the steps to recalculate the assessment.
1. Once the recalculation of assessment is complete review the code insights.  

### Method 2: Add code scan report using GitHub Copilot app modernization extension

In this method, Azure Migrate connects to a GitHub repository using provided connection details and automatically creates an issue in that repository. By using the GitHub Copilot app modernization extension, you can scan your code and upload the reports directly to the related GitHub issue. After updating the issue, Azure Migrate will automatically attach the code scan reports to the associated web applications. This approach allows cloud administrators and developers to collaborate while maintaining application code security boundaries. 

## Prerquisites

- Ensure a web app assessment exists for each required web app, as code scan reports can only be added to from an existing assessment. 
- Information about the GitHub repository required for integration with Azure Migrate, allowing automatic requests and synchronization of code scan reports. 
- A GitHub Application details which has permission to create issue and read comments on issues within the target repository. 

