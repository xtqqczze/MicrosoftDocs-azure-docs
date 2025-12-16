---
title: MQTT Retain in Azure Event Grid
description: Learn how Azure Event Grid supports MQTT Retain to store the last known good value of a topic so that new subscribers get the latest message instantly.
#customer intent: As a developer, I want to understand how MQTT Retain works in Azure Event Grid so that I can ensure new subscribers get the latest message instantly.  
ms.topic: concept-article
ms.date: 07/30/2025
ms.custom:
  - ai-gen-docs-bap
  - ai-gen-title
  - ai-seo-date:07/30/2025
  - ai-gen-description
---

# MQTT Retain support in Azure Event Grid

The Message Queuing Telemetry Transport (MQTT) Retain feature in Azure Event Grid ensures that the last known good value of a topic is stored and readily available for new subscribers. This capability allows new clients to instantly receive the most recent message upon connection, eliminating the need to wait for the next publish. It's beneficial in scenarios such as device state reporting, control signals, or configuration data, where timely access to the latest message is critical.

This article provides an overview of how MQTT Retain works, its billing implications, storage limits, message deletion methods, and Retain management considerations.


## Billing

Each retained publish counts as two MQTT operations: one for processing the message, and one for storing it.

## Storage limits

- Up to 640 MB or 10,000 retained messages per throughput unit (TU).
- Maximum size per retained message is 64 KB.

For larger needs, contact Azure Support.

## Message deletion

- **MQTT 3.1.1**: Publish an empty payload to the topic.
- **MQTT 5.0**: Set expiry or send an empty message to remove it.


## Retained messages – Get & List

Retained messages let an MQTT broker store the **last known message** on a topic so new subscribers immediately receive the current value without waiting for the next publish. Now you can use the following **HTTP management endpoints** for:

- **Retain Get** — fetch the raw retained message body for a specific topic; message metadata is returned via HTTP headers.
- **Retain List** — enumerate retained messages matching a topic filter (wildcards supported) or page through results with a continuation token.

These APIs are intended for **observability, audit, and operational workflows** (for example, support troubleshooting, backfills, or verifying device state at scale).


### Authentication & authorization

The Retain Get and Retain List APIs require:

- **Auth**: `Authorization: Bearer <token>`.
- **Token audience / scope**: Use the broker’s App ID URI / resource provided for this preview (replace `<YOUR TOKEN HERE>` in samples).
- **RBAC**: Caller must have permission to invoke retained message read operations on the namespace.

To get the Bearer token, run the following Azure CLI command:

```bash
az account get-access-token --resource=https://eventgrid.azure.net --query accessToken -o tsv
```

### Reference API

#### Retain Get

```bash
GET /mqtt/retainedMessages/message?topic=<YOUR ENCODED TOPIC HERE>&api-version=2025-11-16-preview HTTP/1.1
Authorization: Bearer <YOUR TOKEN HERE>
Host: <YOUR Event Grid MQTT BROKER URL HERE>
```

**Response**: 

- **Body**: raw MQTT message payload (bytes).
- **Headers**: include message metadata (names subject to change in preview): 
    - **x-ms-mqtt-topic** — topic of the retained message. 
    - **x-ms-mqtt-qos** — QoS level (0 or 1).
    - **x-ms-mqtt-size** — full MQTT message size (bytes). 
    - **x-ms-mqtt-expiry** — expiry timestamp (ISO 8601) if set. 
    - **x-ms-mqtt-last-modified** — last modified timestamp (ISO 8601).

### Retain List

```bash
GET /mqtt/retainedMessages?topicFilter=<YOUR ENCODED TOPIC FILTER HERE>&continuationToken=<MUTUALLY EXCLUSIVE WITH TOPIC FILTER>&maxResults=<1-100>&api-version=2025-11-16-preview HTTP/1.1
Authorization: Bearer <YOUR ENTRA TOKEN HERE>
Host: <YOUR BROKER URL HERE>
```

