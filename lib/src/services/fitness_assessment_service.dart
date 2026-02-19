import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:share_plus/share_plus.dart';
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

  Future<void> sendFitnessAssessment({
    required double neck,
    required double waist,
    required double hip,
    required double weight,
    required double height,
    required List<XFile> images,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      FormData formData = FormData.fromMap({
        'neck': neck,
        'waist': waist,
        'hip': hip,
        'weight': weight,
        'height': height,
      });

      for (var file in images) {
        formData.files.add(
          MapEntry(
            // ATENÇÃO: 'images' deve ser EXATAMENTE o mesmo nome que o seu Multer
            // espera no backend (ex: upload.array('images')).
            // Em alguns backends, pode ser necessário usar 'images[]'.
            'images',
            await MultipartFile.fromFile(
              file.path,
              filename: file.name.isNotEmpty ? file.name : 'avaliacao.png',
            ),
          ),
        );
      }

      await _dio.post('/mobile/sendFitnessAssessment', data: formData);

      return;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
