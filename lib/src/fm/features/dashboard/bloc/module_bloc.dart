import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'module_event.dart';
import 'module_state.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  final ApiService repository;
  ModuleBloc(this.repository) : super(ModuleInitial()) {

    on<ModuleCountEvent>((event, emit) async {
      emit(ModuleLoading());
      try{
        final upload_status = await repository.getModuleCount();
        emit(ModuleSuccessState(upload_status));
      }catch(e){
        emit(ModuleFailureState(e.toString()));
        print(e);
      }
    });
  }
}
