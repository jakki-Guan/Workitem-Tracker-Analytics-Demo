let
    // Demo source: local/synthetic CSV (public-safe)
    Source = Csv.Document(
        File.Contents("sample-data/f_WorkItems_demo.csv"),
        [Delimiter=",", Columns=18, Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),

    // Type normalization (demo)
    ChangedTypes = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"WorkItemKey", Int64.Type},
            {"Workstream", type text},
            {"Stage", type text},
            {"UrgencyBand", type text},
            {"LeadAlias", type text},
            {"ContributorAliases", type text},
            {"IntakeContactAlias", type text},
            {"IntakeDate", type date},
            {"PlanStart", type date},
            {"PlanEnd", type date},
            {"DoneDate", type date},
            {"SLAFlag", type text},
            {"NoteCount", Int64.Type}
        }
    ),

    // Derived demo fields (optional)
    Add_IsDone = Table.AddColumn(
        ChangedTypes,
        "IsDoneFlag",
        each if [Stage] = "Stage C" then 1 else 0,
        Int64.Type
    ),

    Sorted = Table.Sort(Add_IsDone, {{"WorkItemKey", Order.Ascending}})
in
    Sorted
