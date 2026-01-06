import 'package:intl/intl.dart';

class CalendarModel {
  final int id;
  final int? studentId;
  final String name;
  final String startDate;
  final String endDate;
  final String type;
  final String description;
  final String modalidade;

  CalendarModel({
    required this.id,
    this.studentId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.description,
    required this.modalidade,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    String formattedStartDate = '';
    String formattedEndDate = '';
    try {
      final parsedStartDate = DateTime.parse(json['data_inicio']);
      final parsedEndDate = DateTime.parse(json['data_fim']);
      formattedStartDate = DateFormat(
        'dd/MM/yyyy hh:mm',
      ).format(parsedStartDate);
      formattedEndDate = DateFormat('dd/MM/yyyy HH:mm').format(parsedEndDate);
    } catch (_) {
      formattedStartDate = '';
      formattedEndDate = '';
    }

    return CalendarModel(
      id: json['cod_agenda'] ?? '',
      studentId: json['cod_aluno'],
      name: json['nome_evento'] ?? '',
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      type: json['tipo_agendamento'] ?? '',
      description: json['descricao_evento'] ?? '',
      modalidade: json['modalidade']?['nome_modalidade'] ?? '',
    );
  }
}
