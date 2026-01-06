import 'package:flutter/cupertino.dart';

class BackgroundAlert extends StatelessWidget {
  final String text;
  final IconData icon;

  BackgroundAlert({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: CupertinoColors.systemGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
