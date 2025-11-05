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

---

## Table of contents
- [Prerequisites](#prerequisites)
- [Create a resource](#create-a-resource)
- [Set role-based access control (RBAC)](#set-role-based-access-control-rbac)
- [Running the service using the Python SDK](#running-the-service-using-the-python-sdk)
- [Clean up resources](#clean-up-resources)
- [Next steps](#next-steps)

---

## Prerequisites

- If you don't have an Azure account, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- An Azure subscription with write permissions
- Python 3.8 or later  
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
5. After the deployment completes, note your **Subscription**, **Subscription ID**, and **Service URL**.
   
## Set role-based access control (RBAC)

Now that the resource is deployed, you need to assign yourself the following permissions using RBAC to use the De-identification APIs:

1. On the left panel, select **Access control (IAM).** 
2. Click **Add** and **Add role assignment.** 
3. Select **DeID Data Owner** and **DeID Realtime Data User**, then select **Members** on the top panel. 
4. Select **+ Select members,** and a panel appears. Search for your own name and press **Select.** 
5. Back in the **Members** panel, select **Review + assign** at the bottom left.

 **Tip:** If you want to use both the synchronous and asynchronous (batch) APIs, you need to also assign yourself the **DeID Batch Data Owner**.

## Running the service using the Python SDK

1. Install the Azure Health Deidentification client library for Python. More information is available [here.](/python/api/overview/azure/health-deidentification-readme?view=azure-python-preview&preserve-view=true)

```Bash
python -m pip install azure-health-deidentification
```

2. Test the service:
In terminal, [log in to Microsoft Azure.](/cli/azure/authenticate-azure-cli) 
The code below references the [python SDK for text.](https://github.com/Azure/azure-sdk-for-python/blob/azure-health-deidentification_1.0.0/sdk/healthdataaiservices/azure-health-deidentification/samples/deidentify_text_redact.py)

2.a. To use it, create a python file called "deidentify_text_redact.py" and paste the following code in. Run "python deidentify_text_redact.py".

2.b. Be sure to replace `AZURE_HEALTH_DEIDENTIFICATION_ENDPOINT` with the URL you noted when creating a resource. 

2.c. You can also change the operation type between `REDACT`, `TAG`, or `SURROGATE`. You can change the languale-locale pair to [other languages supported](languages-supported.md) by the service. 

```python

"""
FILE: deidentify_text_redact.py

DESCRIPTION:
    This sample demonstrates the most simple de-identification scenario, calling the service to redact
    PHI values in a string.

USAGE:
    python deidentify_text_redact.py

    Set the `AZURE_HEALTH_DEIDENTIFICATION_ENDPOINT` with your service's URL.
"""

from azure.health.deidentification import DeidentificationClient
from azure.health.deidentification.models import (
    DeidentificationContent,
    DeidentificationOperationType,
    DeidentificationResult,
    DeidentificationCustomizationOptions,
)
from azure.identity import DefaultAzureCredential


def deidentify_text_redact():
    endpoint = "<YOUR SERVICE'S URL>"
    credential = DefaultAzureCredential()
    client = DeidentificationClient(endpoint, credential)

    locale = "en-US"  # e.g., "fr-FR", "es-US", etc
    customizations = DeidentificationCustomizationOptions(surrogate_locale=locale)

    body = DeidentificationContent(
        input_text="It's great to work at Contoso.",
        operation_type=DeidentificationOperationType.SURROGATE,
        customizations=customizations,
    )

    result: DeidentificationResult = client.deidentify_text(body)
    print(f'\nOriginal Text:  "{body.input_text}"')
    print(f'Locale:         {locale}')
    print(f'Redacted Text:  "{result.output_text}"')
    # [END redact]


if __name__ == "__main__":
    deidentify_text_redact()

```

### Example input & output

   | Input        | Output          |
   |----------------|---------|
   | Kimberly Brown is a 34 y.o. female presenting with bilateral eye discomfort. Last seen by her PCP 2/6/2025 Dr. Orlo at Contoso Clinics Downtown Bellevue PCP.           | Britt Macdonough is a 34 y.o. female presenting with bilateral eye discomfort. Last seen by her PCP 1/18/2025 Dr. Defiore at Cardston Hospital PCP.          |

## Clean up resources

If you no longer need the service, delete the resource group and de-identification service:

1. In the Azure portal, select the **resource group**.
2. Select **Delete**.

## Next steps

> [!div class="nextstepaction"]
> [Tutorial: Configure Azure Storage to de-identify documents](configure-storage.md)
