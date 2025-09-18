

sealed class ContractCodeEvent {
  const ContractCodeEvent();
}



class LoadContractCodeEvent extends ContractCodeEvent {
  String  contractCode ;
  LoadContractCodeEvent(this.contractCode);

}