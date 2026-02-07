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
    f_WorkItems[SLAFlag] = "PAST_DUE",
    f_WorkItems[SLAFlag] <> "VOID"
)
```

## SLA / quality


### KPI_SLA_OK_Count
```DAX
KPI_SLA_OK_Count =
CALCULATE (
    [KPI_WorkItemCount],
    f_WorkItems[SLAFlag] = "SLA_OK"
)
```

### KPI_SLA_EligibleCount
```DAX
KPI_SLA_EligibleCount =
CALCULATE (
    [KPI_WorkItemCount],
    NOT ( f_WorkItems[SLAFlag] IN { "NA", "VOID" } )
)
```

### KPI_SLA_OK_Rate
```DAX
KPI_SLA_OK_Rate =
DIVIDE ( [KPI_SLA_OK_Count], [KPI_SLA_EligibleCount] )
```

## Trend Helpers
> Trend measures assume the active relationship from d_Calendar[Date] to f_WorkItems[IntakeDate] (or update accordingly if PlanEnd is used).
### KPI_WorkItemCount_MTD
```DAX
KPI_WorkItemCount_MTD =
CALCULATE (
    [KPI_WorkItemCount],
    DATESMTD ( d_Calendar[Date] )
)
```

### KPI_WorkItemCount_YTD
```DAX
KPI_WorkItemCount_YTD =
CALCULATE (
    [KPI_WorkItemCount],
    DATESYTD ( d_Calendar[Date] )
)
```

## Notes-related

### KPI_ItemsWithNotes
```DAX
KPI_ItemsWithNotes =
CALCULATE (
    [KPI_WorkItemCount],
    f_WorkItems[NoteCount] > 0
)
```

### KPI_AvgNotesPerItem
```DAX
KPI_AvgNotesPerItem =
DIVIDE (
    SUM ( f_WorkItems[NoteCount] ),
    [KPI_WorkItemCount]
)
```

## Rates (demo)

### KPI_PastDueRate
```DAX
KPI_PastDueRate =
DIVIDE ( [KPI_PastDueCount], [KPI_SLA_EligibleCount] )
```

### KPI_DoneRate
```DAX
KPI_DoneRate =
DIVIDE ( [KPI_DoneCount], [KPI_WorkItemCount] )
```

## Time / Flow (demo)
### KPI_AvgAgeActiveDays
```DAX
KPI_AvgAgeActiveDays =
VAR TodayDate = TODAY()
RETURN
AVERAGEX (
    FILTER (
        f_WorkItems,
        f_WorkItems[Stage] IN { "Stage A", "Stage B" }
            && f_WorkItems[SLAFlag] <> "VOID"
            && NOT ISBLANK ( f_WorkItems[IntakeDate] )
    ),
    TodayDate - f_WorkItems[IntakeDate]
)
```

### KPI_AvgCycleDays
```DAX
KPI_AvgCycleDays =
AVERAGEX (
    FILTER (
        f_WorkItems,
        f_WorkItems[Stage] = "Stage C"
            && NOT ISBLANK ( f_WorkItems[PlanStart] )
            && NOT ISBLANK ( f_WorkItems[DoneDate] )
    ),
    f_WorkItems[DoneDate] - f_WorkItems[PlanStart]
)
```

### KPI_MedianCycleDays (optional)
```DAX
KPI_MedianCycleDays =
VAR T =
    FILTER (
        f_WorkItems,
        f_WorkItems[Stage] = "Stage C"
            && NOT ISBLANK ( f_WorkItems[PlanStart] )
            && NOT ISBLANK ( f_WorkItems[DoneDate] )
    )
RETURN
IF ( COUNTROWS ( T ) = 0, BLANK(),
    PERCENTILEX.INC ( T, f_WorkItems[DoneDate] - f_WorkItems[PlanStart], 0.5 )
)

```

