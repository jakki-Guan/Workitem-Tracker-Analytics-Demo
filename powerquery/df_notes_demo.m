let
    Source = Csv.Document(
        File.Contents("sample-data/x_WorkItemNotes_demo.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"NoteKey", Int64.Type},
            {"WorkItemKey", Int64.Type},
            {"NoteDate", type date},
            {"NoteClass", type text},
            {"NoteSummary", type text}
        }
    ),
    Sorted = Table.Sort(ChangedTypes, {{"WorkItemKey", Order.Ascending}, {"NoteDate", Order.Ascending}})
in
    Sorted
