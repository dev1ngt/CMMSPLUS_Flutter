

import 'package:cmms/src/features/faultreport/fifthroom/model/request/room_request_model.dart';

sealed class FRFifthRoomEvent {}

class FRFifthRoomFetchEvent extends FRFifthRoomEvent{

  String requestId;
  FRFifthRoomFetchEvent(this.roomRequestModel, this.requestId);

  RoomRequestModel roomRequestModel = RoomRequestModel();
}
