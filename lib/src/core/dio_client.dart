import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/core/dio_interceptor.dart';
import 'package:fitcpxaluno/src/utils/variables.dart';

class DioClient {
  static Dio? _dio;

  static Dio getInstance(AuthBloc authBloc) {
    if (_dio != null) return _dio!;

    _dio = Dio(
      BaseOptions(
        baseUrl: Variables.url,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    _dio!.interceptors.add(DioInterceptor(authBloc));
    // _dio!.interceptors.add(
    //   LogInterceptor(responseBody: true, requestBody: true),
    // );
    return _dio!;
  }

  static Dio get instance {
    if (_dio == null) {
      throw Exception(
        'DioClient não inicializado. Use getInstance(authBloc) antes.',
      );
    }
    return _dio!;
  }
}
