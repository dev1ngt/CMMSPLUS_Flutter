


import 'package:flutter/cupertino.dart';

import '../model/response/room_response_model.dart';

@immutable
sealed class FRFifthRoomState {}

class FRFifthRoomInitial extends FRFifthRoomState {}


class FRFifthRoomLoaded extends FRFifthRoomState{
  FRFifthRoomLoaded(this.roomlist);
  final RoomResponse roomlist;

}

class FRFifthRoomError extends FRFifthRoomState{
  FRFifthRoomError(this.error);
  final String error;
}