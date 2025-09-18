



import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/fm/features/tenant/complaint_reg/bloc/complaint_reg_event.dart';
import 'package:cmms/src/fm/features/tenant/complaint_reg/bloc/complaint_reg_state.dart';




class ComplaintRegisterBloc extends Bloc<ComplaintRegisterEvent, ComplaintRegisterState> {

  final ApiService pendingRepository;

  ComplaintRegisterBloc(this.pendingRepository) : super(ComplaintRegisterInitial()) {

    /* Customer Data Load*/
    on<ComplaintRegisterFetchEvent>((event, emit) async {
      emit(ComplaintRegisterInProgress());
      try {
        final findtype = await pendingRepository.getComplaintReg();
        emit(ComplaintRegisterLoaded(findtype));
      }catch(e){
        emit(ComplaintRegisterError(e.toString()));
      }
    });


    /* Submit */

    on<ComplaintRegisterSubmitEvent>((event, emit) async {
      emit(ComplaintRegisterSubmitInProgress());
      try {
        final findtype = await pendingRepository.putComplaintRegSubmit(complaintSubmitInput: event.complaintSubmitInput);
        emit(ComplaintRegisterSubmitLoaded(findtype));
      }catch(e){
        emit(ComplaintRegisterSubmitError(e.toString()));
      }
    });

  }
}