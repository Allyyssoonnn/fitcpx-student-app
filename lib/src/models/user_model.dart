class UserModel {
  final int id;
  final String name;
  final String? clientImg;
  final int companyId;
  final String company;
  final String? companyImg;
  final String token;
  final String refreshToken;

  UserModel({
    required this.id,
    required this.name,
    this.clientImg,
    required this.companyId,
    required this.company,
    this.companyImg,
    required this.token,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? null,
      name: json['name'] ?? '',
      clientImg: json['clientImg'] ?? '',
      companyId: json['companyId'] ?? null,
      company: json['company'] ?? '',
      companyImg: json['companyImg'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}
