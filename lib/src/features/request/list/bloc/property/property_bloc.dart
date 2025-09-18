import 'dart:convert';

import 'package:bloc/bloc.dart';


import '../../../../../api/api_service.dart';
import 'property_event.dart';
import 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final ApiService repository;
  PropertyBloc(this.repository) : super(PropertyInitial()) {

    on<PropertyFetchEvent>((event, emit) async {
      emit(PropertyInitial());
      try{
        final upload_status = await repository.getUserProperty();
        emit(PropertySuccessState(upload_status));
      }catch(e){
        emit(PropertyFailureState(e.toString()));
        print(e);
      }
    });
  }
}
