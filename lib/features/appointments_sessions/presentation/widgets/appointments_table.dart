import 'package:flutter/material.dart';

class AppointmentsTable extends StatelessWidget {
  final double tableWidth;
  final double tableHeight;
  const AppointmentsTable({
    super.key,
    required this.tableWidth,
    required this.tableHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tableWidth,
      color: Colors.red,
    );
  }
}