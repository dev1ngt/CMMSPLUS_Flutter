import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/features/request/search/bloc/search_case_event.dart';
import 'package:cmms/src/features/request/search/bloc/search_case_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCasesBloc extends Bloc<SearchCasesEvent, SearchCasesState> {
  final ApiService repository;

  SearchCasesBloc(this.repository) : super(SearchCasesInitial()) {
    on<SearchCasesTextChanged>(_onTextChanged);
  }

  Future<void> _onTextChanged(
      SearchCasesTextChanged event, Emitter<SearchCasesState> emit) async {
    final query = event.query;
    final type = event.type;
    final propertyId = event.propertyId;
    final subType = event.subType;

    if (query.isEmpty) {
      emit(SearchCasesInitial());
      return;
    }

    emit(SearchCasesLoading());
    try {
      final results = await repository.getSearchCasesList(query: query, type: type, propertyId: propertyId, subType: subType);
      emit(SearchCasesLoaded(results));
    } catch (e) {
      emit(SearchCasesError("Failed to fetch search results"));
    }
  }
}
