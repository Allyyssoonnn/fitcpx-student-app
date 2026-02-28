import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_event.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/user_model.dart';
import 'package:fitcpxaluno/src/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService userService;
  late UserModel user;

  AuthBloc(this.userService) : super(AuthUnAuthenticated()) {
    // 1. Handler para Login
    on<AuthLoggedIn>((event, emit) async {
      try {
        String? deviceToken;

        try {
          deviceToken = await FirebaseMessaging.instance.getToken();
        } catch (e) {
          deviceToken = '';
        }

        final data = await userService.login(
          event.firstAccess,
          event.email,
          event.password,
          deviceToken ?? "",
          Platform.isIOS ? "IOS" : "Android",
          event.context,
        );

        if (data.token == null) {
          emit(AuthUnAuthenticated());
          return;
        }

        // Atualiza a variável local
        user = data;

        // Salva no SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_client', data.id);
        await prefs.setString('name', data.name);
        await prefs.setString('clientImg', data.clientImg ?? '');
        await prefs.setInt('id_company', data.companyId);
        await prefs.setString('company', data.company);
        await prefs.setString('companyImg', data.companyImg ?? '');
        await prefs.setString('token', data.token);
        await prefs.setString('refreshToken', data.refreshToken);
        await prefs.setString('status', data.status);
        await prefs.setString(
          'status_description',
          data.status_description ?? '',
        );

        // AQUI ESTAVA O ERRO POTENCIAL:
        // Passamos 'data' (que é o UserModel) para o estado.
        emit(AuthAuthenticated(data));
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode ?? 'no status code';
        final responseData = e.response?.data ?? 'no response data';
        final message = DioExceptions.fromDioError(e).toString();

        // Nota: Idealmente, você deveria emitir um estado de erro aqui
        // emit(AuthError(message));
        // Mas como seu código lançava exception, mantive a lógica,
        // embora isso possa crashar o app se não tratado na UI.
        throw Exception(
          'Dio error: $message | Status: $statusCode | Response: $responseData',
        );
      }
    });

    // 2. Handler para Logout
    on<AuthLoggedOut>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthUnAuthenticated());
    });

    // 3. NOVO Handler para Verificar Status (Substitui a função solta)
    on<AuthCheckStatus>(_onCheckStatus);

    // 4. Dispara a verificação imediatamente ao criar o Bloc
    add(AuthCheckStatus());
  }

  // Lógica de verificação de token movida para dentro de um handler seguro
  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final refreshToken = prefs.getString('refreshToken');

    if (token != null && token.isNotEmpty) {
      final id = prefs.getInt('id_client');
      final name = prefs.getString('name');
      final email = prefs.getString('email');
      final companyId = prefs.getInt('id_company');
      final company = prefs.getString('company');
      final status = prefs.getString('status');
      final statusDesc = prefs.getString('status_description');
      final clientImg = prefs.getString('clientImg');
      final companyImg = prefs.getString('companyImg');

      user = UserModel(
        id: id ?? 0,
        name: name ?? "",
        email: email ?? "",
        companyId: companyId ?? 0,
        company: company ?? "",
        token: token,
        refreshToken: refreshToken ?? "",
        status: status ?? "",
        status_description: statusDesc,
        clientImg: clientImg,
        companyImg: companyImg ?? "",
      );

      // CORREÇÃO: Passando o usuário recuperado para o estado
      emit(AuthAuthenticated(user));
    } else {
      // Se não tem token, está deslogado
      emit(AuthUnAuthenticated());
    }
  }
}
