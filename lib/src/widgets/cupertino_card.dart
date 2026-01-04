import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BoxBorder? border;

  const CupertinoCard({
    super.key,
    required this.child,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      decoration: BoxDecoration(
        border: border,
        color: CupertinoColors.tertiarySystemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(242, 245, 237, 1).withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(12),
          onPressed: onTap,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
