import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';


import 'ppm_checkpoint_event.dart';
import 'ppm_checkpoint_state.dart';

class PPMCheckpointBloc extends Bloc<PPMCheckpointEvent, PPMCheckpointState> {
  final ApiService repository;
  PPMCheckpointBloc(this.repository) : super(PPMCheckpointInitial()) {

    on<PPMCheckpointFetchEvent>((event, emit) async {
      emit(PPMCheckpointLoading());
      try{
        final upload_status = await repository.getPPMCheckpoint(ppmid: event.ppmID);
        emit(PPMCheckpointSuccessState(upload_status));
      }catch(e){
        emit(PPMCheckpointFailureState(e.toString()));
        print(e);
      }
    });
  }
}
