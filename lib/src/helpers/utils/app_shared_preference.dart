import 'package:cmms/src/helpers/utils/preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs {
  static final AppSharedPrefs _repo = AppSharedPrefs();
  static AppSharedPrefs get() => _repo;

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> addValue(PreferenceKeys preferenceKeys, String text) async {
    SharedPreferences prefs = await getSharedPrefs();
    await prefs.setString(preferenceKeys.getKey(), text);
  }

  Future<void> addBoolean(PreferenceKeys preferenceKeys, bool value) async {
    SharedPreferences prefs = await getSharedPrefs();
    await prefs.setBool(preferenceKeys.getKey(), value);
  }

  Future<void> addInt(PreferenceKeys preferenceKeys, int value) async {
    SharedPreferences prefs = await getSharedPrefs();
    await prefs.setInt(preferenceKeys.getKey(), value);
  }

  Future<String?> getValue(PreferenceKeys preferenceKeys) async {
    SharedPreferences prefs = await getSharedPrefs();
    return prefs.getString(preferenceKeys.getKey());
  }

  Future<int> getInt(PreferenceKeys preferenceKeys) async {
    SharedPreferences prefs = await getSharedPrefs();
    return prefs.getInt(preferenceKeys.getKey())!;
  }

  Future<bool> getBoolean(PreferenceKeys preferenceKeys) async {
    SharedPreferences prefs = await getSharedPrefs();
    return prefs.getBool(preferenceKeys.getKey()) ?? false;
  }

  Future<bool> clearSharedPreference() async {
    SharedPreferences prefs = await getSharedPrefs();
    await prefs.clear();
    return true;
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> setAccessToken(String accessToken) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.accessToken, accessToken);
  }

  static Future<String> getAccessToken() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.accessToken) ??
        '';
  }

  Future<void> setLoginToken(String accessToken) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.loginToken, accessToken);
  }

  static Future<String> getLoginToken() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.loginToken) ??
        '';
  }

  Future<void> setUniqueId(String uniqueId) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.uniqueId, uniqueId);
  }

  static Future<String> getUniqueId() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.uniqueId) ??
        '';
  }

  Future<void> setBaseUrl(String baseurl) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.baseURL, baseurl);
  }

  static Future<String> getBaseUrl() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.baseURL) ?? '';
  }

  Future<void> setUsername(String baseurl) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.username, baseurl);
  }

  static Future<String> getUsername() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.username) ?? '';
  }

  Future<void> setFirstname(String baseurl) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.firstname, baseurl);
  }

  static Future<String> getFirstname() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.firstname) ?? '';
  }

  Future<void> setLastname(String baseurl) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.lastname, baseurl);
  }

  static Future<String> getLastname() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.lastname) ?? '';
  }

  Future<void> setPassword(String baseurl) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.password, baseurl);
  }

  static Future<String> getPassword() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.password) ?? '';
  }

  Future<void> setEmail(String baseurl) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.email, baseurl);
  }

  static Future<String> getEmail() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.email) ?? '';
  }

  Future<void> setPhone(String baseurl) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.phone, baseurl);
  }

  static Future<String> getPhone() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.phone) ?? '';
  }

  Future<void> setUserID(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.userid, userid);
  }

  static Future<String> getUserID() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.userid) ?? '';
  }

  Future<void> setUserObject(String userObject) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.userObject, userObject);
  }

  static Future<String> getUserObject() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.userObject) ?? '';
  }

  Future<void> setCaseID(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.case_id, userid);
  }

  static Future<String> getCaseID() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.case_id) ?? '';
  }

  Future<void> setCaseIDName(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.case_id_name, userid);
  }

  static Future<String> getCaseIDName() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.case_id_name) ??
        '';
  }

  Future<void> setCompanyName(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.company_name, userid);
  }

  static Future<String> getCompanyName() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.company_name) ??
        '';
  }

  Future<void> setAssetName(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.asset_name, userid);
  }

  static Future<String> getAssetName() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.asset_name) ?? '';
  }

  Future<void> setAssetID(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.asset_id, userid);
  }

  static Future<String> getAssetID() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.asset_id) ?? '';
  }

  static Future<String> getPropertyName() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.property_name) ??
        '';
  }

  Future<void> setPropertyName(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.property_name, userid);
  }

  Future<void> setBlockName(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.block_name, userid);
  }

  static Future<String> getBlockName() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.block_name) ?? '';
  }

  Future<void> setLevelName(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.level_name, userid);
  }

  static Future<String> getLevelName() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.level_name) ?? '';
  }

  Future<void> setFaultTypeName(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.fault_type_name, userid);
  }

  static Future<String> getFaultTypeName() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.fault_type_name) ??
        '';
  }

  Future<void> setFaultSubTypeName(String userid) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.fault_sub_type_name, userid);
  }

  static Future<String> getFaultSubTypeName() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.fault_sub_type_name) ??
        '';
  }

  Future<void> setBeforePhotoPath(String userid) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.before_photo_path, userid);
  }

  static Future<String> getBeforePhotoPath() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.before_photo_path) ??
        '';
  }

  Future<void> setVendorName(String name) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.vendor_name, name);
  }

  Future<void> setDesc(String desc) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.description, desc);
  }

  static Future<String> getDesc() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.description) ??
        '';
  }

  Future<void> setPriority(String desc) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.priority, desc);
  }

  static Future<String> getPriority() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.priority) ??
        '';
  }

  static Future<String> getVendorName() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.vendor_name) ??
        '';
  }

  Future<void> setIsinProgresslistEdit(String userid) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.is_in_progress_list_editable, userid);
  }

  static Future<String> getIsinProgresslistEdit() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.is_in_progress_list_editable) ??
        '';
  }

  Future<void> setIsPendingListEdit(String userid) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.is_pending_list_editable, userid);
  }

  static Future<String> getIsPendingListEdit() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.is_pending_list_editable) ??
        '';
  }

  Future<void> setUserRole(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.user_role, userid);
  }

  static Future<String> getUserRole() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.user_role) ?? '';
  }

  Future<void> setCauseOfFault(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.cause_of_fault, userid);
  }

  static Future<String> getCauseOfFault() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.cause_of_fault) ??
        '';
  }

  Future<void> setActionTaken(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.action_taken, userid);
  }

  static Future<String> getActionTaken() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.action_taken) ??
        '';
  }

  Future<void> setAfterImagePath(String userid) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.after_photo_path, userid);
  }

  static Future<String> getAfterImagePath() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.after_photo_path) ??
        '';
  }

  Future<void> setSignImagePath(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.sign_path, userid);
  }

  static Future<String> getSignImagePath() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.sign_path) ?? '';
  }

  Future<void> setClientSignImagePath(String userid) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.client_sign_path, userid);
  }

  static Future<String> getClientSignImagePath() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.client_sign_path) ??
        '';
  }

  Future<void> setContractCode(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.contract_code, userid);
  }

  static Future<String> getContractCode() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.contract_code) ??
        '';
  }

  Future<void> setEstmatedAmount(String userid) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.estimated_amount, userid);
  }

  static Future<String> getEstmatedAmount() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.estimated_amount) ??
        '';
  }

  Future<void> setEstdTimeOfCompletion(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.estimated_hrs, userid);
  }

  static Future<String> getEstdTimeOfCompletion() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.estimated_hrs) ??
        '';
  }

  Future<void> setProminentDisclosureCheck(String data) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.prominent_disclosure, data);
  }

  static Future<String> getProminentDisclosureCheck() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.prominent_disclosure) ??
        '';
  }

  Future<void> setProminentDisclosureLocationCheck(String data) async {
    await AppSharedPrefs.get()
        .addValue(PreferenceKeys.prominent_disclosure_location, data);
  }

  static Future<String> getProminentDisclosureLocationCheck() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.prominent_disclosure_location) ??
        '';
  }

  Future<void> setSubSchduleID(String ppmid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.sub_schdule_id, ppmid);
  }

  static Future<String> getSubSchduleID() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.sub_schdule_id) ??
        '';
  }

  Future<void> setisbuttonvisible(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.isbuttonvisible, userid);
  }

  static Future<String> getisbuttonvisible() async {
    return await AppSharedPrefs.get()
        .getValue(PreferenceKeys.isbuttonvisible) ??
        '';
  }

  Future<void> setattachurl(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.attach_url, userid);
  }

  static Future<String> getattachurl() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.attach_url) ?? '';
  }

  Future<void> setislist(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.is_list, userid);
  }

  static Future<String> getislist() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.is_list) ?? '';
  }

  Future<void> setrequestid(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.requestid, userid);
  }

  static Future<String> getrequestid() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.requestid) ?? '';
  }

  Future<void> setdesc(String userid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.desc, userid);
  }

  static Future<String> getdesc() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.desc) ?? '';
  }

  Future<void> setCMID(String cmid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.cmid, cmid);
  }

  static Future<String> getCMID() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.cmid) ?? '';
  }


  Future<void> setPPMID(String cmid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.ppmid, cmid);
  }

  static Future<String> getPPMID() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.ppmid) ?? '';
  }

  Future<void> setEmployeeID(String employeeid) async {
    await AppSharedPrefs.get().addValue(PreferenceKeys.client_token, employeeid);
  }

  static Future<String> getEmployeeID() async {
    return await AppSharedPrefs.get().getValue(PreferenceKeys.client_token) ?? '';
  }

}
