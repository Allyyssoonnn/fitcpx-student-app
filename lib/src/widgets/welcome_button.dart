import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    required this.buttonText,
    required this.buttonDescription,
    required this.onTap,
    required this.icon,
    this.color,
    this.labelColor,
    this.showBadge,
    this.messageBadge,
  });

  final String buttonText;
  final String buttonDescription;
  final VoidCallback onTap;
  final IconData icon;
  final Color? color;
  final Color? labelColor;
  final bool? showBadge;
  final String? messageBadge;

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
                color:
                    color ??
                    CupertinoColors.tertiarySystemBackground.resolveFrom(
                      context,
                    ),
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
                  Icon(icon, color: labelColor),
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    buttonDescription,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (messageBadge != null)
              Positioned(
                top: 0,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  child: Text(
                    style: const TextStyle(color: Colors.white),
                    messageBadge ?? "",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
