import 'package:dio/dio.dart';
import 'package:fitcpxapp/src/core/dio_client.dart';
import 'package:fitcpxapp/src/core/dio_exceptions.dart';

class JointsService {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>> getJoints() async {
    try {
      final response = await _dio.post(
        '/treino/getArticulacoes',
        data: {'cod_empresa': 1},
      );

      final data = response.data;

      return data['articulacoes'];
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
