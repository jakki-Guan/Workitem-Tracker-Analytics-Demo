# Refresh & Ops (Demo)

## Refresh Cadence
- Scheduled refresh: every 15 minutes during business hours (demo description)

## Assumptions
- Data latency depends on SharePoint update timing + ingestion schedule
- Date fields are cast to Date type in ETL

## Data Quality Checks (Examples)
- WorkItemKey uniqueness at parent grain
- Null checks for PlanEnd / IntakeDate
- Stage and Workstream values mapped to demo enumerations

