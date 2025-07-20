import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  final String message;
  DioExceptions._(this.message);

  factory DioExceptions.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DioExceptions._("Tempo de conexão excedido");
      case DioExceptionType.sendTimeout:
        return DioExceptions._("Falha ao enviar dados");
      case DioExceptionType.receiveTimeout:
        return DioExceptions._("Tempo de resposta excedido");
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode ?? 0;
        final msg = error.response?.statusMessage ?? 'Erro desconhecido';
        return DioExceptions._("Erro $code: $msg");
      case DioExceptionType.cancel:
        return DioExceptions._("Requisição cancelada");
      default:
        return DioExceptions._("Erro inesperado");
    }
  }

  @override
  String toString() => message;
}
