# Work Item Tracker Analytics (Fabric + Power BI) — Demo / Redacted

End-to-end operational analytics pipeline:
**SharePoint (parent/child lists) → Fabric Dataflow Gen2 → Lakehouse → Semantic Model → Power BI Report (drill-through)**

This repository is a **public demo**:
- Uses **synthetic data** in `sample-data/`
- Uses **pseudonymous naming** (e.g., `WorkItemKey`, `LeadAlias`, `Workstream`, `Stage`)
- Includes **redacted visuals** (no tenant URLs, no real names, no internal identifiers)

---

## What this demonstrates
- Modeling **parent/child list data** for analytics (work items + notes/links)
- Building an **ETL pipeline** in Fabric Dataflow Gen2 (Power Query M)
- Publishing an analytics-ready table in a **Lakehouse**, then creating a **semantic model**
- Designing a **Power BI report** with KPI cards, trends, and drill-through patterns

---

## Architecture (Demo)
### Fabric lineage (v2)
![Fabric Lineage v2 (Demo)](screenshots/fabric/lineage_v2_demo.png)

**Flow summary**
1) Two SharePoint sources (parent + child)
2) Two Dataflow Gen2 pipelines standardize and enrich data
3) Lakehouse stores curated tables
4) Semantic model provides KPI measures and time intelligence
5) Power BI report supports slice/filter + drill-through detail

> Implementation details: [`docs/architecture.md`](docs/architecture.md)

---

## Data Model (Demo)
**Grain:** `f_WorkItems` is at the **work item grain** (1 row per `WorkItemKey`).  
Child tables store detail at **many-to-one** (notes/links).

- Full schema: [`docs/schema.md`](docs/schema.md)

```mermaid
erDiagram
  F_WORKITEMS ||--o{ X_WORKITEMNOTES : has
  F_WORKITEMS ||--o{ X_WORKITEMLINKS : has

  F_WORKITEMS {
    INT WorkItemKey PK
    TEXT WorkItemLabel
    TEXT Workstream
    TEXT Stage
    TEXT UrgencyBand
    DATE IntakeDate
    DATE PlanEnd
    DATE DoneDate
    TEXT SLAFlag
  }

  X_WORKITEMNOTES {
    INT NoteKey PK
    INT WorkItemKey FK
    DATE NoteDate
    TEXT NoteClass
    TEXT NoteSummary
  }

  X_WORKITEMLINKS {
    INT LinkKey PK
    INT WorkItemKey FK
    TEXT LinkClass
    TEXT LinkTitle
    TEXT LinkUrl
  }
