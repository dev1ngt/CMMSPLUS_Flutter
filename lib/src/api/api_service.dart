import 'dart:convert';
import 'dart:io';
import 'package:cmms/src/features/adhocinspection/model/adhoc_list_response_model.dart';
import 'package:cmms/src/features/checkin_out/model/report_response_model.dart';
import 'package:cmms/src/features/dashboard/model/dasboard_count_model.dart';
import 'package:cmms/src/features/dashboard/model/logout_response_model.dart';
import 'package:cmms/src/features/notification/model/notification_clear_model.dart';
import 'package:cmms/src/features/notification/model/notification_list_model.dart';
import 'package:cmms/src/features/pendingresponse/model/asset_model.dart';
import 'package:cmms/src/features/pendingresponse/model/property_model.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/SignatureUploadResponseModel.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/SubmitResponseModel.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/TechnicianInitiateRequestModel.dart';
import 'package:cmms/src/features/request/search/model/search_response_model.dart';
import 'package:cmms/src/features/request/view/model/delete_file_response_model.dart';
import 'package:cmms/src/features/resetpassword/model/resetpass_response_model.dart';
import 'package:cmms/src/fm/features/cm/model/cm_model_response.dart';
import 'package:cmms/src/fm/features/cm_additional_emp/model/cm_add_emp_response_model.dart';
import 'package:cmms/src/fm/features/cm_material/model/cm_material_response_model.dart';
import 'package:cmms/src/fm/features/cm_occupant/model/cm_occupant_sign_response_model.dart';
import 'package:cmms/src/fm/features/cm_submit/model/submit_response_model.dart';
import 'package:cmms/src/fm/features/cmanalysis/model/rootcause_response_model.dart';
import 'package:cmms/src/fm/features/cmdetails/model/cmdetails_response_model.dart';
import 'package:cmms/src/fm/features/cmdetails/model/starttime_response_model.dart';
import 'package:cmms/src/fm/features/common/photosupload/model/uploadfile_response_model.dart';
import 'package:cmms/src/fm/features/dashboard/model/model_response.dart';
import 'package:cmms/src/fm/features/ppm/ppm_additional_emp/model/ppm_add_emp_response_model.dart';
import 'package:cmms/src/fm/features/ppm/ppm_barcode/model/ppm_barcode_response_model.dart';
import 'package:cmms/src/fm/features/ppm/ppm_checkpoint/model/ppm_checklist_response_model.dart';
import 'package:cmms/src/fm/features/ppm/ppm_list_details/model/ppm_starttime_response_model.dart';
import 'package:cmms/src/fm/features/ppm/ppm_list_details/model/ppmdetails_response_model.dart';
import 'package:cmms/src/fm/features/ppm/ppm_status_view/model/ppm_status_response_model.dart';
import 'package:cmms/src/fm/features/ppm/ppm_submit/model/ppm_submit_request_model.dart';
import 'package:cmms/src/fm/features/tenant/complaint_reg/model/complaint_reg_response_model.dart';
import 'package:http/http.dart' as http;

import 'package:cmms/src/features/inprogress/list/model/inprogress_list_model.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:cmms/src/helpers/config/server_url.dart';
import 'package:http/http.dart';

import '../features/myfaultreport/list/model/myfault_list_model.dart';
import '../features/myfaultreport/list/model/myfault_list_view_model.dart';
import '../features/adhocinspection/model/adhoc_details_view_model.dart';
import '../features/adhocinspection/view/add_new/model/adhoc_add_new_asset_model.dart';
import '../features/adhocinspection/view/add_new/model/adhoc_add_new_space_floor_model.dart';
import '../features/adhocinspection/view/add_new/model/adhoc_add_new_webview_model.dart';
import '../features/adhocinspection/view/add_new/model/adhoc_addnew_view_model.dart';
import '../features/adhocinspection/view/add_new/model/adhoc_inspection_submit_model.dart';
import '../features/closed/list/model/closed_list_model.dart';
import '../features/closed/view/model/closed_response_model.dart';
import '../features/contract/model/contractcode_response_model.dart';
import '../features/dashboard/model/log/logger_model_response.dart';
import '../features/faultreport/fifthroom/model/request/room_request_model.dart';
import '../features/faultreport/fifthroom/model/response/room_response_model.dart';
import '../features/faultreport/firstmenu/model/request_type.dart';
import '../features/faultreport/fourthlocation/model/location_response.dart';
import '../features/faultreport/secondpriority/model/priority_response.dart';
import '../features/faultreport/submit/model/fault_report_save_model.dart';
import '../features/faultreport/submit/model/fault_report_save_model_old.dart';
import '../features/faultreport/submit/model/fault_report_submit_response_model.dart';
import '../features/faultreport/submit/model/priority_request_model.dart';
import '../features/faultreport/submit/model/priority_response_model.dart';
import '../features/faultreport/subtype/model/request/subtype_request_model.dart';
import '../features/faultreport/subtype/model/response/subtype_response_model.dart';
import '../features/forgotpassword/model/forgot_response_model.dart';
import '../features/inprogress/view/model/inprogress_response_model.dart';
import '../features/inprogress/view/model/inprogress_submit_request_model.dart';
import '../features/inprogress/view/model/inprogress_submit_response.dart';
import '../features/login/model/login_model.dart';
import '../features/pendingresponse/model/location_model.dart';
import '../features/pendingresponse/model/pending_model.dart';
import '../features/pendingresponsedetails/model/UploadFileResponseModel.dart';
import '../features/ppm/completed/model/ppm_completed_response.dart';
import '../features/ppm/list/model/ppm_list_response_model.dart';
import '../features/ppm/view/model/asset/AssetResponse.dart';
import '../features/ppm/view/model/ppm_details_response_model.dart';
import '../features/ppm/view/model/ppm_details_submit_request.dart';
import '../features/publicwebview/model/asset_response_model.dart';
import '../features/request/list/model/request_list_model.dart';
import '../features/request/view/model/request_list_view_model.dart';
import '../fm/features/cm_afterimage/model/image_delete/preimage_deleteresponse_model.dart';
import '../fm/features/cm_beforeimage/model/image_delete/preimage_deleteresponse_model.dart';
import '../fm/features/cm_submit/model/tech_sign_response_model.dart';
import '../fm/features/cm_summary/model/cm_submit_request_model.dart' show CMSubmitRequestModel;
import '../fm/features/common/photosupload/model/uploadfile_after_response_model.dart';
import '../fm/features/contract/model/contractcode_response_model.dart';
import '../fm/features/login/model/login_model.dart';
import '../fm/features/ppm/ppm_list/model/ppm_list_response_model.dart';
import '../fm/features/ppm/ppm_postimage/model/image_upload/ppm_post_uploadfile_response_model.dart';
import '../fm/features/ppm/ppm_preimage/model/image_upload/ppm_uploadfile_response_model.dart';
import '../fm/features/ppm/ppm_submit/model/ppm_tech_sign_response_model.dart';
import 'endpoint_map.dart';

