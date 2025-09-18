import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';


import 'cm_material_event.dart';
import 'cm_material_state.dart';

class CMMaterialBloc extends Bloc<CMMaterialEvent, CMMaterialStateI> {
  final ApiService repository;
  CMMaterialBloc(this.repository) : super(CMMaterialInitial()) {

    on<CMMaterialFetchEvent>((event, emit) async {
      emit(CMMaterialLoading());
      try{
        final upload_status = await repository.getCMMaterialEmp(cmid: event.cmID);
        emit(CMMaterialSuccessState(upload_status));
      }catch(e){
        emit(CMMaterialFailureState(e.toString()));
        print(e);
      }
    });
  }
}
