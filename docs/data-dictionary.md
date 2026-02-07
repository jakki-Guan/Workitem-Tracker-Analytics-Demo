# Demo Naming Dictionary (Public)

## Tables
- f_WorkItems (parent / master)
- x_WorkItemNotes (child)
- x_WorkItemLinks (child)
- d_Calendar (date dimension)

## Key Columns (f_WorkItems)
- WorkItemKey (PK)
- Workstream
- Stage
- UrgencyBand
- Lead
- Contributors
- IntakeDate
- PlanStart
- PlanEnd
- DoneDate
- SLAFlag
- LastUpdate

## Notes
This dictionary is intentionally different from any internal/production naming.
## Measure Naming (Public)
All measures use a demo naming convention to avoid overlap with any internal system:
- `KPI_WorkItemCount`
- `KPI_ActiveCount`
- `KPI_DoneCount`
- `KPI_PastDueCount`
- `KPI_SLA_OK_Rate`

## Redaction Rule
If a screenshot/code snippet contains internal names, replace them using this dictionary before publishing.
