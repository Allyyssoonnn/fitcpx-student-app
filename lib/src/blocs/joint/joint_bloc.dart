import 'package:fitcpxaluno/src/blocs/joint/joint_event.dart';
import 'package:fitcpxaluno/src/blocs/joint/joint_state.dart';
import 'package:fitcpxaluno/src/models/joint_model.dart';
import 'package:fitcpxaluno/src/services/joints_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JointBloc extends Bloc<JointEvent, JointState> {
  final JointsService jointsService;
  List<JointModel> _allJoints = [];

  JointBloc(this.jointsService) : super(JointInitial()) {
    on<LoadJoint>(_onLoadJoints);
  }

  Future<void> _onLoadJoints(LoadJoint event, Emitter<JointState> emit) async {
    try {
      final data = await jointsService.getJoints();
      _allJoints = data
          .map((e) => JointModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(JointLoaded(_allJoints));
    } catch (e) {
      emit(JointError('Error load exercises $e'));
    }
  }
}
