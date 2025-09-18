import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'ppmdetails_event.dart';
import 'ppmdetails_state.dart';

class PPMDetailsBloc extends Bloc<PPMDetailsEvent, PPMDetailsState> {
  final ApiService repository;
  PPMDetailsBloc(this.repository) : super(PPMDetailsInitial()) {

    on<PPMDetailsFetchEvent>((event, emit) async {
      emit(PPMDetailsLoading());
      try{
        final upload_status = await repository.getPPMDetails1(ppmid: event.ppmID);
        emit(PPMDetailsSuccessState(upload_status));
      }catch(e){
        emit(PPMDetailsFailureState(e.toString()));
        print(e);
      }
    });
  }
}
