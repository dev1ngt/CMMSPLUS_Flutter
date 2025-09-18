

import '../model/adhoc_add_new_asset_model.dart';
import '../model/adhoc_add_new_space_floor_model.dart';
import '../model/adhoc_add_new_webview_model.dart';
import '../model/adhoc_addnew_view_model.dart';
import '../model/adhoc_inspection_submit_model.dart';

abstract class AdhocAddNewViewState {}

/* Show all records */
class AdhocAddNewViewInitState extends AdhocAddNewViewState {}

class AdhocAddNewViewLoadingState extends AdhocAddNewViewState {}

class AdhocAddNewViewLoadedState extends AdhocAddNewViewState {
  final AdhocAddNewViewResponseModel addNewViewResponseModel;

  AdhocAddNewViewLoadedState(this.addNewViewResponseModel);
  @override
  List<Object?> get props => [addNewViewResponseModel];
}

class AdhocAddNewViewErrorState extends AdhocAddNewViewState {
  final String errorMessage;

  AdhocAddNewViewErrorState(this.errorMessage);
}

/* Show webview */

class AdhocAddNewWebViewLoadingState extends AdhocAddNewViewState {}

class AdhocAddNewWebViewLoadedState extends AdhocAddNewViewState {
  final AdhocInspectionWebViewResponseModel adhocInspectionWebViewResponseModel;

  AdhocAddNewWebViewLoadedState(this.adhocInspectionWebViewResponseModel);
  @override
  List<Object?> get props => [adhocInspectionWebViewResponseModel];
}

class AdhocAddNewWebViewErrorState extends AdhocAddNewViewState {
  final String errorMessage;

  AdhocAddNewWebViewErrorState(this.errorMessage);
}

/* Space / Floor */


class AdhocAddNewSpaceFloorLoadingState extends AdhocAddNewViewState {}

class AdhocAddNewSpaceFloorLoadedState extends AdhocAddNewViewState {
  final AdhocAddNewSpaceFloorModel addNewSpaceFloorModel;

  AdhocAddNewSpaceFloorLoadedState(this.addNewSpaceFloorModel);
  @override
  List<Object?> get props => [addNewSpaceFloorModel];
}

class AdhocAddNewSpaceFloorErrorState extends AdhocAddNewViewState {
  final String errorMessage;

  AdhocAddNewSpaceFloorErrorState(this.errorMessage);
}

/*Asset */

class AdhocAddNewAssetLoadingState extends AdhocAddNewViewState {}

class AdhocAddNewAssetLoadedState extends AdhocAddNewViewState {
  final AdhocAddNewAssetModel addNewAssetModel;

  AdhocAddNewAssetLoadedState(this.addNewAssetModel);
  @override
  List<Object?> get props => [addNewAssetModel];
}

class AdhocAddNewAssetErrorState extends AdhocAddNewViewState {
  final String errorMessage;

  AdhocAddNewAssetErrorState(this.errorMessage);
}

  /* submit  */

class AdhocAddNewSubmitLoadingState extends AdhocAddNewViewState {}

class AdhocAddNewSubmitLoadedState extends AdhocAddNewViewState {
  final AdhocInspectionSubmitModel adhocInspectionSubmitModel;

  AdhocAddNewSubmitLoadedState(this.adhocInspectionSubmitModel);
  @override
  List<Object?> get props => [adhocInspectionSubmitModel];
}

class AdhocAddNewSubmitErrorState extends AdhocAddNewViewState {
  final String errorMessage;

  AdhocAddNewSubmitErrorState(this.errorMessage);
}