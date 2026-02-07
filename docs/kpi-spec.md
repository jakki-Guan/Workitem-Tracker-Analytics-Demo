# KPI Spec (Demo / Redacted)

This document defines the **demo KPI layer** for the Work Item Tracker Analytics project.
All terms are pseudonymous and do not match any internal production system.

---

## 1) Shared definitions

### 1.1 Grain
- **Work item grain:** one row per `WorkItemKey` in `f_WorkItems`

### 1.2 Core enums (demo)
- `Stage`: `Stage A / Stage B / Stage C / Stage D`
  - Stage A/B = open or in-progress (active backlog)
  - Stage C = completed (done)
  - Stage D = void / excluded (cancelled or out of scope)
- `UrgencyBand`: `Urgency 0 / 1 / 2 / 3`
- `SLAFlag`: `SLA_OK / PAST_DUE / NA / VOID`

### 1.3 SLA eligibility rule (demo)
A work item is **SLA-eligible** if:
- `SLAFlag` is NOT in `{ NA, VOID }`

### 1.4 Date role assumptions
- Default date axis uses `d_Calendar[Date]`
- Recommended active relationship: `d_Calendar[Date]` → `f_WorkItems[IntakeDate]`
  - (Alternative: use `PlanEnd` as active if the report is due-date focused)

---

## 2) KPI groups

## Group A — Volume (work item counts)

### KPI_A1: Total Work Items
**Purpose:** overall workload size in the selected filter context  
**Definition:** distinct count of work items  
**Grain:** work item  
**Formula:** `DISTINCTCOUNT(f_WorkItems[WorkItemKey])`  
**Filters:** respects slicers (Workstream/Stage/Urgency/Lead)  
**Notes:** includes all stages unless excluded by slicers

---

### KPI_A2: Active Work Items
**Purpose:** current backlog / in-flight work  
**Definition:** items in active stages  
**Grain:** work item  
**Filter logic:** `Stage in {Stage A, Stage B}` AND `SLAFlag <> VOID`  
**Formula (pseudo):** `COUNTD(WorkItemKey where Stage A/B and not VOID)`  
**Notes:** Stage D is excluded by design

---

### KPI_A3: Done Work Items
**Purpose:** completed throughput  
**Definition:** items completed  
**Grain:** work item  
**Filter logic:** `Stage = Stage C`  
**Notes:** if `DoneDate` is blank, the item is treated as not done (demo convention)

---

### KPI_A4: Past Due Work Items
**Purpose:** exception tracking  
**Definition:** items currently past due based on SLAFlag  
**Grain:** work item  
**Filter logic:** `SLAFlag = PAST_DUE`  
**Notes:** depends on the upstream derivation rule for `SLAFlag`

---

## Group B — SLA / Compliance

### KPI_B1: SLA Eligible Work Items
**Purpose:** denominator for SLA rates  
**Definition:** items where SLA is applicable  
**Filter logic:** `SLAFlag NOT IN {NA, VOID}`  
**Formula (pseudo):** `COUNTD(WorkItemKey where SLAFlag not NA/VOID)`

---

### KPI_B2: SLA OK Work Items
**Purpose:** SLA met (count)  
**Definition:** items meeting SLA  
**Filter logic:** `SLAFlag = SLA_OK`  
**Notes:** includes open items considered on track (demo)

---

### KPI_B3: SLA OK Rate
**Purpose:** SLA compliance ratio  
**Definition:** share of eligible items that are SLA_OK  
**Formula:** `SLA_OK_Count / SLA_Eligible_Count`  
**Notes:** use `DIVIDE()` to avoid divide-by-zero

---

### KPI_B4: Past Due Rate
**Purpose:** risk indicator  
**Definition:** share of eligible items that are past due  
**Formula:** `PastDue_Count / SLA_Eligible_Count`  
**Notes:** If your definition of eligibility differs, update Group B consistently

---

## Group C — Time / Flow (demo-level)

### KPI_C1: Average Age of Active Items (days)
**Purpose:** backlog aging  
**Definition:** average days since intake for active items  
**Filter logic:** `Stage in {Stage A, Stage B}` AND `IntakeDate not blank`  
**Formula (pseudo):** `AVG( Today - IntakeDate ) over active items`  
**Notes:** if `IntakeDate` is missing, exclude from average

---

### KPI_C2: Average Cycle Time (days)
**Purpose:** delivery speed  
**Definition:** average days from PlanStart to DoneDate for completed items  
**Filter logic:** `Stage = Stage C` AND `PlanStart and DoneDate not blank`  
**Formula (pseudo):** `AVG( DoneDate - PlanStart )`  
**Notes:** demo only; production may use different start/end events

---

### KPI_C3: Median Cycle Time (days) (optional)
**Purpose:** robust cycle time (less sensitive to outliers)  
**Definition:** median of cycle days for completed items  
**Notes:** implement with `PERCENTILEX.INC` in DAX if needed

---

## Group D — Notes / Engagement (optional)

### KPI_D1: Items with Notes
**Purpose:** activity coverage  
**Definition:** count of items with at least one note  
**Inputs:** requires `NoteCount` on `f_WorkItems` OR a relationship to `x_WorkItemNotes`  
**Formula (pseudo):** `COUNTD(WorkItemKey where NoteCount > 0)`

---

### KPI_D2: Avg Notes per Item
**Purpose:** intensity of updates  
**Definition:** average notes per work item  
**Formula:** `SUM(NoteCount) / DISTINCTCOUNT(WorkItemKey)`  
**Notes:** In production, consider excluding system-generated notes

---

## 3) Implementation references
- Demo measures: `dax/measures_demo.md`
- Demo schema: `docs/schema.md`
- Semantic model notes: `docs/model.md`
