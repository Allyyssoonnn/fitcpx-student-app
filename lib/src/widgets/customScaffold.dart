import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.child,
    this.floatingActionButton,
    this.navigationBar,
  });

  final CupertinoNavigationBar? navigationBar;
  final Widget? floatingActionButton;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        // backgroundColor: const Color.fromRGBO(40, 167, 69, 1),
        navigationBar: navigationBar,
        resizeToAvoidBottomInset: true,
        child: Stack(
          children: [
            Container(
              // color: const Color.fromRGBO(40, 167, 69, 1),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: CupertinoColors.transparent,
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
            ),
            SafeArea(bottom: false, child: child!),
          ],
        ),
      ),
    );
  }
}
