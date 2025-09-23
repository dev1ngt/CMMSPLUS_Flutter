class PreferenceKeys {
  static const PreferenceKeys accessToken = PreferenceKeys._('ACCESS_TOKEN');
  static const PreferenceKeys loginToken = PreferenceKeys._('LOGIN_TOKEN');
  static const PreferenceKeys uniqueId = PreferenceKeys._('UNIQUE_ID');
  static const PreferenceKeys baseURL = PreferenceKeys._('BASE_URL');
  static const PreferenceKeys userObject = PreferenceKeys._('USER_OBJECT');
  static const PreferenceKeys username = PreferenceKeys._("USERNAME");
  static const PreferenceKeys firstname = PreferenceKeys._("FIRSTNAME");
  static const PreferenceKeys lastname = PreferenceKeys._("LASTNAME");
  static const PreferenceKeys password = PreferenceKeys._("PASSWORD");
  static const PreferenceKeys email = PreferenceKeys._("EMAIL");
  static const PreferenceKeys phone = PreferenceKeys._("PHONE");
  static const PreferenceKeys userid = PreferenceKeys._("USERID");
  static const PreferenceKeys is_pending_list_editable =
  PreferenceKeys._("IS_PENDING_LIST_EDITABLE");
  static const PreferenceKeys is_in_progress_list_editable =
  PreferenceKeys._("IS_IN_PROGRESS_LIST_EDITABLE");
  static const PreferenceKeys case_id = PreferenceKeys._("CASE_ID");
  static const PreferenceKeys case_id_name = PreferenceKeys._("CASE_ID_NAME");
  static const PreferenceKeys company_name = PreferenceKeys._("COMPANY_NAME");
  static const PreferenceKeys asset_name = PreferenceKeys._("ASSET_NAME");
  static const PreferenceKeys asset_id = PreferenceKeys._("ASSET_ID");
  static const PreferenceKeys property_name = PreferenceKeys._("PROPERTY_NAME");
  static const PreferenceKeys block_name = PreferenceKeys._("BLOCK_NAME");
  static const PreferenceKeys level_name = PreferenceKeys._("LEVEL_NAME");
  static const PreferenceKeys fault_type_name =
  PreferenceKeys._("FAULT_TYPE_NAME");
  static const PreferenceKeys fault_sub_type_name =
  PreferenceKeys._("FAULT_SUB_TYPE_NAME");
  static const PreferenceKeys before_photo_path =
  PreferenceKeys._("BEFORE_PATH_NAME");
  static const PreferenceKeys user_role = PreferenceKeys._("USER_ROLE");
  static const PreferenceKeys cause_of_fault =
  PreferenceKeys._("CAUSE_OF_FAULT");
  static const PreferenceKeys action_taken = PreferenceKeys._("ACTION_TAKEN");
  static const PreferenceKeys after_photo_path =
  PreferenceKeys._("AFTER_PHOTO_PATH");
  static const PreferenceKeys sign_path = PreferenceKeys._("SIGN_PATH");
  static const PreferenceKeys client_sign_path =
  PreferenceKeys._("CLIENT_SIGN_PATH");
  static const PreferenceKeys contract_code = PreferenceKeys._("CONTRACT_CODE");
  static const PreferenceKeys estimated_amount =
  PreferenceKeys._("ESTIMATED_AMOUNT");
  static const PreferenceKeys estimated_hrs =
  PreferenceKeys._("ESTIMATED_TIME");
  static const PreferenceKeys prominent_disclosure =
  PreferenceKeys._("PROMINENT_DISCLOSURE");
  static const PreferenceKeys prominent_disclosure_location =
  PreferenceKeys._("PROMINENT_DISCLOSURE_LOCATION");
  static const PreferenceKeys vendor_name = PreferenceKeys._('VENDOR_NAME');
  static const PreferenceKeys sub_schdule_id =
  PreferenceKeys._("SUB_SCHDULE_ID");
  static const PreferenceKeys description = PreferenceKeys._("DESCRIPTION");
  static const PreferenceKeys priority = PreferenceKeys._("PRIORITY");

  static const PreferenceKeys isbuttonvisible =
  PreferenceKeys._("IS_BUTTON_VISBLE");
  static const PreferenceKeys attach_url = PreferenceKeys._("ATTACH_URL");
  static const PreferenceKeys is_list = PreferenceKeys._("IS_LIST");
  static const PreferenceKeys requestid = PreferenceKeys._("REQUEST_ID");
  static const PreferenceKeys desc = PreferenceKeys._("DESC");

  static const PreferenceKeys subtype_id = PreferenceKeys._("SUBTYPE_ID");
  static const PreferenceKeys cmid  = PreferenceKeys._("CMID");
  static const PreferenceKeys ppmid = PreferenceKeys._("PPMID");
  static const PreferenceKeys client_token = PreferenceKeys._("CLIENT_TOKEN");
  static const PreferenceKeys token = PreferenceKeys._("TOKEN");

  final String text;
  const PreferenceKeys._(this.text);
  String getKey() => text;
}
