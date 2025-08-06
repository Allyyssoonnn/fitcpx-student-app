import 'package:intl/intl.dart';

class ContractPaymentModel {
  final String id;
  final String status;
  final double amount;
  final String dueDate;
  final String invoiceUrl;

  ContractPaymentModel({
    required this.id,
    required this.status,
    required this.amount,
    required this.dueDate,
    required this.invoiceUrl,
  });

  factory ContractPaymentModel.fromJson(Map<String, dynamic> json) {
    String formattedDueDate = '';
    try {
      final parsedDueDate = DateTime.parse(
        json['expiracao_aluno_contrato_pagamento'],
      );
      formattedDueDate = DateFormat('dd/MM/yyyy').format(parsedDueDate);
    } catch (_) {
      formattedDueDate = '';
    }
    return ContractPaymentModel(
      id: json['asaas_id'] ?? '',
      status: json['status_aluno_contrato_pagamento'] ?? '',
      amount:
          double.tryParse(json['valor_aluno_contrato_pagamento'].toString()) ??
          0.0,
      dueDate: formattedDueDate,
      invoiceUrl: json['asaas_url'] ?? '',
    );
  }
}
