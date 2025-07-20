class JointModel {
  final int cod_articulacao;
  final String nome_articulacao;

  JointModel({required this.cod_articulacao, required this.nome_articulacao});

  factory JointModel.fromJson(Map<String, dynamic> json) {
    return JointModel(
      cod_articulacao: json['cod_articulacao'] ?? null,
      nome_articulacao: json['nome_articulacao'] ?? '',
    );
  }
}
