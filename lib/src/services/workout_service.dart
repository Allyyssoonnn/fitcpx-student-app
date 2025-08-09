import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/session_model.dart';
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
        data: {"cod_aluno": id_client, 'activeOnly': true},
        // options: Options(headers: {'Authorization': token}),
      );

      final data = response.data['treinos'];

      return data;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }

  Future<List<SessionModel>> getSessions({int? id_workout}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.post(
        '/treino/getTreino',
        data: {"cod_treino": id_workout},
        // options: Options(headers: {'Authorization': token}),
      );

      final data = response.data['treino']?['sessoes'];

      if (data is List) {
        return data.map((session) => SessionModel.fromJson(session)).toList();
      }

      return [];
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }

  Future<void> finishWorkout({
    SessionModel? session,
    int? durationSeconds,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id_client = prefs.getInt('id_client');

      final response = await _dio.post(
        '/appaluno/finishTreino',
        data: {
          'sessao': session,
          "cod_aluno": id_client,
          'tempo': durationSeconds,
        },
      );

      response.data['treino']?['sessoes'];

      return;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
