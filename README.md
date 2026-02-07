# Work Item Tracker Analytics (Demo / Redacted)

End-to-end operational analytics pipeline built with **SharePoint Online Lists → Microsoft Fabric → Power BI**.
This repository contains **no production data** and uses **redacted screenshots + demo naming**.

## What this is
A demo-style portfolio project that showcases:
- Parent/child list modeling (lookup key relationships)
- Fabric ingestion with Dataflow Gen2 (Power Query M)
- Lakehouse + star-schema modeling + Calendar dimension
- Semantic model measures for KPI reporting
- Power BI report UX (main + drill-through)

## High-level Architecture
SharePoint Lists → Dataflow Gen2 → Lakehouse → Semantic Model → Power BI Report  
(See: `docs/architecture.md`)

## Contents
- `docs/architecture.md` – pipeline overview + lineage explanation  
- `docs/data-dictionary.md` – demo schema & naming dictionary  
- `docs/kpi-spec.md` – KPI definitions (demo names)  
- `docs/refresh-and-ops.md` – refresh cadence + assumptions  
- `docs/security-and-privacy.md` – redaction rules and what is excluded  
- `powerquery/` – demo Power Query M patterns (redacted)  
- `dax/` – demo measures (redacted names)  
- `sample-data/` – synthetic datasets (CSV)  
- `screenshots/` – redacted visuals (no identifiers, no record details)

## Security & Privacy
- No tenant URLs, list GUIDs, user names, emails, or task descriptions are included.
- All field/table/measure names use a **demo naming system** (e.g., `WorkItemKey`, `Workstream`, `Lead`).
- Any screenshots are redacted to remove identifiers and record-level details.

## Status
- [ ] Add architecture diagram
- [ ] Add demo naming dictionary + data dictionary
- [ ] Add KPI spec + sample DAX
- [ ] Add demo Power Query M + synthetic data
- [ ] Add redacted screenshots
