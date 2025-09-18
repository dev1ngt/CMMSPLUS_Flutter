



import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'rootcause_event.dart';
import 'root_cause_state.dart';

class RootCauseBloc extends Bloc<RootCauseEvent, RootCauseState> {

  final ApiService pendingRepository;

  RootCauseBloc(this.pendingRepository) : super(RootCauseInitial()) {

    /* Customer Data Load*/
    on<RootCauseFetchEvent>((event, emit) async {
      emit(RootCauseInProgress());
      try {
        final findtype = await pendingRepository.getRootCause();
        emit(RootCauseLoaded(findtype));
      }catch(e){
        emit(RootCauseError(e.toString()));
      }
    });

  }
}