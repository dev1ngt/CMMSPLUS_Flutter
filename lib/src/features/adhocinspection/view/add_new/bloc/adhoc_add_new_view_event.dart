sealed class AdhocAddNewViewEvent {
  const AdhocAddNewViewEvent();
}


class AdhocAddNewViewItemEvent extends AdhocAddNewViewEvent {

  AdhocAddNewViewItemEvent();

}


class AdhocAddNewWebViewEvent extends AdhocAddNewViewEvent {

  int inspectionClass ;
  String token;
  AdhocAddNewWebViewEvent(this.inspectionClass,this.token);

}

class AdhocAddNewSpaceFloorFilterEvent extends AdhocAddNewViewEvent {

  int propertyID ;

  AdhocAddNewSpaceFloorFilterEvent(this.propertyID);

}

class AdhocAddNewAssetFilterEvent extends AdhocAddNewViewEvent {

  int propertyID ;

  AdhocAddNewAssetFilterEvent(this.propertyID);

}

class AdhocAddNewSubmitEvent extends AdhocAddNewViewEvent {


  int inspectionClass;
  String token;
  int property_id;
  int space_floor_id;
  int asset_id;
  String occupant;
  String location;

  AdhocAddNewSubmitEvent(this.inspectionClass, this.token, this.property_id, this.space_floor_id,
      this.asset_id, this.occupant, this.location);

}





