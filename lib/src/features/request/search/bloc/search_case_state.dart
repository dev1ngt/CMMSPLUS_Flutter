import '../model/search_response_model.dart';

abstract class SearchCasesState {}

class SearchCasesInitial extends SearchCasesState {}

class SearchCasesLoading extends SearchCasesState {}

class SearchCasesLoaded extends SearchCasesState {
  final SearchResponseModel searchResponseModel;

  SearchCasesLoaded(this.searchResponseModel);
}

class SearchCasesError extends SearchCasesState {
  final String message;

  SearchCasesError(this.message);
}
