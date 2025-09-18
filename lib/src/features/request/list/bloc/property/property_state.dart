

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../pendingresponse/model/property_model.dart';



@immutable
abstract class PropertyState extends Equatable{}

 class PropertyInitial extends PropertyState {
   @override
   List<Object?> get props => [];
 }

class PropertyLoading extends PropertyState{
  @override
  List<Object?> get props => [];
}

class PropertySuccessState extends PropertyState {
  PropertyModel moduleResponse;
  PropertySuccessState(this.moduleResponse);

  @override
  List<Object> get props => [moduleResponse];
}

class PropertyFailureState extends PropertyState {
  PropertyFailureState(this.loginError);
  String loginError = '';
  @override
  List<Object> get props => [loginError];
}



