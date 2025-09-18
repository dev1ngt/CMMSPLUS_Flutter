import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';


import 'cmdetails_event.dart';
import 'cmdetails_state.dart';

class CMDetailsBloc extends Bloc<CMDetailsEvent, CMDetailsState> {
  final ApiService repository;
  CMDetailsBloc(this.repository) : super(CMDetailsInitial()) {

    on<CMDetailsFetchEvent>((event, emit) async {
      emit(CMDetailsLoading());
      try{
        final upload_status = await repository.getCMDetails(cmid: event.cmID);
        emit(CMDetailsSuccessState(upload_status));
      }catch(e){
        emit(CMDetailsFailureState(e.toString()));
        print(e);
      }
    });
  }
}
