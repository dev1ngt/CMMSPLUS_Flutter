import 'package:cmms/src/helpers/config/server_url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static void showInSnackBar(
      BuildContext context, String value, int toastType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: TextStyle(
              color:
                  toastType == ToastType.Warning ? Colors.black : Colors.white),
        ),
        backgroundColor: Utils()._getColor(toastType),
        // duration: Duration(milliseconds: 300),
      ),
    );
  }

  Color _getColor(int toastType) {
    Color returnColor;
    if (toastType == ToastType.Success) {
      returnColor = Colors.green;
    } else if (toastType == ToastType.Error) {
      returnColor = Colors.red;
    } else {
      returnColor = Colors.yellow;
    }
    return returnColor;
  }

  String getURL() {
    var urlString = '';
    urlString = ServerUrl.BASE_URL;
    return urlString;
  }

}

validateStatusCode(int statusCode, BuildContext context) {
  int tempStatusCode = statusCode;

  if (tempStatusCode == 401) {
    //_showUnAuthorisedAccessAlert(context);
  } else {
    //
  }
}

class ToastType {
  static const int Success = 1;
  static const int Error = 2;
  static const int Warning = 3;
}



