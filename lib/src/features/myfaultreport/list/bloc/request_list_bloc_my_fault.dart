import 'package:bloc/bloc.dart';

import '../../../../api/api_service.dart';
import '../../../myfaultreport/list/bloc/request_list_event_my_fault.dart';
import '../../../myfaultreport/list/bloc/request_list_state_my_fault.dart';

class MyFaultlistBloc extends Bloc<MyFaultlistEvent, MyFaultlistState> {
  final ApiService requestRepo;

  MyFaultlistBloc(this.requestRepo) : super(MyFaultlistInitialState()) {
    on<MyFaultlistLoadEvent>((event, emit) async {
      emit(MyFaultlistInitialState());
      print("You emitted first state test1");
      try {
        print("You emitted first state test3");
        final pendinglist =
        await requestRepo.getRequestList1(page: event.pageNo, reqId: event.reqId, type: event.type);
        emit(MyFaultlistLoadedState(pendinglist));
      } catch (e) {
        print("You emitted first state test2");
        emit(MyFaultlistErrorState(e.toString()));
      }
    });
  }
}
