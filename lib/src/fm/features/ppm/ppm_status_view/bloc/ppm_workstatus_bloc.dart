import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'ppm_workstatus_event.dart';
import 'ppm_workstatus_state.dart';

class PPMWorkStausBloc extends Bloc<PPMWorkStatusEvent, PPMWorkStatusState> {
  final ApiService repository;
  PPMWorkStausBloc(this.repository) : super(PPMWorkStatusInitial()) {

    on<PPMWorkStatusCountEvent>((event, emit) async {
      emit(PPMWorkStatusLoading());
      try{
        final upload_status = await repository.getPPMStatus(type: event.type);
        print(upload_status.toString());
        emit(PPMWorkStatusSuccessState(upload_status));
      }catch(e){
        emit(PPMWorkStatusFailureState(e.toString()));
        print(e);
      }
    });
  }
}
