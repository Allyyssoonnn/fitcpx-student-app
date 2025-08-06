import 'package:fitcpxaluno/src/models/contract_model.dart';

abstract class ContractState {}

class ContractInitial extends ContractState {}

class ContractLoaded extends ContractState {
  final List<ContractModel> contracts;

  ContractLoaded(this.contracts);
}

class ContractLoading extends ContractState {}

class ContractError extends ContractState {
  final String message;

  ContractError(this.message);
}
