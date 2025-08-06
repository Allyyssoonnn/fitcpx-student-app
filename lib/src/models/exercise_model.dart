import 'package:fitcpxaluno/src/models/sets_model.dart';

class ExerciseModel {
  final int cod_exercicio;
  final String nome_exercicio;
  final String? url_exercicio;
  final int nSets;
  final int weight;
  final int repetition;
  final List<SetsModel>? setsInfo;

  //Information
  final int? cod_grupo_exercicio_1;
  final String? nome_grupo_exercicio_1;
  final int? cod_equipamento_1;
  final String? nome_equipamento_1;
  final int? cod_equipamento_2;
  final String? nome_equipamento_2;
  final int? cod_equipamento_3;
  final String? nome_equipamento_3;

  ExerciseModel copyWith({
    int? id,
    String? name,
    bool? checked,
    int? weight,
    int? repetition,
    List<SetsModel>? setsInfo,
  }) {
    return ExerciseModel(
      cod_exercicio: id ?? this.cod_exercicio,
      nome_exercicio: name ?? this.nome_exercicio,
      url_exercicio: this.url_exercicio,
      nSets: this.nSets,
      setsInfo: setsInfo ?? this.setsInfo,
      weight: weight ?? this.weight,
      repetition: repetition ?? this.repetition,
    );
  }

  ExerciseModel({
    required this.cod_exercicio,
    required this.nome_exercicio,
    required this.url_exercicio,
    required this.nSets,
    required this.weight,
    required this.repetition,
    this.setsInfo,

    //Information
    this.cod_grupo_exercicio_1,
    this.nome_grupo_exercicio_1,
    this.cod_equipamento_1,
    this.nome_equipamento_1,
    this.cod_equipamento_2,
    this.nome_equipamento_2,
    this.cod_equipamento_3,
    this.nome_equipamento_3,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      cod_exercicio: json['cod_exercicio'] ?? 0,
      nome_exercicio: json['nome_exercicio'] ?? '',
      url_exercicio: json['url_exercicio'] ?? '',
      nSets: json['serie_sessao_exercicio'] ?? 0,
      weight: json['carga_sessao_exercicio'] ?? 0,
      repetition: json['repeticao_sessao_exercicio'] ?? 0,
      setsInfo:
          (json['setsInfo'] as List?)
              ?.map((e) => SetsModel.fromJson(e))
              .toList() ??
          List.generate(
            json['serie_sessao_exercicio'] ?? 0,
            (index) => SetsModel(
              id: index + 1,
              repetition: json['repeticao_sessao_exercicio'] ?? 0,
              weight: json['carga_sessao_exercicio'] ?? 0,
              checked: false,
            ),
          ),
      cod_grupo_exercicio_1: json['cod_grupo_exercicio_1'] ?? 0,
      nome_grupo_exercicio_1:
          json['grupo_exercicio_1']?['nome_grupo_exercicio'] ?? '',
      cod_equipamento_1: json['cod_equipamento_1'] ?? 0,
      nome_equipamento_1: json['equipamento_1']?['nome_equipamento'] ?? '',
      cod_equipamento_2: json['cod_equipamento_2'] ?? 0,
      nome_equipamento_2: json['equipamento_2']?['nome_equipamento'] ?? '',
      cod_equipamento_3: json['cod_equipamento_3'] ?? 0,
      nome_equipamento_3: json['equipamento_3']?['nome_equipamento'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_exercicio': cod_exercicio,
      'nome_exercicio': nome_exercicio,
      'url_exercicio': url_exercicio,
      'nSets': nSets,
      'weight': weight,
      'repetition': repetition,
      'setsInfo': setsInfo?.map((set) => set.toJson()).toList(),
      'cod_grupo_exercicio_1': cod_grupo_exercicio_1,
      'nome_grupo_exercicio_1': nome_grupo_exercicio_1,
      'cod_equipamento_1': cod_equipamento_1,
      'nome_equipamento_1': nome_equipamento_1,
      'cod_equipamento_2': cod_equipamento_2,
      'nome_equipamento_2': nome_equipamento_2,
      'cod_equipamento_3': cod_equipamento_3,
      'nome_equipamento_3': nome_equipamento_3,
    };
  }
}
