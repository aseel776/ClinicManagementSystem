import 'package:flutter/material.dart';

import '../../data/model/medicine_model.dart';

class MedicineTableScreen extends StatelessWidget {
  final List<Medicine> medicines;

  MedicineTableScreen({required this.medicines});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: medicines.length + 1, // +1 for the header row
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header row
          return Table(
            border: TableBorder.all(),
            children: const [
              TableRow(
                children: [
                  TableCell(
                      child: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  TableCell(
                      child: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  TableCell(
                      child: Text('concentration',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          );
        } else {
          // Data rows
          final rowData = medicines[index - 1];
          return Table(
            border: TableBorder.symmetric(),
            children: [
              TableRow(
                children: [
                  TableCell(child: Text(rowData.name.toString())),
                  TableCell(child: Text(rowData.name!)),
                  TableCell(child: Text(rowData.concentration.toString())),
                ],
              ),
            ],
          );
        }
      },
    ));
  }
}
