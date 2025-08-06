import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/models/session_model.dart';
import 'package:fitcpxaluno/src/screens/session_exercises.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionScreen extends StatelessWidget {
  final int idWorkout;
  final String nameWorkout;
  final _WorkoutService = WorkoutService();

  SessionScreen({required this.idWorkout, required this.nameWorkout});

  Future<List<SessionModel>> _getSessions() async {
    return await _WorkoutService.getSessions(id_workout: idWorkout);
  }

  Future<void> _onStartWorkout(
    BuildContext context,
    SessionModel session,
  ) async {
    try {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Deseja iniciar o treino?'),
          content: Text(session.name),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<SessionBloc>().add(StartWorkout(session));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => SessionExerciseScreen(),
                  ),
                );
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Text(
              nameWorkout,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Sessões'),
            Divider(),
            FutureBuilder(
              future: _getSessions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar os dados'));
                }

                final sessions = snapshot.data;
                if (sessions!.isEmpty) {
                  return Center(child: Text('Nenhuma sessão encontrada'));
                }

                return Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                        child: InkWell(
                          onTap: () => _onStartWorkout(context, session),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.fitness_center,
                                    // size: 30,
                                    size: 15,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        session.name,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
