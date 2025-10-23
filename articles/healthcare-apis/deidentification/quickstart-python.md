---
title: Create an Azure Health Data Services de-identification service by using the synchronous endpoint in Python
description: Learn how to create an Azure Health Data Services de-identification service by using the synchronous endpoint in Python
services: azure-resource-manager
ms.service: azure-health-data-services
ms.subservice: deidentification-service
author: kimiamavon
ms.author: kimiamavon
ms.topic: quickstart
ms.date: 10/23/2025
---

# Quickstart: Deploy the de-identification service synchronous endpoint (English and Multilingual)

In this quickstart, you deploy an instance of the de-identification service in your Azure subscription using the synchronous endpoint in Python. 

- For **English data**, use the [Python SDK](#using-the-english-model-python).  
- For **French, Spanish, and German data**, use the [multilingual model](#using-the-multilingual-model-french-spanish-german) with `curl` or PowerShell.

---

## Table of contents
- [Prerequisites](#prerequisites)
- [Create a resource](#create-a-resource)
- [Set role-based access control (RBAC)](#set-role-based-access-control-rbac)
- [Install the package (Python only)](#install-the-package-python-only)
- [Using the English model (Python)](#using-the-english-model-python)
- [Using the multilingual model (French, Spanish, German)](#using-the-multilingual-model-french-spanish-german)
  - [Get an access token](#get-an-access-token)
  - [Run the multilingual service](#run-the-multilingual-service)
  - [Multilingual code examples](#multilingual-code-examples)
- [Clean up resources](#clean-up-resources)
- [Next steps](#next-steps)

---

## Prerequisites

- If you don't have an Azure account, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).
- An Azure subscription with **write permissions**
- Access to the [Azure portal](https://portal.azure.com/).
- Python 3.8 or later (for the English language model)
- cURL (for the French, German and Spanish language model)
- The Azure azure-health-deidentification [Python package](/python/api/overview/azure/health-deidentification-readme?view=azure-python-preview&preserve-view=true)
- Basic familiarity with Azure CLI or terminal.

## Create a resource

1. In the [Azure portal](https://portal.azure.com), search for **de-identification** in the top search bar. 
2. Select **De-identification Services** in the search results.
3. Select the **Create** button.

## Complete the Basics tab

In the **Basics** tab, provide the following information for your de-identification service:

1. Fill in the **Project Details** section:

   | Setting        | Action                                       |
   |----------------|----------------------------------------------|
   | Subscription   | Select your Azure subscription.              |
   | Resource group | Select **Create new** and enter **my-deid**. |

2. Fill in the **Instance details** section:

   | Setting        | Action                                       |
   |----------------|----------------------------------------------|
   | Name           | Name your de-identification service.          |
   | Location       | Select a supported Azure region. |

Supported regions are located [here.](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table)

After you complete the configuration, you can deploy the de-identification service:

3. Select **Next: Review + create** to review your choices.
4. Select **Create** to start the deployment of your de-identification service. Deployment may take a few minutes. After the deployment is complete, select **Go to resource** to view your service.
5. After the deployment completes, note your **Subscription**, **Subscription ID** and **Service URL**.
   
## Set role-based access control (RBAC)

Now that the resource is deployed, you need to assign yourself the following permissions using RBAC to use the De-identification APIs:

1. On the left panel, select **Access control (IAM).** 
2. Click **Add** and **Add role assignment.** 
3. Select **DeID Data Owner** and **DeID Realtime Data User**, then select **Members** on the top panel. 
4. Select **+ Select members,** and a panel will appear. Search for your own name and press **Select.** 
5. Back in the **Members** panel, select **Review + assign** at the bottom left.

 **Tip:** If you want to use both the synchronous and asynchronous (batch) APIs, you will need to aslo assign yourself the **DeID Batch Data Owner**.

## Using the English model (Python)

### Install the package (Python only)

The following steps apply if you are looking to de-identify data in English with the Python SDK.
Skip to [Using the multilingual model (French, Spanish, German)](#using-the-multilingual-model-french-spanish-german) for non-English data.

Install the Azure Health Deidentification client library for Python. More information is available [here.](/python/api/overview/azure/health-deidentification-readme?view=azure-python-preview&preserve-view=true)

```Bash
python -m pip install azure-health-deidentification
```

### Test the service
In terminal, [log in to Microsoft azure.](/cli/azure/authenticate-azure-cli) 
Now, write “python” to open a python shell and paste the following code. 
Be sure to replace your Service URL with the URL you noted when creating a resource. 
You can also change the operation type between REDACT, TAG, or SURROGATE.

```Bash
from azure.health.deidentification import *  
from azure.health.deidentification.models import *  
from azure.identity import DefaultAzureCredential  

SERVICE_URL = "<YOUR SERVICE URL HERE>" ### Replace 
client = DeidentificationClient(SERVICE_URL.replace("https://", ""), DefaultAzureCredential())  

# Input  
text = """  Hannah is a 92-year-old admitted on 9/7/23. First presented symptoms two days earlier on Tuesday, 9/5/23 """  
operation=OperationType.SURROGATE ### CHANGE OPERATION TYPE AS NEEDED. Options include OperationType.TAG, OperationType.REDACT, and OperationType.SURROGATE    

# Processing  
print("############ Input")  
print(text)  
content = DeidentificationContent(input_text=text, operation=operation)  
try: 
    response = client.deidentify(content) 
except Exception as e: 
    print("Request failed with exception: \n\n", e) 
    exit() 
print("\n############ Output")  

if operation==OperationType.TAG:  
    print(response.tagger_result)  
else:  
    print(response.output_text)  

```

### Example input & output

   | Input        | Output          |
   |----------------|---------|
   | Hannah is a 92-year-old admitted on 9/7/23. First presented symptoms two days earlier on Tuesday, 9/5/23           | Kim is a 90-year-old admitted on 9/30/23. First presented symptoms two days earlier on Thursday, 9/28/23          |

## Using the multilingual model (French, Spanish, German)

The following steps apply if you are looking to de-identify data in French, Spanish, and German using curl or PowerShell.

**Note:** SDKs for multilingual support are not yet available. Use REST API calls with cURL or PowerShell instead.

### Get an access token

1. To get your token 

```Bash
az login
az account get-access-token --scope https://deid.azure.com/.default --query accessToken -o tsv
```

2. To save your token

```Bash
echo "<token>" > token.txt
```
### Run the multilingual service

You can use one of two methods:

1. PowerShell script 

1.1. Using powershell in terminal, run the file  

```Bash
DemoDeidentificationService.ps1 
``` 

1.2. Edit the text (line ~121) to insert your own text.  

1.3. In terminal, run:  

```Bash
pwsh DemoDeidentificationService.ps1
```

2. cURL command 

The examples below cover the TAG, REDACT and SURROGATE operations. To set the language in which the de-identification service needs to operate, set the following line:

```Bash
"InputLocale": "[see full list of supported language-locale pairs](articles/healthcare-apis/deidentification/Languages-supported)"
```

**Note:** Replace <your-service-url> with your actual service URL and <token> with your access token in the examples below.

**TAG**
```Bash
curl -X POST \
  -H "Authorization: Bearer $(<token.txt)" \
  -H "Content-Type: application/json" \
  -d '{
    "Operation": "tag",
    "InputText": "Julie Tremblay a été consultée par Dr. Marc Lavoie  à l'Hôpital de la Cité-des-Prairies le 10 Janvier.",
    "customizations": {
      "InputLocale": "fr-CA"
    }
  }' \
  https://<your-service-url>/deid?api-version=2024-12-15-preview
```
**REDACT**
```Bash
curl -X POST \
  -H "Authorization: Bearer $(<token.txt)" \
  -H "Content-Type: application/json" \
  -d '{
    "Operation": "redact",
    "InputText": "María Gómez fue ingresada para una cirugía el 29 de octubre.",
    "customizations": {
      "InputLocale": "es-US"
    }
  }' \
  https://<your-service-url>/deid?api-version=2024-12-15-preview
```

**SURROGATE**
```Bash
curl -X POST \
  -H "Authorization: Bearer $(<token.txt)" \
  -H "Content-Type: application/json" \
  -d '{
    "Operation": "surrogate",
    "InputText": "Sein letzter Termin war bei Doktor Hibbert",
    "customizations": {
      "SurrogateLocale": "de-DE"
    }
  }' \
  https://<your-service-url>/deid?api-version=2024-12-15-preview
```

## Clean up resources

If you no longer need the service, delete the resource group and de-identification service:

1. In the Azure portal, select the **resource group**.
2. Select **Delete**.

## Next steps

> [!div class="nextstepaction"]
> [Tutorial: Configure Azure Storage to de-identify documents](configure-storage.md)
