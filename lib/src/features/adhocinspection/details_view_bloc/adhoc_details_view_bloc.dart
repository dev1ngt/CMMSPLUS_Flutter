

import 'dart:convert';

import 'package:bloc/bloc.dart';


import '../../../api/api_service.dart';

import '../model/adhoc_details_view_model.dart';
import 'adhoc_details_view_event.dart';
import 'adhoc_details_state.dart';



class AdhocDetailsViewBloc extends Bloc<AdhocDetailsViewEvent, AdhocDetailsViewState> {

  final ApiService pendingRepository;

  AdhocDetailsViewBloc(this.pendingRepository) : super(AdhocDetailsViewInitialState())
  {

    on<AdhocDetailsViewPageEvent>((event, emit) async{

        emit(AdhocDetailsViewLoadingState());
        print("You emitted first state test");
      try{
        final pendinglist =  await pendingRepository.getAdhocDetailsView(property_id: event.inspectionID);
        emit(AdhocDetailsViewLoadedState(pendinglist));
      }catch(e){
        emit(AdhocDetailsViewErrorState(e.toString()));
      }

    });

  }
}
