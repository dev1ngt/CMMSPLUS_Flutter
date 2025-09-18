


import 'package:bloc/bloc.dart';
import '../../../api/api_service.dart';
import '../../request/list/bloc/request_list_state.dart';
import '../model/notification_list_model.dart';
import 'notification_list_event.dart';
import 'notification_list_state.dart';

class NotificationListBloc extends Bloc<NotificationListEvent, NotificationListState> {
  final ApiService requestRepo;
  NotificationListBloc(this.requestRepo) : super(NotificationListInitialState())
  {

    on<NotificationListLoadEvent>((event, emit) async{
      emit(NotificationListInitialState());
      print("You emitted first state test");
      try{
        final notificationList =  await requestRepo.getNotificationList();
        emit(NotificationListLoadedState(notificationList.notification));
      }catch(e){
        emit(NotificationListErrorState(e.toString()));
      }
    });


    on<NotificationClearEvent>((event, emit) async {
      emit(NotificationClearLoadingState());
      try {
        final response = await requestRepo.clearNotificationList(event.isRead);

        if (response.status) {
          emit(NotificationClearSuccessState(response.message));

          // Optionally reload list
          final notificationList = await requestRepo.getNotificationList();
          emit(NotificationListLoadedState(notificationList.notification));
        } else {
          emit(NotificationClearErrorState(response.message));
        }
      } catch (e) {
        emit(NotificationClearErrorState(e.toString()));
      }
    });



  }
}
