import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_event.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_state.dart';
import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitnessAssessmentBloc
    extends Bloc<FitnessAssessmentEvent, FitnessAssessmentState> {
  final FitnessAssessmentService fitnessAssessmentService;
  List<FitnessAssessmentModel> _allFitnessAssessments = [];

  FitnessAssessmentBloc(this.fitnessAssessmentService)
    : super(FitnessAssessmentInitial()) {
    on<LoadFitnessAssessment>(_onLoadFitnessAssessments);
  }

  Future<void> _onLoadFitnessAssessments(
    LoadFitnessAssessment event,
    Emitter<FitnessAssessmentState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id_client = prefs.getInt('id_client');

      if (id_client == null) {
        emit(FitnessAssessmentInitial());
        return;
      }

      final data = await fitnessAssessmentService.getFitnessAssessments(
        id_client: id_client,
      );

      _allFitnessAssessments = data
          .map(
            (e) =>
                FitnessAssessmentModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
      emit(FitnessAssessmentLoaded(_allFitnessAssessments));
    } catch (e) {
      emit(FitnessAssessmentError('Error load exercises $e'));
    }
  }
}
