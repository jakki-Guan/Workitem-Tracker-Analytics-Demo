# KPI Spec (Demo)

## Demo Enumerations
- Stage: Stage A / Stage B / Stage C / Stage D
- Workstream: Workstream 1..N
- UrgencyBand: Urgency 1 / Urgency 2 / Urgency 3 / Urgency 0 (Unknown)
- SLAFlag: SLA_OK / PAST_DUE / NA / VOID

## Core Measures (KPI_*)
### KPI_WorkItemCount
- Definition: total number of work items in current filter context
- Grain: Work item
- Notes: counts distinct WorkItemKey

### KPI_ActiveCount
- Definition: items currently active (not done, not void)
- Logic: Stage in {Stage A, Stage B} AND SLAFlag <> VOID

### KPI_DoneCount
- Definition: items completed
- Logic: Stage = Stage C (Done)

### KPI_PastDueCount
- Definition: items past due (open items whose PlanEnd < today; or completed late if you choose)
- Logic: SLAFlag = PAST_DUE

### KPI_SLA_OK_Rate
- Definition: SLA_OK / (SLA_OK + PAST_DUE) within eligible items
- Exclusions: SLAFlag in {NA, VOID}

