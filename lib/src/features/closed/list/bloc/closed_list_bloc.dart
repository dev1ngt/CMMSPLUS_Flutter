import 'dart:convert';

import 'package:bloc/bloc.dart';
import '../../../../api/api_service.dart';

import 'closed_list_event.dart';
import 'closed_list_state.dart';

class ClosedListBloc extends Bloc<ClosedListEvent, ClosedListState> {
  final ApiService pendingRepository;

  ClosedListBloc(this.pendingRepository) : super(ClosedListInitialState()) {
    on<FetchClosedListEvent>((event, emit) async {
      emit(ClosedListInitialState());
      print("You emitted first state test");
      try {
        final pendinglist = await pendingRepository.getClosedList(
           propertyid: event.propertyid, page: event.pageno, reqId: event.reqId, );
        emit(ClosedListLoadedState(pendinglist));
      } catch (e) {
        emit(ClosedListErrorState(e.toString()));
      }
    });
  }
}
