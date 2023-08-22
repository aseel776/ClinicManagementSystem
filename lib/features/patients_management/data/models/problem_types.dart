class ProblemTypes {
  int? id;
  String? name;

  ProblemTypes({required this.id, required this.name});

  factory ProblemTypes.fromJson(Map<String, dynamic> json) {
    return ProblemTypes(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
