import 'package:fitcpxaluno/src/blocs/contract/contract_bloc.dart';
import 'package:fitcpxaluno/src/blocs/contract/contract_state.dart';
import 'package:fitcpxaluno/src/screens/view_payment_contract.dart';
import 'package:fitcpxaluno/src/widgets/backgroundAlert.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyContracts extends StatelessWidget {
  MyContracts({super.key});

  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: const CupertinoNavigationBar(
        border: null,
        middle: Text('Meus contratos'),
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
        child: BlocBuilder<ContractBloc, ContractState>(
          builder: (context, state) {
            if (state is ContractLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is ContractError) {
              return Center(child: Text(state.message));
            } else if (state is ContractLoaded) {
              if (state.contracts.isEmpty) {
                return BackgroundAlert(
                  text: "Nenhum contrato encontrado",
                  icon: FontAwesomeIcons.link,
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: state.contracts.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final contract = state.contracts[index];
                    return CupertinoCard(
                      onTap: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ViewPaymentContract(
                            key: UniqueKey(),
                            payments: contract.payments ?? [],
                            contract: contract,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey4.withOpacity(
                                0.3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              FontAwesomeIcons.paperclip,
                              // size: 30,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contract.description,
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
                                  'Status: ${contract.status}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.label.resolveFrom(
                                      context,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${contract.date} até ${contract.dueDate}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.label.resolveFrom(
                                      context,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${contract.id}',
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
                          Icon(CupertinoIcons.chevron_right),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
    );
  }
}
