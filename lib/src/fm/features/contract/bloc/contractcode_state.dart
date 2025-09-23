


import '../model/contractcode_response_model.dart';
import '../view/contractcode.dart';

abstract class ContractCodeState {}

class ContractCodeInitState extends ContractCodeState {}

class ContractCodeLoadingState extends ContractCodeState {}

class ContractCodeLoadedState extends ContractCodeState {
  final Contract screenMappingMobile;

  ContractCodeLoadedState(this.screenMappingMobile);
  @override
  List<Object?> get props => [screenMappingMobile];
}

class ContractCodeErrorState extends ContractCodeState {
  final String errorMessage;

  ContractCodeErrorState(this.errorMessage);
}