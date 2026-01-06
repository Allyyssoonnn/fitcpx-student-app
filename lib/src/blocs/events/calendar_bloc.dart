import 'package:fitcpxaluno/src/blocs/events/calendar_event.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_state.dart';
import 'package:fitcpxaluno/src/models/calendar_model.dart';
import 'package:fitcpxaluno/src/services/calendar_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarService calendarService;
  List<CalendarModel> _allEvents = [];

  CalendarBloc(this.calendarService) : super(CalendarInitial()) {
    on<LoadCalendar>(_onLoadCalendar);
  }

  Future<void> _onLoadCalendar(
    LoadCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id_client = prefs.getInt('id_client');

      if (id_client == null) {
        emit(CalendarInitial());
        return;
      }

      // final data = await calendarService.getEvents(id_client: id_client);
      final data = await calendarService.getEvents();
      _allEvents = data;

      final ScheduledEvents = data.where((e) => e.studentId != null).toList();
      final avaliableEvents = data.where((e) => e.studentId == null).toList();

      // _allEvents = data
      //     .map((e) => CalendarModel.fromJson(Map<String, dynamic>.from(e)))
      //     .toList();
      emit(CalendarLoaded(ScheduledEvents, avaliableEvents ?? []));
    } catch (e) {
      emit(CalendarError('Error load exercises $e'));
    }
  }
}
