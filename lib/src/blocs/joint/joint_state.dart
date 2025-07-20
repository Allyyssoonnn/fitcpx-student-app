import 'package:fitcpxapp/src/models/joint_model.dart';

abstract class JointState {}

class JointInitial extends JointState {}

class JointLoading extends JointState {}

class JointLoaded extends JointState {
  final List<JointModel> joints;

  JointLoaded(this.joints);
}

class JointError extends JointState {
  final String message;

  JointError(this.message);
}
