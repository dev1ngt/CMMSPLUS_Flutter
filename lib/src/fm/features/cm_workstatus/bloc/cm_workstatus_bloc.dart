import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';


import 'cm_workstatus_event.dart';
import 'cm_workstatus_state.dart';

class CMWorkStausBloc extends Bloc<CMWorkStatusEvent, CMWorkStatusState> {
  final ApiService repository;
  CMWorkStausBloc(this.repository) : super(CMWorkStatusInitial()) {

    on<CMWorkStatusCountEvent>((event, emit) async {
      emit(CMWorkStatusLoading());
      try{
        final upload_status = await repository.getCMListMain(type: event.type);
        print(upload_status.toString());
        emit(CMWorkStatusSuccessState(upload_status));
      }catch(e){
        emit(CMWorkStatusFailureState(e.toString()));
        print(e);
      }
    });
  }
}
