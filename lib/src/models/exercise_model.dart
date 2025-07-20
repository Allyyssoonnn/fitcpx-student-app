class ExerciseModel {
  final int cod_exercicio;
  final String nome_exercicio;
  final String? url_exercicio;
  final int? cod_grupo_exercicio_1;
  final String? nome_grupo_exercicio_1;
  final int? cod_grupo_exercicio_2;
  final String? nome_grupo_exercicio_2;
  final int? cod_grupo_exercicio_3;
  final String? nome_grupo_exercicio_3;
  final int? cod_grupo_exercicio_4;
  final String? nome_grupo_exercicio_4;
  final int? cod_grupo_exercicio_5;
  final String? nome_grupo_exercicio_5;
  final int? cod_grupo_exercicio_6;
  final String? nome_grupo_exercicio_6;
  final int? cod_grupo_exercicio_7;
  final String? nome_grupo_exercicio_7;
  final int? cod_grupo_exercicio_8;
  final String? nome_grupo_exercicio_8;
  final int? cod_grupo_exercicio_9;
  final String? nome_grupo_exercicio_9;
  final int? cod_grupo_exercicio_10;
  final String? nome_grupo_exercicio_10;
  final int? cod_articulacao_1;
  final String? nome_articulacao_1;
  final int? cod_articulacao_2;
  final String? nome_articulacao_2;
  final int? cod_articulacao_3;
  final String? nome_articulacao_3;
  final int? cod_articulacao_4;
  final String? nome_articulacao_4;
  final int? cod_equipamento_1;
  final String? nome_equipamento_1;
  final int? cod_equipamento_2;
  final String? nome_equipamento_2;
  final int? cod_equipamento_3;
  final String? nome_equipamento_3;
  final int? cod_tipo_exercicio;
  final String? nome_tipo_exercicio;
  final int? cod_exercicio_resistencia;
  final String? nome_exercicio_resistencia;
  final int? cod_indicacao;
  final String? nome_indicacao;

  ExerciseModel({
    required this.cod_exercicio,
    required this.nome_exercicio,
    required this.url_exercicio,
    this.cod_grupo_exercicio_1,
    this.nome_grupo_exercicio_1,
    this.cod_grupo_exercicio_2,
    this.nome_grupo_exercicio_2,
    this.cod_grupo_exercicio_3,
    this.nome_grupo_exercicio_3,
    this.cod_grupo_exercicio_4,
    this.nome_grupo_exercicio_4,
    this.cod_grupo_exercicio_5,
    this.nome_grupo_exercicio_5,
    this.cod_grupo_exercicio_6,
    this.nome_grupo_exercicio_6,
    this.cod_grupo_exercicio_7,
    this.nome_grupo_exercicio_7,
    this.cod_grupo_exercicio_8,
    this.nome_grupo_exercicio_8,
    this.cod_grupo_exercicio_9,
    this.nome_grupo_exercicio_9,
    this.cod_grupo_exercicio_10,
    this.nome_grupo_exercicio_10,
    this.cod_articulacao_1,
    this.nome_articulacao_1,
    this.cod_articulacao_2,
    this.nome_articulacao_2,
    this.cod_articulacao_3,
    this.nome_articulacao_3,
    this.cod_articulacao_4,
    this.nome_articulacao_4,
    this.cod_equipamento_1,
    this.nome_equipamento_1,
    this.cod_equipamento_2,
    this.nome_equipamento_2,
    this.cod_equipamento_3,
    this.nome_equipamento_3,
    this.cod_tipo_exercicio,
    this.nome_tipo_exercicio,
    this.cod_exercicio_resistencia,
    this.nome_exercicio_resistencia,
    this.cod_indicacao,
    this.nome_indicacao,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      cod_exercicio: json['cod_exercicio'] ?? 0,
      nome_exercicio: json['nome_exercicio'] ?? '',
      url_exercicio: json['url_exercicio'] ?? '',
      cod_grupo_exercicio_1: json['cod_grupo_exercicio_1'] ?? 0,
      nome_grupo_exercicio_1:
          json['grupo_exercicio_1']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_2: json['cod_grupo_exercicio_2'] ?? 0,
      nome_grupo_exercicio_2:
          json['grupo_exercicio_2']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_3: json['cod_grupo_exercicio_3'] ?? 0,
      nome_grupo_exercicio_3:
          json['grupo_exercicio_3']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_4: json['cod_grupo_exercicio_4'] ?? 0,
      nome_grupo_exercicio_4:
          json['grupo_exercicio_4']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_5: json['cod_grupo_exercicio_5'] ?? 0,
      nome_grupo_exercicio_5:
          json['grupo_exercicio_5']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_6: json['cod_grupo_exercicio_6'] ?? 0,
      nome_grupo_exercicio_6:
          json['grupo_exercicio_6']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_7: json['cod_grupo_exercicio_7'] ?? 0,
      nome_grupo_exercicio_7:
          json['grupo_exercicio_7']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_8: json['cod_grupo_exercicio_8'] ?? 0,
      nome_grupo_exercicio_8:
          json['grupo_exercicio_8']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_9: json['cod_grupo_exercicio_9'] ?? 0,
      nome_grupo_exercicio_9:
          json['grupo_exercicio_9']?['nome_grupo_exercicio'] ?? '',
      cod_grupo_exercicio_10: json['cod_grupo_exercicio_10'] ?? 0,
      nome_grupo_exercicio_10:
          json['grupo_exercicio_10']?['nome_grupo_exercicio'] ?? '',
      cod_articulacao_1: json['cod_articulacao_1'] ?? 0,
      nome_articulacao_1: json['articulacao_1']?['nome_articulacao'] ?? '',
      cod_articulacao_2: json['cod_articulacao_2'] ?? 0,
      nome_articulacao_2: json['articulacao_2']?['nome_articulacao'] ?? '',
      cod_articulacao_3: json['cod_articulacao_3'] ?? 0,
      nome_articulacao_3: json['articulacao_3']?['nome_articulacao'] ?? '',
      cod_articulacao_4: json['cod_articulacao_4'] ?? 0,
      nome_articulacao_4: json['articulacao_4']?['nome_articulacao'] ?? '',
      cod_equipamento_1: json['cod_equipamento_1'] ?? 0,
      nome_equipamento_1: json['equipamento_1']?['nome_equipamento'] ?? '',
      cod_equipamento_2: json['cod_equipamento_2'] ?? 0,
      nome_equipamento_2: json['equipamento_2']?['nome_equipamento'] ?? '',
      cod_equipamento_3: json['cod_equipamento_3'] ?? 0,
      nome_equipamento_3: json['equipamento_3']?['nome_equipamento'] ?? '',
      cod_tipo_exercicio: json['cod_tipo_exercicio'] ?? 0,
      nome_tipo_exercicio: json['tipo_exercicio']?['nome_tipo_exercicio'] ?? '',
      cod_exercicio_resistencia: json['cod_exercicio_resistencia'] ?? 0,
      nome_exercicio_resistencia:
          json['exercicio_resistencia']?['nome_exercicio_resistencia'] ?? '',
      cod_indicacao: json['cod_indicacao'] ?? 0,
      nome_indicacao: json['indicacao']?['nome_indicacao'] ?? '',
    );
  }
}
