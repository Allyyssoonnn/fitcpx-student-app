import 'package:dio/dio.dart';
import 'package:fitcpxapp/src/core/dio_client.dart';
import 'package:fitcpxapp/src/core/dio_exceptions.dart';
import 'package:fitcpxapp/src/models/user_model.dart';

class UserService {
  final Dio _dio = DioClient.instance;

  Future<UserModel> login(String email, String senha) async {
    try {
      final response = await _dio.post(
        '/usuario/login',
        data: {'email': email, 'senha': senha},
      );

      final data = response.data;

      //add exception because the response is 200 to error
      if (response.data['status'] == false) {
        throw Exception(response.data['msg']);
      }
      //

      return UserModel(
        name: data['usuario']?['nome_usuario'],
        token: data['token'],
        refreshToken: data['refreshToken'],
      );
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }
}
