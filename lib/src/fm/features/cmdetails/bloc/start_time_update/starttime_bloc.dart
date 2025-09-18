import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'starttime_event.dart';
import 'starttime_state.dart';

class StartTimeBloc extends Bloc<StartTimeEvent, StartTimeState> {
  final ApiService repository;
  StartTimeBloc(this.repository) : super(StartTimeInitial()) {

    on<StartTimeFetchEvent>((event, emit) async {
      emit(StartTimeLoading());
      try{
        final upload_status = await repository.getStartTime(starttime: event.startTime, cmid: event.CMID);
        emit(StartTimeSuccessState(upload_status));
      }catch(e){
        emit(StartTimeFailureState(e.toString()));
        print(e);
      }
    });
  }
}
