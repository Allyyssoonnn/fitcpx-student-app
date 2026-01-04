import 'package:fitcpxaluno/src/models/exercise_model.dart';

class SessionModel {
  final String workoutId;
  final String id;
  final String name;
  final bool lastWorkout;
  final List<ExerciseModel>? exercises;

  SessionModel copyWith({
    String? id,
    String? name,
    List<ExerciseModel>? exercises,
  }) {
    return SessionModel(
      workoutId: this.workoutId,
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      lastWorkout: this.lastWorkout,
    );
  }

  SessionModel({
    required this.workoutId,
    required this.id,
    required this.name,
    required this.lastWorkout,
    this.exercises,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      workoutId: json['cod_treino'].toString(),
      id: json['cod_sessao'].toString(),
      name: json['nome_sessao'] ?? '',
      exercises: (json['exercicios'] as List<dynamic>?)
          ?.map((e) => ExerciseModel.fromJson(e))
          .toList(),
      lastWorkout: json['lastWorkout'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_treino': workoutId,
      'cod_sessao': id,
      'nome_sessao': name,
      'exercicios': exercises?.map((e) => e.toJson()).toList(),
    };
  }
}
