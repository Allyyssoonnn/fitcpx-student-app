import 'package:fitcpxaluno/src/models/calendar_model.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<CalendarModel> events;
  final List<CalendarModel> avaliableEvents;

  CalendarLoaded(this.events, this.avaliableEvents);
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError(this.message);
}
