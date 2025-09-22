import 'package:fitcpxaluno/src/models/contract_payment_model.dart';
import 'package:fitcpxaluno/src/services/contract_service.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Não foi possível abrir o link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Text('Pagamentos'),
            Divider(),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.payments.length,
                itemBuilder: (context, index) {
                  final payment = widget.payments[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    payment.status == 'confirmed' ||
                                        payment.status == 'paid' ||
                                        payment.status == 'succeeded'
                                    ? Colors.green
                                    : Colors.orange,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              payment.status == 'confirmed' ||
                                      payment.status == 'paid' ||
                                      payment.status == 'succeeded'
                                  ? Icons.check_circle
                                  : Icons.pending,
                              // size: 30,
                              size: 15,
                              color: Theme.of(context).colorScheme.primary,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Valor: R\$ ${payment.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (payment.status != 'confirmed' &&
                                    payment.status != 'paid' &&
                                    payment.status != 'succeeded')
                                  Container(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.green,
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        foregroundColor: Colors.green,
                                      ),
                                      onPressed: () =>
                                          _launchUrl(payment.invoiceUrl),
                                      child: Text('Pagar agora'),
                                    ),
                                  ),
                                Text(
                                  'ID: ${payment.id}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
