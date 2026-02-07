# Architecture (v2) — SharePoint → Fabric → Power BI

## Overview
This solution ingests operational tracking data from SharePoint Online Lists and delivers governed KPI reporting through Microsoft Fabric and Power BI.

## Data Sources (SharePoint)
- `f_WorkItems` (Parent/master list)
  - Key: `WorkItemKey` (SharePoint Item ID surrogate)
- `x_WorkItemNotes` (Child list)
  - Foreign key: `WorkItemKey` (lookup to parent)
- `x_WorkItemLinks` (Child list)
  - Foreign key: `WorkItemKey` (lookup to parent)

## Ingestion & Transform (Fabric Dataflow Gen2)
- Pulls SharePoint list items
- Standardizes column types (dates, text)
- Normalizes multi-person fields into a single text column (`Contributors`)
- Expands Person/Group fields into display labels (`Lead`)
- Derives `SLAFlag` using plan vs actual dates and today's date

## Storage (Lakehouse)
- Dataflow Gen2 writes curated tables into a shared Lakehouse (v2)
- Tables are modeled for analytics (fact + dimensions pattern)

## Semantic Layer (v2)
- A semantic model is built on the v2 Lakehouse tables
- Star schema with a dedicated `d_Calendar` date dimension
- KPI measures are defined with consistent naming (`KPI_*`)

## Reporting (Power BI Report v2)
- Main overview page (KPI cards + distributions + trend)
- Drill-through pages for deeper slices (record details excluded in the public demo)

## Refresh & Ops
- Designed for scheduled refresh during business hours (demo config described in `docs/refresh-and-ops.md`)

