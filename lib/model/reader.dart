class Reader {
  final int? id;
  final String fullName;
  final String? phone;
  final String? email;

  Reader({this.id, required this.fullName, this.phone, this.email});

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json['reader_id'] as int? ?? 0,
      fullName: json['full_name'] as String? ?? 'Неизвестный',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'reader_id': id,
        'full_name': fullName,
        'phone': phone,
        'email': email,
      };
}