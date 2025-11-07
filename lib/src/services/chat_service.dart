import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_chat/chat.dart';

class ChatService {
  final Dio _dio = DioClient.instance;

  Future<void> sendMessage(String message, BuildContext context) async {
    try {
      await _dio.post('/mobile/sendStudentMessage', data: {'message': message});
      return;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception('Dio error: $message | URL: ${e.requestOptions.uri}');
    }
  }

  Future<List<ChatMessage>> getMessages() async {
    try {
      final response = await _dio.get('/mobile/getMessages');
      final data = response.data as List;
      return data
          .map(
            (e) => ChatMessage(
              text: e["message"],
              time: DateTime.parse(e["createdAt"]).toLocal(),
              author: e["from"] != "company"
                  ? ChatAuthor(
                      id: "student-${e["studentId"]}",
                      name: e["student"]["nome_aluno"]!.split(" ")[0],
                    )
                  : ChatAuthor(
                      id: "company-${e["companyId"]}",
                      name: e["company"]["nome_empresa"]!.split(" ")[0],
                    ),
            ),
          )
          .toList();
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception('Dio error: $message | URL: ${e.requestOptions.uri}');
    }
  }

  Future<String> getUnreadMessages() async {
    try {
      final response = await _dio.get('/mobile/getUnreadMessages');
      final data = response.data;
      return data;
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception('Dio error: $message | URL: ${e.requestOptions.uri}');
    }
  }
}
