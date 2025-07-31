class UserModel {
  final int id;
  final String name;
  final String token;
  final String refreshToken;

  UserModel({
    required this.id,
    required this.name,
    required this.token,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? null,
      name: json['name'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}
