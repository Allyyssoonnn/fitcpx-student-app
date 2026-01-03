import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/session_model.dart';
import 'package:fitcpxaluno/src/models/workout_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutService {
  final Dio _dio = DioClient.instance;

  Future<List<WorkoutHistoryModel>> getWorkoutHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.get('/mobile/getWorkoutHistory');

      final data = response.data;

      if (response.data is List) {
        final List data = response.data;
        return data.map((e) => WorkoutHistoryModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }

  Future<List<dynamic>> getWorkouts({int? id_client}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.get('/mobile/getWorkouts');

      final data = response.data;

      return data;
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
        '/mobile/finishTreino',
        data: {
          'sessao': session,
          "cod_aluno": id_client,
          'tempo': durationSeconds,
        },
      );

      response.data;

      return;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
