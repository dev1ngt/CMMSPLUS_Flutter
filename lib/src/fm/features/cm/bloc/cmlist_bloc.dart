import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';



import 'cmlist_event.dart';
import 'cmlist_state.dart';

class CMListBloc extends Bloc<CMListEvent, CMListState> {


  final ApiService repository;
  CMListBloc(this.repository) : super(CMListInitial()) {

    on<CMListCountEvent>((event, emit) async {
      emit(CMListLoading());
      try{
        final upload_status = await repository.getCMListMain(type: event.type);
        print(upload_status.toString());
        emit(CMListSuccessState(upload_status));
      }catch(e){
        emit(CMListFailureState(e.toString()));
        print(e);
      }
    });
  }
}
