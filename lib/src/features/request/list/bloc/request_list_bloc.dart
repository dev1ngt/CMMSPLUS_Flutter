


import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/request/list/bloc/request_list_event.dart';
import 'package:cmms/src/features/request/list/bloc/request_list_state.dart';

import '../../../../api/api_service.dart';

class RequestListBloc extends Bloc<RequestListEvent, RequestListState> {

  final ApiService requestRepo;

  RequestListBloc(this.requestRepo) : super(RequestListInitialState())
  {

    on<RequestListLoadEvent>((event, emit) async{

      emit(RequestListInitialState());
      print("You emitted first state test");
      try{
        final pendinglist =  await requestRepo.getRequestList(propertyid: event.propertyid, type: event.type, reqId: event.reqId, page: event.pageno );
        emit(RequestListLoadedState(pendinglist));
      }catch(e){
        emit(RequestListErrorState(e.toString()));
      }

    });

  }
}
