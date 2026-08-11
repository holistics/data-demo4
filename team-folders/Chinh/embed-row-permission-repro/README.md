# Embedded permission model lookup reproduction

This reproduces the reported state where `demo_fact_task` exists as a published AML model, but the `documents` dataset does not contain it.

Use this row-based permission with the embed portal:

```json
{
  "permissions": {
    "row_based": [
      {
        "path": {
          "dataset": "documents",
          "model": "demo_fact_task",
          "field": "organization_id"
        },
        "modifier": null,
        "values": ["org_a"],
        "operator": "is"
      }
    ]
  }
}
```

Expected result: Holistics reports that `demo_fact_task` cannot be found in the `documents` dataset.

The `documents_with_demo_fact_task` dataset is the control case. It includes the same model and field referenced by the permission path.
