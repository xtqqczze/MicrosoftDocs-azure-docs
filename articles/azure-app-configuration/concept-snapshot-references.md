---
title: Snapshot references in Azure App Configuration
description: Learn what snapshot references are and how they enable both immutable configuration sets and dynamic updates.
author: jimmyca15
ms.author: jimmyca
ms.service: azure-app-configuration
ms.topic: concept-article 
ms.date: 11/11/2025
---

# Snapshot references

Snapshot references are special key-values that point to a specific snapshot in an App Configuration store. They let you combine the safety of immutable configuration (snapshots) with the flexibility of dynamically changing which snapshot an application consumes at runtime.

With direct snapshot usage, an application selects a snapshot by name in code. Changing the targeted snapshot requires a new deployment or configuration change in the code path that builds configuration. Snapshot references remove that constraint: you load a reference key-value once, and if its target snapshot name changes later, configuration providers automatically reload configuration to the new immutable set.

## Why use snapshot references?

Snapshot references provide:

* **Easy updates**: Update the referenced snapshot without touching application code, even during runtime.
* **Immutable configuration sets**: Each snapshot remains unchanged, preserving auditability and rollback guarantees.

## How they work

A snapshot reference is stored as a key-value whose value contains the name of the snapshot to consume. When a configuration provider loads key-values, any snapshot references among the selected items are automatically resolved. The referenced snapshot's key-values are merged into the application's configuration. If the reference changes to point to a different snapshot, the configuration provider refresh causes the new snapshot contents to be loaded.

> [!NOTE]
> You don't have to call a specialized API to opt into snapshot references. If you select the key-value that is a snapshot reference, resolution is automatic.

## Comparison: direct snapshot vs snapshot reference

| Aspect | Direct snapshot selection | Snapshot reference |
|--------|---------------------------|--------------------|
| How configured | `SelectSnapshot("Name")` in code | Load a key-value whose content type marks it as a reference |
| Change at runtime | Requires code/config update and redeploy | Update reference key-value only |
| Immutability of contents | Yes | Yes (contents of targeted snapshot) |
| Provider reload behavior | Only when app explicitly reconfigures | Automatic when reference changes |

## Creating a snapshot reference (Azure portal)

1. Open your App Configuration store in the Azure portal.
2. Select **Configuration Explorer**.
3. Choose **Create**.
4. Select **Snapshot reference**.
5. Enter a key for the reference. Optionally set a label.
6. Choose the target snapshot name from the list (or enter it).
7. Select **Create**.

Once created, the snapshot reference appears alongside other key-values in Configuration Explorer.


## Consuming snapshot references

You load configuration normally. Selecting the reference key-value is enough; the provider handles resolution.

```csharp
configurationBuilder.AddAzureAppConfiguration(options =>
{
    options.Connect(new Uri(Environment.GetEnvironmentVariable("Endpoint")), new DefaultAzureCredential());
    // No explicit snapshot selection required; any snapshot reference among selected key-values will be resolved.
});
```

Compare that with loading snapshots directly which fixes the snapshot at startup. Changing it later requires updating code or redeploying.

```csharp
configurationBuilder.AddAzureAppConfiguration(options =>
{
    options.Connect(new Uri(Environment.GetEnvironmentVariable("Endpoint")), new DefaultAzureCredential());
    // Direct snapshot selection: immutable set chosen here.
    options.SelectSnapshot("SnapshotName");
});
```

## Runtime update example

The following sequence demonstrates application behavior when an application is using snapshot references and has refresh configured.

1. The app starts up. The configuration provider fetches selected key-values including a snapshot reference.
2. The configuration provider resolves the reference to snapshot `Snapshot_A` and loads its key-values.
3. Later, you update the snapshot reference's value to `Snapshot_B` (still immutable).
4. The configuration provider detects the snapshot reference key-value has changed.
5. The configuration provider re-resolves. The key-values of `Snapshot_A` are unloaded. The configuration reload yields the key-values of `Snapshot_B`.

> [!NOTE]
> This sequence assumes you have configured refresh for your application. For details on how to configure refresh, see [dynamic configuration](./enable-dynamic-configuration-aspnet-core.md)

## Example snapshot reference

The following example demonstrates a snapshot reference

```json
{
    "key": "app1/snapshot-reference",
    "value": "{\"snapshot_name\":\"referenced-snapshot\"}",
    "content_type": "application/json; profile=\"https://azconfig.io/mime-profiles/snapshot-ref\"; charset=utf-8",
    "tags": {}
}
```

As mentioned, a snapshot reference is a normal key-value with some added constraints. Configuration providers identify snapshot references by their specific content type. The value of a snapshot reference is a json object with a name property that points to the target snapshot.

Snapshot reference content type: `application/json; profile="https://azconfig.io/mime-profiles/snapshot-ref"; charset=utf-8`

## Considerations and edge cases

* **Missing target snapshot**: If the reference points to a snapshot name that doesn't exist or is archived beyond retention, the provider ignores the reference.
* **Multiple references**: If you load multiple snapshot references, their resolved key-values merge by key order; conflicting keys follow standard precedence (last one wins).
* **Access control**: Reading a snapshot via a reference requires [snapshot read permissions](./concept-snapshots.md#read-and-list-snapshots), similarly to reading a snapshot directly.
* **Retention/archival**: Take care when referencing archived snapshots, as once the snapshot expires the app will no longer be able to access the contained configuration.

## Next steps

> [!div class="nextstepaction"]
> [Create and use snapshots](./howto-create-snapshots.md)

For deeper background, see the [Snapshots overview](./concept-snapshots.md).
