

sealed class FRFourthLocationEvent {}

class FRFourthLocationFetchEvent extends FRFourthLocationEvent{

  String requestId;

  FRFourthLocationFetchEvent(this.requestId);

}

