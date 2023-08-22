class Lab {
  final int? id;
  final String address;
  final String email;
  final String name;
  final String phone;

  Lab({
    this.id,
    required this.address,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      id: json['id'],
      address: json['address'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }
}
