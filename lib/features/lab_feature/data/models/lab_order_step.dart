class LabOrderStep {
  int id;
  String name;

  LabOrderStep({
    required this.id,
    required this.name,
  });

  factory LabOrderStep.fromJson(Map<String, dynamic> json) {
    return LabOrderStep(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
