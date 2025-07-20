import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomScaffoldApp extends StatelessWidget {
  const CustomScaffoldApp({
    super.key,
    this.child,
    required this.currentLocation,
  });
  final Widget? child;
  final String currentLocation;

  static const routes = ['/home', '/settings'];

  @override
  Widget build(BuildContext context) {
    final index = routes.indexWhere((t) => currentLocation.startsWith(t));

    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 167, 69, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 167, 69, 1),
        elevation: 0,
        // title: const Text('FitCpx App'),
      ),
      // appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      // extendBodyBehindAppBar: true,
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 55,
        // backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black12,
        selectedIndex: index >= 0 ? index : 0,
        onDestinationSelected: (i) {
          if (index != i) context.go(routes[i]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Minha conta',
          ),
        ],
      ),
    );
  }
}
