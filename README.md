# How to dynamically generate columns using JSON data in a Flutter DataTable (SfDataGrid)?.

In this article, we will show you how to dynamically generate columns using JSON data in a [Flutter DataTable](https://www.syncfusion.com/flutter-widgets/flutter-datagrid).

Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the necessary properties. Retrieve the JSON data using the [http.get](https://pub.dev/documentation/http/latest/http/Client/get.html) method and decode it. Then, convert the JSON data into a list collection. Once the data is loaded, the first item from the JSON (productlist[0]) is used to generate the columns. Each key in this first item becomes a column header by iterating over the key-value pairs of the first JSON object. The [DataGridSource](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource-class.html) class maps the JSON data to the DataGrid rows. The columns are passed as an argument, and for each row, the values corresponding to those columns are extracted.

```dart
class JsonDataGridState extends State<JsonDataGrid> {

  late JsonDataGridSource jsonDataGridSource;
  List<dynamic> productlist = [];
  List<GridColumn> columns = [];

  Future generateProductList() async {
    var response = await rootBundle.loadString("assets/product.json");
    productlist = json.decode(response) as List<dynamic>;
    if (productlist.isNotEmpty) {
      // Generate columns dynamically from the first item in the list.
      columns = generateColumns(productlist[0]);
      jsonDataGridSource = JsonDataGridSource(productlist, columns);
    }
    return productlist;
  }

  List<GridColumn> generateColumns(Map<String, dynamic> data) {
    List<GridColumn> columns = [];

    for (var entry in data.entries) {
      GridColumn gridColumn = GridColumn(
        columnName: entry.key,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            entry.key,
          ),
        ),
      );

      columns.add(gridColumn);
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter DataGrid Sample'),
      ),
      body: FutureBuilder(
          future: generateProductList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.hasData
                ? SfDataGrid(
                    source: jsonDataGridSource,
                    columns: columns,
                    columnWidthMode: ColumnWidthMode.fill,
                  )
                : const Center(
                    child: CircularProgressIndicator(strokeWidth: 3),
                  );
          }),
    );
  }
}

class JsonDataGridSource extends DataGridSource {
….

  JsonDataGridSource(List<dynamic> productlist, List<GridColumn> columns) {
    dataGridRows = productlist
        .map<DataGridRow>((product) => DataGridRow(
                cells: columns.map<DataGridCell>((column) {
              return DataGridCell(
                  columnName: column.columnName,
                  value: product[column.columnName]);
            }).toList()))
        .toList();
  }
}
```

You can download this example on [GitHub](https://github.com/SyncfusionExamples/How-to-dynamically-generate-columns-using-JSON-data-in-Flutter-DataTable).