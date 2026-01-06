import 'package:dio/dio.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_bloc.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_event.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/core/dio_exceptions.dart';
import 'package:fitcpxaluno/src/models/calendar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarService {
  final Dio _dio = DioClient.instance;

  Future<List<CalendarModel>> getEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.get('/mobile/findEvents');

      final data = response.data;

      if (response.data is List) {
        final List data = response.data;
        return data.map((e) => CalendarModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      final message = DioExceptions.fromDioError(e).toString();
      throw Exception(message);
    }
  }

  Future<void> scheduleEvent(int eventId, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      _dio.options.headers['Authorization'] = token;
      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.get('/mobile/scheduleEvent?eventId=$eventId');

      final data = response.data;

      return;
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
                onPressed: () {
                  context.read<CalendarBloc>().add(LoadCalendar());
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
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
