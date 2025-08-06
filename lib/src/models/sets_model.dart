class SetsModel {
  int id;
  int repetition;
  int weight;
  bool checked;

  SetsModel copyWith({bool? check, int? rep, int? neWeight}) {
    return SetsModel(
      id: id,
      repetition: rep ?? repetition,
      weight: neWeight ?? weight,
      checked: check ?? checked,
    );
  }

  SetsModel({
    required this.id,
    required this.repetition,
    required this.weight,
    required this.checked,
  });

  factory SetsModel.fromJson(Map<String, dynamic> json) {
    return SetsModel(
      id: json['id'],
      repetition: json['repetition'],
      weight: json['weight'],
      checked: json['checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'repetition': repetition,
      'weight': weight,
      'checked': checked,
    };
  }
}
