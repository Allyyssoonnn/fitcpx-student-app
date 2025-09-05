import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_event.dart';
import 'package:fitcpxaluno/src/utils/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioInterceptor extends Interceptor {
  final AuthBloc authBloc;
  DioInterceptor(this.authBloc);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = token;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final refreshToken = prefs.getString('refreshToken');

        final refreshResponse = await Dio().post(
          '${Variables.url}/appaluno/refreshToken',
          data: {'refreshToken': refreshToken},
        );

        final newToken = refreshResponse.data['token'];
        await prefs.setString('token', newToken);

        // Reenvia a request original com o novo token
        final newRequest = err.requestOptions;
        newRequest.headers['Authorization'] = newToken;

        final response = await Dio().fetch(newRequest);
        return handler.resolve(response);
      } catch (e) {
        authBloc.add(AuthLoggedOut());
        print('[ERROR] - Refresh Token Request $e');
        return handler.reject(err);
      }
    }

    print('Erro [$statusCode] em ${err.requestOptions.path}: ${err.message}');
    return handler.next(err);
  }
}
