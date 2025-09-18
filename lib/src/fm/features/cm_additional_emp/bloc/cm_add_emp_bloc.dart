import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';


import 'cm_add_emp_event.dart';
import 'cm_add_emp_state.dart';

class CMAddEmpBloc extends Bloc<CMAddEmpEvent, CMAddEmpState> {
  final ApiService repository;
  CMAddEmpBloc(this.repository) : super(CMAddEmpInitial()) {

    on<CMAddEmpFetchEvent>((event, emit) async {
      emit(CMAddEmpLoading());
      try{
        final upload_status = await repository.getCMAdditionalEmp(cmid: event.cmID);
        emit(CMAddEmpSuccessState(upload_status));
      }catch(e){
        emit(CMAddEmpFailureState(e.toString()));
        print(e);
      }
    });
  }
}
