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

1. Install the AppCAT using below steps: 

    - For .NET you can use below command. You can find additional details [here](/dotnet/azure/migration/appcat/install#install-the-net-global-tool) dotnet tool install -g dotnet-appcat.
    - For Java follow the steps [document](/azure/migrate/appcat/appcat-7-quickstart?tabs=windows#download-and-install).
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

    1. In the upper-right corner of any page on GitHub, click your profile picture. 
    1. Navigate to your account settings. 
- For an app owned by a personal account, click Settings. 
        - Click Your organizations. 
        - To the right of the organization, click Settings. 
- For an app owned by an enterprise:  
    1. If you use Enterprise Managed Users, click Your enterprise to go directly to the enterprise account settings. 
        - If you use personal accounts, click Your enterprises and then to the right of the enterprise, click Settings. 
    1. Navigate to the GitHub App settings. 
- For an app owned by a personal account or organization:  
    1. In the left sidebar, click <> Developer settings, then click GitHub Apps. 
- For an app owned by an enterprise:  
        - In the left sidebar, under "Settings", click GitHub Apps. 
    1. Click New GitHub App. 
    [Add screen]

    1. Provide details for the new app.  

        - Under GitHub App name, enter a name for your app.  
        - Under Homepage URL, provide the full URL. This serves as a placeholder and is not utilized in this process. 
         [Add screen]
        - Deselect Active under Webhook 
        [Add screen]
        -  Under Permissions, click on Repository permissions choose following permissions for the app. 
            
        | Issues  | Read and write  | 
        | --- | --- | 
        | Metadata  | Read-only  |
        | Webhook   | Read and write  |

    - Under Where can this GitHub App be installed?, select Only on this account or Any account. 
        [Add screen]

    1. Click Create GitHub App. 

### Install GitHub App on the repository

1. Navigate to the GitHub App you created. 
1. Select Install App 
1. Choose an account to install the app and click on Install. This should be account where repository present for creating issue and uploading code scan report.  
[Add screen]

1. Select Only select repositories and in select appropriate repositories by clicking on Select repositories. You can select multiple repositories. Once done click on Install.  

[Add screen]

1. Once the installation is complete, note down the browser URL which has the installation ID. For example, `https://github.com/settings/installations/<installationID>`

### GitHub App details and Private key to create GitHub connection

**Note** following details of the app to create GitHub connection in Azure Migrate.  

1. Navigate to the GitHub App you created. Select Edit. 
1. Under General, About find the App ID and note down. 
1. For private key scroll down to Private keys. Click on Generate a private key. 
1. New private key file will be automatically downloaded on your machine. 
1. For Installation ID, navigate to Install App and select setting in front of the account where the app is installed.  
1. From the installation details page note down the browser URL which has the installation ID. For example, `https://github.com/settings/installations/<installationID>`

### Request code scan report to web app assessment using GitHub 

1. On the Azure Migrate project Overview page, under Decide and Plan, select Assessments. 
1. Search for the assessment using the Workloads filter and select it. 
1. On the assessment Overview page, select the Recommended path tab or View details in the recommended path report.  
1. This screen displays the distribution of the web apps across the Azure targets. Select a line item to drill down further. 
1. Under Add code insights select Using AppCAT reports. 
1. In the Add code insights page, select Create GitHub connection. 
1. In the Create new GitHub connection page provide following details 

| Field  | Details  | 
| --- | --- | 
| Connection name  | Provide the name for the connection. This connection name will appear in the list when adding report to the web app.  |    
| GitHub repository URL   | Specific the GitHub repository designated for creating an issue to request a Code scan report. The code scan report need be uploaded to this issue via GitHub Copilot.  </br> </br> Note: This repository is intended solely for the purpose of GitHub issue creation and read the code scan report from the issue. The application code does not need to be present within this repository.   | 
| App ID  | Enter the App ID of the GitHub App you created for allowing access to Azure Migrate. | 
| Private Key  | Copy the all the contents of the private key file that you generate for your GitHub app  |
| Installation ID  | Enter the Installation ID of the GitHub App installed on the repository provided above.  |

1. Once you add the details click on Create connection. Wait for the connection creation to be successful.  
1. Post the to request the code scan report for each web app from the list, select Request report via GitHub. In the Request report via GitHub page select the appropriate connection name and click on Request.  
1. This will create GitHub issue in the repository available in the connection details. 
1. When the code scan report has been uploaded to the GitHub issue, Azure Migrate will automatically attach the report to the web app. 
1. Adding the code scan report to Web App marks the assessment as outdated. 
1. Recalculate the assessment to see enhanced results with code insights. 

### Generate code scan report using GitHub Copilot app modernization extension

To generate code scan report follow below steps. 

1. To generate code scan report for .Net follow these steps [Assess and migrate a .NET project with GitHub Copilot app modernization for .NET](/dotnet/azure/migration/appmod/quickstart). 
1. To generate code scan report for Java, follow these steps [Assess a Java project using GitHub Copilot app modernization]. 
1. Once the report is available, upload the report to Github issue using below prompt in GitHub Copilot. 
1. upload assessment report to <GitHub Issue URL>   

### View code insights after adding code scan reports. 

1. On the Azure Migrate project Overview page, under Decide and Plan, select Assessments. 
1. Search for the assessment using the Workloads filter and select it. 
1. On the assessment Overview page, select the Recommended path tab or View details in the recommended path report.  
1. This screen displays the distribution of the web apps across the Azure targets. Select a line item to drill down further. 
1. Click on View code changes under Code insights.  
1. Check the code change by selecting the relevant tab. Issues, Warning, or Information. This is summarized view of code changes across the web apps in respective assessment.  
1. View individual web app changes, by clicking on the number under Code changes column against respective web app.  

After adding the code scan reports, the readiness and migration strategy for the relevant web app may change according to the identified code changes. If the code changes required are significant, the readiness of the web app may update from Ready to Ready with conditions.  

## Troubleshooting 