

sealed class PPMListEvent {}

class FetchPPMListEvent extends PPMListEvent{

   final String status_type;

   FetchPPMListEvent(
   {required this.status_type});

}
