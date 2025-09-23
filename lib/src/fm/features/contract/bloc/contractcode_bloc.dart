



import 'package:bloc/bloc.dart';


import '../../../../api/api_service.dart';
import 'contractcode_event.dart';
import 'contractcode_state.dart';

class ContractCodeBloc extends Bloc<ContractCodeEvent, ContractCodeState> {
  //final DashboardRepository repository;
  final ApiService repository;

  ContractCodeBloc(this.repository) : super(ContractCodeInitState()) {


    on<LoadContractCodeEvent>((event, emit) async {
      emit(ContractCodeLoadingState());
      print("You emitted first state test");
      try {
        final pendinglist = await repository.getEndpointFM(contractCode: event.contractCode);
        emit(ContractCodeLoadedState(pendinglist));
      } catch (e) {
        emit(ContractCodeErrorState(e.toString()));
      }
    });
  }
}