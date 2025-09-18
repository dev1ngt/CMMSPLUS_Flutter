
import 'package:bloc/bloc.dart';

import '../../../../api/api_service.dart';
import 'notification_update_event.dart';
import 'notification_update_state.dart';

class NotificationUpdateBloc extends Bloc<NotificationUpdateEvent, NotificationUpdateState> {
  final ApiService requestRepo;
  NotificationUpdateBloc(this.requestRepo) : super(NotificationUpdateInitialState())
  {

    on<NotificationLoadUpdateEvent>((event,emit) {});

    on<NotificationListUpdateEvent>((event, emit) async{
      emit(NotificationUpdateInitialState());
      print("You emitted first state test");
      try{
        final notificationList =  await requestRepo.updateNotificationList(notifyid: event.notifyid);
        emit(NotificationUpdateLoadedState(notificationList));
      }catch(e){
        emit(NotificationUpdateErrorState(e.toString()));
      }
    });



  }
}