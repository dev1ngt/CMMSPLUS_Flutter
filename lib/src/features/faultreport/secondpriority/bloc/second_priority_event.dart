

sealed class FRSecondPriorityEvent {}

class FRSecondPriorityFetchEvent extends FRSecondPriorityEvent{

  FRSecondPriorityFetchEvent();

}


class FRSecondPrioritySaveData extends FRSecondPriorityEvent {

  FRSecondPrioritySaveData();
}