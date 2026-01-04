import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/models/session_model.dart';
import 'package:fitcpxaluno/src/screens/session_exercises.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SessionScreen extends StatelessWidget {
  final String nameWorkout;
  final List<SessionModel> sessions;

  SessionScreen({required this.nameWorkout, required this.sessions});

  Future<void> _onStartWorkout(
    BuildContext context,
    SessionModel session,
  ) async {
    try {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Deseja iniciar o treino?'),
          content: Text(session.name),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              isDestructiveAction: true,
              child: const Text('Cancelar'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                context.read<SessionBloc>().add(StartWorkout(session));
                context.read<TimerBloc>().add(StartTimer());
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) => SessionExerciseScreen(),
                  ),
                );
              },
              isDefaultAction: true,
              child: const Text('Confirmar'),
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
      navigationBar: const CupertinoNavigationBar(
        border: null,
        middle: Text('Sessões do treino'),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
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
            Text(
              'Sessões',
              style: TextStyle(
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 12),
              child: Container(
                height: 0.5,
                color: CupertinoColors.separator
                    .resolveFrom(context)
                    .resolveFrom(context),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];

                  return CupertinoCard(
                    onTap: () => _onStartWorkout(context, session),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey4.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            FontAwesomeIcons.dumbbell,
                            // size: 30,
                            size: 15,
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
                                  color: CupertinoColors.label.resolveFrom(
                                    context,
                                  ),
                                ),
                              ),
                              if (session.lastWorkout)
                                Text(
                                  "Último treino",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: CupertinoColors.systemGreen,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(CupertinoIcons.chevron_right),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
