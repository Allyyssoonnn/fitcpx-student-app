import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/user_model.dart';
import 'package:fitcpxaluno/src/utils/variables.dart';
import 'package:flutter/material.dart';

class UserService {
  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: Variables.url,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            contentType: 'application/json',
          ),
        )
        ..interceptors.add(DioInterceptor())
        ..interceptors.add(
          LogInterceptor(responseBody: true, requestBody: true),
        );

  Future<UserModel> login(
    String email,
    String senha,
    String deviceToken,
    String platform,
    BuildContext context,
  ) async {
    try {
      final response = await _dio.post(
        '/mobile/login',
        data: {
          'login': email,
          'password': senha,
          'deviceToken': deviceToken,
          'platform': platform,
        },
      );

      final data = response.data;

      return UserModel(
        id: data['student']?['cod_aluno'],
        name: data['student']?['nome_aluno'],
        clientImg: data['student']?['imagem_aluno'],
        companyId: data['company']?['cod_empresa'],
        company: data['company']?['nome_empresa'],
        companyImg: data['company']?['imagem_empresa'],
        token: data['token'],
        refreshToken: data['refreshToken'],
      );
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(e.response?.data['message'] ?? e.message ?? message),
        ),
      );
      throw Exception('Dio error: $message | URL: ${e.requestOptions.uri}');
    }
  }
}

class DioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // final statusCode = err.response?.statusCode;
    // final message = DioExceptions.fromDioError(err).toString();
    // debugPrint(
    //   'Dio error intercepted: $statusCode Code $message | URL: ${err.requestOptions.uri}',
    // );
    handler.reject(err);
  }
}
