# Power Query (Demo / Redacted)

This folder contains **public-safe Power Query M** examples used to demonstrate a Fabric/Dataflow-style ETL pattern for the demo dataset.

## Files
- `dataflow_gen2_transform_demo.pq`  
  Reads synthetic CSV inputs, standardizes types/enums, derives `SLAFlag`, aggregates notes, and outputs an analytics-ready table.

## Inputs (synthetic)
Expected input files in this repository:
- `sample-data/f_WorkItems_demo.csv`
- `sample-data/x_WorkItemNotes_demo.csv`

The query loads these files using GitHub Raw URLs (public demo).  
If you prefer local execution, you can replace the `Web.Contents(...)` section with `File.Contents(...)`.

## Output
The query outputs a single enriched table at the **work item grain**:
- `WorkItemKey` (primary key)
- Core fields: `Workstream`, `Stage`, `UrgencyBand`, `Lead`, `Contributors`
- Dates: `IntakeDate`, `PlanStart`, `PlanEnd`, `DoneDate`, `LastUpdate`
- Derived: `SLAFlag`
- Notes summary: `NoteCount`, `LastNoteDate`

## Enum conventions (demo)
- Stage: `Stage A / Stage B / Stage C / Stage D`
- Workstream: `Workstream 1..N` (defaults to `Workstream 0` when missing)
- UrgencyBand: `Urgency 0 / 1 / 2 / 3` (defaults to `Urgency 0` when invalid)
- SLAFlag: `SLA_OK / PAST_DUE / NA / VOID`

## SLAFlag derivation rule (demo)
`SLAFlag` is derived using a simple plan-vs-actual rule:
- `Stage D` → `VOID`
- Missing `PlanEnd` → `NA`
- `Stage C` with missing `DoneDate` → `NA`
- `DoneDate > PlanEnd` → `PAST_DUE`
- Open items (`Stage A/B`) with `PlanEnd < today` → `PAST_DUE`
- Otherwise → `SLA_OK`

## Security & privacy
This demo:
- Includes **no tenant URLs, list GUIDs, workspace names, real user names/emails, or record-level descriptions**
- Uses **pseudonymous naming** (`WorkItemKey`, `Lead`, `Workstream`, etc.)
- Uses **synthetic datasets only**
