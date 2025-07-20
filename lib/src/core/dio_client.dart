import 'package:dio/dio.dart';
import 'package:fitcpxapp/src/core/dio_interceptor.dart';

class DioClient {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://api.fitcpx.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            contentType: 'application/json',
          ),
        )
        ..interceptors.addAll([
          DioInterceptor(),
          LogInterceptor(responseBody: false, requestBody: true),
        ]);
  static Dio get instance => _dio;
}
