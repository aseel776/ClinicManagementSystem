import 'lab_order.dart';

class LabOrderTable {
  List<LabOrder> labOrders;
  int? totalPages;

  LabOrderTable({required this.labOrders, this.totalPages});

  factory LabOrderTable.fromJson(Map<String, dynamic> json) {
    return LabOrderTable(
      labOrders: (json['items'] as List<dynamic>)
          .map((itemJson) => LabOrder.fromJson(itemJson))
          .toList(),
      totalPages: json['totalPages'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': labOrders.map((labOrder) => labOrder.toJson()).toList(),
      'totalPages': totalPages,
    };
  }
}
