import 'package:fitcpxaluno/src/models/session_model.dart';

class WorkoutModel {
  final int id;
  final String name;
  final String level;
  final int qtdSessions;
  final List<SessionModel>? sessions;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.level,
    required this.qtdSessions,
    this.sessions,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['cod_treino'] ?? '',
      name: json['nome_treino'] ?? '',
      level: json['nivel_treino'] ?? '',
      qtdSessions: json['qtd_sessoes'] ?? '',
      sessions: (json['sessoes'] as List<dynamic>?)
          ?.map((e) => SessionModel.fromJson(e))
          .toList(),
    );
  }
}
