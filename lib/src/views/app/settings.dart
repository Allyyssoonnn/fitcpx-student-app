import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_event.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/models/user_model.dart';
import 'package:fitcpxaluno/src/screens/events.dart';
import 'package:fitcpxaluno/src/screens/my_contracts.dart';
import 'package:fitcpxaluno/src/screens/workout_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  String? userName;
  String? userImg;
  String _version = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = "${info.version}+${info.buildNumber}";
    });
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name');
      userImg = prefs.getString('clientImg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemBackground.resolveFrom(
              context,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  UserModel? user;
                  if (state is AuthAuthenticated) user = state.user;

                  final bool isBlocked = user?.status == "B";

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          spacing: 10,
                          children: [
                            if (userImg != '')
                              ClipOval(
                                child: Image.network(
                                  userImg ?? 'https://placehold.co/400',
                                  height: 50,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 50,
                                          width: 50,
                                          alignment: Alignment.center,
                                          child:
                                              const CupertinoActivityIndicator(),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      // color: Colors.grey[300],
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        CupertinoIcons.person,
                                        size: 24,
                                        // color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              ClipOval(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  // color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    CupertinoIcons.person,
                                    size: 24,
                                  ),
                                ),
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName ?? 'userName'),
                                // Text(
                                //   'Ver perfil',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          height: 0.5,
                          color: CupertinoColors.separator.resolveFrom(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute(
                                    builder: (context) => MyContracts(),
                                  ),
                                ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 16,
                                  children: [
                                    Icon(FontAwesomeIcons.moneyBillWave),
                                    Text('Pagamentos'),
                                  ],
                                ),
                                Icon(CupertinoIcons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!isBlocked) ...[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () =>
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    CupertinoPageRoute(
                                      builder: (context) => WorkoutHistory(),
                                    ),
                                  ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 16,
                                    children: [
                                      Icon(FontAwesomeIcons.dumbbell),
                                      Text('Histórico de treinos'),
                                    ],
                                  ),
                                  Icon(CupertinoIcons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () =>
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    CupertinoPageRoute(
                                      builder: (context) => Events(),
                                    ),
                                  ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 16,
                                    children: [
                                      Icon(FontAwesomeIcons.calendar),
                                      Text('Agenda'),
                                    ],
                                  ),
                                  Icon(CupertinoIcons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () =>
                            context.read<AuthBloc>().add(AuthLoggedOut()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 16,
                              children: [
                                Icon(
                                  FontAwesomeIcons.rightFromBracket,
                                  color: CupertinoColors.destructiveRed,
                                ),
                                Text(
                                  'Sair da conta',
                                  style: TextStyle(
                                    color: CupertinoColors.destructiveRed,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              CupertinoIcons.chevron_right,
                              color: CupertinoColors.destructiveRed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text("Version: $_version", style: TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),
        )
        .animate()
        .slide(
          duration: 200.ms,
          curve: Curves.easeOut,
          begin: const Offset(0, 1),
          end: Offset.zero,
        )
        .fade(duration: 200.ms);
  }
}
