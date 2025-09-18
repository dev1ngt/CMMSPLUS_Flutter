import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'ppm_add_emp_event.dart';
import 'ppm_add_emp_state.dart';

class PPMAddEmpBloc extends Bloc<PPMAddEmpEvent, PPMAddEmpState> {
  final ApiService repository;
  PPMAddEmpBloc(this.repository) : super(PPMAddEmpInitial()) {

    on<PPMAddEmpFetchEvent>((event, emit) async {
      emit(PPMAddEmpLoading());
      try{
        final upload_status = await repository.getPPMAdditionalEmp(ppmid: event.ppmid);
        emit(PPMAddEmpSuccessState(upload_status));
      }catch(e){
        emit(PPMAddEmpFailureState(e.toString()));
        print(e);
      }
    });
  }
}
