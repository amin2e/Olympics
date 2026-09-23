[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Regions_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}, PreviewOnlySteps = {"Data preview sampling"}]
shared Regions = let
  Source = SharePoint.Files("https://bbctest06.sharepoint.com/sites/Fabric_test", [ApiVersion = 15]),
  #"Filtered hidden files" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
  // This step reduces the set of files in use to improve the data preview performance. It will be removed at refresh to use all files.
  #"Data preview sampling" = Table.FirstN(#"Filtered hidden files", 10),
  #"Invoke custom function" = Table.AddColumn(#"Data preview sampling", "Transform file", each #"Transform file"([Content])),
  #"Renamed columns" = Table.RenameColumns(#"Invoke custom function", {{"Name", "Source.Name"}}),
  #"Removed other columns" = Table.SelectColumns(#"Renamed columns", {"Source.Name", "Transform file"}),
  Navigation = #"Removed other columns"{0}[Transform file],
  #"Changed column type" = Table.TransformColumnTypes(Navigation, {{"NOC", type text}, {"region", type text}, {"notes", type text}, {"", type text}, {"_1", type text}, {"_2", type text}, {"_3", type text}, {"_4", type text}, {"_5", type text}}),
  #"Removed columns" = Table.RemoveColumns(#"Changed column type", {"", "_1", "_2", "_3", "_4", "_5"})
in
  #"Removed columns";
shared #"Sample file" = let
  Source = SharePoint.Files("https://bbctest06.sharepoint.com/sites/Fabric_test", [ApiVersion = 15]),
  #"Filtered hidden files" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
  Navigation = #"Filtered hidden files"{[Name = "winter.csv", #"Folder Path" = "https://bbctest06.sharepoint.com/sites/Fabric_test/Documents partages/"]}[Content]
in
  Navigation;
shared Parameter = let
  Parameter = #"Sample file" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type binary, BinaryIdentifier = #"Sample file"]
in
  Parameter;
shared #"Transform Sample file" = let
  Source = Csv.Document(Parameter, [Delimiter = ",", Columns = 9, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true])
in
  #"Promoted headers";
[FunctionQueryBinding = "{""exemplarFormulaName"":""Transform Sample file""}"]
shared #"Transform file" = (Parameter as binary) => let
  Source = Csv.Document(Parameter, [Delimiter = ",", Columns = 9, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true])
in
  #"Promoted headers";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Sigles_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Sigles = let
  Source = SharePoint.Files("https://bbctest06.sharepoint.com/sites/Fabric_test", [ApiVersion = 15]),
  #"Filtered hidden files" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
  // This step reduces the set of files in use to improve the data preview performance. It will be removed at refresh to use all files.
  #"Data preview sampling" = Table.FirstN(#"Filtered hidden files", 10),
  #"Invoke custom function" = Table.AddColumn(#"Data preview sampling", "Transform file", each #"Transform file"([Content])),
  #"Renamed columns" = Table.RenameColumns(#"Invoke custom function", {{"Name", "Source.Name"}}),
  #"Removed other columns" = Table.SelectColumns(#"Renamed columns", {"Source.Name", "Transform file"}),
  Navigation = #"Removed other columns"{2}[Transform file],
  #"Changed column type" = Table.TransformColumnTypes(Navigation, {{"Country", type text}, {"Code", type text}, {"Population", Int64.Type}, {"GDP per Capita", type number}, {"", type text}, {"_1", type text}, {"_2", type text}, {"_3", type text}, {"_4", type text}}),
  #"Removed columns" = Table.RemoveColumns(#"Changed column type", {"", "_1", "_2", "_3", "_4"})
in
  #"Removed columns";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Winter_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Winter = let
  Source = SharePoint.Files("https://bbctest06.sharepoint.com/sites/Fabric_test", [ApiVersion = 15]),
  #"Filtered hidden files" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
  // This step reduces the set of files in use to improve the data preview performance. It will be removed at refresh to use all files.
  #"Data preview sampling" = Table.FirstN(#"Filtered hidden files", 10),
  #"Invoke custom function" = Table.AddColumn(#"Data preview sampling", "Transform file", each #"Transform file"([Content])),
  #"Renamed columns" = Table.RenameColumns(#"Invoke custom function", {{"Name", "Source.Name"}}),
  #"Removed other columns" = Table.SelectColumns(#"Renamed columns", {"Source.Name", "Transform file"}),
  #"Drill down" = #"Removed other columns"{1}[Transform file]
in
  #"Drill down";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Summer_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Summer = let
  Source = SharePoint.Files("https://bbctest06.sharepoint.com/sites/Fabric_test", [ApiVersion = 15]),
  #"Filtered hidden files" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
  // This step reduces the set of files in use to improve the data preview performance. It will be removed at refresh to use all files.
  #"Data preview sampling" = Table.FirstN(#"Filtered hidden files", 10),
  #"Invoke custom function" = Table.AddColumn(#"Data preview sampling", "Transform file", each #"Transform file"([Content])),
  #"Renamed columns" = Table.RenameColumns(#"Invoke custom function", {{"Name", "Source.Name"}}),
  #"Removed other columns" = Table.SelectColumns(#"Renamed columns", {"Source.Name", "Transform file"}),
  #"Drill down" = #"Removed other columns"{3}[Transform file]
in
  #"Drill down";
shared Summer_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "0b0bc357-e202-43a2-8243-15fb409df21b"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "8a45325c-63c4-4f17-a768-fef3b7b37d1c"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Summer", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared Winter_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "0b0bc357-e202-43a2-8243-15fb409df21b"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "8a45325c-63c4-4f17-a768-fef3b7b37d1c"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Winter", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared Sigles_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "0b0bc357-e202-43a2-8243-15fb409df21b"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "8a45325c-63c4-4f17-a768-fef3b7b37d1c"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Sigles", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared Regions_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "0b0bc357-e202-43a2-8243-15fb409df21b"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "8a45325c-63c4-4f17-a768-fef3b7b37d1c"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "Regions", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
