

import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/features/inprogress/list/view/inprogress_list.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/utils/utils.dart';
import '../bloc/publicwebview_bloc.dart';
import '../bloc/publicwebview_event.dart';
import '../bloc/publicwebview_state.dart';




class PublicWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider( // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<PublicWebviewBloc>(
          create: (context) =>
              PublicWebviewBloc(RepositoryProvider.of<ApiService>(context)),
        ),

      ],
      child: PublicWebViewShow(),
    );
    // return InprogressDetails();
  }
}

class PublicWebViewShow extends StatefulWidget {
  @override
  _PublicWebViewShowState createState() => _PublicWebViewShowState();
}

class _PublicWebViewShowState extends State<PublicWebViewShow> {

  late PublicWebviewBloc publicWebviewBloc;

  //late WebViewController controller;
   InAppWebViewController? _webViewController;
  String webview_url  = "";
  bool _isAPICalled = true;
  String url = "";
  double progress = 0;


  @override
  void initState() {
    super.initState();
    publicWebviewBloc = BlocProvider.of<PublicWebviewBloc>(context);

  }



  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic>? args = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('QRResult')) {
      final String qr_result = args['QRResult'] as String;
      print(' $qr_result');
      if(_isAPICalled){
        publicWebviewBloc.add(PublicWebviewQRScanResult(asset_code: qr_result));
      }


    }


    return BlocProvider(
      create: (context) => publicWebviewBloc,
      child: WillPopScope(
        onWillPop: () async {
          final dashboard =  await  Navigator.pushNamed(context, '/dashboard');
          Navigator.pop(context, dashboard);

          return true;
        },
        child:  Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final dashboard =  await  Navigator.pushNamed(context, '/dashboard');
                    Navigator.pop(context, dashboard);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/ic_back.png',
                      // Replace with your ic_back image asset
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png', // replace with your image path
                  width: 100,
                  height: 20,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle your onClick event here
                    Navigator.pushNamed(context, '/dashboard'); // Example: Navigate to home page
                  },
                  child: Image.asset(
                    'assets/images/ic_home.png', // replace with your image path
                    width: 20,
                    height: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.customColor1,
                    AppColors.customColor2,
                  ], // Replace with your gradient colors
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body:  SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "WebView",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0, // Adjust the font size as needed
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),


                BlocListener<PublicWebviewBloc, PublicWebviewState>(
                  listener: (context, state) async {
                    if (state is PublicWebviewSuccess) {
                      Utils.showInSnackBar(
                          context, state.assetResponseModel.message!, ToastType.Success);
                      try{
                        setState(() {
                          _isAPICalled = false;
                          webview_url = state.assetResponseModel.url;
                          print(webview_url);

                        });
                      }catch(e){
                        print(e);
                      }

                    }
                    else if (state is PublicWebviewFailure) {
                      Utils.showInSnackBar(context, state.error, ToastType.Warning);
                    }
                  },

                  child: BlocBuilder<PublicWebviewBloc, PublicWebviewState>(
                      builder: (context, state) {
                        if(state is PublicWebviewScanLoad){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }),
                ),

                // SingleChildScrollView(
                //   child: Container(
                //    height: 600,
                //     child: InAppWebView(
                //       initialUrlRequest: URLRequest(
                //           url: WebUri(webview_url)
                //       ),
                //       initialOptions: InAppWebViewGroupOptions(
                //           crossPlatform: InAppWebViewOptions(
                //
                //           )
                //       ),
                //       onWebViewCreated: (InAppWebViewController controller) {
                //         _webViewController = controller;
                //       },
                //
                //       onLoadStart: (InAppWebViewController controller, WebUri? url) {
                //       setState(() {
                //       print(url.toString());
                //       });
                //       },
                //       onLoadStop: (InAppWebViewController controller, WebUri? url) async {
                //       setState(() {
                //         print(url.toString());
                //       });
                //       },
                //       onProgressChanged: (InAppWebViewController controller, int progress) {
                //         setState(() {
                //           this.progress = progress / 100;
                //         });
                //       }
                //     ),
                //
                //
                //   ),
                // ),


              ],
            ),
          ),
        ),),);
  }
}

showAlertDialog({required BuildContext context, required String title, required String content}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ""),
          content: Text(content ?? ""),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Continue'),
              ),
            ),
          ],
        );
      });
}



