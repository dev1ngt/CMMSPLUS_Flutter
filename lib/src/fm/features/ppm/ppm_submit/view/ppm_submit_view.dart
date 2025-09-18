import 'dart:async';
import 'dart:io';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:cmms/src/helpers/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';


import '../../../../../helpers/utils/app_shared_preference.dart';
import '../bloc/sign/ppm_tech_sign_filesbloc.dart';
import '../bloc/sign/ppm_tech_sign_filesevent.dart';
import '../bloc/sign/ppm_tech_sign_filesstate.dart';
import '../bloc/submit/ppm_submit_bloc.dart';
import '../bloc/submit/ppm_submit_event.dart';
import '../bloc/submit/ppm_submit_state.dart';
import '../model/ppm_submit_request_model.dart';
import '../model/ppm_submit_save.dart';



class PPMFinalSubmitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PPMTechSignFileBloc>(
          create: (context) =>
              PPMTechSignFileBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PPMSubmitBloc>(
          create: (context) =>
              PPMSubmitBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: PPMFinalSubmitState(),
    );
  }
}

class PPMFinalSubmitState extends StatefulWidget {
  @override
  _PPMFinalSubmitState createState() => _PPMFinalSubmitState();
}

class _PPMFinalSubmitState extends State<PPMFinalSubmitState> {
  late PPMTechSignFileBloc techSignFileBloc;
  late PPMSubmitBloc ppmSubmitBloc;
  String ppmid = "" , userid = "";
  String? imagePath;
  bool signatureSaved = false;
  TextEditingController tech_remarks_controller = TextEditingController();
  PPMSubmitSaveModel viewModel = PPMSubmitSaveModel();


  // Signature Controller for capturing and saving signature
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    techSignFileBloc = BlocProvider.of<PPMTechSignFileBloc>(context);
    techSignFileBloc.add(PPMTechSignFileInitEvent());

    ppmSubmitBloc = BlocProvider.of<PPMSubmitBloc>(context);
    ppmSubmitBloc.add(PPMSubmitInitEvent());


    PPMSubmitRequestModelOne ppmSubmitRequestModel = viewModel.ppmSubmitRequestModel;
    if(ppmSubmitRequestModel.tecSign != null && ppmSubmitRequestModel.tecSign!.isNotEmpty){
      imagePath =  ppmSubmitRequestModel.tecSign;
    }

