import 'location_state.dart';

class BatteryTooLowState extends LocationState {
  final String message;

  BatteryTooLowState({required this.message});

  @override
  List<Object?> get props => [message];
}
