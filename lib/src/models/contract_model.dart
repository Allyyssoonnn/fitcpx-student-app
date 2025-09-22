import 'package:fitcpxaluno/src/models/contract_payment_model.dart';
import 'package:intl/intl.dart';

class ContractModel {
  final int id;
  final String description;
  final String? status;
  final String? date;
  final String? dueDate;
  final List<ContractPaymentModel>? payments;

  ContractModel({
    required this.id,
    required this.description,
    this.payments,
    this.status,
    this.date,
    this.dueDate,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    String formattedDate = '';
    String formattedDueDate = '';
    try {
      final parsedDate = DateTime.parse(json['iniciopagamento_aluno_contrato']);
      final parsedDueDate = DateTime.parse(json['expiracao_aluno_contrato']);
      formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
      formattedDueDate = DateFormat('dd/MM/yyyy').format(parsedDueDate);
    } catch (_) {
      formattedDate = '';
      formattedDueDate = '';
    }

    return ContractModel(
      id: json['cod_aluno_contrato'] ?? 0,
      description: json['descricao_aluno_contrato'] ?? 'contractName',
      status: json['status_aluno_contrato'] ?? '',
      date: formattedDate,
      dueDate: formattedDueDate,
      payments: (json['pagamentos'] as List<dynamic>?)
          ?.map((e) => ContractPaymentModel.fromJson(e))
          .toList(),
    );
  }
}
