import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    required this.buttonText,
    required this.buttonDescription,
    required this.onTap,
    required this.icon,
    this.showBadge,
  });

  final String buttonText;
  final String buttonDescription;
  final VoidCallback onTap;
  final IconData icon;
  final bool? showBadge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    buttonDescription,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (showBadge == true)
              Positioned(
                top: 0,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  child: const Text(
                    style: TextStyle(color: Colors.white),
                    'Gratuito',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
