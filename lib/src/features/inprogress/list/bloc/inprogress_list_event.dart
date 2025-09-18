

abstract class InProgressListEvent {


}

class FetchInProgressListEvent extends InProgressListEvent {
  final int pageNo , propertyID;
  FetchInProgressListEvent(this.pageNo, this.propertyID);
}
