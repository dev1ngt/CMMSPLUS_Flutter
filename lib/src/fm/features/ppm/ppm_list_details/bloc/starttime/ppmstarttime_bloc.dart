import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'ppmstarttime_event.dart';
import 'ppmstarttime_state.dart';

class PPMStartTimeBloc extends Bloc<PPMStartTimeEvent, PPMStartTimeState> {
  final ApiService repository;
  PPMStartTimeBloc(this.repository) : super(PPMStartTimeInitial()) {

    on<PPMStartTimeFetchEvent>((event, emit) async {
      emit(PPMStartTimeLoading());
      try{
        final upload_status = await repository.getPPMStartTime(starttime: event.startTime, ppmid: event.PPMID);
        emit(PPMStartTimeSuccessState(upload_status));
      }catch(e){
        emit(PPMStartTimeFailureState(e.toString()));
        print(e);
      }
    });
  }
}
