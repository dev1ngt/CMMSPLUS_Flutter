sealed class AdhocListEvent {}

class FetchAdhocListEvent extends AdhocListEvent {
  final String status_type;
  final int page_no;

  FetchAdhocListEvent({required this.status_type, required this.page_no});
}
