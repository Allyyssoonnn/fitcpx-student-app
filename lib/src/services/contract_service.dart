import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/contract_payment_model.dart';

class ContractService {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>> getContracts({int? clientId}) async {
    try {
      final response = await _dio.post(
        '/aluno/getAlunoContratos',
        data: {'cod_aluno': clientId},
      );

      final data = response.data;

      return data['alunoContratos'];
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }

  Future<List<ContractPaymentModel>> getContract({int? contractId}) async {
    try {
      final response = await _dio.post(
        '/aluno/getAlunoContrato',
        data: {'cod_aluno_contrato': contractId},
      );

      final data = response.data['alunoContrato']?['pagamentos'];

      if (data is List) {
        final payments = data
            .map(
              (e) =>
                  ContractPaymentModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
        return payments;
      }
      return [];
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
