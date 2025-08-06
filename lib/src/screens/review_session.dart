import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewSessionScreen extends StatelessWidget {
  const ReviewSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.check),
        label: const Text('Confirmar'),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        width: double.infinity,
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
              final session = state.session;
              final exercises = session.exercises;

              return Column(
                children: [
                  Text(
                    session.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: exercises!.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: exercise.setsInfo!.length,
                                      itemBuilder: (context, index) {
                                        final set = exercise.setsInfo![index];

                                        return Row(
                                          children: [
                                            if (set.checked)
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 18,
                                              )
                                            else
                                              Icon(
                                                Icons.close,
                                                color: Colors.redAccent,
                                                size: 18,
                                              ),
                                            const SizedBox(width: 8),
                                            Text('${set.id.toString()}ª Série'),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${set.repetition.toString()}x',
                                            ),
                                            const SizedBox(width: 8),
                                            Text('${set.weight.toString()}kg'),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              exercise.setsInfo!.every((s) => s.checked)
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 18,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: Colors.redAccent,
                                      size: 18,
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }

            return const Center(child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
