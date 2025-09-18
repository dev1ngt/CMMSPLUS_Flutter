



import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/features/qrscn/bloc/qrscan_event.dart';
import 'package:cmms/src/features/qrscn/bloc/qrscan_state.dart';



class QRScanBloc extends Bloc<QRScanEvent, QRScanState> {
  final ApiService repository;

  QRScanBloc(this.repository) : super(QRScanStateInitial()) {
    on<QRScanEventInit>((event, emit) {});




  }
}