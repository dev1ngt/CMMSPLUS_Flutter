



import 'package:flutter/cupertino.dart';

@immutable
sealed class RemarksState {}

final class RemarksInitial extends RemarksState {}


class BlocButtonClickedState extends RemarksState {
  BlocButtonClickedState();
}