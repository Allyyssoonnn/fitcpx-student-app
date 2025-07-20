class UserModel {
  final String name;
  final String token;
  final String refreshToken;

  UserModel({
    required this.name,
    required this.token,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}
