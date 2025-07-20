import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            color: const Color.fromRGBO(40, 167, 69, 1),
            // color: Colors.green,
            width: double.infinity,
            height: double.infinity,
          ),
          // Image.asset(
          //   "assets/images/bg2.png",
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          SafeArea(child: child!, bottom: false),
        ],
      ),
    );
  }
}
