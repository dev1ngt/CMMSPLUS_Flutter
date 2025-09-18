import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'ppm_list_event.dart';
import 'ppm_list_state.dart';

class PPMListBloc extends Bloc<PPMListEvent, PPMListState> {
  final ApiService repository;
  PPMListBloc(this.repository) : super(PPMListInitial()) {

    on<PPMListDataEvent>((event, emit) async {
      emit(PPMListLoading());
      try{
        final upload_status = await repository.getPPMListMain(type: event.type);
        print(upload_status.toString());
        emit(PPMListSuccessState(upload_status));
      }catch(e){
        emit(PPMListFailureState(e.toString()));
        print(e);
      }
    });
  }
}
