class MuscleModel {
  final int cod_grupo_exercicio;
  final String nome_grupo_exercicio;

  MuscleModel({
    required this.cod_grupo_exercicio,
    required this.nome_grupo_exercicio,
  });

  factory MuscleModel.fromJson(Map<String, dynamic> json) {
    return MuscleModel(
      cod_grupo_exercicio: json['cod_grupo_exercicio'] ?? null,
      nome_grupo_exercicio: json['nome_grupo_exercicio'] ?? '',
    );
  }
}
