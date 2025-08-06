class WorkoutModel {
  final int id;
  final String name;
  final String level;
  final int qtdSessions;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.level,
    required this.qtdSessions,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['cod_treino'] ?? '',
      name: json['nome_treino'] ?? '',
      level: json['nivel_treino'] ?? '',
      qtdSessions: json['qtd_sessoes'] ?? '',
    );
  }
}
