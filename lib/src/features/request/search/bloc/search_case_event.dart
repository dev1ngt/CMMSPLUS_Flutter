abstract class SearchCasesEvent {}

class SearchCasesTextChanged extends SearchCasesEvent {
  final String query, type, subType;
  final int propertyId;

  SearchCasesTextChanged(this.query, this.type, this.propertyId, this.subType);
}
