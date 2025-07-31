import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutService {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>> getWorkouts({int? id_client}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.post(
        '/treino/getTreinos',
        data: {"cod_aluno": id_client},
        // options: Options(headers: {'Authorization': token}),
      );

      final data = response.data['treinos'];

      //add exception because the response is 200 to error
      if (response.data['status'] == false) {
        throw Exception(response.data['msg']);
      }
      //

      return data;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
