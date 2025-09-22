import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';

class ContractService {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>> getContracts({int? clientId}) async {
    try {
      final response = await _dio.get('/mobile/getContracts');

      final data = response.data;

      return data;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
