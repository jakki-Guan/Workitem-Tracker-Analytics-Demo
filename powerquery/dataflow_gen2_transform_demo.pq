let
    /*******************************
      DEMO / PUBLIC-SAFE POWER QUERY M
      Reads synthetic CSVs from GitHub and produces analytics-ready tables.

      Required repo files:
      - sample-data/f_WorkItems_demo.csv
      - sample-data/x_WorkItemNotes_demo.csv

      Replace <RAW_BASE_URL> with your GitHub raw base URL, e.g.
      https://raw.githubusercontent.com/<user>/<repo>/<branch>
    ********************************/

    // ====== 0) Parameters ======
    RAW_BASE_URL = "https://raw.githubusercontent.com/jakki-Guan/Workitem-Tracker-Analytics-Demo/main",

    WorkItemsUrl = RAW_BASE_URL & "/sample-data/f_WorkItems_demo.csv",
    NotesUrl     = RAW_BASE_URL & "/sample-data/x_WorkItemNotes_demo.csv",

    // ====== 1) Helpers ======
    ReadCsvFromWeb = (url as text) as table =>
        let
            Source = Csv.Document(
                Web.Contents(url),
                [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
            ),
            Promote = Table.PromoteHeaders(Source, [PromoteAllScalars=true])
        in
            Promote,

    // Optional: Local file read (comment out Web lines and use File.Contents)
    // ReadCsvFromFile = (path as text) as table =>
    //     let
    //         Source = Csv.Document(File.Contents(path), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    //         Promote = Table.PromoteHeaders(Source, [PromoteAllScalars=true])
    //     in
    //         Promote,

    // Normalizes text values (trim, handle blanks)
    CleanText = (t as any) as nullable text =>
        let
            x = try Text.Trim(Text.From(t)) otherwise null
        in
            if x = "" then null else x,

    // Parse date safely (returns null if invalid)
    ToDate = (d as any) as nullable date =>
        let
            x = try Date.From(d) otherwise null
        in
            x,

    // ====== 2) Load synthetic tables ======
    f_WorkItems_raw = ReadCsvFromWeb(WorkItemsUrl),
    x_Notes_raw     = ReadCsvFromWeb(NotesUrl),

    // ====== 3) Type casting (WorkItems) ======
    f_WorkItems_types =
        Table.TransformColumnTypes(
            f_WorkItems_raw,
            {
                {"WorkItemKey", Int64.Type},
                {"Workstream", type text},
                {"Stage", type text},
                {"UrgencyBand", type text},
                {"Lead", type text},
                {"Contributors", type text},
                {"IntakeDate", type date},
                {"PlanStart", type date},
                {"PlanEnd", type date},
                {"DoneDate", type date},
                {"SLAFlag", type text},
                {"LastUpdate", type date}
            },
            "en-US"
        ),

    // ====== 4) Clean & normalize enums (WorkItems) ======
    f_WorkItems_clean1 =
        Table.TransformColumns(
            f_WorkItems_types,
            {
                {"Workstream", each CleanText(_), type text},
                {"Stage", each CleanText(_), type text},
                {"UrgencyBand", each CleanText(_), type text},
                {"Lead", each CleanText(_), type text},
                {"Contributors", each CleanText(_), type text},
                {"SLAFlag", each CleanText(_), type text}
            }
        ),

    // Ensure Workstream has the format "Workstream N"
    f_WorkItems_workstream =
        Table.TransformColumns(
            f_WorkItems_clean1,
            {
                {"Workstream", each if _ = null then "Workstream 0" else _, type text}
            }
        ),

    // Ensure Stage is one of Stage A/B/C/D, else Stage D
    AllowedStages = {"Stage A","Stage B","Stage C","Stage D"},
    f_WorkItems_stage =
        Table.TransformColumns(
            f_WorkItems_workstream,
            {
                {"Stage", each if _ = null or not List.Contains(AllowedStages, _) then "Stage D" else _, type text}
            }
        ),

    // Ensure UrgencyBand is "Urgency 0/1/2/3"
    AllowedUrgency = {"Urgency 0","Urgency 1","Urgency 2","Urgency 3"},
    f_WorkItems_urgency =
        Table.TransformColumns(
            f_WorkItems_stage,
            {
                {"UrgencyBand", each if _ = null or not List.Contains(AllowedUrgency, _) then "Urgency 0" else _, type text}
            }
        ),

    // Ensure Lead is set
    f_WorkItems_lead =
        Table.TransformColumns(
            f_WorkItems_urgency,
            {
                {"Lead", each if _ = null then "Lead X" else _, type text}
            }
        ),

    // ====== 5) Derive SLAFlag (public demo rule) ======
    // Rule (demo):
    // - If Stage = Stage D => VOID
    // - If PlanEnd is null => NA
    // - If Stage = Stage C and DoneDate is null => NA
    // - If DoneDate exists and DoneDate > PlanEnd => PAST_DUE
    // - Else if Stage in A/B and PlanEnd < today => PAST_DUE
    // - Else => SLA_OK
    Today = Date.From(DateTime.LocalNow()),

    f_WorkItems_sla =
        Table.AddColumn(
            f_WorkItems_lead,
            "SLAFlag_Derived",
            each
                let
                    st  = [Stage],
                    pe  = [PlanEnd],
                    dd  = [DoneDate]
                in
                    if st = "Stage D" then "VOID"
                    else if pe = null then "NA"
                    else if st = "Stage C" and dd = null then "NA"
                    else if dd <> null and dd > pe then "PAST_DUE"
                    else if (st = "Stage A" or st = "Stage B") and pe < Today then "PAST_DUE"
                    else "SLA_OK",
            type text
        ),

    // Prefer derived SLAFlag for consistency; keep original as SLAFlag_Source
    f_WorkItems_sla_final =
        Table.RenameColumns(
            Table.TransformColumnTypes(
                Table.AddColumn(f_WorkItems_sla, "SLAFlag_Source", each [SLAFlag], type text),
                {{"SLAFlag_Source", type text}}
            ),
            {{"SLAFlag", "SLAFlag_Source_Old"}}
        ),

    f_WorkItems_sla_select =
