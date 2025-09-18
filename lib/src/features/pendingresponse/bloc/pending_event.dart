
sealed class InProgressEvent {
}

class FetchInProgressEvent extends InProgressEvent {
  final int pageNo , propertyID;
  FetchInProgressEvent(this.pageNo , this.propertyID);
}



