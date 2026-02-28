class UserModel {
  final int id;
  final String name;
  final String email;
  final String? clientImg;
  final int companyId;
  final String company;
  final String? companyImg;
  final String token;
  final String refreshToken;
  final String status;
  final String? status_description;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.clientImg,
    required this.companyId,
    required this.company,
    this.companyImg,
    required this.token,
    required this.refreshToken,
    required this.status,
    this.status_description,
  });

  UserModel copyWith({
    String? token,
    String? refreshToken,
    String? status,
    String? status_description,
  }) {
    return UserModel(
      id: this.id,
      name: this.name,
      email: this.email,
      companyId: this.companyId,
      company: this.company,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      status: status ?? this.status,
      status_description: status_description ?? this.status_description,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? null,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      clientImg: json['clientImg'] ?? '',
      companyId: json['companyId'] ?? null,
      company: json['company'] ?? '',
      companyImg: json['companyImg'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      status: json['status'] ?? '',
      status_description: json['status_description'] ?? '',
    );
  }
}
