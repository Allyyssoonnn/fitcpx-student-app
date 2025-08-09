import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_event.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService userService;

  AuthBloc(this.userService) : super(AuthUnAuthenticated()) {
    on<AuthLoggedIn>((event, emit) async {
      try {
        final data = await userService.login(
          event.email,
          event.password,
          event.context,
        );

        if (data.token == null) {
          emit(AuthUnAuthenticated());
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_client', data.id);
        await prefs.setString('name', data.name);
        await prefs.setString('clientImg', data.clientImg ?? '');
        await prefs.setInt('id_company', data.companyId);
        await prefs.setString('company', data.company);
        await prefs.setString('companyImg', data.companyImg ?? '');
        await prefs.setString('token', data.token);
        await prefs.setString('refreshToken', data.refreshToken);

        emit(AuthAuthenticated());
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode ?? 'no status code';
        final responseData = e.response?.data ?? 'no response data';

        final message = DioExceptions.fromDioError(e).toString();

        throw Exception(
          'Dio error: $message | '
          'Status: $statusCode | '
          'Response: $responseData | '
          'URL: ${e.requestOptions.uri}',
        );
      }
    });
    on<AuthLoggedOut>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthUnAuthenticated());
    });
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      emit(AuthAuthenticated());
    } else {
      add(AuthLoggedOut());
    }
  }
}
