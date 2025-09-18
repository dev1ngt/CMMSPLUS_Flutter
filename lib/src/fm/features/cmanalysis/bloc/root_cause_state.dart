

import '../model/rootcause_response_model.dart';



sealed class RootCauseState {
}
/* Customer Data Load */
class RootCauseInitial extends RootCauseState {
}

class RootCauseInProgress extends RootCauseState {
}

class RootCauseLoaded extends RootCauseState{
  RootCauseLoaded(this.rootcause);
  final RootCauseResponse rootcause;
}

class RootCauseError extends RootCauseState{
  RootCauseError(this.error);
  final String error;
}


