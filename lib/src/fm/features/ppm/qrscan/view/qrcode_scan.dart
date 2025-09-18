/*
import 'dart:developer';
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../bloc/qrscan_bloc.dart';
import '../bloc/qrscan_event.dart';


class QRCodeScan extends StatelessWidget {
  const QRCodeScan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   QRViewExample();
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String Navigation = "" , webview_path = "";
  String ScanResult = "";
  late QRScanBloc qrScanBloc;




  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (context != null) {
      qrScanBloc = QRScanBloc(RepositoryProvider.of<ApiService>(context))
        ..add(QRScanEventInit());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access parameters here
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Check if args is not null and contains the required parameters
    if (args != null && args.containsKey('Types')) {
      final String navigation = args['Types'] as String;
      print('Navigation parameter: $navigation');
      Navigation = navigation;
    }

    if (args != null && args.containsKey("WebView")) {
      final String webview = args['WebView'] as String;
      webview_path = webview;
      print(webview_path);
      // controller.loadRequest(
      // Uri.parse(webview_path),
      // );
    }
   return BlocProvider(
        create: (context) => qrScanBloc,
        child: WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006BE6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(

          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Scan Barcode',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: Column(
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

                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
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
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.primaryColor, backgroundColor: Colors.white, // Text color
                              textStyle: TextStyle(fontSize: 20), // Text style
                            ),
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),

                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Background color

                            ),
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}' ,style: TextStyle(fontSize: 18, color: AppColors.primaryColor),);
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
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
                            await controller?.pauseCamera();

                            if(result?.code == "" || result?.code == null){
                              Utils.showInSnackBar(context, "Invalid Result", ToastType.Warning);
                            }
                            else if(Navigation == "PPMBarcode"){

                               Navigator.pushNamed(context, "/ppmbarcode", arguments: {
                                 'QRResult': result?.code,
                                 // Add more parameters as needed
                               }, );
                           }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor, backgroundColor: Colors.white, // Text color
                            textStyle: TextStyle(fontSize: 20), // Text style
                          ),
                          child: const Text('OK ',),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor, backgroundColor: Colors.white, // Text color
                        textStyle: TextStyle(fontSize: 20), // Text style
                      ),
                          child: const Text('Re Scan',),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),),);
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        this.controller?.pauseCamera();
        result = scanData;
        // Update Navigation based on scan result

      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}*/
