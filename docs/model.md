# Semantic Model (Demo)

This document describes the **public demo** semantic model built on top of the synthetic `f_WorkItems` dataset.
All names are pseudonymous and intentionally different from any internal/production system.

## 1) Modeling grain
- **Fact grain:** one row per **WorkItemKey** in `f_WorkItems`
- Each row represents a single work item and its current attributes (Stage, Lead, Workstream, etc.)

## 2) Tables

### f_WorkItems (core fact-like table)
Primary key:
- `WorkItemKey`

Key attributes (demo):
- `Workstream` (Workstream 1..N)
- `Stage` (Stage A/B/C/D)
- `UrgencyBand` (Urgency 0/1/2/3)
- `Lead` (Lead A..N)
- `Contributors` (semicolon-delimited text)
- `SLAFlag` (SLA_OK / PAST_DUE / NA / VOID)

Dates:
- `IntakeDate`
- `PlanStart`
- `PlanEnd`
- `DoneDate`
- `LastUpdate` (optional)

Optional enrichment (from notes aggregation):
- `NoteCount`
- `LastNoteDate`

### d_Calendar (date dimension)
- Continuous date range covering all work item dates (demo)
- Typical columns:
  - `Date` (key)
  - `Year`, `Quarter`, `Month`, `MonthName`, `WeekOfYear`, `Day`
- Marked as a **Date table** in the model (for time intelligence)

## 3) Relationships

### Recommended default (simple demo)
- `d_Calendar[Date]` (1) → `f_WorkItems[IntakeDate]` (*)

### Alternative (more BI-realistic)
If the report focuses on due dates, set the active relationship to:
- `d_Calendar[Date]` (1) → `f_WorkItems[PlanEnd]` (*)

And keep the other date relationships as **inactive**, activating them in measures via `USERELATIONSHIP()` when needed.

## 4) KPI measure naming
All measures follow a demo-safe convention:
- Prefix: `KPI_`
- Examples:
  - `KPI_WorkItemCount`
  - `KPI_ActiveCount`
  - `KPI_DoneCount`
  - `KPI_PastDueCount`
  - `KPI_SLA_OK_Rate`

## 5) Filter behavior (expected)
- Slicers/filtering on `Workstream`, `Stage`, `UrgencyBand`, `Lead` filter the `f_WorkItems` table directly
- KPI measures are designed to respect the current filter context

## 6) Time-intelligence assumptions
Time-intelligence measures assume:
- `d_Calendar[Date]` is continuous and marked as the Date table
- the active relationship drives default MTD/YTD calculations
