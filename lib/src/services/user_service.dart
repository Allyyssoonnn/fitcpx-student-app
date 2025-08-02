import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/user_model.dart';

class UserService {
  final Dio _dio = DioClient.instance;

  Future<UserModel> login(String email, String senha) async {
    try {
      final response = await _dio.post(
        '/appaluno/login',
        data: {'login': email, 'senha': senha},
      );

      final data = response.data;

      //add exception because the response is 200 to error
      if (response.data['status'] == false) {
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
      throw Exception(message);
    }
  }
}
