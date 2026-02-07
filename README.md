# Work Item Tracker Analytics (Fabric + Power BI) — Demo / Redacted

An end-to-end operational analytics pipeline:
**SharePoint Online Lists (parent/child) → Fabric Dataflow Gen2 → Lakehouse → Semantic Model → Power BI Report (drill-through)**

This repository is a **public demo**. It contains **no production data** and uses **pseudonymous naming** (e.g., `WorkItemKey`, `Lead`, `Workstream`) and **redacted visuals**.

## Why it matters
- Shows how to model parent/child SharePoint lists for analytics
- Demonstrates Fabric ingestion + Lakehouse modeling + semantic layer governance
- Highlights reporting UX patterns (KPI cards, trends, drill-through)

## Tech Stack
- Source: SharePoint Online Lists (parent/child lookup)
- ETL: Fabric Dataflow Gen2 (Power Query M)
- Storage: Fabric Lakehouse
- Modeling: Star schema + `d_Calendar`
- Semantic layer: DAX measures (KPI-focused)
- Reporting: Power BI (main + drill-through)

## Repo Map
- `docs/architecture.md` – pipeline overview & lineage (v2)
- `docs/model.md` – semantic model structure (grain, relationships, KPI naming)
- `docs/data-dictionary.md` – demo schema + naming dictionary
- `docs/kpi-spec.md` – KPI definitions (demo names)
- `docs/refresh-and-ops.md` – refresh cadence & assumptions
- `docs/security-and-privacy.md` – redaction rules / what is excluded
- `powerquery/` – redacted demo M patterns
- `dax/measures_demo.md` – demo DAX measures (KPI_*) aligned with the KPI spec
- `dax/` – demo measures (public-safe names)
- `sample-data/` – synthetic CSVs
- `screenshots/` – redacted visuals

## Security & Privacy (Public-safe)
- No tenant URLs, list GUIDs, user names/emails, or record-level descriptions are included.
- Visuals are redacted to remove identifiers and operational details.
- Naming is intentionally different from any internal/production system.
