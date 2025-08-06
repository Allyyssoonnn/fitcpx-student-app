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

  Future<void> finishWorkout({SessionModel? session}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await _dio.post(
        '/appaluno/finishTreino',
        data: {},
        options: Options(headers: {'Authorization': token}),
      );

      final data = response.data['treino']?['sessoes'];

      // if (data is List) {
      //   return data.map((session) => SessionModel.fromJson(session)).toList();
      // }

      return;
      //
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
