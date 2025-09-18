import 'package:cmms/src/features/login/model/login_model.dart';
import 'package:cmms/src/helpers/config/server_url.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:cmms/src/helpers/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

bool isSkipLog = false;
displayAPICallDetails(Response response, String requestBody, Map<String, String> requestHeader)
{
  if (isSkipLog) {
    if (kDebugMode) {
      isSkipLog = false;
      debugPrint(
          '*************************\n\n\nRequest type:----->${response.request?.method}\nstatusCode:----->${response.statusCode} \nurl:----->${response.request?.url})\nrequestHeader:----->${requestHeader}\nrequestBody:----->${requestBody}\n\n*************************');
    }
  } else {
    if (kDebugMode) {
      debugPrint(
          '*************************\n\n\nRequest type:----->${response.request?.method}\nstatusCode:----->${response.statusCode} \nurl:----->${response.request?.url})\nrequestHeader:----->${requestHeader}\nrequestBody:----->${requestBody}\nResponse data:----->${response.body}\n\n*************************');
    }
  }
}

Future<String> getBaseURL() async {
  return await AppSharedPrefs.getBaseUrl();
}

displayAPICallRequest(String URLString, String requestBody, Map<String, String> requestHeader)
{
  if (isSkipLog) {
    if (kDebugMode) {
      isSkipLog = false;
      debugPrint(
          '*************************\nurl:----->$URLString\nrequestHeader:----->${requestHeader}\nrequestBody:----->${requestBody}\n\n*************************');
    }
  } else {
    if (kDebugMode) {
      debugPrint(
          '*************************\nurl:----->$URLString\nrequestHeader:----->${requestHeader}\nrequestBody:----->${requestBody}\n\n*************************');
    }
  }
}

Future<Map<String, String>> getHeader() async {
  Map<String, String> headers = {
    'Content-type': 'application/json',
  };

  headers = {
    'Content-type': 'application/json',
  };

  return headers;
}

/*
   *  Post with Header
*/
Future<Response> postUserLogin(LoginInput loginInput) async {
  // set up Post request arguments
  String method = ServerUrl.USER_LOGIN;
  String url = '${await getBaseURL()}$method';
  Map<String, String> headers = await getHeader();
  var jsonConverted = jsonEncode(loginInput.toJson());

  if (kDebugMode) {
    debugPrint('url:------->${url}');
    displayAPICallRequest(url, jsonConverted, headers);
  }
  Response response =
      await post(Uri.parse(url), headers: headers, body: jsonConverted);
  // check the status code for the result
  displayAPICallDetails(response, jsonConverted, headers);
  return response;
}
