String baseURLBasedOnBuildFlavor = 'https://democw.e-ifms.biz/api/';

class ServerUrl {
  static String BASE_URL = baseURLBasedOnBuildFlavor;
  //
  //
  static const String USER_LOGIN = 'login';
  static const String PENDING_LIST = "pending_response_list";
  static const String DASHBOARD_MENU = "mobile_menu_visible";
  static const String LOGOUT = "logout";
  static const String INPROGRESS_LIST = "inprogress_response_list";
  static const String CLOSED_LIST = "closed_request_list";
  static const String REQUEST_LIST = "request_list";
  static const String DELETE_ATTACHMENT = "request_attachment_delete";
  static const String REQUEST_LIST_FILTER = "request_list_filter";
  static const String REQUEST_VIEW = "request_list_view";
  static const String CLOSED_VIEW_NEW = "closed_request_view";
  static const String SAVE_REQUEST_LIST = "save_request_list";
  static const String PROPERTY_LOCATION = "check_property_location";
  static const String MULTIPART_UPLOAD = "Multifileupload";
  static const String SAVE_CONTRACTOR_PENDING = "save_contractor_pending_fault";
  static const String INPROGRESS_VIEW = "get_inprogress_view";
  static const String CLOSED_VIEW = "closed_view";
  static const String PPM_LIST = "cw_sub_schedule_list";
  static const String PPM_DETAILS = "cw_sub_schedule_view";
  static const String FINDTYPE = "findTypes";
  static const String FINDSUBTYPE = "findSubTypesByType";
  static const String PRIORITY = "findPriorityBySubType";
  static const String PRIORITY_TYPE = "findPriority";
  static const String LOCATION_LIST = "findProperties";
  static const String FIND_ROOMS_BY_PROPERTY = "findRoomsByProperty";
  static const String SAVE_FAULT_REPORT = "saveMobileRequest";
  static const String GET_ASSET = "getAsset";
  static const String RESET_PASSWORD = "reset_password";
  static const String RENEW_PASSWORD = "password_renew";
  static const String GETASSETBYSCHID = "getAssetByScheduleId";
  static const String UPDATESUBSCHEDULE = "update_sub_schedule";
  static const String FORGOT_PASSWORD = "forgot_password";
  static const String SUB_SCHEDULE = "view_sub_schedule";
  static const String UPDATE_FAULT_RESPONSE = "update_fault_response";
  static const String GET_ASSET_URL = "getAssetURL";
  static const String GET_NOTIFICATION = "getfaultnotification";
  static const String CLEAR_NOTIFICATION = "clearRequestByType";
  static const String UPDATE_NOTIFICATION = "updatenotification";
  //static const String ENDPOINT  = "get_endpoint";
  static const String ENDPOINT = "getCMMSContract";
  static const String USER_PROPERTY = "user_property_list";
  static const String LOGGER = "mobile_api_logs";
  static const String ADHOC_LIST = "get_adhoc_inpsection_list";
  static const String REPORT_LIST = "AttendanceReport";

  static const String ADHOC_ADD_NEW_VIEW = "adhoc_inpsection_view";
  static const String ADHOC_WEBVIEW = "get_adhoc_inpsection_web_url";
  static const String ADHOC_ADD_SAPCE_FLOOR = "get_adhoc_inpsection_level";
  static const String ADHOC_ADD_ASSET = "get_adhoc_inpsection_asset";
  static const String ADHOC_INSPECTION_SAVE = "save_adhoc_inpsection";
  static const String ADHOC_INSPECTION_COMPLETED_VIEW =
      "adhoc_inspection_completed_view";
  static const String MYFAULT_LIST = "my_fault_report_list";
  static const String MYFAULT_LIST_VIEW = "my_fault_report_view";
  static const String SAVE_FAULT_REPORT1 = "my_fault_report_update";


  //PPM Module

  static const String MODULE_COUNT = 'user/dashboard';
  static const String CMLIST = "helpDesk/findByStatus";
  static const String CMDETAILS = "helpDesk/findById";
  static const String CMSTART = "helpDesk/start";
  static const String IMAGE_UPLOAD  = "helpDesk/saveImage";
  static const String IMAGE_DELETE = "taskDetail/delete";
  static const String ROOTCAUSE = "rootCause/findActive";
  static const String ADDITIONAL_EMP = "employee/findActive";
  static const String CMSUBMIT = "taskDetail/create";

  static const String PPMSTATUS = "pmSubSchedule/findByStatus";
  static const String PPMLIST  = "pmSubSchedule/allPPM";
  static const String PPMDETAILS = "pmSubSchedule/findById";
  static const String PPMSTART = "pmSubSchedule/start";
  static const String PPM_IMAGE_UPLOAD = "pmSubSchedule/saveImage";
  static const String PPM_IMAGE_DELETE = "pmSubSchedule/removeImage";
  static const String PPM_CHECKPOINT = "pmSubSchedule/showCheckPoints";
  static const String PPM_SUBMIT = "pmSubSchedule/create";
  static const String PPM_ADDITIONAL_EMP = "employee/findByPPM";

  static const String COMPLAINT_REG = "complainerRegistry/all";
  static const String COMPLAINT_SUBMIT = "helpDesk/create";
  static const String PPM_DEFECT = "pmSubSchedule/defect";

}
