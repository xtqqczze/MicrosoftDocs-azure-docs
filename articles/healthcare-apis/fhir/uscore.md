---
title: US Core
description: Overview of US Core in Azure Health Data Services FHIR
author: evachen96
ms.author: evach
ms.service: healthcare-apis
ms.topic: overview #Required; leave this attribute/value as-is.
ms.date: 10/10/2025

---

# US Core

The HL7 US Core Implementation Guide (US Core IG) is a set of rules and best practices that help healthcare providers share patient information safely and efficiently across the United States. The Azure Health Data Services FHIR server supports the following US Core versions:

- [US Core 3.1.1](https://hl7.org/fhir/us/core/STU3.1.1/index.html)
- [US Core 6.1.0](https://www.hl7.org/fhir/us/core/STU6.1/ImplementationGuide-hl7.fhir.us.core.html)

Note that the FHIR service doesn't store any profiles from implementation guides by default. You'll need to load them into the FHIR service. Follow [storing profiles instructions](./fhir/store-profiles-in-fhir.md) to store the relevant profiles for your desired US Core version. 

## US Core 6.1.0
## `$docref` operation
The [$docref operation](https://www.hl7.org/fhir/us/core/STU6.1/OperationDefinition-docref.html), as defined as part of US Core 6.1.0, is used to return all the references to documents related to a patient. A `searchset` Bundle containing DocumentReference resources for the patient is returned. 

### `$docref` parameters
|Parameter|Description|
|---|---|
|patient|The ID of the patient resource.|
|start|The start date-time of the date range relates to care dates, not record currency dates. |
|end| The end date-time of the date range relates to care dates, not record currency dates. |
|type| The type relates to document type.|

Note that on-demand and profile parameters aren't currently supported.

<!--
### Example `$doc-ref` request
Add example $docref request here
-->

## `$expand` operation
The [$expand operation](https://hl7.org/fhir/R4/valueset-operation-expand.html), as defined as part of US Core 6.1.0, is used to determine the values in a ValueSet.  

### `$expand` parameters
|Parameter|Description|
|---|---|
|url|Canonical reference of the value set.|
| valueSet| Provide the value set directly as part of the request.|

Note: other $expand parameters beyond this list aren't currently supported.

<!--
### Example `$expand` request
Add example $expand request here
-->

<!-->
### US Core 6 test data
We have provided [sample test data](https://github.com/Azure-Samples/azure-health-data-and-ai-samples/tree/main/samples/USCore6-test-data) that can be used for US Core 6 compliance testing.  

Note: Samples are open-source code, and you should review the information and licensing terms on GitHub before using it. They are not part of the Azure Health Data Service and are not supported by Microsoft Support.   
-->

Medical device disclaimer: Microsoft products and services (1) aren't designed, intended, or made available as a medical device, and (2) aren't designed or intended to be a substitute for professional medical advice, diagnosis, treatment, or judgment and shouldn't be used to replace or as a substitute for professional medical advice, diagnosis, treatment, or judgment. Customers/partners are responsible for ensuring solutions comply with applicable laws and regulations.  

[!INCLUDE [FHIR trademark statement](../includes/healthcare-apis-fhir-trademark.md)]


