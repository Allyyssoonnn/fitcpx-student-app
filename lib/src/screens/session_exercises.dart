import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/screens/review_session.dart';
import 'package:fitcpxaluno/src/views/auth/exercise_info.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionExerciseScreen extends StatelessWidget {
  SessionExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewSessionScreen(key: UniqueKey()),
            ),
          );
        },
        icon: const Icon(Icons.add_chart),
        label: const Text('Finalizar'),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            if (state is SessionError) {
              return Center(
                child: Text('Erro ao carregar sessão ${state.message}'),
              );
            } else if (state is SessionInitial) {
              return Center(child: Text('Sessão não carregada'));
            } else if (state is SessionLoaded) {
              final session = state.session;

              return Column(
                children: [
                  Text(
                    session.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Exercícios'),
                  Divider(),
                  if (session.exercises is List<ExerciseModel>)
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: session.exercises!.length,
                        itemBuilder: (context, index) {
                          final exercise = session.exercises![index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black.withOpacity(0.1),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseInfoScreen(
                                    key: UniqueKey(),
                                    exerciseIndex: index,
                                  ),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: Theme.of(context)
                                    //         .colorScheme
                                    //         .primary
                                    //         .withOpacity(0.1),
                                    //     borderRadius: BorderRadius.circular(
                                    //       12,
                                    //     ),
                                    //   ),
                                    //   padding: const EdgeInsets.all(12),
                                    //   child: Icon(
                                    //     Icons.fitness_center,
                                    //     // size: 30,
                                    //     size: 15,
                                    //     color: Theme.of(
                                    //       context,
                                    //     ).colorScheme.primary,
                                    //   ),
                                    // ),
                                    // const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exercise.nome_exercicio,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              // fontSize: 18,
                                              fontSize: 14,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Switch(
                                      value: exercise.setsInfo!.every(
                                        (s) => s.checked,
                                      ),
                                      onChanged: (bool value) {
                                        context.read<SessionBloc>().add(
                                          CheckExerciseSession(
                                            value,
                                            exercise.cod_exercicio,
                                          ),
                                        );
                                      },
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
