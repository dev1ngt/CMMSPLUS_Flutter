

sealed class PPMCompletedEvent {}

class PPMCompletedInitEvent extends PPMCompletedEvent{}

class PPMCompletedStartEvent extends PPMCompletedEvent{

  final String sub_schedule_id;

  PPMCompletedStartEvent({
    required this.sub_schedule_id,

  });

}



