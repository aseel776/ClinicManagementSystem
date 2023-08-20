import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/medicine_model.dart';
import '../Pages/medicine_page.dart';
import 'medicineTable.dart';

class DataSource extends DataTableSource {
  DataSource({required this.context, required this.ref, required this.rows});
  final BuildContext context;
  final WidgetRef ref;
  late List<Medicine> rows;

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= rows.length) return null;
    final row = rows[index];
    return DataRow.byIndex(
      // onLongPress: () => print("aaa"),
      index: index,
      // onSelectChanged: (value) => print("asdas"),
      cells: [
        DataCell(Text(row.name!),
            onTap: () => animatedContainer(context, ref, index, false)),
        DataCell(Text(row.concentration.toString())),
        DataCell(Text(row.concentration.toString())),
        DataCell(Text(row.id.toString())),
      ],
    );
  }

  @override
  int get rowCount => rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
