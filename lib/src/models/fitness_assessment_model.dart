import 'package:intl/intl.dart';

class FitnessAssessmentModel {
  final int id;
  final int idClient;
  final String date;
  final String weight;
  final String height;

  // Mass Percent
  final double bodyPercFat;
  final double leanPercMass;
  final double musclePerMass;
  final double bonePercMass;
  final double residualPercMass;

  final double? bodyFat;
  final double? leanMass;
  final double? muscleMass;
  final double? boneMass;
  final double? residualMass;

  final String trainer;
  final String client;
  final String? gender;
  final int? age;
  final String? basalMetabolicRate;

  // Skinfolds
  final String? tricepsFold;
  final String? chestFold;
  final String? subscapularisFold;
  final String? armpitFold;
  final String? abdominal;
  final String? thighFold;
  final String? suprailiacFold;
  final String? supraspinatusFold;
  final String? bicepsFold;
  final String? calfFold;

  //Perimeters
  //General
  final String? neck;
  final String? shoulder;
  final String? chestInhaled;
  final String? chestExhaled;
  final String? waist;
  final String? abdomen;
  final String? hips;

  //Right side
  final String? rightArmRelaxed;
  final String? rightArmContracted;
  final String? rightForearm;
  final String? rightThigh;
  final String? rightCalf;

  //Left side
  final String? leftArmRelaxed;
  final String? leftArmContracted;
  final String? leftForearm;
  final String? leftThigh;
  final String? leftCalf;

  FitnessAssessmentModel({
    required this.id,
    required this.idClient,
    required this.date,
    required this.weight,
    required this.height,

    required this.bodyPercFat,
    required this.leanPercMass,
    required this.musclePerMass,
    required this.bonePercMass,
    required this.residualPercMass,
    this.bodyFat,
    this.leanMass,
    this.muscleMass,
    this.boneMass,
    this.residualMass,

    required this.trainer,
    required this.client,
    this.gender,
    this.age,
    this.basalMetabolicRate,

    this.tricepsFold,
    this.chestFold,
    this.subscapularisFold,
    this.armpitFold,
    this.abdominal,
    this.thighFold,
    this.suprailiacFold,
    this.supraspinatusFold,
    this.bicepsFold,
    this.calfFold,

    this.neck,
    this.shoulder,
    this.chestInhaled,
    this.chestExhaled,
    this.waist,
    this.abdomen,
    this.hips,
    this.rightArmRelaxed,
    this.rightArmContracted,
    this.rightForearm,
    this.rightThigh,
    this.rightCalf,
    this.leftArmRelaxed,
    this.leftArmContracted,
    this.leftForearm,
    this.leftThigh,
    this.leftCalf,
  });

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory FitnessAssessmentModel.fromJson(Map<String, dynamic> json) {
    // Tratando a data com try-catch
    String formattedDate = '';
    try {
      final parsedDate = DateTime.parse(json['data_avaliacao']);
      formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (_) {
      formattedDate = '';
    }

    return FitnessAssessmentModel(
      id: json['cod_avaliacao'] is int
          ? json['cod_avaliacao']
          : int.tryParse(json['cod_avaliacao'].toString()) ?? 0,
      idClient: json['cod_aluno'] is int
          ? json['cod_aluno']
          : int.tryParse(json['cod_aluno'].toString()) ?? 0,
      date: formattedDate,
      weight: json['peso']?.toString() ?? '',
      height: json['altura']?.toString() ?? '',

      bodyPercFat: _toDouble(json['gordura']),
      musclePerMass: _toDouble(
        json['compositionPercentage']?['massa_muscular'],
      ),
      leanPercMass: _toDouble(json['compositionPercentage']?['massa_magra']),
      bonePercMass: _toDouble(json['compositionPercentage']?['massa_ossea']),
      residualPercMass: _toDouble(
        json['compositionPercentage']?['massa_residual'],
      ),

      bodyFat: _toDouble(json['compositionWeight']?['gordura']),
      muscleMass: _toDouble(json['compositionWeight']?['massa_muscular']),
      leanMass: _toDouble(json['compositionWeight']?['massa_magra']),
      boneMass: _toDouble(json['compositionWeight']?['massa_ossea']),
      residualMass: _toDouble(json['compositionWeight']?['massa_residual']),

      trainer: json['usuario']?['nome_usuario']?.toString() ?? '',
      client: json['aluno']?['nome_aluno']?.toString() ?? '',
      basalMetabolicRate: json['basal']?.toString(),

      age: json['idade'] is int
          ? json['idade']
          : int.tryParse(json['idade'].toString()),
      gender: json['sexo']?.toString(),

      tricepsFold: json['triciptal']?.toString(),
      chestFold: json['peitoral']?.toString(),
      subscapularisFold: json['subescapular']?.toString(),
      armpitFold: json['axilar_media']?.toString(),
      abdominal: json['abdominal']?.toString(),
      thighFold: json['coxa']?.toString(),
      suprailiacFold: json['supra_iliaca']?.toString(),
      supraspinatusFold: json['supra_espinhal']?.toString(),
      bicepsFold: json['biciptal']?.toString(),
      calfFold: json['panturrilha']?.toString(),

      neck: json['pescoco']?.toString(),
      shoulder: json['ombro']?.toString(),
      chestInhaled: json['torax_inspirado']?.toString(),
      chestExhaled: json['torax_expirado']?.toString(),
      waist: json['cintura']?.toString(),
      abdomen: json['abdomen']?.toString(),
      hips: json['quadril']?.toString(),

      rightArmRelaxed: json['braco_relaxado_direito']?.toString(),
      rightArmContracted: json['braco_contraido_direito']?.toString(),
      rightForearm: json['antebraco_direito']?.toString(),
      rightThigh: json['coxa_direita']?.toString(),
      rightCalf: json['panturrilha_direita']?.toString(),

      leftArmRelaxed: json['braco_relaxado_esquerdo']?.toString(),
      leftArmContracted: json['braco_contraido_esquerdo']?.toString(),
      leftForearm: json['antebraco_esquerdo']?.toString(),
      leftThigh: json['coxa_esquerda']?.toString(),
      leftCalf: json['panturrilha_esquerda']?.toString(),
    );
  }
}
