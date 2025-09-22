import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitnessAssessmentService {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>> getFitnessAssessments({int? id_client}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.get('/mobile/getPhysicalAssessments');

      final data = response.data;

      return data;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }

  Future<FitnessAssessmentModel> getFitnessAssessmentResult({
    int? id_assessment,
    int? id_client,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.get(
        '/mobile/getPhysicalAssessment?physicalAssessmentId=${id_assessment}',
      );

      final data = response.data;

      return FitnessAssessmentModel.fromJson(data);
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
