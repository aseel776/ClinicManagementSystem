import 'lab_model.dart';

class LabTable {
  List<Lab> labs;
  int? totalPages;

  LabTable({required this.labs, this.totalPages});

  factory LabTable.fromJson(Map<String, dynamic> json) {
    final List<dynamic> labData = json['labs'];
    final List<Lab> labs = labData.map((data) => Lab.fromJson(data)).toList();

    return LabTable(
      labs: labs,
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labs': labs.map((lab) => lab.toJson()).toList(),
      'totalPages': totalPages,
    };
  }
}
