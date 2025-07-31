class WorkoutModel {
  final String name;
  final String level;
  final int qtdSessions;

  WorkoutModel({
    required this.name,
    required this.level,
    required this.qtdSessions,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      name: json['nome_treino'] ?? '',
      level: json['nivel_treino'] ?? '',
      qtdSessions: json['qtd_sessoes'] ?? '',
    );
  }
}
