# Security & Privacy (Demo / Redacted)

This repository is a **public portfolio demo**. It contains **no production data** and is designed to be safe to share publicly.

---

## 1) What is included
- **Synthetic CSV data** only (`sample-data/`)
- **Pseudonymous naming** (e.g., `WorkItemKey`, `LeadAlias`, `Workstream`, `Stage`)
- **Public-safe documentation** (schema, KPI definitions, quickstart)
- **Redacted visuals** (lineage / diagrams) without identifiable environment details

---

## 2) What is explicitly excluded
The following are **not** included anywhere in this repo:
- Tenant URLs, site URLs, SharePoint paths, or workspace names
- List GUIDs, dataset/report IDs, environment identifiers
- Real user names, emails, or person identifiers
- Record-level descriptions, operational notes, or sensitive task content
- Production KPI values, counts, or performance metrics derived from a real system
- Any internal policy text, ticket references, or organization-specific labels

---

## 3) Redaction rules used in visuals
All screenshots/visual evidence follow these rules:
- Remove or mask **any URL**, tenant reference, or site/workspace identifier
- Replace all object names with demo-safe names:
  - `SharePoint_Parent_Demo`, `SharePoint_Child_Demo`
  - `df_WorkItems_v2`, `df_WorkItemNotes_v2`
  - `lh_WorkItemAnalytics_Demo`
  - `sm_WorkItemModel_v2`
  - `rpt_WorkItemTracker_v2`
- Remove timestamps such as **Refreshed at ...**
- Remove viewer/view counts if they could imply operational usage (optional)
- Remove branding (logos, organization names)

---

## 4) Data anonymization & naming conventions
### Demo naming
- Primary key: `WorkItemKey`
- People fields: `Lead`, `Contributor`
- Work categories: `Workstream 1..N`
- Stages: `Stage A/B/C/D`
- Priority: `Urgency 0/1/2/Not Tracked`

### Synthetic values only
- Any values under `sample-data/` are generated for demonstration and may not reflect real distributions.

---

## 5) Safe reuse guidance
If you fork or reuse this template for your own portfolio:
- Use only synthetic data
- Keep pseudonymous naming
- Do not include real URLs, IDs, names, or record-level descriptions
- Treat any screenshot from internal systems as sensitive until fully redacted

---

## 6) Disclaimer
This project is shared for **educational/portfolio purposes only** and does not represent any real organization's systems, data, or operations.
