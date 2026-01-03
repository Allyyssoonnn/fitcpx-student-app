import 'package:intl/intl.dart';

class WorkoutHistoryModel {
  final int id;
  final int duration;
  final String date; // Data formatada (ex: 20/10/2023)
  final String startTime; // Hora formatada (ex: 23:30)
  final String endTime; // Hora formatada (ex: 00:45)
  final DateTime? rawEndDateTime; // Data bruta caso precise de validação extra
  final List<ExerciseHistoryModel>? exercises;

  WorkoutHistoryModel({
    required this.id,
    required this.duration,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.rawEndDateTime,
    this.exercises,
  });

  // Getter para exibir o intervalo completo (ex: "23:30 - 00:45")
  String get timeRange => "$startTime - $endTime";

  // Getter da duração formatada (Mantive sua lógica que é boa)
  String get durationFormatted {
    final durationObj = Duration(seconds: duration);
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    // Se tiver horas, mostra HH:mm:ss, senão mm:ss
    if (durationObj.inHours > 0) {
      return "${twoDigits(durationObj.inHours)}:${twoDigits(durationObj.inMinutes.remainder(60))}:${twoDigits(durationObj.inSeconds.remainder(60))}";
    } else {
      return "${twoDigits(durationObj.inMinutes.remainder(60))}:${twoDigits(durationObj.inSeconds.remainder(60))}";
    }
  }

  factory WorkoutHistoryModel.fromJson(Map<String, dynamic> json) {
    String formattedDate = '';
    String formattedStart = '--:--';
    String formattedEnd = '--:--';
    DateTime? endDateTime;
    int parsedDuration = 0;

    try {
      // 1. Parse da Duração
      parsedDuration = json['duracao_treino_execucao'] is int
          ? json['duracao_treino_execucao']
          : int.tryParse(json['duracao_treino_execucao'].toString()) ?? 0;

      // 2. Parse do createdAt (DATA DE TÉRMINO)
      // O Sequelize manda em UTC. É vital usar .toLocal() para mostrar a hora do Brasil.
      if (json['createdAt'] != null) {
        endDateTime = DateTime.parse(json['createdAt']).toLocal();
      } else {
        // Fallback se não tiver createdAt, tenta usar a data do treino
        final fallbackDate = DateTime.tryParse(
          json['data_treino_execucao'] ?? '',
        );
        endDateTime = fallbackDate ?? DateTime.now();
      }

      // 3. Cálculo da DATA DE INÍCIO (Término - Duração)
      // O Dart lida automaticamente com a virada de dia (ex: 00:10 - 20min = 23:50 do dia anterior)
      final startDateTime = endDateTime.subtract(
        Duration(seconds: parsedDuration),
      );

      // 4. Formatação
      final dateFormatter = DateFormat('dd/MM/yyyy');
      final timeFormatter = DateFormat('HH:mm'); // Formato 24h

      formattedDate = dateFormatter.format(
        endDateTime,
      ); // Data baseada no término
      formattedEnd = timeFormatter.format(endDateTime);
      formattedStart = timeFormatter.format(startDateTime);
    } catch (e) {
      // Log de erro simples se necessário
      print("Erro ao parsear treino: $e");
    }

    return WorkoutHistoryModel(
      id: json['cod_treino_execucao'] ?? 0,
      duration: parsedDuration,
      date: formattedDate,
      startTime: formattedStart,
      endTime: formattedEnd,
      rawEndDateTime: endDateTime,
      exercises:
          (json['exercicios'] as List?)
              ?.map((e) => ExerciseHistoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ExerciseHistoryModel {
  final int id;
  final bool done;
  final String name;
  final List<SetsExerciseHistoryModel> sets;
  final List<ExerciseHistoryModel> superSets;

  ExerciseHistoryModel({
    required this.id,
    required this.done,
    required this.name,
    required this.sets,
    required this.superSets,
  });

  factory ExerciseHistoryModel.fromJson(Map<String, dynamic> json) {
    // Tenta buscar o nome na raiz (Nova estrutura do backend)
    String? exerciseName = json['nome_exercicio'];

    // Se não achar, tenta buscar dentro do objeto 'exercicio' (Estrutura antiga ou fallback)
    if (exerciseName == null && json['exercicio'] != null) {
      exerciseName = json['exercicio']['nome_exercicio'];
    }

    return ExerciseHistoryModel(
      id: json['cod_treino_execucao_exercicio'] ?? 0,
      done: json['treino_exercicio_executado'] == "S",
      name: exerciseName ?? 'Exercício Removido/Indisponível',
      sets:
          (json['sets'] as List?)
              ?.map((e) => SetsExerciseHistoryModel.fromJson(e))
              .toList() ??
          [],
      superSets:
          (json['superSets'] as List?)
              ?.map((e) => ExerciseHistoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SetsExerciseHistoryModel {
  final int id;
  final bool done;
  final int repetition;
  final int weight;

  SetsExerciseHistoryModel({
    required this.id,
    required this.done,
    required this.repetition,
    required this.weight,
  });

  factory SetsExerciseHistoryModel.fromJson(Map<String, dynamic> json) {
    return SetsExerciseHistoryModel(
      id: json['id'] ?? 0,
      done: json['checked'] == true,
      repetition: json['repetition'] ?? 0,
      weight: json['weight'] ?? 0,
    );
  }
}
