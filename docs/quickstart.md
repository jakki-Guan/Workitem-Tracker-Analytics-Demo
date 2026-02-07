# Quick Start (Demo / Redacted)

This quick start shows how to review or rebuild the demo using **synthetic CSVs** and **public-safe naming**.

---

## Option A — Quick review (recommended)
1) View Fabric lineage image: `screenshots/fabric/lineage_v2_demo.png`
2) Read the schema: `docs/schema.md` (includes ER diagram)
3) Read KPI definitions: `docs/kpi-spec.md`
4) Review DAX measures: `dax/measures_demo.md`
5) Review Power Query patterns: `powerquery/`

---

## Option B — Rebuild a minimal demo in Power BI (no Fabric required)

### B1) Prepare demo inputs
Use the synthetic CSVs in `sample-data/`:
- `f_WorkItems_demo.csv`
- `x_WorkItemNotes_demo.csv`
- `x_WorkItemLinks_demo.csv` (optional)

### B2) Load CSVs into Power BI Desktop
1) Power BI Desktop → **Get Data** → Text/CSV
2) Load `f_WorkItems_demo.csv` as table **f_WorkItems**
3) Load `x_WorkItemNotes_demo.csv` as table **x_WorkItemNotes**
4) (Optional) load `x_WorkItemLinks_demo.csv` as table **x_WorkItemLinks**

### B3) Create a Date table (required for MTD/YTD)
Model view → New table:

```DAX
d_Calendar =
VAR MinDate =
    MINX ( f_WorkItems, f_WorkItems[IntakeDate] )
VAR MaxDate =
    MAXX ( f_WorkItems, COALESCE ( f_WorkItems[DoneDate], f_WorkItems[PlanEnd] ) )
RETURN
ADDCOLUMNS (
    CALENDAR ( MinDate, MaxDate ),
    "Year", YEAR ( [Date] ),
    "Month", FORMAT ( [Date], "YYYY-MM" ),
    "MonthName", FORMAT ( [Date], "MMM" ),
    "Quarter", "Q" & FORMAT ( [Date], "Q" ),
    "WeekOfYear", WEEKNUM ( [Date], 2 )
)
```
Then:
- Mark as date table: Table tools → Mark as date table → Date
- Create relationship: `d_Calendar[Date] → f_WorkItems[IntakeDate]` (active)
### B4) Add measures
Copy measures from:
- `dax/measures_demo.md`
### B5) Build a minimal report page
Recommended visuals:
- Cards: `KPI_WorkItemCount`, `KPI_ActiveCount`, `KPI_DoneCount`, `KPI_PastDueCount`
- Line chart by `d_Calendar[Date]`: `KPI_WorkItemCount` (or MTD/YTD)
- Slicers: `Workstream`, `Stage`, `UrgencyBand`, `LeadAlias`
- Drill-through page (optional): show `WorkItemKey` and a notes table filtered by key

## Notes
- Trend measures (MTD/YTD) assume `d_Calendar` exists and an active relationship is set.
- All data is synthetic; replace CSVs freely to test different patterns.
- The Fabric implementation follows the same logic (Dataflow Gen2 → Lakehouse → Semantic model).
