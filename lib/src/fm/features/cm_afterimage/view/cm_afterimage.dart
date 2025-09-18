
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../api/api_service.dart';
import '../../../../features/inprogress/view/view/inprogress_details.dart';
import '../../../../helpers/utils/utils.dart';
import '../../cm_summary/model/cm_submit_request_model.dart';
import '../../cm_summary/model/cm_submit_save.dart';
import '../../common/photosupload/bloc/after/upload_after_filesbloc.dart';
import '../../common/photosupload/bloc/after/upload_after_filesevent.dart';
import '../../common/photosupload/bloc/after/upload_after_filesstate.dart';
import '../../common/photosupload/model/uploadfile_after_response_model.dart';
import '../bloc/postworkbloc.dart';
import '../bloc/postworkevent.dart';
import '../bloc/postworkstate.dart';

class CMAfterImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider<UploadAfterFilesBloc>(
          create: (context) => UploadAfterFilesBloc(RepositoryProvider.of<ApiService>(context)),
        ),

        BlocProvider<PostWorkBloc>(
          create: (context) => PostWorkBloc(RepositoryProvider.of<ApiService>(context)),
        ),


      ],
      child: CMAfterImageViewState(),
    );
  }
}

class CMAfterImageViewState extends StatefulWidget {
  @override
  _CMAfterImageState createState() => _CMAfterImageState();
}

class _CMAfterImageState extends State<CMAfterImageViewState> {
  String cmid = "" , employee_id = "";
  final ImagePicker _picker = ImagePicker();
  final List<UploadedAfterImageData> _images = [];
  List<Map<String, String>> photoSets = [];
  int currentIndex = 0;
  String MultiplePhotosCurrentClick = "";
  bool visibilityAdditionalDocument = true;
  String _selectedImagePath = "", afterImageUploadPath = "";
  File? _image;
  String AdditionalDocumentGallery = "", AdditionalDocUploadPath = "";
  late UploadAfterFilesBloc _afterFilesBloc;
  late PostWorkBloc postWorkBloc;
  int selectedImageListIndexValue = 0;
  CMSubmitSaveModel cmSubmitSaveModel = CMSubmitSaveModel();

  @override
  void initState() {
    super.initState();


    try {
      CMSubmitRequestModel cmSubmitRequestModel = cmSubmitSaveModel.cmSubmitRequestModel;
      if( cmSubmitRequestModel.post_images != null){
        _images.addAll(cmSubmitRequestModel.post_images!);
      }

    } on Exception catch (e) {
      // TODO
    }

    getSharedPrefe();

    _afterFilesBloc = BlocProvider.of<UploadAfterFilesBloc>(context);
    _afterFilesBloc.add(UploadAfterInProgressEvent());

    postWorkBloc  = BlocProvider.of<PostWorkBloc>(context);
    postWorkBloc.add(PostWorkLoadEvent());

  }

