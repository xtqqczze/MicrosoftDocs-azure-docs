---
title: Release notes for 2026 Azure Health Data Services monthly releases
description: 2026 - Stay updated with the latest features and improvements for the FHIR, DICOM, and MedTech services in Azure Health Data Services in 2026. Read the monthly release notes and learn how to get the most out of healthcare data.
services: healthcare-apis
author: evachen96
ms.service: azure-health-data-services
ms.subservice: workspace
ms.topic: reference
ms.date: 1/1/2026
ms.author: evachen96
ms.custom:
  - references_regions
  - build-2026
---

# Release notes 2026: Azure Health Data Services

Release notes describe features, enhancements, and bug fixes released in 2026 for the FHIR&reg; service, Azure API for FHIR, DICOM&reg; service, and MedTech service in Azure Health Data Services.

## January 2026
### FHIR service

**Enhancement to $expand operation**: Added support for "context" parameter for [$expand](./fhir/fhir-expand.md) operation for US Core 6 IG support.

**Enhancement to SMART v2**: Enabled support for _include and _revinclude searches when using [SMART v2](./fhir/smart-on-fhir.md) granular scopes.

#### Bug fixes:

**Bug fix for PUT request with new search parameters**: Resolved issue where PUT requests for new search parameters were failing due to validation. This issue is resolved. PUT requests for search parameters should now properly work as upserts, allowing new search parameters to be inserted using PUT if the search parameter doesn't already exist in the system.

**Bug fix for PUT regression with metadata-only updates**: Resolved issue where metadata-only updates made via PATCH incremented the resource version without preserving the previous version. This issue was resolved on November 28, 2025.

**Bug fix for $import with relative URL error**: Previously, using $import with a relative URL could return a 500 Internal Server Error stating `This operation is not supported for a relative URI`. This issue is fixed, and now, a relative URL can be used as the input URL.

**Bug fixes for search with `_include`/`_revinclude` and `_sort`**: When executing a [search request with _include or _revinclude](./fhir/overview-of-search.md#request-parameters), if there are more than the `_includesCount` number of matched items, an include continuation link is provided, allowing you to navigate the complete result set. Previously, this particular functionality had some bugs when it was used with `_sort`. The following issues are fixed:
- Sorting by `lastUpdated` (descending): Included resources were missing from the bundle, and no include continuation token was returned. This issue is fixed; included resources and the include continuation token are now returned correctly.
- Sorting by any other field: If enough results existed to fill a page, it triggered a 500 error. This issue is fixed, and all results are returned correctly.
- Partial page with sort value: If matched results didn't fill a page but generated an include continuation token, that token was lost during the second search for non-sort matches. This issue is fixed, and the include continuation token is returned correctly.
- Include continuation link with `_sort`: The search retrieved data for both matches with and without the sort field, regardless of which type generated the token. This issue is fixed, and data is retrieved for the correct match.



## Related content

[Release notes 2021](release-notes-2021.md)

[Release notes 2022](release-notes-2022.md)

[Release notes 2023](release-notes-2023.md)

[Release notes 2024](release-notes-2024.md)

[Release notes 2025](release-notes-2025.md)

[Known issues](known-issues.md)

[!INCLUDE [FHIR and DICOM trademark statement](includes/healthcare-apis-fhir-dicom-trademark.md)]
