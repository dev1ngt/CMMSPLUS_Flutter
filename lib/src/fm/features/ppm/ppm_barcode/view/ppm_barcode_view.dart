import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../../../../../helpers/utils/app_shared_preference.dart';
import '../../../../../helpers/utils/utils.dart';
import '../../ppm_submit/model/ppm_submit_request_model.dart';
import '../../ppm_submit/model/ppm_submit_save.dart';
import '../bloc/ppmbarcode_bloc.dart';
import '../bloc/ppmbarcode_event.dart';
import '../bloc/ppmbarcode_state.dart';
import '../model/ppm_barcode_response_model.dart';

class PPMBarcodeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PPMBarcodeBloc>(
          create: (context) =>
              PPMBarcodeBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: PPMBarcodeState_(),
    );
  }
}

class PPMBarcodeState_ extends StatefulWidget {
  @override
  _PPMBarcodeState createState() => _PPMBarcodeState();
}

class _PPMBarcodeState extends State<PPMBarcodeState_> {
  @override
  bool _ApiCalled = false;
  late PPMBarcodeBloc ppmBarcodeBloc;

  String taskNo = "",
      assetBarcode = "",
      assetName = "",
      assetTagno = "",
      QRResult = "" , assetNo = "";
  bool isQrcode = false;
  String ppmid = "" , userid = "";
  String startTime = "";
  int isBarcodeValidate = 0;
  PPMSubmitSaveModel viewModel = PPMSubmitSaveModel();
  TextEditingController barcode_number_controller = TextEditingController();
  TextEditingController defect_controller = TextEditingController();

  SubmitDefectInput submitDefectInput = SubmitDefectInput();

  void initState() {
    super.initState();
    ppmBarcodeBloc = BlocProvider.of<PPMBarcodeBloc>(context);

    PPMSubmitRequestModelOne ppmSaveModel = viewModel.ppmSubmitRequestModel;
    if (ppmSaveModel.ppmID != null) {
      assetNo = ppmSaveModel.assetNo!;
      assetName = ppmSaveModel.assetName!;
      assetTagno = ppmSaveModel.assetTagNo!;
      isQrcode  = ppmSaveModel.isQrcode!;
    }
    getSharedPrefe();
    }

  @override
  void dispose() {
    ppmBarcodeBloc.close();
    super.dispose();
  }

  Future<void> getSharedPrefe() async {
    ppmid = await AppSharedPrefs.getPPMID();
    userid  = await AppSharedPrefs.getUserID();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("PPMID")) {
      final String ppmID_ = args['PPMID'] as String;
      if (!_ApiCalled) {
        _ApiCalled = true;
        ppmid = ppmID_;
      }
    }

