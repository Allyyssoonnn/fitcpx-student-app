import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/user_model.dart';
import 'package:fitcpxaluno/src/utils/variables.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> recoveryPassword(String email, BuildContext context) async {
    try {
      await _dio.post('/mobile/recoveryPassword', data: {'login': email});
      return;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            e.response?.data['message'] ?? e.message ?? message,
            textAlign: TextAlign.center,
          ),
        ),
      );
      throw Exception('Dio error: $message | URL: ${e.requestOptions.uri}');
    }
  }

  Future<Map<String, dynamic>> verifyAccount(
    String email,
    BuildContext context,
  ) async {
    try {
      final response = await _dio.post(
        '/mobile/verifyAccount',
        data: {'login': email},
      );

      final data = response.data;

      String name = data['name'] ?? "";
      bool firstAccess = data['firstAccess'] ?? false;

      return {'firstAccess': firstAccess, 'name': name};
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      final userMessage =
          e.response?.data['message'] ?? e.message ?? errorMessage;

      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Atenção'),
            content: Text(userMessage),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      throw Exception(
        'Dio error: $errorMessage | URL: ${e.requestOptions.uri}',
      );
    }
  }

  Future<UserModel> login(
    bool firstAccess,
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
          'firstAccess': firstAccess,
        },
      );

      final data = response.data;

      return UserModel(
        id: data['student']?['cod_aluno'],
        name: data['student']?['nome_aluno'],
        email: data['student']?['email_aluno'],
        clientImg: data['student']?['imagem_aluno'],
        companyId: data['company']?['cod_empresa'],
        company: data['company']?['nome_empresa'],
        companyImg: data['company']?['imagem_empresa'],
        token: data['token'],
        refreshToken: data['refreshToken'],
        status: data['license']?['status'],
        status_description: data['license']?['status_description'],
      );
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      final userMessage =
          e.response?.data['message'] ?? e.message ?? errorMessage;

      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Atenção'),
            content: Text(userMessage),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      throw Exception(
        'Dio error: $errorMessage | URL: ${e.requestOptions.uri}',
      );
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
