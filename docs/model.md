```md
# Semantic Model (Demo)

## Grain
- `f_WorkItems` is modeled at the **work item grain** (one row per `WorkItemKey`).

## Tables
- `f_WorkItems` (fact-like master table)
- `d_Calendar` (date dimension; joined for time intelligence)

Optional (if you later add dimensions):
- `d_Workstream`
- `d_Lead`
- `d_Stage`
- `d_Urgency`

## Relationships
- `d_Calendar[Date]` (1) → `f_WorkItems[IntakeDate]` (*)  
  (Alternative: use `PlanEnd` as the active relationship and keep others inactive for specific measures.)

## KPI Measures
Measures are defined using a public-safe naming convention:
- `KPI_WorkItemCount`, `KPI_ActiveCount`, `KPI_DoneCount`, `KPI_PastDueCount`, `KPI_SLA_OK_Rate`, etc.

## Notes on time intelligence
Time-intelligence measures assume:
- a continuous `d_Calendar[Date]`
- marked as Date table in the semantic model
