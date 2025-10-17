import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../api/api_service.dart';
import '../../../api/login_api_handler.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/utils.dart';
import '../bloc/qrscan_bloc.dart';
import '../bloc/qrscan_event.dart';


class QRCodeScan extends StatelessWidget {
  const QRCodeScan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const QRViewExample();
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {


  Barcode? result;
  MobileScannerController controller = MobileScannerController();

  String navigation = "";
  String webviewPath = "";

  bool _isLoading = false;

  String latitude = '';
  String longitude = '';
  String userId = '';
  String location = '';
  String baseUrl = '';
  Map<String, String> headers = {};

  late QRScanBloc qrScanBloc;
  bool isTorchOn = false;

  @override
  void initState() {
    super.initState();

    if (context != null) {
      qrScanBloc = QRScanBloc(RepositoryProvider.of<ApiService>(context))
        ..add(QRScanEventInit());
    }
  }

  // The rest of your location and API call code remains the same

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('Types')) {
      navigation = args['Types'] as String;
      log('Navigation parameter: $navigation');
    }

    if (args != null && args.containsKey("WebView")) {
      webviewPath = args['WebView'] as String;
      log('WebView path: $webviewPath');
    }

    return BlocProvider(
      create: (context) => qrScanBloc,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/ic_back.png',
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
             /*   const Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png',
                  width: 100,
                  height: 20,
                ),*/
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/dashboard'),
                  child: Image.asset(
                    'assets/images/ic_home.png',
                    width: 20,
                    height: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
         /*   flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.customColor1,
                    AppColors.customColor2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),*/
          ),
          body: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
              children: <Widget>[
                Expanded(flex: 4, child: _buildQrView(context)),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (result != null)
                          Center(
                            child: Text('Data: ${result!.rawValue}'),
                          )
                        else
                          const Text('Scan a code'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await controller.toggleTorch();
                                  setState(() {
                                    isTorchOn = !isTorchOn;  // toggle your local torch state
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.themeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(isTorchOn ? 'Flash: On' : 'Flash: Off', style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await controller.switchCamera();
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.themeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Flip Camera', style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await controller.stop();
                                  if (result == null ||
                                      result!.rawValue == null ||
                                      result!.rawValue!.isEmpty) {
                                    Utils.showInSnackBar(
                                        context,
                                        "Invalid Result",
                                        ToastType.Warning);
                                  } else if (navigation ==
                                      "PendingDetails") {
                                    Navigator.pushNamed(
                                      context,
                                      "/pendingDetails",
                                      arguments: {
                                        'QRResult': result!.rawValue,
                                      },
                                    );
                                  } else if (navigation == "PPMDetails") {
                                    Navigator.pop(
                                      context,
                                      {
                                        'QRResult': result!.rawValue,
                                        'WebView': webviewPath,
                                      },
                                    );
                                  }
                                  else if (navigation ==
                                      "MyCases") {
                                    Navigator.pop(context, {
                                      'QRResult': result?.rawValue,
                                      'WebView': webviewPath,
                                    });

                                  }
                                  else if (navigation ==
                                      "PPMCompletedDetails") {
                                    Navigator.pop(context, {
                                      'QRResult': result!.rawValue,
                                      'WebView': webviewPath,
                                    });
                                  } else if (navigation ==
                                      "ppmClosedDetails") {
                                    Navigator.pushNamed(
                                      context,
                                      "/ppmClosedDetails",
                                      arguments: {
                                        'QRResult': result!.rawValue,
                                        'WebView': webviewPath,
                                      },
                                    );
                                  } else if (navigation == "Dashboard") {
                                    Navigator.pushNamed(
                                      context,
                                      "/publicWebView",
                                      arguments: {
                                        'QRResult': result!.rawValue,
                                      },
                                    );
                                  } else if (navigation == "CheckIn") {
                                    String propertyId = result!.rawValue!;
                                    await getLocation(propertyId);

                                    Navigator.pushNamed(
                                      context,
                                      "/displayCheckIn",
                                      arguments: {
                                        'QRResult': result!.rawValue,
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.themeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Submit',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await controller.start();
                                  setState(() {
                                    result = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.themeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Re Scan',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getLocation(String propertyId) async {
    setState(() {
      _isLoading = true;
    });
    headers = await getHeader();
    userId = await AppSharedPrefs.getUserID();
    baseUrl = await AppSharedPrefs.getBaseUrl();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();

    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    location = place.street.toString() +
        ', ' +
        place.locality.toString() +
        ', ' +
        place.country.toString() +
        ', ' +
        place.postalCode.toString();

    if (latitude.isNotEmpty && longitude.isNotEmpty && location.isNotEmpty) {
      _makeApiCall(context, propertyId);
    }
  }

  Widget _buildQrView(BuildContext context) {
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 220.0
        : 250.0;

    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          fit: BoxFit.cover,
          onDetect: (barcodeCapture) {
            final List<Barcode> barcodes = barcodeCapture.barcodes;
            if (barcodes.isEmpty) {
              log('Failed to scan Barcode');
              return;
            }

            final barcode = barcodes.first;
            if (mounted) {
              setState(() {
                result = barcode;
                controller.stop(); // stop once scanned
              });
            }
          },
          scanWindow: Rect.fromCenter(
            center: Offset(
              MediaQuery.of(context).size.width / 2,
              MediaQuery.of(context).size.height / 2,
            ),
            width: scanArea,
            height: scanArea,
          ),
        ),

        /// Scanner overlay
       /* Center(
          child: Container(
            width: scanArea,
            height: scanArea,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),*/

        /// Optional: Add an animated red line (like real scanners)
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -scanArea / 2, end: scanArea / 2),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Container(
                    width: scanArea,
                    height: 2,
                    color: Colors.redAccent,
                  ),
                );
              },
              onEnd: () {
                // restart animation
              },
            ),
          ),
        ),
      ],
    );
  }



  Future<void> _makeApiCall(BuildContext context, String propertyId) async {
    print('$userId, $propertyId, $latitude, $longitude');
    print(headers);

    final url = Uri.parse("${baseUrl}CheckUserProperty?"
        "propert_id=$propertyId"
        "&userid=$userId"
        "&latitute=$latitude"
        "&longitute=$longitude");

    Response response = await post(
      url,
      headers: headers,
    );

    try {
      print(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        bool status = data['status'];
        print(status);
        setState(() {
          _isLoading = false;
        });
        if (status == true) {
          Utils.showInSnackBar(context, data['message'], ToastType.Success);
          Navigator.pushReplacementNamed(
            context,
            "/displayCheckIn",
            arguments: {
              'QRResult': result?.rawValue,
              'Lat': latitude,
              'Long': longitude,
              'Location': location,
// Add more parameters as needed
            },
          );
//Navigator.pop(context);
        } else {
          Utils.showInSnackBar(context, data['message'], ToastType.Error);
          Navigator.pop(context);
        }
      } else {
        Utils.showInSnackBar(
            context, response.reasonPhrase.toString(), ToastType.Error);
        Navigator.pop(context);
      }
    } catch (e) {
      Utils.showInSnackBar(context, 'Error', ToastType.Error);
      Navigator.pop(context);
    }
  }

  Future<String> getContractCode() async {
    return await AppSharedPrefs.getContractCode();
  }

  Future<Map<String, String>> getHeader() async {
    return {
      'Content-type': 'application/json',
      'X-Project-Code': await getContractCode(),
    };
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
