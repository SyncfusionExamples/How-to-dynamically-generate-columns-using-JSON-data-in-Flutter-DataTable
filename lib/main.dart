import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const JsonDataGrid(),
    );
  }
}

class JsonDataGrid extends StatefulWidget {
  const JsonDataGrid({Key? key}) : super(key: key);

  @override
  JsonDataGridState createState() => JsonDataGridState();
}

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

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(dataGridCell.value.toString()));
    }).toList());
  }
}