  Future<void> getSharedPrefe() async {
    cmid = await AppSharedPrefs.getCMID();
    employee_id  = await AppSharedPrefs.getEmployeeID();
    setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) {
      // Display a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 5 images allowed')),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {

      // Read the image file
      final imageBytes = await pickedFile.readAsBytes();

      // Get current timestamp
      final timestamp = DateFormat('dd-MM-yyyy HH:mm:ss').format(
          DateTime.now());

      // Add timestamp to the image
      final imageWithText = await addTextToImage(imageBytes, timestamp);

      // Convert Uint8List back to File
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.png');
      await tempFile.writeAsBytes(imageWithText);
      var connectivityResult =  (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Utils.showInSnackBar(
          context,
          "No internet connection.",
          ToastType.Error,
        );
      } else {
        _afterFilesBloc.add(
            UploadAfterFileInProgressEvent(tempFile, cmid, "After"));
        //_afterFilesBloc.add(UploadAfterFileInProgressEvent(File(pickedFile.path), cmid ,"After" ));
      }

    }
  }

  @override
  void dispose() {
    _afterFilesBloc.close();
    postWorkBloc.close();
    super.dispose();
  }

  void _showImageDialog(UploadedAfterImageData imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.network(
                  imageFile.imageAfterPath,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:AppColors.primaryColor,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => postWorkBloc,
      child: WillPopScope(
        onWillPop: () async {
          cmSubmitSaveModel.updateCMWorkOrderPostImages(_images);
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Post-Work Photos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: TextButton(
                  onPressed: () {
                  //  cmSubmitSaveModel.updateCMWorkOrderPostImages(_images);

                    Navigator.pushNamed(context, '/cmadditionalemp',
                         arguments: {
                        'CMID': cmid,
                        }
                    );

                    // Add your button action here
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
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF006BE6), // Blue background color
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Actions',
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
                            // Ensure texts start from the starting point
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  var status = await Permission.camera.status;
                                  if (status.isGranted) {
                                    _pickImage(ImageSource.camera);
                                  } else if (status.isDenied) {
                                    // Request camera permission
                                    var result =
                                    await Permission.camera.request();
                                    if (result.isGranted) {
                                      _pickImage(ImageSource.camera);
                                    } else {
                                      // Handle denied permission
                                      showAlertDialog(
                                        context: context,
                                        title: "Permission Denied",
                                        content:
                                        "Please enable camera permissions in settings.",
                                      );
                                    }
                                  } else {
                                    // Handle permissions that are permanently denied
                                    showAlertDialog(
                                      context: context,
                                      title: "Permission Denied",
                                      content:
                                      "Please enable camera permissions in settings.",
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.primaryColor,
                                ),
                                label: Text(
                                  'Take Photo',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // Button color
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  var status = await Permission.camera.status;
                                  if (status.isGranted) {
                                    _pickImage(ImageSource.gallery);
                                  } else if (status.isDenied) {
                                    // Request camera permission
                                    var result =
                                    await Permission.camera.request();
                                    if (result.isGranted) {
                                      _pickImage(ImageSource.gallery);
                                    } else {
                                      // Handle denied permission
                                      showAlertDialog(
                                        context: context,
                                        title: "Permission Denied",
                                        content:
                                        "Please enable camera permissions in settings.",
                                      );
                                    }
                                  } else {
                                    // Handle permissions that are permanently denied
                                    showAlertDialog(
                                      context: context,
                                      title: "Permission Denied",
                                      content:
                                      "Please enable camera permissions in settings.",
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.photo,
                                  color: AppColors.primaryColor,
                                ),
                                label: Text(
                                  'Gallery',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // Button color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                            'Images View',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 100,
                            height: 180, // Adjust height as needed
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _showImageDialog(_images[index]);
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            _images[index].imageAfterPath,
                                            width: 100, // Adjust width as needed
                                            height: 150, // Adjust height as needed
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {


                                            _showCustomDialog(index , _images[index].taskId);


                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                            ),
                                            child: Icon(
                                              Icons.delete_outlined,
                                              color:AppColors.primaryColor,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Maximum 5 images allowed',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),


                        /* UploadImage API */
                        BlocListener<UploadAfterFilesBloc, UploadAfterFilesState>(
                          listener: (context, state) {
                            if (state is UploadAfterFilesSuccess) {

                              if(state.fileuploadresponse.data.length > 0){
                                Utils.showInSnackBar(context,  state.fileuploadresponse.message , ToastType.Success);
                                setState(() {
                                  // _images.add(File(pickedFile.path));
                                  _images.add(state.fileuploadresponse.data.first);
                                });
                              }
                              else {
                                Utils.showInSnackBar(context,   "Something went wrong"  , ToastType.Success);
                              }

                            } else if (state is UploadAfterFilesFailure) {
                              Utils.showInSnackBar(context, state.error, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<UploadAfterFilesBloc, UploadAfterFilesState>(
                            builder: (context, state) {
                              if (state is UploadAfterInProgress) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        /* End here */

                        /* UploadImage delete API */
                        BlocListener<PostWorkBloc, PostWorkState>(
                          listener: (context, state) {
                            if (state is PostWorkSuccess) {
                              print("index API>>" + selectedImageListIndexValue.toString());
                              setState(() {
                                _images.removeAt(selectedImageListIndexValue); // Remove the image from list
                              });
                              Utils.showInSnackBar(context, state.fileuploadresponse.message, ToastType.Warning);

                            } else if (state is PostWorkFailure) {
                              Utils.showInSnackBar(context, state.error, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<PostWorkBloc, PostWorkState>(
                            builder: (context, state) {
                              if (state is PostWorkInProgress) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        /* End here */


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),),);
  }


  void _showCustomDialog(int index , int taskid) {
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
                      'Alert',
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
                  child: Text(
                    'Are you sure you want to delete this image?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
                        'No',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () {
                        var connectivityResult =  (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
                        Utils.showInSnackBar(
                        context,
                        "No internet connection.",
                        ToastType.Error,
                        );
                        } else {
                          Navigator.of(context).pop(); // Close the dialog
                          print("index before>>" +
                              selectedImageListIndexValue.toString());
                          setState(() {
                            selectedImageListIndexValue = index;
                          });

                          postWorkBloc.add(PostWorkInProgressEvent(taskid));
                          print("index after>>" +
                              selectedImageListIndexValue.toString());
                        }
                      },
                      child: Text(
                        'Yes',
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

  // Function to add text to an image
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
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
    );

    // Calculate text position
    final textParagraph = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 22.0,
    ))
      ..pushStyle(textStyle)
      ..addText(text);
    final paragraph = textParagraph.build();
    paragraph.layout(ui.ParagraphConstraints(width: image.width.toDouble()));
    canvas.drawParagraph(
      paragraph,
      Offset(0, image.height - 50), // Adjust position as needed
    );

    final img = await recorder.endRecording().toImage(
      image.width,
      image.height,
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    completer.complete(byteData!.buffer.asUint8List());
    return completer.future;
  }

}
