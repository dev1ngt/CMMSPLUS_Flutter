sealed class FRFirstMenuEvent {}

class FRFirstMenuFetchEvent extends FRFirstMenuEvent {
  final String requestId;

  FRFirstMenuFetchEvent(this.requestId);
}
