import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';

class ExercisesService {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>> getExercises() async {
    try {
      final response = await _dio.post(
        '/treino/getExercicios',
        data: {'cod_empresa': 1},
      );

      final data = response.data;

      return data['exercicios'];
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
