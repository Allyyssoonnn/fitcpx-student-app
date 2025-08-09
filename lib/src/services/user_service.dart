import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/user_model.dart';
import 'package:fitcpxaluno/src/utils/variables.dart';
import 'package:flutter/material.dart';

class UserService {
  // final Dio _dio = DioClient.instance;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Variables.url,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  )..interceptors.add(DioInterceptor())..interceptors.add(
    LogInterceptor(responseBody: true, requestBody: true),
  );

  Future<UserModel> login(
    String email,
    String senha,
    BuildContext context,
  ) async {
    try {
      final response = await _dio.post(
        '/appaluno/login',
        data: {'login': email, 'senha': senha},
      );

      final data = response.data;

      //add exception because the response is 200 to error
      if (response.data['status'] == true && response.data['token'] == null) {
        final message = response.data['msg'] ?? '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text(message)),
        );
        throw Exception(response.data['msg']);
      }
      //

      return UserModel(
        id: data['aluno']?['cod_aluno'],
        name: data['aluno']?['nome_aluno'],
        clientImg: data['aluno']?['imagem_aluno'],
        companyId: data['empresa']?['cod_empresa'],
        company: data['empresa']?['nome_empresa'],
        companyImg: data['empresa']?['imagem_empresa'],
        token: data['token'],
        refreshToken: data['refreshToken'],
      );
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      debugPrint('Dio error: $message | URL: ${e.requestOptions.uri}');
      throw Exception('Dio error: $message | URL: ${e.requestOptions.uri}');
    }
  }
}

class DioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final message = DioExceptions.fromDioError(err).toString();
    debugPrint(
      'Dio error intercepted: $statusCode Code $message | URL: ${err.requestOptions.uri}',
    );
    handler.reject(err);
  }
}
