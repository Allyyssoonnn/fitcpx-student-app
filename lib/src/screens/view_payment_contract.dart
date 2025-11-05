import 'package:fitcpxaluno/src/models/contract_payment_model.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

void showCupertinoSnackBar(BuildContext context, String message) =>
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(content: Text(message)),
    );

class ViewPaymentContract extends StatefulWidget {
  final List<ContractPaymentModel> payments;

  const ViewPaymentContract({super.key, required this.payments});

  @override
  State<ViewPaymentContract> createState() => _viewPaymentContractState();
}

class _viewPaymentContractState extends State<ViewPaymentContract> {
  Future<void> _launchUrl(String url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      showCupertinoSnackBar(context, 'Não foi possível abrir o link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
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
              'Pagamentos',
              style: TextStyle(
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 12),
              child: Container(height: 0.5, color: CupertinoColors.separator),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.payments.length,
                itemBuilder: (context, index) {
                  final payment = widget.payments[index];

                  return CupertinoCard(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey4.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  payment.status == 'confirmed' ||
                                      payment.status == 'paid' ||
                                      payment.status == 'succeeded'
                                  ? CupertinoColors.activeGreen
                                  : CupertinoColors.activeOrange,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            payment.status == 'confirmed' ||
                                    payment.status == 'paid' ||
                                    payment.status == 'succeeded'
                                ? CupertinoIcons.check_mark
                                : CupertinoIcons.arrow_2_circlepath,
                            // size: 30,
                            size: 15,
                            color: CupertinoColors.activeGreen,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                payment.dueDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  // fontSize: 18,
                                  fontSize: 14,
                                  color: CupertinoColors.label.resolveFrom(
                                    context,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Valor: R\$ ${payment.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.label.resolveFrom(
                                    context,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (payment.status != 'confirmed' &&
                                  payment.status != 'paid' &&
                                  payment.status != 'succeeded')
                                Container(
                                  width: double.infinity,
                                  child: CupertinoButton.tinted(
                                    sizeStyle: CupertinoButtonSize.medium,
                                    color: CupertinoColors.activeGreen,
                                    onPressed: () =>
                                        _launchUrl(payment.invoiceUrl),
                                    child: Text(
                                      'Pagar agora',
                                      style: TextStyle(
                                        color: CupertinoColors.activeGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              Text(
                                'ID: ${payment.id}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: CupertinoColors.label.resolveFrom(
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
