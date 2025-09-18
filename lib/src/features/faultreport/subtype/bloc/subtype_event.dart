
import '../model/request/subtype_request_model.dart';

sealed class SubtypeEvent {}

class SubtypeFetchEvent extends SubtypeEvent{

  SubtypeRequestModel subtypeRequestModel;
  String requestId;
  SubtypeFetchEvent(this.subtypeRequestModel, this.requestId);

}