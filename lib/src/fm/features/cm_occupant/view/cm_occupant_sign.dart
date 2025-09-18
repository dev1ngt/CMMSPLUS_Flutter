import 'dart:async';

import 'dart:io';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';


import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../cm_summary/model/cm_submit_request_model.dart';
import '../../cm_summary/model/cm_submit_save.dart';
import '../bloc/sign/occupant_filesbloc.dart';
import '../bloc/sign/occupant_filesevent.dart';
import '../bloc/sign/occupant_filesstate.dart';

class CMOccupantSignView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OccuapntSignFilesBloc>(
          create: (context) =>
              OccuapntSignFilesBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: CMOccupantSignState(),
    );
  }
}

class CMOccupantSignState extends StatefulWidget {
  @override
  _CMOccupantSignState createState() => _CMOccupantSignState();
}

class _CMOccupantSignState extends State<CMOccupantSignState> {
  late OccuapntSignFilesBloc occuapntSignFilesBloc;
  String cmid = "";
  String? imagePath = "";
  bool signatureSaved = false;
  TextEditingController occupant_name_controller = TextEditingController();
  TextEditingController occupant_phone_controller = TextEditingController();
  CMSubmitSaveModel cmSubmitSaveModel = CMSubmitSaveModel();

  // Signature Controller for capturing and saving signature
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    occuapntSignFilesBloc = BlocProvider.of<OccuapntSignFilesBloc>(context);
    occuapntSignFilesBloc.add(OccuapntSignInProgressEvent());


    try {
      CMSubmitRequestModel cmSubmitRequestModel = cmSubmitSaveModel.cmSubmitRequestModel;
      if( cmSubmitRequestModel.occupantName != null){
        occupant_name_controller.text = cmSubmitRequestModel.occupantName!;
        occupant_phone_controller.text = cmSubmitRequestModel.occupantMobile!;
        if(cmSubmitRequestModel.occupantSign != null && cmSubmitRequestModel.occupantSign!.isNotEmpty){
          signatureSaved = true;
          imagePath    = cmSubmitRequestModel.occupantSign;
        }
      }
    } on Exception catch (e) {
      // TODO
    }

    getSharedPrefe();
  }

  @override
  void dispose() {
    _controller.dispose();
    occupant_name_controller.dispose();
    occupant_phone_controller.dispose();
    super.dispose();
  }

  Future<void> getSharedPrefe() async {
    cmid = await AppSharedPrefs.getCMID();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("CMID")) {
      final String cmID_ = args['CMID'] as String;
      cmid = cmID_;
    }

    return  WillPopScope(
    onWillPop: () async {
    Navigator.pop(context);
    cmSubmitSaveModel.updateCMWorkOccupantInfo(
        occupant_name_controller.text,
        occupant_phone_controller.text,
        imagePath!);
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
            'Requestor Review',
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
                  try {
                    cmSubmitSaveModel.updateCMWorkOccupantInfo(
                        occupant_name_controller.text,
                        occupant_phone_controller.text,
                        imagePath!);
                    Navigator.pushNamed(context, '/cmfinalsubmit');
                  }catch(e){
                    throw Exception('Error occurred during API call: $e');
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
                      BlocListener<OccuapntSignFilesBloc, OccupantSignFilesState>(
                        listener: (context, state) {
                          if (state is OccupantSignFilesSuccess) {
                            if (state.fileuploadresponse.data.length > 0) {
                              setState(() {
                                signatureSaved = true;
                                imagePath = state
                                    .fileuploadresponse.data[0].tenantSignature;
                                print(imagePath);
                              });
                            }
                            print(state.fileuploadresponse.message);
                          } else if (state is OccupantSignFilesFailure) {
                            Utils.showInSnackBar(
                                context, state.error, ToastType.Warning);
                          }
                        },
                        child: BlocBuilder<OccuapntSignFilesBloc,
                            OccupantSignFilesState>(
                          builder: (context, state) {
                            if (state is OccupantSignInProgress) {
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
                          ' Requestor Info',
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
                        height: 55,
                        child: TextFormField(
                          controller: occupant_name_controller,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      Container(
                        height: 55,
                        child: TextFormField(
                          controller: occupant_phone_controller,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
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
                          'Signature Pad',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveSignatureImage() async {
    final signatureImageBytes =
       // await _controller.toPngBytes(height: 1000, width: 1000);
    await _controller.toPngBytes();

    if (signatureImageBytes != null) {
      DateTime now = DateTime.now();

      String timestamp1 = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      DateTime timestamp = DateTime.now();
      Uint8List signedImageBytes =
          await addTextToImage(signatureImageBytes, timestamp1);
      File sign =
          await convertBytesToFile(signedImageBytes!, "Signature", timestamp);
      var connectivityResult =  (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Utils.showInSnackBar(
          context,
          "No internet connection.",
          ToastType.Error,
        );
      } else {
        occuapntSignFilesBloc
            .add(OccuapntSignFileInProgressEvent(sign, cmid, "Occupant"));
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