    if (args != null && args.containsKey('QRResult')) {
      final String navigation = args['QRResult'] as String;
      print('QR Scan  parameter: $navigation');
      QRResult = navigation;
      barcode_number_controller.text = navigation;
      /*  assetInput.id = QRResult;
      if (!_assetApiCalled) {
        _assetApiCalled = true;
        assetScanBloc.add(FetchAssetScanEvent(assetInput));
      }*/
    }
    return BlocProvider(
      create: (context) => ppmBarcodeBloc,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFF006BE6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'PPM Barcode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: TextButton(
                  onPressed: () {

                    if(isQrcode){
                      if(barcode_number_controller.text == assetNo){
                        Navigator.pushNamed(context, '/ppmbeforeimages');
                      }
                      else {
                        Utils.showInSnackBar(
                            context, "Invalid Barcode/QRCode ", ToastType.Warning);
                      }

                    }
                    else {
                      Navigator.pushNamed(context, '/ppmbeforeimages');
                    }


                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Color(0xFF006BE6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [


                        BlocListener<PPMBarcodeBloc, PPMBarcodeState>(
                          listener: (context, state) {
                            if (state is PPMBarcodeSuccessState) {
                              setState(() {
                                //taskNo = state. ;
                              });
                            } else if (state is PPMBarcodeFailureState) {
                              Utils.showInSnackBar(
                                  context, state.loginError, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<PPMBarcodeBloc, PPMBarcodeState>(
                            builder: (context, state) {
                              if (state is PPMBarcodeLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),

                        /* Defect submit start*/


                        BlocListener<PPMBarcodeBloc, PPMBarcodeState>(
                          listener: (context, state) {
                            if (state is DefectSubmitLoaded) {
                              setState(() {
                                //taskNo = state. ;
                                Utils.showInSnackBar(
                                    context, state.complaintreg.message!, ToastType.Success);
                                Navigator.pushNamed(context, '/dashboard');

                              });
                            } else if (state is DefectSubmitError) {
                              Utils.showInSnackBar(
                                  context, state.error, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<PPMBarcodeBloc, PPMBarcodeState>(
                            builder: (context, state) {
                              if (state is DefectSubmitInProgress) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),

                         /* -----   -    */

                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF006BE6), // Blue background color
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Asset Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              _buildRow('Asset Name', assetName),
                              _buildRow('Asset Tagno', assetTagno),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF006BE6), // Blue background color
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            ' Scan Result',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isQrcode
                                    ? 'Barcode number validation mandatory'
                                    : 'Barcode number validation non-mandatory',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          // Adjust the horizontal padding to control width
                          child: Container(
                            width: 200, // Set the desired width
                            child: TextFormField(
                              controller: barcode_number_controller,
                              decoration: InputDecoration(
                                labelText: 'Barcode Number',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0), // Adjust the value as needed
                              ),
                              keyboardType: TextInputType.number,
                              maxLines:
                                  null, // Allows the user to input multiple lines
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/qrScan",
                                arguments: {
                                  'Types': 'PPMBarcode',
                                  // Add more parameters as needed
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.qr_code, // or any other icon you want
                                  color: Color(0xFF006BE6), // Color of the icon
                                ),
                                SizedBox(width: 8.0), // Space between the icon and the text
                                Text(
                                  'Scan QR / Barcode',
                                  style: TextStyle(
                                    color: Color(0xFF006BE6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Handle floating action button press
              _showMenu(context);
            },
            backgroundColor: Color(0xFF006BE6),
            child: Icon(Icons.more_horiz_sharp , color: AppColors.whiteColor,),
          ),


        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // Ensure texts start from the starting point
        crossAxisAlignment: CrossAxisAlignment.center,
        // Align texts vertically centered
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              ": " + value,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  void _showMenu(BuildContext context) {
    final RenderBox fabRenderBox = context.findRenderObject() as RenderBox;
    final Offset fabOffset = fabRenderBox.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      fabOffset.dx,
      fabOffset.dy - fabRenderBox.size.height, // Position menu above the FAB
      fabOffset.dx + fabRenderBox.size.width,
      fabOffset.dy, // Bottom position set to the FAB's top position
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: Text('Hold'),
          value: 1,
        ),
        PopupMenuItem(
          child: Text('Defect'),
          value: 2,
        ),

      ],
    ).then((value) {
      if (value != null) {
        // Handle menu item selection if needed
        switch (value) {
          case 1:
          // Handle Option 1

          /*  Navigator.pushNamed(context, '/cmmaterialview' ,
              arguments: {
                'CMID': "1",
              },);*/

            break;
          case 2:
          // Handle Option 2

            _showCustomDialog();

            break;

        }
      }
    });
  }

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF006BE6), // Blue background color
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Submit Defect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Are you sure you want to submit this work order as a defect?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: defect_controller,
                        decoration: InputDecoration(
                          labelText: 'Brief the reason.',
                          labelStyle: TextStyle(color: Colors.grey), // Custom label color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF006BE6), // Custom outline color when focused
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF006BE6), // Custom outline color when not focused
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () async {

                       if(defect_controller.text.isEmpty){
                         Utils.showInSnackBar(context,  "Enter the reason" , ToastType.Error);
                       }
                       else {

                         submitDefectInput.ppmid = int.parse(ppmid);
                         submitDefectInput.user_id = int.parse(userid);
                         submitDefectInput.description = defect_controller.text;

                         ppmBarcodeBloc.add(DefectSubmitEvent(submitDefectInput));
                         Navigator.of(context).pop();

                       }


                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Color(0xFF006BE6),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
