# Data Dictionary (Demo / Redacted)

This dictionary documents the demo fields used across:
- `sample-data/` (synthetic inputs)
- `powerquery/` (ETL patterns)
- `dax/measures_demo.md` (semantic KPIs)
- `docs/kpi-spec.md` (business definitions)

---

## 1) Table: `f_WorkItems` (work item grain)

| Field | Type | Example (Demo) | Description | Source / Derivation | Used by |
|---|---|---:|---|---|---|
| `WorkItemKey` | INT | 100012 | Unique identifier (PK) | Source key, renamed to demo | All KPIs (base distinct count) |
| `WorkItemLabel` | TEXT | "Item 012" | Short label/title | Synthetic / source title | Optional (drill-through display) |
| `WorkItemSummary` | TEXT | "Brief summary..." | Description/summary | Synthetic | Drill-through display |
| `Workstream` | TEXT | "Workstream 3" | High-level category | Synthetic / mapped category | Slicers; breakdown visuals |
| `Stage` | TEXT | "Stage B" | Work stage/state | Synthetic / mapped status | Active/Done KPIs |
| `UrgencyBand` | TEXT | "Urgency 2" | Priority band | Synthetic / mapped priority | Slicers; prioritization views |
| `LeadAlias` | TEXT | "Lead F" | Owner/lead (alias) | Source person field → alias | Slicers; owner views |
| `ContributorAliases` | TEXT | "User A; User C" | Assigned users (alias list) | Flatten multi-person to delimited text | Optional breakdown |
| `IntakeContactAlias` | TEXT | "Requester B" | Requester/contact (alias) | Source requester → alias | Optional |
| `IntakeDate` | DATE | 2026-01-10 | Date received/intake | Source date normalized | Aging, time trends |
| `PlanStart` | DATE | 2026-01-12 | Planned start | Source date normalized | Cycle time |
| `PlanEnd` | DATE | 2026-02-01 | Planned finish/target | Source date normalized | SLA derivation context |
| `DoneDate` | DATE | 2026-02-03 | Actual completion | Source date normalized | Done/Cycle time |
| `LastUpdate` | DATE | 2026-01-22 | Last update date | Parsed or synthetic | Optional |
| `NextActions` | TEXT | "Follow up..." | Next steps | Text field (synthetic) | Optional drill-through |
| `UpdateLog` | TEXT | "Update..." | Latest update notes | Text field (synthetic) | Optional drill-through |
| `SLAFlag` | TEXT | "PAST_DUE" | SLA status classification | Derived in ETL or provided in demo | SLA KPIs |
| `NoteCount` | INT | 3 | Number of notes for item | Child aggregation (optional) | Notes KPIs |

---

## 2) Table: `x_WorkItemNotes` (child detail)

| Field | Type | Example (Demo) | Description | Source / Derivation | Used by |
|---|---|---:|---|---|---|
| `NoteKey` | INT | 900001 | Note unique key (PK) | Synthetic / source key | Drill-through |
| `WorkItemKey` | INT | 100012 | FK back to work item | Relationship key | Drill-through filtering |
| `NoteDate` | DATE | 2026-01-18 | Note timestamp | Normalized date | Optional time analysis |
| `NoteClass` | TEXT | "NoteType 2" | Note category/type | Synthetic / mapped type | Optional |
| `NoteSummary` | TEXT | "Short note..." | Note text (redacted) | Synthetic | Drill-through display |

---

## 3) Table: `x_WorkItemLinks` (optional child)

| Field | Type | Example (Demo) | Description | Source / Derivation | Used by |
|---|---|---:|---|---|---|
| `LinkKey` | INT | 800010 | Link unique key (PK) | Synthetic | Drill-through |
| `WorkItemKey` | INT | 100012 | FK back to work item | Relationship key | Drill-through filtering |
| `LinkClass` | TEXT | "LinkType 1" | Link type | Synthetic | Optional |
| `LinkTitle` | TEXT | "Doc A" | Link display title | Synthetic | Optional |
| `LinkUrl` | TEXT | "https://example.com/..." | Demo URL only | Synthetic (never internal) | Optional |

---

## 4) Table: `d_Calendar` (date dimension)

| Field | Type | Example | Description | Derivation |
|---|---|---:|---|---|
| `Date` | DATE | 2026-01-10 | Date key | `CALENDAR()` |
| `Year` | INT | 2026 | Year | `YEAR([Date])` |
| `Month` | TEXT | "2026-01" | Year-month | `FORMAT([Date], "YYYY-MM")` |
| `MonthName` | TEXT | "Jan" | Month label | `FORMAT([Date], "MMM")` |
| `Quarter` | TEXT | "Q1" | Quarter label | `"Q"&FORMAT([Date],"Q")` |
| `WeekOfYear` | INT | 2 | Week number | `WEEKNUM([Date],2)` |

---

## 5) KPI → field dependency map (quick reference)

| KPI | Depends on fields |
|---|---|
| `KPI_WorkItemCount` | `WorkItemKey` |
| `KPI_ActiveCount` | `WorkItemKey`, `Stage`, `SLAFlag` |
| `KPI_DoneCount` | `WorkItemKey`, `Stage` |
| `KPI_PastDueCount` | `WorkItemKey`, `SLAFlag` |
| `KPI_SLA_OK_Rate` | `WorkItemKey`, `SLAFlag` |
| `KPI_PastDueRate` | `WorkItemKey`, `SLAFlag` |
| `KPI_AvgAgeActiveDays` | `Stage`, `SLAFlag`, `IntakeDate` |
| `KPI_AvgCycleDays` | `Stage`, `PlanStart`, `DoneDate` |
| `KPI_WorkItemCount_MTD/YTD` | `d_Calendar[Date]` + active relationship |

---

## 6) Notes on public-safety
- All examples are synthetic.
- Any text fields (`WorkItemSummary`, `UpdateLog`, `NoteSummary`) should remain generic and non-identifying.
- Do not include internal URLs, IDs, or organization-specific terminology.
