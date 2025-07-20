import 'package:dio/dio.dart';
import 'package:fitcpxapp/src/core/dio_client.dart';
import 'package:fitcpxapp/src/core/dio_exceptions.dart';

class MusclesService {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>> getMuscles() async {
    try {
      final response = await _dio.post(
        '/treino/getGrupoExercicios',
        data: {'cod_empresa': 1},
      );

      final data = response.data;

      return data['grupos'];
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
