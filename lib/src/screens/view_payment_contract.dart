import 'package:fitcpxaluno/src/models/contract_model.dart';
import 'package:fitcpxaluno/src/models/contract_payment_model.dart';
import 'package:fitcpxaluno/src/services/contract_service.dart';
import 'package:fitcpxaluno/src/widgets/backgroundAlert.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void showCupertinoSnackBar(BuildContext context, String message) =>
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(content: Text(message)),
    );

class ViewPaymentContract extends StatefulWidget {
  final List<ContractPaymentModel> payments;
  final ContractModel contract;

  const ViewPaymentContract({
    super.key,
    required this.payments,
    required this.contract,
  });

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

  Future<void> _downloadContract(String? contractId) async {
    if (contractId == null) {
      return showCupertinoSnackBar(context, 'Não foi possível abrir o link');
    }
    final url = await ContractService().downloadContract(contractId);

    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      showCupertinoSnackBar(context, 'Não foi possível abrir o link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: const CupertinoNavigationBar(
        border: null,
        middle: Text('Pagamentos do contrato'),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            CupertinoCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.contract.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            // fontSize: 18,
                            fontSize: 14,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${widget.contract.status}',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.contract.date} até ${widget.contract.dueDate}',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${widget.contract.id}',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (widget.contract.statusContract != null)
                          Text(
                            widget.contract.statusContract!,
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.label.resolveFrom(context),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.contract.idContract ?? "Não consta contrato"}',
                          style: TextStyle(
                            fontSize: 8,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        if (widget.contract.idContract != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CupertinoButton.tinted(
                                  sizeStyle: CupertinoButtonSize.medium,
                                  child: const Text("Ver contrato"),
                                  onPressed: () {
                                    _downloadContract(
                                      widget.contract.idContract,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Container(
                height: 0.5,
                color: CupertinoColors.separator.resolveFrom(context),
              ),
            ),
            if (widget.payments.isEmpty)
              BackgroundAlert(
                text: "Nenhum pagamento encontrado",
                icon: FontAwesomeIcons.link,
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
                                      payment.status == 'succeeded' ||
                                      payment.status == 'receivedCash'
                                  ? CupertinoColors.activeGreen
                                  : CupertinoColors.activeOrange,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            payment.status == 'confirmed' ||
                                    payment.status == 'paid' ||
                                    payment.status == 'succeeded' ||
                                    payment.status == 'receivedCash'
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
                              if (payment.status == 'confirmed' ||
                                  payment.status == 'paid' ||
                                  payment.status == 'succeeded' ||
                                  payment.status == 'receivedCash')
                                Text(
                                  "Pago",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.systemGreen,
                                  ),
                                ),
                              if (payment.status != 'confirmed' &&
                                  payment.status != 'paid' &&
                                  payment.status != 'succeeded' &&
                                  payment.status != 'receivedCash')
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
