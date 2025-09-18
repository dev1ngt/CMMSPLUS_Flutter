import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class DashboardEvent extends Equatable{

  const DashboardEvent();

  get screenMappingMobile => null;

}

class LoadDashboardEvent extends DashboardEvent {

  @override
  List<Object?> get props => [];
}

class LogoutEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}