**Notes**
Notes
- topicFilter supports wildcards (e.g., factory/+/state, sensors/#).
- continuationToken is mutually exclusive with topicFilter. Use it to continue from a previous page.
- maxResults bounds the page size (1–100).

**Response (JSON)**:

```json
Response (JSON)
{
  "nextLink": <NULL OR URL HERE>,
  "retainedMessages": [
    {
      "topic": <SOME TOPIC>,
      "qos": <SOME QOS>,
      "size": <FULL MQTT MESSAGE SIZE>,
      "expiry": <TIME STAMP>,
      "lastModifiedTime": <TIME STAMP>
    }
  ]
}
```

### Examples

URL‑encoding helper
- Topic: `factory/line1/cell17/state` 
    - Encoded: `factory%2Fline1%2Fcell17%2Fstate`
- Filter: `factory/line1/+/state` 
    - Encoded: `factory%2Fline1%2F%2B%2Fstate`

#### curl — Retain Get

```bash
BROKER="<YOUR BROKER URL HERE>"  # e.g. contoso.westus.ts.eventgrid.azure.net
TOKEN="<YOUR TOKEN HERE>"
TOPIC_ENC="factory%2Fline1%2Fcell17%2Fstate"

curl -i \
  -H "Authorization: Bearer $TOKEN" \
  "https://$BROKER/mqtt/retainedMessages/message?topic=$TOPIC_ENC&api-version=2025-11-16-preview"
```

**Sample response:**

```bash
HTTP/1.1 200 OK
x-ms-mqtt-topic: factory/line1/cell17/state
x-ms-mqtt-qos: 1
x-ms-mqtt-size: 42
x-ms-mqtt-expiry: 2025-11-16T08:13:05Z
x-ms-mqtt-last-modified: 2025-11-16T07:59:41Z
content-type: application/octet-stream

{"state":"READY","tempC":25.1,"ts":"2025-11-16T07:59:40Z"}
```

#### curl — Retain List with topicFilter

```bash
BROKER="<YOUR BROKER URL HERE>"
TOKEN="<YOUR TOKEN HERE>"
FILTER_ENC="factory%2Fline1%2F%2B%2Fstate"

curl -sS \
  -H "Authorization: Bearer $TOKEN" \
  "https://$BROKER/mqtt/retainedMessages?topicFilter=$FILTER_ENC&maxResults=50&api-version=2025-11-16-preview"
```

**Sample response:**

```json
{
  "nextLink": null,
  "retainedMessages": [
    {
      "topic": "factory/line1/cell17/state",
      "qos": 1,
      "size": 42,
      "expiry": "2025-11-16T08:13:05Z",
      "lastModifiedTime": "2025-11-16T07:59:41Z"
    },
    {
      "topic": "factory/line1/cell18/state",
      "qos": 1,
      "size": 41,
      "expiry": null,
      "lastModifiedTime": "2025-11-16T07:55:02Z"
    }
  ]
}
```

#### curl — Retain List with continuationToken

```bash
NEXT_LINK="<PASTE NEXTLINK FROM PRIOR CALL>"

curl -sS -H "Authorization: Bearer $TOKEN" "$NEXT_LINK"
```

### Behavior, limits & performance 
- maxResults range: 1–100 per page.
- Topic filter supports standard MQTT wildcards + and # (encoded in URL).
- Payload size: returned as raw bytes (no JSON wrapping).
- Headers are the single source for metadata in Get; do not expect a JSON envelope.
- Paging: follow nextLink until null. Do not mix topicFilter with continuationToken.
- Throttling: Standard platform throttles may apply (429). Use retry with backoff.

###Error handling & troubleshooting

- 400 Bad Request — malformed or missing topic / topicFilter; provided both topicFilter and continuationToken.
- 401 Unauthorized — invalid/expired token or wrong audience.
- 403 Forbidden — caller lacks permission on the namespace.
- 404 Not Found — no retained message for the specified topic.
- 409 Conflict — request violates preview constraints.
- 429 Too Many Requests — throttled; respect Retry-After.
- 5xx — transient service error; retry with exponential backoff.

> [!NOTE]
> - Confirm the topic is exact (case‑sensitive) and correctly URL‑encoded. 
> - Verify you’re requesting the correct audience/scope for the broker. 

