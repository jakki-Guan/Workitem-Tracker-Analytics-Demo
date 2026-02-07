# Demo DAX Measures (Public)

> Naming policy: all measures use `KPI_*` prefixes and demo terms only.

## Core counts

### KPI_WorkItemCount
```DAX
KPI_WorkItemCount =
DISTINCTCOUNT ( f_WorkItems[WorkItemKey] )
```

### KPI_DoneCount
```DAX
KPI_DoneCount =
CALCULATE (
    [KPI_WorkItemCount],
    f_WorkItems[Stage] = "Stage C"
)
```
### KPI_ActiveCount
```DAX
KPI_ActiveCount =
CALCULATE (
    [KPI_WorkItemCount],
    f_WorkItems[Stage] IN { "Stage A", "Stage B" },
    f_WorkItems[SLAFlag] <> "VOID"
)
```
### KPI_PastDueCount
```DAX
KPI_PastDueCount =
CALCULATE (
    [KPI_WorkItemCount],
    f_WorkItems[SLAFlag] = "PAST_DUE"
)
```


