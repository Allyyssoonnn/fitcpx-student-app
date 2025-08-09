import 'dart:async';

import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/screens/exerciseInfo/exercise_info_body.dart';
import 'package:fitcpxaluno/src/screens/exerciseInfo/exercise_info_header.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseInfoScreen extends StatefulWidget {
  const ExerciseInfoScreen({
    super.key,
    required this.exerciseIndex,
    required this.allExercises,
  });

  final int exerciseIndex;
  final List<ExerciseModel> allExercises;

  @override
  State<ExerciseInfoScreen> createState() => _ExerciseInfoState();
}

class _ExerciseInfoState extends State<ExerciseInfoScreen> {
  late int _exerciseIndex;
  int? _exerciseSuperSetIndex;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _exerciseIndex = widget.exerciseIndex;
  }

  void _changeExercise(
    int newIndex,
    List<ExerciseModel> exercises,
    int? indexExerciseSuperSet,
  ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (indexExerciseSuperSet != null) {
      _debounce = Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _exerciseSuperSetIndex = indexExerciseSuperSet;
        });
      });
    } else {
      _debounce = Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _exerciseIndex = newIndex;
          _exerciseSuperSetIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return CustomScaffold(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: mediaHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: BlocBuilder<SessionBloc, SessionState>(
            builder: (context, state) {
              if (state is SessionError) {
                return Center(child: Text('Erro ${state.message}'));
              } else if (state is SessionInitial) {
                return const Center(child: Text('Sessão não carregada'));
              } else if (state is SessionLoaded) {
                final currentExercise =
                    state.session.exercises![_exerciseIndex];

                final sets = currentExercise.setsInfo ?? [];
                final allSuperSets = currentExercise.superSet ?? [];
                final currentSuperSet =
                    _exerciseSuperSetIndex == null ||
                        _exerciseSuperSetIndex == 0
                    ? null
                    : allSuperSets[_exerciseSuperSetIndex! - 1];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ExerciseInfoHeader(
                      key: ValueKey(currentExercise.cod_sessao_exercicio),
                      exercise: currentExercise,
                      exerciseSuperSet: currentSuperSet,
                      sessionExerciseLength: state.session.exercises!.length,
                      indexExerciseSelected: _exerciseIndex,
                      allExercises: state.session.exercises ?? [],
                      allSuperSets: allSuperSets,
                      changeExercise: _changeExercise,
                    ),
                    ExerciseInfoBody(
                      key: ValueKey(
                        'body ${currentExercise.cod_sessao_exercicio}',
                      ),
                      sets: sets,
                      exercise: currentExercise,
                      exerciseSuperSet: currentSuperSet,
                    ),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
