import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';

abstract class FitnessAssessmentState {}

class FitnessAssessmentInitial extends FitnessAssessmentState {}

class FitnessAssessmentLoading extends FitnessAssessmentState {}

class FitnessAssessmentLoaded extends FitnessAssessmentState {
  final List<FitnessAssessmentModel> fitnessAssessments;

  FitnessAssessmentLoaded(this.fitnessAssessments);
}

class FitnessAssessmentError extends FitnessAssessmentState {
  final String message;

  FitnessAssessmentError(this.message);
}
