import 'package:fitcpxaluno/src/blocs/contract/contract_event.dart';
import 'package:fitcpxaluno/src/blocs/contract/contract_state.dart';
import 'package:fitcpxaluno/src/models/contract_model.dart';
import 'package:fitcpxaluno/src/services/contract_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final ContractService contractService;
  List<ContractModel> _allContracts = [];

  ContractBloc(this.contractService) : super(ContractInitial()) {
    on<LoadContract>(_onLoadContracts);
  }

  Future<void> _onLoadContracts(
    LoadContract event,
    Emitter<ContractState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id_client = prefs.getInt('id_client');

      if (id_client == null) {
        emit(ContractInitial());
        return;
      }

      final data = await contractService.getContracts(clientId: id_client);
      _allContracts = data
          .map((e) => ContractModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(ContractLoaded(_allContracts));
    } catch (e) {
      emit(ContractError('Error load contracts $e'));
    }
  }
}
