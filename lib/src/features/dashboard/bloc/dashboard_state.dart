import 'package:cmms/src/features/dashboard/model/logout_response_model.dart';

import '../model/dasboard_count_model.dart';

abstract class DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadedState extends DashboardState {
  final DashboardMenuVisibleResponseModel screenMappingMobile;
  final bool isLoggingOut;

  DashboardLoadedState(
      this.screenMappingMobile, {
        this.isLoggingOut = false,
      });

  DashboardLoadedState copyWith({
    DashboardMenuVisibleResponseModel? screenMappingMobile,
    bool? isLoggingOut,
  }) {
    return DashboardLoadedState(
      screenMappingMobile ?? this.screenMappingMobile,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => [screenMappingMobile, isLoggingOut];
}


class DashboardErrorState extends DashboardState {
  final String errorMessage;

  DashboardErrorState(this.errorMessage);
}

class LogoutLoadingState extends DashboardState {}

class LogoutSuccessState extends DashboardState {
  final LogoutResponseModel logoutResponseModel;

  LogoutSuccessState(this.logoutResponseModel);

  @override
  List<Object> get props => [logoutResponseModel];
}

class LogoutErrorState extends DashboardState {
  final String errorMessage;

  LogoutErrorState(this.errorMessage);
}
