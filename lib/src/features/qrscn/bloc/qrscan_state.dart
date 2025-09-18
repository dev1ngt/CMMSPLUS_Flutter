import 'package:flutter/cupertino.dart';

@immutable
sealed class QRScanState {}


class QRScanStateInitial extends QRScanState {}