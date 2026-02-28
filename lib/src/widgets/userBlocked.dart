import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserBlockedWarning extends StatelessWidget {
  final String? message;

  const UserBlockedWarning({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemOrange
            .resolveFrom(context)
            .withOpacity(0.1),
        border: Border.all(
          color: CupertinoColors.systemOrange
              .resolveFrom(context)
              .withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FontAwesomeIcons.circleExclamation,
            color: CupertinoColors.systemOrange.resolveFrom(context),
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            "Acesso Temporariamente Restrito",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Notamos que o seu perfil possui algumas restrições. Isso geralmente ocorre devido a uma pendência financeira ou a uma configuração feita pelo seu professor.\n\nPor favor, verifique seus pagamentos abaixo ou entre em contato com a equipe para regularizar seu acesso.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              height: 1.3, // Melhora o espaçamento das linhas
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Faça login novamente para atualizar",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              height: 1.3, // Melhora o espaçamento das linhas
            ),
          ),

          if (message!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
