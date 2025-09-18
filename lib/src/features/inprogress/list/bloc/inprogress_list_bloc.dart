



import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'inprogress_list_event.dart';
import 'inprogress_list_state.dart';

class InProgressListBloc extends Bloc<InProgressListEvent, InProgressListState> {

  final ApiService inProgressRepository;

  InProgressListBloc(this.inProgressRepository) : super(InProgressListLoadingState()) {

    on<InProgressListEvent>((event, emit) {});
    on<FetchInProgressListEvent>((event, emit) async{

      emit(InProgressListLoadingState());
      print("You emitted first state test");
      try{
        final pendinglist =  await inProgressRepository.getInProgressList(page: event.pageNo, propertyid: event.propertyID);
        emit(InProgressListLoadedState(pendinglist));
      }catch(e){
        emit(InProgressListErrorState(e.toString()));
      }

    });

}}