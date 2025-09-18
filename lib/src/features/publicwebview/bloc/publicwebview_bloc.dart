

import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/publicwebview/bloc/publicwebview_event.dart';
import 'package:cmms/src/features/publicwebview/bloc/publicwebview_state.dart';

import '../../../api/api_service.dart';

class PublicWebviewBloc extends Bloc<PublicWebviewEvent, PublicWebviewState> {
  final ApiService repository;

  PublicWebviewBloc(this.repository) : super(PublicWebviewInitial()) {
    on<PublicWebviewEventInit>((event, emit) {});

    on<PublicWebviewQRScanResult>((event, emit) async {
      emit(PublicWebviewScanLoad());

      try {
        final response = await repository.getPublicWeblink(
            asset_code: event.asset_code);

        if (response.status) {
          emit(PublicWebviewSuccess(response));
        } else {
          emit(PublicWebviewSuccess(response));
        }
      } catch (e) {
        emit(PublicWebviewFailure(e.toString()));
      }

});}}