class ApiService {
  Future<String> getBaseURL() async {
    return await AppSharedPrefs.getBaseUrl();
  }

  Future<String> getStaticBaseURL() async {
    return await EndpointMap().base;
  }

  Future<String> getUserID() async {
    return await AppSharedPrefs.getUserID();
  }

  Future<String> getToken() async {
    return await AppSharedPrefs.getLoginToken();
  }

  Future<String> getCaseID() async {
    return await AppSharedPrefs.getCaseID();
  }

  Future<String> getContractCode() async {
    return await AppSharedPrefs.getContractCode();
  }

  Future<String> getEmployeeID() async {
    return await AppSharedPrefs.getEmployeeID();
  }


  Future<Map<String, String>> getHeader() async {
    return {
      'Content-type': 'application/json',
      'X-Project-Code': await getContractCode(),
    };
  }

/*  Future<Map<String, String>> getHeader() async {
    return {
      'Content-type': 'application/json',
      'x-auth-client': await getClientToken(),
      'x-auth-token': await getToken(),
      'x-api-client': 'ngtmobile',
    };
  }*/

  Future<String> getClientToken() async {
    return await AppSharedPrefs.getClientToken();
  }

  Future<ContractCodeResponseModel> getEndpoint(
      {required String contractCode}) async {
    String method = ServerUrl.ENDPOINT;
    String endpoint = '${await getStaticBaseURL()}$method'
            '?Contract_Code=' +
        contractCode;

    Response response = await get(
      Uri.parse(endpoint),
    );
    print("After api call" + response.body.toString());
    if (response.statusCode == 200) {
      print("api called ");
      return ContractCodeResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Contract> getEndpointFM({required String  contractCode}) async {
    String method = ServerUrl.ENDPOINT;
    String endpoint = '${await getStaticBaseURL()}$method'
        '?Contract_Code=' + contractCode;
    // Map<String, String> headers = await getHeader();

    Response response = await get(
      Uri.parse(endpoint),
      // headers: headers,
    );
    print("After api call" + response.body.toString());
    if (response.statusCode == 200) {
      print("api called ");
      return Contract.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<InProgressData>> getInProgressList(
      {required int page, required int propertyid}) async {
    String method = ServerUrl.INPROGRESS_LIST +
        '?user_id=' +
        await getUserID() +
        '&page_no=' +
        page.toString() +
        '&property_id=' +
        propertyid.toString();
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call" + endpoint);
    Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      final List result = jsonDecode(response.body)['inprogress_data'];
      return result.map(((e) => InProgressData.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<ClosedData>> getClosedList({
    required int propertyid,
    required int page,
    required String reqId,
  }) async {
    String method = ServerUrl.CLOSED_LIST +
        '?user_id=' +
        await getUserID() +
        '&property_id=' +
        propertyid.toString() +
        '&request_id=' +
        reqId +
    '&page_no=' +
    page.toString();
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call : " + endpoint);
    Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body)['closed_list']);
      final List result = jsonDecode(response.body)['closed_list'];
      return result.map(((e) => ClosedData.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<RequestData>> getRequestList(
      {required int propertyid,
      required String type,
      required String reqId,
      required int page}) async {
    String method = ServerUrl.REQUEST_LIST +
        '?user_id=' +
        await getUserID() +
        '&property_id=' +
        propertyid.toString() +
        '&type=' +
        type.toString() +
        '&request_id=' +
        reqId +
    '&page_no=' +
    page.toString();
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call : " + endpoint);
    Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body)['request_list']);
      final List result = jsonDecode(response.body)['request_list'];
      return result.map(((e) => RequestData.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<SearchResponseModel> getSearchCasesList(
      {required String type,
      required String subType,
      required String query,
      required int propertyId}) async {
    String method = ServerUrl.REQUEST_LIST_FILTER;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call : " + endpoint);
    Map<String, dynamic> request = {
      "user_id": await getUserID(),
      "request_id": query,
      "property_id": propertyId,
      "type": type,
      "sub_type": subType
    };
    Response response = await post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(request));
    print("After api call");
    print(request.toString());
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body));
      final jsonData = SearchResponseModel.fromJson(jsonDecode(response.body));
      return jsonData;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<RequestData1>> getRequestList1({required int page,
  required String reqId, required String type}) async {
    print("Before api call1 : ");
    String method = ServerUrl.MYFAULT_LIST +
        '?user_id=' +
        await getUserID() +
        '&request_id=' +
        reqId +
        '&page_no=' +
        page.toString() +
    '&type=' + type;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call : " + endpoint);
    Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      final List result = jsonDecode(response.body)['my_fault_report_list'];
      return result.map(((e) => RequestData1.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<NotificationList> getNotificationList() async {
    String method = ServerUrl.GET_NOTIFICATION;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    // Construct the request body
    Map<String, dynamic> requestBody = {
      "user_id": await getUserID(),
    };
    print("Before api call : " + requestBody.toString());
    print("Before api call : " + endpoint);
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body));
      return NotificationList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<NotificationClearResponse> clearNotificationList(int isRead) async {
    String method = ServerUrl.CLEAR_NOTIFICATION;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();

    Map<String, dynamic> requestBody = {
      "user_id": await getUserID(),
      "nread": isRead, // 0 = unread, 1 = read
    };

    print("Clear API Request: $requestBody");
    print("Endpoint: $endpoint");

    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('api called');
      print(jsonDecode(response.body));
      return NotificationClearResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<SubmitResponseModel> updateNotificationList(
      {required int notifyid}) async {
    String method = ServerUrl.UPDATE_NOTIFICATION;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    // Construct the request body
    Map<String, dynamic> requestBody = {
      "user_id": await getUserID(),
      "notify_id": notifyid.toString(),
    };
    print("Before api call : " + requestBody.toString());
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body));
      return SubmitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<DashboardMenuVisibleResponseModel> getDashboard() async {
    String method = '${ServerUrl.DASHBOARD_MENU}?user_id=${await getUserID()}&unique_id=${await AppSharedPrefs.getUniqueId()}';
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call" + endpoint);
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body));
      // final List result = jsonDecode(response.body)['ScreenMapping_Mobile'];
      // return result.map(((e) => ScreenMappingMobile.fromJson(e))).toList();
      return DashboardMenuVisibleResponseModel.fromJson(
          jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<LogoutResponseModel> logout() async {
    String userId = await getUserID();
    String token = await getToken();
    Map<String, String> headers = await getHeader();

    String method = ServerUrl.LOGOUT + '?id=$userId&token=$token';
    String endpoint = '${await getBaseURL()}$method';


    print("Before API call: $endpoint");

    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
    );

    print("After API call");

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return LogoutResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to logout: ${response.reasonPhrase}');
    }
  }


  Future<PropertyModel> getUserProperty() async {
    String method = ServerUrl.USER_PROPERTY;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call" + endpoint);

    Map<String, dynamic> requestBody = {
      "user_id": await getUserID(),
    };

    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called " + response.body);

      // final List result = jsonDecode(response.body)['ScreenMapping_Mobile'];
      // return result.map(((e) => ScreenMappingMobile.fromJson(e))).toList();
      return PropertyModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<PendingListResponseModel> getPendingList(
      {required int page, required int propertyid}) async {
    String method = ServerUrl.PENDING_LIST +
        '?user_id=' +
        await getUserID() +
        '&page_no=' +
        page.toString() +
        '&property_id=' +
        propertyid.toString();
    ;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call");
    Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    print(response);
    print(endpoint);
    if (response.statusCode == 200) {
      print("api called ");
      return PendingListResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<PropertyLocationResponseModel> getLocationValidate(
      {required String longitude,
      required String latitude,
      required String propertyID}) async {
    String method = ServerUrl.PROPERTY_LOCATION +
        '?property_id=' +
        propertyID.toString() +
        '&latitude=' +
        latitude +
        '&longitude=' +
        longitude;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call" + endpoint);
    Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      return PropertyLocationResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<RequestViewModel> getRequestViewByID(
      {required int requestID}) async {
    String method = ServerUrl.REQUEST_VIEW;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    // Construct the request body
    Map<String, dynamic> requestBody = {
      "id": requestID,
      "user_id": await getUserID(),
    };
    print("endpoint:" + endpoint);
    print("Before api call" + requestBody.toString());
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print("After api call" + response.body.toString());
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body));
      return RequestViewModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<ClosedViewModelNew> getClosedViewByID({required int requestID}) async {
    String method = ServerUrl.CLOSED_VIEW_NEW +
        '?user_id=' +
        await getUserID() +
        '&id=' +
        requestID.toString();
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();

    print("endpoint:" + endpoint);
    print("Before api call" + endpoint.toString());
    Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call" + response.body.toString());
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body));
      return ClosedViewModelNew.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<RequestData2> getMyfaultViewByID(
      {required int requestID, required String type}) async {
    String method = ServerUrl.MYFAULT_LIST_VIEW +
        '?user_id=' +
        await getUserID() +
        '&request_id=' +
        requestID.toString();
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();

    print("endpoint:" + endpoint);
    Response response = await get(Uri.parse(endpoint), headers: headers);
    print("After api call" + response.body.toString());
    if (response.statusCode == 200) {
      print("api called ");
      print(jsonDecode(response.body));
      return RequestData2.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<DeleteFileResponseModel> deleteAttachment({



    required int id,
    required String requestId,
  }) async {

    String user_id = await getUserID();

    String method =
        ServerUrl.DELETE_ATTACHMENT + '?id=$id&request_id=$requestId&user_id=$user_id';

    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();

    print("DELETE (GET) endpoint: $endpoint");

    final response = await http.post(Uri.parse(endpoint), headers: headers);

    if (response.statusCode == 200) {
      print("Delete Response: ${response.body}");
      return DeleteFileResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete file: ${response.reasonPhrase}');
    }
  }

  Future<SubmitResponseModel> getRequestViewSubmit(
      {required int requestID,
      required int userID,
      required int assigneeID,
      statusID,
      remarks,
      additionalSpace,
      estimatedAmt,
      uploadFiles,
      assetID}) async {
    String method = ServerUrl.SAVE_REQUEST_LIST;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    // Construct the request body
    Map<String, dynamic> requestBody = {
      "request_id": requestID,
      "status": statusID,
      "user_id": await getUserID(),
      "remarks": remarks,
      "assigned_to": assigneeID,
      "additional_space": additionalSpace,
      "estimated_amount": estimatedAmt,
      "multipleimage": uploadFiles.map((e) => e.toJson()).toList(),
      "asset_id": assetID,
    };
    print("endpoint" + endpoint);
    print("Before api call" + requestBody.toString());
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      return SubmitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<AssetResponseModel> getPublicWeblink(
      {required String asset_code}) async {
    String method = ServerUrl.GET_ASSET_URL + '?asset_code=' + asset_code;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call" + endpoint);
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      return AssetResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<ForgotResponseModel> getForgotPasswordAPI(
      {required String mail}) async {
    String method = ServerUrl.FORGOT_PASSWORD + '?email=' + mail;
    String endpoint = '${await getBaseURL()}$method';
    print("Before api call" + endpoint);
    Map<String, String> headers = await getHeader();
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      return ForgotResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<ForgotResponseModel> getResetPasswordAPI({
    required String current_password,
    required String confirm_password,
    required String new_password,
  }) async {
    String baseUrl = await getBaseURL();
    String userId = await getUserID();
    Map<String, String> headers = await getHeader();

    String endpoint = '$baseUrl${ServerUrl.RESET_PASSWORD}';



    // Prepare JSON body
    Map<String, dynamic> body = {
      'user_id': userId,
      'current_password': current_password,
      'confirm_password': confirm_password,
      'new_password': new_password,
    };

    print("Before API call: $endpoint");
    print("Headers: $headers");
    print("Body: ${jsonEncode(body)}");

    // Send POST request
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    print("After API call");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("API called successfully");
      return ForgotResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to reset password: ${response.statusCode} ${response.reasonPhrase}');
    }
  }


  Future<ResetpassResponseModel> getResetPasswordAPIDashboard({
    required String current_password,
    required String confirm_password,
    required String new_password,
  }) async {
    String endpoint = '${await getBaseURL()}${ServerUrl.RENEW_PASSWORD}';
    Map<String, String> headers = await getHeader();

    Map<String, dynamic> body = {
      'user_id': await getUserID(),
      'current_password': current_password,
      'confirm_password': confirm_password,
      'new_password': new_password,
    };

    print("Before API call: $endpoint");

    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    print("After API call");

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return ResetpassResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }


  Future<ScheduleResponse> getViewSubScheduleAPI(
      {required String sub_schedule_id}) async {
    String method =
        ServerUrl.SUB_SCHEDULE + '?sub_schedule_id=' + sub_schedule_id;
    String endpoint = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    print("Before api call" + endpoint);
    Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
    );
    print("After api call");
    if (response.statusCode == 200) {
      print("api called ");
      return ScheduleResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<UploadFileResponseModel> getFileUploadStatus(
      {required File ActualFileData, required String FileName}) async {
    String method = ServerUrl.MULTIPART_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    // Add your multipart parameters
    request.fields['userid'] = await getUserID();
    request.fields['permit'] = '1';
    request.fields['typestr'] = '1';
    request.fields['projetId'] = '1';

    // Add your file to the request
    request.files.add(
      http.MultipartFile(
        'filetoupload', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );

    try {
      // Send the request
      http.Response response =
          await http.Response.fromStream(await request.send());

      print("After API call");

      if (response.statusCode == 200) {
        print("API called successfully");
        return UploadFileResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<SignatureUploadResponseModel> getSignUploadStatus({
    required File ActualFileData,
    required String FileName,
  }) async {
    String method = ServerUrl.MULTIPART_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse(endpoint));

    // Add headers to the request
    request.headers.addAll(headers);

    // Add your multipart parameters
    request.fields['userid'] = await getUserID();
    request.fields['permit'] = '1';
    request.fields['typestr'] = '1';
    request.fields['projetId'] = '1';

    // Add your file to the request
    request.files.add(
      http.MultipartFile(
        'filetoupload', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );

    print("File path: ${ActualFileData.path}");
    print("File extension: ${ActualFileData.path.split('.').last}");
    print("Headers: $headers");


    try {
      // Send the request
      http.Response response =
          await http.Response.fromStream(await request.send());

      print("After API call");

      if (response.statusCode == 200) {
        print("API called successfully");
        print(jsonDecode(response.body));

        return SignatureUploadResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<SubmitResponseModel> postSubmitPendingReponse(
      {required TechnicianInitiateRequestModel
          technicianInitiateRequestModel}) async {
    // set up Post request arguments
    String method = ServerUrl.SAVE_CONTRACTOR_PENDING;
    String url = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(technicianInitiateRequestModel.toJson());

    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return SubmitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<SubmitResponseModel> postSubmitPPMDetails(
      {required PPMSubmitRequestModel ppmSubmitRequestModel}) async {
    // set up Post request arguments
    String method = ServerUrl.UPDATESUBSCHEDULE;
    String url = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(ppmSubmitRequestModel.toJson());

    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);

    print(response);
    if (response.statusCode == 200) {
      return SubmitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<AssetResponse> postAssetScanReponse(
      {required AssetInput assetInput}) async {
    // set up Post request arguments
    String method = ServerUrl.GET_ASSET;
    String url = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(assetInput.toJson());

    print(jsonConverted);
    print(url);

    Response response =
    await post(Uri.parse(url), headers: headers, body: jsonConverted);

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return AssetResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<AssetsResponse> postMultiAssetReponse(
      {required MultiAssetInput assetInput}) async {
    // set up Post request arguments
    String method = ServerUrl.GETASSETBYSCHID;
    String url = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(assetInput.toJson());

    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);

    if (response.statusCode == 200) {
      print("API called successfully");
      return AssetsResponse.fromJson(jsonDecode(response.body));
    } else {
      // Handle any additional errors that may occur
      print('Error: ${response.body}');
      throw Exception(response.reasonPhrase);
    }
  }

  Future<InprogressSubmitResponseModel> postInProgressSubmit(
      {required InprogressSubmitRequestModel
          inprogressSubmitRequestModel}) async {
    // set up Post request arguments
    String method = ServerUrl.UPDATE_FAULT_RESPONSE;
    String url = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(inprogressSubmitRequestModel.toJson());

    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return InprogressSubmitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<InprogressResponseModel> getInProgressDetails() async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';
      String caseId = await getCaseID() ?? '';

      String method =
          ServerUrl.INPROGRESS_VIEW + '?user_id=' + userId + '&id=' + caseId;
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();

      print("Before api call" + endpoint);

      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );

      print("After api call");

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['login_of_request_view'] != null &&
            jsonResponse['fault_response_view'] != null &&
            jsonResponse['follow_up'] != null &&
            jsonResponse['images'] != null &&
            jsonResponse['status'] != null &&
            jsonResponse['message'] != null) {
          return InprogressResponseModel.fromJson(jsonResponse);
        } else {
          throw Exception(
              "One or more required keys are missing in JSON response");
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  /*Future<ClosedResponseModel> getClosedDetails() async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';
      String caseId = await getCaseID() ?? '';

      String method =
          ServerUrl.CLOSED_VIEW + '?user_id=' + userId + '&id=' + caseId;
      String endpoint = '${await getBaseURL()}$method';

      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);

      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );
      print("After api call");

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['login_of_request_view'] != null &&
            jsonResponse['fault_response_view'] != null &&
            jsonResponse['follow_up'] != null &&
            jsonResponse['images'] != null &&
            jsonResponse['status'] != null &&
            jsonResponse['message'] != null) {
          return ClosedResponseModel.fromJson(jsonResponse);
        } else {
          throw Exception(
              "One or more required keys are missing in JSON response");
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }*/

  Future<PPMListResponseModel> getPPMList({required String type}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';

      String method = ServerUrl.PPM_LIST +
          '?user_id=' +
          userId +
          '&property_id=1&type=' +
          type;
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);

      Response response = await post(
        Uri.parse(endpoint),
        headers: headers,
      );

      print("After api call");

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return PPMListResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  // PPM Details

  Future<PPMDetailsResponseModel> getPPMDetails({required String subScheduleId}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';

      String method = ServerUrl.PPM_DETAILS +
          '?user_id=' +
          userId +
          '&sub_schedule_id=' +
          subScheduleId;
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);

      Response response = await post(
        Uri.parse(endpoint),
        headers: headers,
      );

      print("After api call");

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return PPMDetailsResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error PPM Details: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<RequestType> getFindType(String requestId) async {
    try {
      String method = ServerUrl.FINDTYPE;
      String baseUrl = await getBaseURL();

      // Add request_id as a query parameter
      Uri uri = Uri.parse('$baseUrl$method').replace(queryParameters: {
        'request_id': requestId,
      });

      print("Endpoint: $uri");

      Map<String, String> headers = await getHeader();

      Response response = await get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("API called");
        print(jsonDecode(response.body));
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return RequestType.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        throw Exception(response.reasonPhrase);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }


  /*SubType */
  Future<SubtypeResponseModel> getSubTypeList({
    required SubtypeRequestModel subtypeRequest,
    required String requestId,
  }) async {
    String method = ServerUrl.FINDSUBTYPE;
    String baseUrl = await getBaseURL();

    Uri uri = Uri.parse('$baseUrl$method').replace(queryParameters: {
      'request_id': requestId,
    });

    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(subtypeRequest.toJson());

    print("Request body: $jsonConverted");
    print("URL: $uri");

    Response response = await post(uri, headers: headers, body: jsonConverted);

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return SubtypeResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<PrioritiesResponse> getPriorityType() async {
    try {
      String method = ServerUrl.PRIORITY_TYPE;
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return PrioritiesResponse.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<LocationResponse> getLocationList({required String requestId}) async {
    try {
      String userId = await getUserID() ?? '';
      String method = ServerUrl.LOCATION_LIST;
      String baseUrl = await getBaseURL();

      // Use Uri to safely append query parameters
      Uri uri = Uri.parse('$baseUrl$method').replace(queryParameters: {
        'user_id': userId,
        'request_id': requestId,
      });

      Map<String, String> headers = await getHeader();

      print("API URL: $uri");

      Response response = await get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("API called successfully");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return LocationResponse.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        throw Exception(response.reasonPhrase);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('An error occurred while fetching location list');
    }
  }


  Future<RoomResponse> getRoomList({
    required RoomRequestModel roomRequestModel,
    required String requestId, // <-- Added requestId
  }) async {
    String method = ServerUrl.FIND_ROOMS_BY_PROPERTY;
    String baseUrl = await getBaseURL();

    // Build URI with query parameter
    Uri uri = Uri.parse('$baseUrl$method').replace(queryParameters: {
      'request_id': requestId,
    });

    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(roomRequestModel.toJson());

    print("Request Body: $jsonConverted");
    print("URL: $uri");

    Response response = await post(uri, headers: headers, body: jsonConverted);

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return RoomResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<FaultReportSaveResponseModel> doCallSubmitFaultReport(
      {required FaultReportSaveModel faultReportSaveModel}) async {
    // set up Post request arguments
    String method = ServerUrl.SAVE_FAULT_REPORT;
    String url = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(faultReportSaveModel.toJson());

    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);
    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return FaultReportSaveResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<FaultReportSaveResponseModel> doCallSubmitFaultReport1(
      {required FaultReportOldSaveModel faultReportoldSaveModel}) async {
    // set up Post request arguments
    String method = ServerUrl.SAVE_FAULT_REPORT1;
    String url = '${await getBaseURL()}$method';
    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(faultReportoldSaveModel.toJson());

    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);
    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return FaultReportSaveResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<LoginResponseModel> postUserLogin(
      {required LoginInput loginInput}) async {
    // set up Post request arguments
    String method = ServerUrl.USER_LOGIN;
    String url = '${await getBaseURL()}$method';

    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(loginInput.toJson());
    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);

    print(response.body);

    return LoginResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<LoginResponseModelFM> postUserLoginFM(
      {required LoginInputFM loginInput}) async {
    // set up Post request arguments
    String method = ServerUrl.USER_LOGIN;
    String url = '${await getBaseURL()}$method';

    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(loginInput.toJson());
    print(jsonConverted);
    print(url);

    Response response =
    await post(Uri.parse(url), headers: headers, body: jsonConverted);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);

    print(response.body);

    return LoginResponseModelFM.fromJson(jsonDecode(response.body));
  }

  Future<LoggerModelResponse> postLogger({required LoggerInput logger}) async {
    // set up Post request arguments
    String method = ServerUrl.LOGGER;
    String url = '${await getBaseURL()}$method';

    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(logger.toJson());
    print(jsonConverted);
    print(url);

    Response response =
        await post(Uri.parse(url), headers: headers, body: jsonConverted);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);

    print(response.body);

    return LoggerModelResponse.fromJson(jsonDecode(response.body));
  }

  Future<AdhocListResponseModel> getAdhocList(
      {required String type, required int page}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';

      String method = ServerUrl.ADHOC_LIST +
          '?user_id=' +
          userId +
          '&type=' +
          type +
          '&page_no=' +
          page.toString();
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);

      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );

      print("After api call");

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return AdhocListResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<ReportResponseModel> getReportList(
      {required String year,
      required String month,
      required String pageNo}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';

      String method = ServerUrl.REPORT_LIST +
          '?userid=' +
          userId +
          '&year=' +
          year +
          '&month=' +
          month +
          '&page_no=' +
          pageNo.toString();
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);

      Response response = await post(
        Uri.parse(endpoint),
        headers: headers,
      );

      print("After api call");

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return ReportResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<AdhocAddNewViewResponseModel> getAdhocAddnewView() async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';

      String method = ServerUrl.ADHOC_ADD_NEW_VIEW + '?user_id=' + userId;
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();

      print("Before api call" + endpoint);

      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );

      print("After api call");

      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return AdhocAddNewViewResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<AdhocInspectionWebViewResponseModel> getAdhocAddWebView({
    required int inspectionClass,
    required String token,
  }) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';
      String method = ServerUrl.ADHOC_WEBVIEW +
          '?user_id=' +
          userId +
          '&inspection_class=' +
          inspectionClass.toString() +
          '&token=' +
          token;
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);
      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );
      print("After api call");
      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return AdhocInspectionWebViewResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<AdhocAddNewSpaceFloorModel> getAdhocSpaceFloorFilter(
      {required int property_id}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';
      String method = ServerUrl.ADHOC_ADD_SAPCE_FLOOR +
          '?property_id=' +
          property_id.toString();
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);
      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );
      print("After api call");
      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("DATA1" + jsonResponse.toString());
        return AdhocAddNewSpaceFloorModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<AdhocAddNewAssetModel> getAdhocAssetFilter(
      {required int property_id}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';
      String method =
          ServerUrl.ADHOC_ADD_ASSET + '?property_id=' + property_id.toString();
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);
      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );
      print("After api call");
      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return AdhocAddNewAssetModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<AdhocInspectionSubmitModel> getAdhocNewInspectionSubmit(
      {required int inspectionClass,
      required String token,
      required int property_id,
      required int space_floor_id,
      required int asset_id,
      required String occupant,
      required String location}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';
      String method = ServerUrl.ADHOC_INSPECTION_SAVE +
          '?user_id=' +
          userId +
          '&inspection_class=' +
          inspectionClass.toString() +
          '&token=' +
          token +
          '&property_id=' +
          property_id.toString() +
          '&space_floor_id=' +
          space_floor_id.toString() +
          '&asset_id=' +
          asset_id.toString() +
          '&occupant=' +
          occupant +
          '&location=' +
          location;
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call" + endpoint);
      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );
      print("After api call");
      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return AdhocInspectionSubmitModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<AdhocDetailsViewModel> getAdhocDetailsView(
      {required int property_id}) async {
    try {
      // Ensure that getUserID and getCaseID do not return null
      String userId = await getUserID() ?? '';
      String method = ServerUrl.ADHOC_INSPECTION_COMPLETED_VIEW +
          '?user_id=' +
          userId +
          '&inspection_id=' +
          property_id.toString();
      String endpoint = '${await getBaseURL()}$method';
      Map<String, String> headers = await getHeader();
      print("Before api call >> " + endpoint);
      Response response = await get(
        Uri.parse(endpoint),
        headers: headers,
      );
      print("After api call");
      if (response.statusCode == 200) {
        print("api called ");
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return AdhocDetailsViewModel.fromJson(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (4xx)
        throw Exception(response.reasonPhrase);
      } else if (response.statusCode >= 500) {
        // Handle server errors (5xx)
        throw Exception(response.reasonPhrase);
      } else {
        // Handle other status codes
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      // Handle any additional errors that may occur
      print('Error: $error');
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<PriorityResponseModel> doCallFaultReportPriority({
    required String requestId,
    required PriorityRequestModel priorityRequestModel,
  }) async {
    String method = ServerUrl.PRIORITY;

    // Append request_id as query parameter
    String url = '${await getBaseURL()}$method?request_id=$requestId';

    Map<String, String> headers = await getHeader();
    var jsonConverted = jsonEncode(priorityRequestModel.toJson());

    print(jsonConverted);
    print(url);

    Response response = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonConverted,
    );

    if (response.statusCode == 200) {
      print("API called successfully");
      print(jsonDecode(response.body));
      return PriorityResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  // PPM Start here

  Future<TaskModel> getCMListMain({required String type}) async {
    // set up Post request arguments
    String method = ServerUrl.CMLIST + '?employee_id=' + await getEmployeeID() + '&status=' + type; ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return  TaskModel.fromJson(jsonDecode(response.body));;
  }

  Future<CMAdditionalEmployeeModel> getCMAdditionalEmp({required String cmid}) async {
    // set up Post request arguments
    String method = ServerUrl.ADDITIONAL_EMP  + "?helpdeskId=" + cmid ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  CMAdditionalEmployeeModel.fromJson(jsonDecode(response.body));;
  }

  Future<RemovalPostResponse> getPostImageDelete({required int  taskid }) async {
    // set up Post request arguments
    String method = ServerUrl.IMAGE_DELETE + '?taskId=' + taskid.toString(); ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);
    print("Result:" + response.body);
    return  RemovalPostResponse.fromJson(jsonDecode(response.body));;
  }

  Future<RemovalResponse> getImageDelete({required int  taskid }) async {
    // set up Post request arguments
    String method = ServerUrl.IMAGE_DELETE + '?taskId=' + taskid.toString(); ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);
    print("Result:" + response.body);
    return  RemovalResponse.fromJson(jsonDecode(response.body));;
  }

  Future<CMMaterialModel> getCMMaterialEmp({required String cmid}) async {
    // set up Post request arguments
    String method = ServerUrl.ADDITIONAL_EMP  + "?helpdeskId=" + cmid ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  CMMaterialModel.fromJson(jsonDecode(response.body));;
  }

  Future<OccupantSignResponseModel> getOccupantSignSaveStatus(
      {required File ActualFileData, required String work_id , required String type}) async {
    String method = ServerUrl.IMAGE_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    // Add your multipart parameters
    //request.fields['userid'] = await getUserID();
    request.fields['createdBy'] = await getUserID();
    request.fields['id'] = work_id;


    // Add your file to the request

    request.files.add(
      http.MultipartFile(
        'tenantSignature', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );



    try {
      // Send the request
      http.Response response =
      await http.Response.fromStream(await request.send());

      print("After API call");
      print("Return Response" +  response.body);
      if (response.statusCode == 200) {
        print("API called successfully");
        return OccupantSignResponseModel.fromJson(jsonDecode(response.body));
      } else {

        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<TechSignResponseModel> getTechSignStatus(
      {required File ActualFileData, required String work_id , required String type}) async {
    String method = ServerUrl.IMAGE_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    // Add your multipart parameters
    //request.fields['userid'] = await getUserID();
    request.fields['createdBy'] = await getUserID();
    request.fields['id'] = work_id;


    // Add your file to the request

    request.files.add(
      http.MultipartFile(
        'technicianSignature', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );



    try {
      // Send the request
      http.Response response =
      await http.Response.fromStream(await request.send());

      print("After API call");
      print("Return Response" +  response.body);
      if (response.statusCode == 200) {
        print("API called successfully");
        return TechSignResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<CMSubmitResponseModel> postCMSubmit({required CMSubmitRequestModel submitmodel}) async {
    // set up Post request arguments
    String method = ServerUrl.CMSUBMIT;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();
    String body = jsonEncode(submitmodel.toJson());

    print(body);
    print(url);

    Response response =
    await post(Uri.parse(url), headers: headers, body: body);
    print("After API call");
    print("Return Response" +  response.body);
    if (response.statusCode == 200) {
      print("API called successfully");
      return CMSubmitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }

  }

  Future<RootCauseResponse> getRootCause() async {
    // set up Post request arguments
    String method = ServerUrl.ROOTCAUSE ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);
    print("Result:" + response.body);
    return  RootCauseResponse.fromJson(jsonDecode(response.body));;
  }

  Future<StartTimeResponseModel> getStartTime({required String starttime , required String cmid}) async {
    // set up Post request arguments
    String method = ServerUrl.CMSTART;
    String server = '${await getBaseURL()}';
    String url =    server +  method;

    Map<String, dynamic> complaintData = {
      'id': int.parse(cmid),
      'complainedDate': starttime,
    };
    String body = jsonEncode(complaintData);
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(body);
    Response response =
    await put(Uri.parse(url), headers: headers , body: body);
    if (response.statusCode == 200) {
    return  StartTimeResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<CMDetailsResponseModel> getCMDetails({required String cmid}) async {
    // set up Post request arguments
    String method = ServerUrl.CMDETAILS  + "?id=" + cmid ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  CMDetailsResponseModel.fromJson(jsonDecode(response.body));;
  }


  Future<UploadFileAfterResponseModel> getAfterFileUploadStatus(
      {required File ActualFileData, required String work_id , required String type}) async {
    String method = ServerUrl.IMAGE_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    // Add your multipart parameters
    //request.fields['userid'] = await getUserID();
    request.fields['createdBy'] = await getUserID();
    request.fields['id'] = work_id;


    // Add your file to the request

    request.files.add(
      http.MultipartFile(
        'afterPhoto', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );



    try {
      // Send the request
      http.Response response =
      await http.Response.fromStream(await request.send());

      print("After API call");
      print("Return Response" +  response.body);
      if (response.statusCode == 200) {
        print("API called successfully");
        return UploadFileAfterResponseModel.fromJson(jsonDecode(response.body));
      } else {

        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<UploadFileResponseFMModel> getFileUploadStatusFM(
      {required File ActualFileData, required String work_id , required String type}) async {

    String method = ServerUrl.IMAGE_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    request.fields['createdBy'] = await getUserID();
    request.fields['id'] = work_id;


    // Add your file to the request
    request.files.add(
      http.MultipartFile(
        'beforePhoto', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );

    try {
      // Send the request
      http.Response response =
      await http.Response.fromStream(await request.send());

      print("After API call");
      print("Return Response" +  response.body);
      if (response.statusCode == 200) {
        print("API called successfully");
        return UploadFileResponseFMModel.fromJson(jsonDecode(response.body));
      } else {

        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<ModuleResponse> getModuleCount() async {
    // set up Post request arguments
    String method = ServerUrl.MODULE_COUNT + '?employee_id=' + await getEmployeeID(); ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  ModuleResponse.fromJson(jsonDecode(response.body));;
  }

  Future<PPMAdditionalEmployeeModel> getPPMAdditionalEmp({required String ppmid}) async {
    // set up Post request arguments
    String method = ServerUrl.PPM_ADDITIONAL_EMP  + "?ppmId=" + ppmid ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  PPMAdditionalEmployeeModel.fromJson(jsonDecode(response.body));;
  }

  Future<PPMBarcodeResponseModel> getPPMBarcode({required String ppmid}) async {
    // set up Post request arguments
    String method = ServerUrl.CMDETAILS  + "?id=" + ppmid ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  PPMBarcodeResponseModel.fromJson(jsonDecode(response.body));;
  }

  Future<SubmitResponseModel> postDefectSubmit({required SubmitDefectInput submitDefectInput}) async {
    // set up Post request arguments
    String method = ServerUrl.PPM_DEFECT ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);

    String body = jsonEncode(submitDefectInput.toJson());

    print(body);
    print(url);
    Response response =
    await put(Uri.parse(url), headers: headers, body: body);

    print("Result:" + response.body);
    return  SubmitResponseModel.fromJson(jsonDecode(response.body));;
  }


  Future<PPMChecklistModel> getPPMCheckpoint({required String ppmid}) async {
    // set up Post request arguments
    String method = ServerUrl.PPM_CHECKPOINT  + "?ppmId=" + ppmid ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);

    print(response.body);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  PPMChecklistModel.fromJson(jsonDecode(response.body));;
  }
  Future<PPMList> getPPMListMain({required String type}) async {
    // set up Post request arguments
    String method = ServerUrl.PPMLIST + '?employee_id=' + await getEmployeeID() + '&status=' + type; ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return  PPMList.fromJson(jsonDecode(response.body));;
  }

  Future<PPMDetailsResponseModelOne> getPPMDetails1({required String ppmid}) async {
    // set up Post request arguments
    String method = ServerUrl.PPMDETAILS  + "?id=" + ppmid ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();

    print(headers);

    print(url);

    Response response =
    await get(Uri.parse(url), headers: headers);

    print(response.body);
    // check the status code for the result
    // displayAPICallDetails(response, jsonConverted, headers);
    return  PPMDetailsResponseModelOne.fromJson(jsonDecode(response.body));;
  }

  Future<PPMStartTimeResponseModel> getPPMStartTime({required String starttime , required String ppmid}) async {
    // set up Post request arguments
    String method = ServerUrl.PPMSTART;
    String server = '${await getBaseURL()}';
    String url =    server +  method;

    Map<String, dynamic> complaintData = {
      'ppmId': int.parse(ppmid),
      'technicianDateTime': starttime,
    };
    String body = jsonEncode(complaintData);
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    print(body);
    Response response =
    await put(Uri.parse(url), headers: headers , body: body);
    if (response.statusCode == 200) {
    return  PPMStartTimeResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<PPMPostUploadFileResponseModel> getPPMPostFileUploadStatus(
      {required File ActualFileData, required String work_id , required String type}) async {

    String method = ServerUrl.PPM_IMAGE_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    request.fields['createdBy'] = await getUserID();
    request.fields['id'] = work_id;


    // Add your file to the request
    request.files.add(
      http.MultipartFile(
        'afterPhoto', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );

    try {
      // Send the request
      http.Response response =
      await http.Response.fromStream(await request.send());

      print("After API call");
      print("Return Response" +  response.body);
      if (response.statusCode == 200) {
        print("API called successfully");
        return PPMPostUploadFileResponseModel.fromJson(jsonDecode(response.body));
      } else {

        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<RemovalResponse> getPPMImageDelete({required int  taskid }) async {
    // set up Post request arguments
    String method = ServerUrl.PPM_IMAGE_DELETE + '?id=' + taskid.toString(); ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);
    print("Result:" + response.body);
    return  RemovalResponse.fromJson(jsonDecode(response.body));;
  }

  Future<PPMUploadFileResponseModel> getPPMFileUploadStatus(
      {required File ActualFileData, required String work_id , required String type}) async {

    String method = ServerUrl.PPM_IMAGE_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    request.fields['createdBy'] = await getUserID();
    request.fields['id'] = work_id;


    // Add your file to the request
    request.files.add(
      http.MultipartFile(
        'beforePhoto', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );

    try {
      // Send the request
      http.Response response =
      await http.Response.fromStream(await request.send());

      print("After API call");
      print("Return Response" +  response.body);
      if (response.statusCode == 200) {
        print("API called successfully");
        return PPMUploadFileResponseModel.fromJson(jsonDecode(response.body));
      } else {

        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<PPMStatusModel> getPPMStatus({required String type}) async {
    // set up Post request arguments
    String method = ServerUrl.PPMSTATUS + '?employee_id=' + await getEmployeeID() + '&status=' + type; ;
    String server = '${await getBaseURL()}';
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return  PPMStatusModel.fromJson(jsonDecode(response.body));;
  }

  Future<PPMTechSignResponseModel> getPPMTechSignStatus(
      {required File ActualFileData, required String work_id , required String type}) async {
    String method = ServerUrl.PPM_IMAGE_UPLOAD;
    String endpoint = '${await getBaseURL()}$method';
    print("Before API call: $endpoint");
    Map<String, String> headers = await getHeader();
    // Create a MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    // Add headers to the request
    request.headers.addAll(headers);

    // Add your multipart parameters
    //request.fields['userid'] = await getUserID();
    request.fields['createdBy'] = await getUserID();
    request.fields['id'] = work_id;


    // Add your file to the request

    request.files.add(
      http.MultipartFile(
        'technicianSignature', // Name of the parameter on the server
        ActualFileData.readAsBytes().asStream(),
        ActualFileData.lengthSync(),
        filename: ActualFileData.path.split("/").last,
      ),
    );



    try {
      // Send the request
      http.Response response =
      await http.Response.fromStream(await request.send());

      print("After API call");
      print("Return Response" +  response.body);
      if (response.statusCode == 200) {
        print("API called successfully");
        return PPMTechSignResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error occurred during API call: $e');
    }
  }

  Future<SubmitResponseModel> postPPMSubmit({required PPMSubmitRequestModelOne ppmSubmitRequestModel}) async {
    // set up Post request arguments
    String method = ServerUrl.PPM_SUBMIT;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;

    // Prepare headers
    Map<String, String> headers = await getHeader();
    String body = jsonEncode(ppmSubmitRequestModel.toJson());

    print(body);
    print(url);

    Response response =
    await post(Uri.parse(url), headers: headers, body: body);
    print("After API call");
    print("Return Response" +  response.body);
    if (response.statusCode == 200) {
      print("API called successfully");
      return SubmitResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }

  }

  Future<ComplainerData> getComplaintReg() async {
    // set up Post request arguments
    String method = ServerUrl.COMPLAINT_REG ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);
    Response response =
    await get(Uri.parse(url), headers: headers);
    print("Result:" + response.body);
    return  ComplainerData.fromJson(jsonDecode(response.body));;
  }


  Future<SubmitResponseModel> putComplaintRegSubmit({required ComplaintSubmitInput complaintSubmitInput}) async {
    // set up Post request arguments
    String method = ServerUrl.COMPLAINT_SUBMIT ;
    String server = '${await getBaseURL()}';;
    String url =    server +  method;
    // Prepare headers
    Map<String, String> headers = await getHeader();
    print(url);

    String body = jsonEncode(complaintSubmitInput.toJson());

    print(body);
    print(url);
    Response response =
    await post(Uri.parse(url), headers: headers, body: body);

    print("Result:" + response.body);
    return  SubmitResponseModel.fromJson(jsonDecode(response.body));;
  }

}
