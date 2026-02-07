# Data Schema (Demo / Redacted)

This project uses a **parent/child** work item design originally sourced from a list-based system.
All names below are **pseudonymous** and do not match any production environment.

## 1) Parent table: `f_WorkItems` (work item grain)

**Primary key**
- `WorkItemKey` (INT) — unique identifier for each work item

**Core attributes**
- `WorkItemLabel` (TEXT) — short label/title
- `WorkItemSummary` (TEXT) — brief description
- `Workstream` (TEXT) — e.g., `Workstream 1..N`
- `Stage` (TEXT) — e.g., `Stage A / B / C / D`
- `UrgencyBand` (TEXT) — e.g., `Urgency 0 / 1 / 2 / 3`

**People (aliases only)**
- `LeadAlias` (TEXT)
- `ContributorAliases` (TEXT; delimited)
- `IntakeContactAlias` (TEXT)

**Dates**
- `IntakeDate` (DATE)
- `PlanStart` (DATE)
- `PlanEnd` (DATE)
- `DoneDate` (DATE)

**Derived / reporting fields**
- `SLAFlag` (TEXT) — `SLA_OK / PAST_DUE / NA / VOID`
- `LastUpdate` (DATE)
- `NextActions` (TEXT)
- `UpdateLog` (TEXT)

## 2) Child table: `x_WorkItemNotes` (many-to-one)

- One work item can have **0..N notes**
- Used for drill-through detail and activity auditing (demo-safe)

**Keys**
- `NoteKey` (INT) — note unique key
- `WorkItemKey` (INT) — foreign key to `f_WorkItems`

**Fields**
- `NoteDate` (DATE)
- `NoteClass` (TEXT) — e.g., `NoteType 0..N`
- `NoteSummary` (TEXT)

## 3) Child table: `x_WorkItemLinks` (optional)

- One work item can have **0..N links/attachments**
- Stored as URLs/titles in the demo (no real internal links)

**Keys**
- `LinkKey` (INT)
- `WorkItemKey` (INT) — foreign key

**Fields**
- `LinkClass` (TEXT)
- `LinkTitle` (TEXT)
- `LinkUrl` (TEXT)

## 4) Relationship summary

- `f_WorkItems[WorkItemKey]` (1) → `x_WorkItemNotes[WorkItemKey]` (*)
- `f_WorkItems[WorkItemKey]` (1) → `x_WorkItemLinks[WorkItemKey]` (*)

## 5) Privacy statement
- No tenant URLs, real user names/emails, or internal identifiers are included.
- Any values in `sample-data/` are synthetic and used for demonstration only.