    getSharedPrefe();
  }

  @override
  void dispose() {
    _controller.dispose();
    tech_remarks_controller.dispose();
    techSignFileBloc.close();
    ppmSubmitBloc.close();
    super.dispose();
  }

  Future<void> getSharedPrefe() async {
    ppmid = await AppSharedPrefs.getPPMID();
    userid  = await AppSharedPrefs.getUserID();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("PPMID")) {
      final String ppmID_ = args['PPMID'] as String;
      ppmid = ppmID_;
    }

    return  WillPopScope(
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
            'Submit',
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
                  DateTime now = DateTime.now();
                  String work_end_date_time =
                  DateFormat('dd-MM-yyyy HH:mm').format(now);

                  if(tech_remarks_controller.text == ""){
                    Utils.showInSnackBar(
                        context, "Please enter your remarks", ToastType.Warning);
                  }
                  else if(imagePath!.isEmpty){
                    Utils.showInSnackBar(
                        context, "Signature required", ToastType.Warning);
                  }
                  else {
                    var connectivityResult = (
                        Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                      Utils.showInSnackBar(
                        context,
                        "No internet connection.",
                        ToastType.Error,
                      );
                    } else {
                      viewModel.updatePPMTechRemarks(
                          tech_remarks_controller.text,
                          imagePath!,
                          work_end_date_time, int.parse(userid));
                      ppmSubmitBloc.add(PPMSubmitInProgressEvent(
                          viewModel.ppmSubmitRequestModel));
                    }
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  'Upload',
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
                      BlocListener<PPMTechSignFileBloc, PPMTechSignFileState>(
                        listener: (context, state) {
                          if (state is PPMTechSignFileSuccess) {
                            Utils.showInSnackBar(
                                context,
                                state.fileuploadresponse.message,
                                ToastType.Success);
                            if (state.fileuploadresponse.data.length > 0) {
                              setState(() {
                                signatureSaved = true;
                                imagePath = state
                                    .fileuploadresponse.data[0].technicianSignature;
                                print(imagePath);
                              });
                            }
                          } else if (state is PPMTechSignFileFailure) {
                            Utils.showInSnackBar(
                                context, state.error, ToastType.Warning);
                          }
                        },
                        child: BlocBuilder<PPMTechSignFileBloc, PPMTechSignFileState>(
                          builder: (context, state) {
                            if (state is PPMTechSignFileInProgress) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(); // Your UI when not in progress
                          },
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF006BE6),
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          ' Technician Remarks *',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Update UI Here

                      SizedBox(
                        height: 15,
                      ),

                      Container(
                        child: TextFormField(
                          controller: tech_remarks_controller,
                          decoration: InputDecoration(
                            labelText: 'Enter the remarks',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.multiline,
                          // Allows for multiline input
                          maxLines:
                          null, // Allows the user to input multiple lines
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                          color: Color(0xFF006BE6),
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Signature Pad *',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (signatureSaved && imagePath != null)
                        AspectRatio(
                          aspectRatio: 267 / 110,
                          // Original aspect ratio of the image
                          child: Image.network(
                            imagePath!,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                            // Adjust this based on your preference
                            filterQuality: FilterQuality.high,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                      null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ??
                                          1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Icon(Icons.error, size: 50);
                            },
                          ),
                        )
                      else
                        Signature(
                          controller: _controller,
                          height: 200,
                          width: MediaQuery.of(context)
                              .size
                              .width, // Adjust width as needed
                          backgroundColor: Colors.white,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              _controller.clear();
                              setState(() {
                                signatureSaved = false;
                                imagePath = null;
                              });
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(color: AppColors.primaryColor)),
                              // Border color
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Rounded corners
                                ),
                              ),
                            ),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: AppColors.primaryColor, // Text color
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          OutlinedButton(
                            onPressed: () {
                              saveSignatureImage();
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(color: AppColors.primaryColor)),
                              // Border color
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Rounded corners
                                ),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: AppColors.primaryColor, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                BlocListener<PPMSubmitBloc, PPMSubmitState>(
                  listener: (context, state) {
                    if (state is PPMSubmitSuccess) {
                      Utils.showInSnackBar(
                          context, state.submitResponseModel.message!, ToastType.Success);
                      viewModel.resetPPMData();
                      Navigator.pushNamed(context, '/dashboard');
                    } else if (state is PPMSubmitFailure) {
                      Utils.showInSnackBar(
                          context, state.error, ToastType.Warning);

                    }
                  },
                  child: BlocBuilder<PPMSubmitBloc, PPMSubmitState>(
                    builder: (context, state) {
                      if (state is PPMSubmitInProgress) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(); // Your UI when not in progress
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),);
  }

  void saveSignatureImage() async {
    // final signatureImageBytes = await _controller.toPngBytes(height: 1000, width: 1000);
    final signatureImageBytes = await _controller.toPngBytes();
    if (signatureImageBytes != null) {

      var connectivityResult = (
          Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Utils.showInSnackBar(
          context,
          "No internet connection.",
          ToastType.Error,
        );
      } else {
        DateTime now = DateTime.now();
        String timestamp1 = DateFormat('dd/MM/yyyy HH:mm').format(
            DateTime.now());
        DateTime timestamp = DateTime.now();
        Uint8List signedImageBytes =
        await addTextToImage(signatureImageBytes, timestamp1);
        File sign =
        await convertBytesToFile(signedImageBytes!, "Signature", timestamp);
        techSignFileBloc.add(
            PPMTechSignFileInProgressEvent(sign, ppmid, "Final"));
      }

      print('Signature image saved.');
    } else {
      print('No signature available.');
    }
  }

  Future<Uint8List> addTextToImage(Uint8List imageBytes, String text) async {
    final Completer<Uint8List> completer = Completer();
    ui.Image image = await decodeImageFromList(imageBytes);
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = Colors.black;
    canvas.drawImage(image, Offset.zero, Paint());

    // Define text style
    final textStyle = ui.TextStyle(
      color: Colors.green,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );

    // Calculate text position
    final textParagraph = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 14.0,
    ))
      ..pushStyle(textStyle)
      ..addText(text);
    final paragraph = textParagraph.build();
    paragraph.layout(ui.ParagraphConstraints(width: image.width.toDouble()));
    canvas.drawParagraph(
      paragraph,
      Offset(0, image.height - 20), // Adjust position as needed
    );

    final img = await recorder.endRecording().toImage(
      image.width,
      image.height,
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    completer.complete(byteData!.buffer.asUint8List());
    return completer.future;
  }

  Future<File> convertBytesToFile(
      Uint8List byteData, String fileName, DateTime timestamp) async {
    if (byteData == null || byteData.isEmpty) {
      throw Exception("Byte data is null or empty");
    }

    // Get the application documents directory
    final Directory appDocumentsDirectory =
    await getApplicationDocumentsDirectory();
    final String filePath = '${appDocumentsDirectory.path}/$fileName';

    final File file = File(filePath);

    // Write the byte data to the file
    await file.writeAsBytes(byteData);

    // Format the timestamp
    final DateFormat formatter =
    DateFormat('dd/MM/yyyy HH:mm'); // Adjust the format string
    final String formattedTimestamp = formatter.format(timestamp);

    // Add formatted timestamp to file content
    await file.writeAsString('\nTimestamp: $formattedTimestamp',
        mode: FileMode.append);

    return file;
  }
}
