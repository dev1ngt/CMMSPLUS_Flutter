import 'dart:io';
import 'dart:typed_data';

import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:cmms/src/features/pendingresponsedetails/bloc/details_part1/UploadFilesBloc.dart';
import 'package:cmms/src/features/pendingresponsedetails/bloc/details_part1/UploadFilesState.dart';
import 'package:cmms/src/features/pendingresponsedetails/view/pendingdetails2.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../api/api_service.dart';
import '../../../helpers/utils/AlertDialog.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/custom_text_fields_step1.dart';
import '../../../helpers/utils/preference_keys.dart';
import '../../../helpers/utils/qrcode_scanner_screen.dart';
import '../../../helpers/utils/utils.dart';

import '../../pendingresponse/model/asset_model.dart';
import '../../pendingresponse/view/pendinglist.dart';
import '../../ppm/closed/view/ppm_closed_details.dart';
import '../../qrscn/view/qrcode_scan.dart';
import '../bloc/asset_scan/asset_bloc.dart';
import '../bloc/asset_scan/asset_event.dart';
import '../bloc/asset_scan/asset_state.dart';
import '../bloc/details_part1/UploadFilesEvent.dart';

class PendingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<UploadFilesBloc>(
          create: (context) =>
              UploadFilesBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<AssetScanBloc>(
          create: (context) =>
              AssetScanBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: PendingDetails_(),
    );
  }
}

class PendingDetails_ extends StatefulWidget {
  @override
  PendingDetails_State createState() => PendingDetails_State();
}

class PendingDetails_State extends State<PendingDetails_> {
  late UploadFilesBloc _uploadFileBloc;
  late AssetScanBloc assetScanBloc;

  TextEditingController textAssetController = TextEditingController();
  TextEditingController textCauseOfFaultController = TextEditingController();
  TextEditingController additionalSpaceController = TextEditingController();
  TextEditingController textActionTakenController = TextEditingController();

  String CaseID = "",
      UserName = "",
      PropertyName = "",
      BlockName = " ",
      LevelName = "",
      Type = " ",
      SubType = "",
      AssetName = "",
      AssetID = "",
      CauseOfFault = "",
      ActionTaken = "",
      QRResult = "",
      Desc = "";

  bool _assetApiCalled = false; // Flag to track whether API call has been made
  bool is_photos_view_visible = false, is_part_replacement_view_visible = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _selectedAfterImagePath = "",
      _selectedBeforeImagePath = "",
      afterImageUploadPath = "",
      beforeImageUploadPath = "",
      priority = "" ;
  bool uploadStatus = false;
  String PhotosChooseEvent = "";
  String dateOfArrival = "", timeOfArrival = "";

  List<String> assetname_list = [];
  List<int> assetid_List = [];

  bool isDataAlreadyPresent(
      String data, List<String> assetnameList, List<int> assetIDList) {
    if (assetnameList.isNotEmpty && assetIDList.isNotEmpty) {
      return assetnameList.contains(data) || assetIDList.contains(data);
    } else {
      return false;
    }
  }

  _imageFromCamera(String type) async {
    // Generate a timestamp for the file name
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        if (type == "After") {
          _selectedAfterImagePath = pickedImage.path;
        } else if(type == "Before"){
          _selectedBeforeImagePath = pickedImage.path;
        }
        else {

        }
      });

      // Create a File object using the path
      if (type == "After") {
        File selectedImageFile = File(_selectedAfterImagePath!);
        PhotosChooseEvent = "After";
        _uploadFileBloc
            .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
      } else if(type == "Before") {
        File selectedImageFile = File(_selectedBeforeImagePath!);
        PhotosChooseEvent = "Before";
        _uploadFileBloc
            .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
      }
      else {

      }
    }
    final File fileImage = File(pickedImage.path);

    if (imageConstraint(fileImage))
      setState(() {
        _image = fileImage;
      });
  }

  Future<void> saveSelectedImagePathToPrefs(String imagePath) async {
    await AppSharedPrefs.get().setAfterImagePath(imagePath);
  }

  Future<File> convertBytesToFile(Uint8List byteData, String fileName) async {
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

    return file;
  }

  _imageFromGallery(String type) async {
    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        if (type == "After") {
          _selectedAfterImagePath = pickedImage.path;
        } else if(type == "Before"){
          _selectedBeforeImagePath = pickedImage.path;
        }
        else {

        }
      });

      // Create a File object using the path
      if (type == "After") {
        File selectedImageFile = File(_selectedAfterImagePath!);
        PhotosChooseEvent = "After";
        _uploadFileBloc
            .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
      } else if(type == "Before") {
        File selectedImageFile = File(_selectedBeforeImagePath!);
        PhotosChooseEvent = "Before";
        _uploadFileBloc
            .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
      }
     }


    final File fileImage = File(pickedImage.path);
    if (imageConstraint(fileImage))
      setState(() {
        _image = fileImage;
      });
  }

  bool imageConstraint(File image) {
    if (!['bmp', 'jpg', 'jpeg', 'png']
        .contains(image.path.split('.').last.toString())) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image format should be jpg/jpeg/bmp.");
      return false;
    }
    /*if (image.lengthSync() > 1000000) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image Size should be less than 1000KB.");
      return false;
    }*/
    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchCaseID();
    fetchPropertyName();
    fetchBlockName();
    fetchLevelName();
    fetchType();
    fetchSubType();
    fetchAssetName();
    fetchDesc();
    _uploadFileBloc = BlocProvider.of<UploadFilesBloc>(context);
    _uploadFileBloc.add(UploadInProgressEvent());
    assetScanBloc = BlocProvider.of<AssetScanBloc>(context);
    assetScanBloc.add(AssetScanEventInit());

    fetchCauseOfFault();
    fetchActionTaken();
    fetchAfterImagePath();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);
    dateOfArrival = formattedDate;
    timeOfArrival = formattedTime;
  }

  Future<void> fetchUsername() async {
    UserName = await AppSharedPrefs.getUsername();
    setState(() {});
  }

  Future<void> fetchCaseID() async {
    CaseID = await AppSharedPrefs.getCaseIDName();
    setState(() {});
  }

  Future<void> fetchPropertyName() async {
    PropertyName = await AppSharedPrefs.getPropertyName();
    setState(() {});
  }

  Future<void> fetchBlockName() async {
    BlockName = await AppSharedPrefs.getBlockName();
    setState(() {});
  }

  Future<void> fetchLevelName() async {
    LevelName = await AppSharedPrefs.getLevelName();
    setState(() {});
  }

  Future<void> fetchType() async {
    Type = await AppSharedPrefs.getFaultTypeName();
    setState(() {});
  }

  Future<void> fetchSubType() async {
    SubType = await AppSharedPrefs.getFaultSubTypeName();
    setState(() {});
  }

  Future<void> fetchDesc() async {
    Desc = await AppSharedPrefs.getDesc();
    setState(() {});
  }

  Future<void> fetchAssetName() async {
    AssetName = await AppSharedPrefs.getAssetName();
    AssetID = await AppSharedPrefs.getAssetID();
    setState(() {
      if (AssetName.isNotEmpty && AssetID.isNotEmpty) {
        assetname_list = AssetName.split(",");
        assetid_List = AssetID.split(",").map(int.parse).toList();
      }

      // textAssetController.text = AssetName;
    });
  }

  Future<void> fetchCauseOfFault() async {
    CauseOfFault = await AppSharedPrefs.getCauseOfFault();
    setState(() {
      textCauseOfFaultController.text = CauseOfFault;
    });
  }

  Future<void> fetchActionTaken() async {
    ActionTaken = await AppSharedPrefs.getActionTaken();
    setState(() {
      textActionTakenController.text = ActionTaken;
    });
  }

  Future<void> fetchAfterImagePath() async {
    beforeImageUploadPath = await AppSharedPrefs.getBeforePhotoPath();
    afterImageUploadPath = await AppSharedPrefs.getAfterImagePath();
    priority = await AppSharedPrefs.getPriority();

    setState(() {
      if(beforeImageUploadPath.isNotEmpty){
        is_photos_view_visible = true;
      }
      else {
        is_photos_view_visible = false;
      }
      afterImageUploadPath = afterImageUploadPath;
      beforeImageUploadPath = beforeImageUploadPath;
    });
  }

  @override
  void dispose() {
    _uploadFileBloc.close();
    assetScanBloc.close();
    super.dispose();
  }

  void _showPhotoDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Photo!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    // Check camera permission
                    var status = await Permission.camera.status;
                    if (status.isGranted) {
                      _imageFromCamera(type);
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromCamera(type);
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
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Camera'),
                ),
                SizedBox(height: 10.0),

                ElevatedButton(
                  onPressed: () async {
                    // Check camera permission
                    var status = await Permission.camera.status;
                    if (status.isGranted) {
                      _imageFromGallery(type);
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromGallery(type);
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
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Gallery'),
                ),
                SizedBox(height: 10.0),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
// Access parameters here
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Check if args is not null and contains the required parameters
    if (args != null && args.containsKey('QRResult')) {
      final String navigation = args['QRResult'] as String;
      print('QR Scan  parameter: $navigation');
      QRResult = navigation;
      AssetInput assetInput = AssetInput();
      assetInput.id = QRResult;
      if (!_assetApiCalled) {
        _assetApiCalled = true;
        assetScanBloc.add(FetchAssetScanEvent(assetInput));
      }
    }

    return BlocProvider(
      create: (context) => _uploadFileBloc,
      child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final ppmlist =
                          await Navigator.pushNamed(context, '/pendingList');
                      Navigator.pop(context, ppmlist);
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
            body: BlocListener<AssetScanBloc, AssetScanState>(
                listener: (context, state) async {
              if (state is AssetScanInprogressState) {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevent dismissing dialog on tap outside
                  builder: (BuildContext context) => AlertDialog(
                    content: ListTile(
                      leading: new CircularProgressIndicator(),
                      title: Text('Loading...'),
                    ),
                  ),
                );
              }

              if (state is AssetScanLoadedState) {
                Navigator.pop(context);
                Utils.showInSnackBar(
                    context, state.asset_response.message, ToastType.Success);

                String name = state.asset_response.assetData.assetName;
                if (isDataAlreadyPresent(name, assetname_list, assetid_List)) {
                  print("Data available");
                  Utils.showInSnackBar(
                      context,
                      "Scanned asset already available in list",
                      ToastType.Warning);
                } else {
                  List<String> assetname_list_temp = [];
                  List<int> assetid_list_temp = [];
                  assetname_list_temp
                      .add(state.asset_response.assetData.assetName);
                  assetid_list_temp.add(state.asset_response.assetData.assetId);

                  assetname_list.addAll(assetname_list_temp);
                  assetid_List.addAll(assetid_list_temp);

                  String separator = ','; // Define your separator
                  // Join the list elements with the separator
                  String assetNamesString = assetname_list.join(separator);
                  String assetIDString = assetid_List.join(separator);

                  AssetName = assetNamesString;
                  AssetID = assetIDString;

                  print(assetNamesString);
                  print(assetIDString);

                  await AppSharedPrefs.get().setAssetName(assetNamesString);
                  await AppSharedPrefs.get().setAssetID(assetIDString);
                }
              } else if (state is AssetScanErrorState) {
                print(state.error);
              }
            }, child: BlocBuilder<UploadFilesBloc, UploadFilesState>(
                    builder: (context, state) {
              if (state is UploadFilesInitial) {
              } else if (state is UploadFilesSuccess) {
                print("Data " + PhotosChooseEvent);
                if (PhotosChooseEvent == "After") {
                  afterImageUploadPath = state.fileuploadresponse.uploadedpath!;
                } else {
                  beforeImageUploadPath =
                      state.fileuploadresponse.uploadedpath!;
                }
              }

              return SingleChildScrollView(
                /* Title name*/
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Contractor Response\nTo Fault',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              20), // Adjust the horizontal padding as needed
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            child: Center(child: Text('1')),
                          ),
                          Container(
                            width: 100,
                            height: 0.3,
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey, // replace with your color
                            ),
                            child: Center(child: Text('2')),
                          ),
                          Container(
                            width: 0,
                            height: 0.3,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /* Case ID */
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // Adjust the horizontal padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            height: 57,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.customColor2,
                                  AppColors.customColor1,],
                              ),

                              border: Border.all(
                                  color: Colors.transparent, width: 1),
                              // Outline box with black border
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the border radius as needed

                              // Replace with your colors
                            ),
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Case ID :',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 57,
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFCBD4F4), width: 1),
                                // Outline box with black border
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the border radius as needed
                              ),
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                CaseID,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /* Name of personnel */
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // Adjust the horizontal padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            height: 57,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.customColor2,
                                  AppColors.customColor1,],
                              ),

                              border: Border.all(
                                  color: Colors.transparent, width: 1),
                              // Outline box with black border
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the border radius as needed

                              // Replace with your colors
                            ),
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Name of\nPersonnel :',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 57,
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFCBD4F4), width: 1),
                                // Outline box with black border
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the border radius as needed
                              ),
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                UserName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /* Asset */
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // Adjust the horizontal padding as needed
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Asset',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    // Handle the scan QR action
                                    print("QR Scan");
                                    Navigator.pushNamed(
                                      context,
                                      "/qrScan",
                                      arguments: {
                                        'Types': 'PendingDetails',
                                        // Add more parameters as needed
                                      },
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/images/qrscan.png',
                                    // replace with your image path
                                    width: 35,
                                    height: 35,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   // Adjust the horizontal padding as needed
                    //   child: Container(
                    //     height: 40,
                    //     child: TextField(
                    //       controller: textAssetController,
                    //       maxLines: null, // Set maxLines to null for multiple lines support
                    //       style: TextStyle(color: Colors.black), // Set the text color
                    //       decoration: InputDecoration(
                    //         contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // Adjust vertical padding as needed
                    //         hintText: '',
                    //         enabledBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1), // Regular border color and width
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //         focusedBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1), // Focused border color and width
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //         filled: true,
                    //         fillColor: Colors.transparent, // Change color as needed
                    //         // replace with your color
                    //         suffixIcon: GestureDetector(
                    //           onTap: () {
                    //             // Handle the clear text action
                    //             textAssetController.clear();
                    //           },
                    //           child: Icon(Icons.clear, color: Colors.black),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //

                    // Dynamic list of chips with delete option
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(assetname_list.length, (index) {
                        return ChipWithDelete(
                          label: assetname_list[index],
                          onDelete: () {
                            // Handle chip deletion
                            setState(() {
                              assetname_list.removeAt(index);
                              assetid_List.removeAt(index);

                              String separator = ',';
                              String assetNamesString =
                                  assetname_list.join(separator);
                              String assetIDString =
                                  assetid_List.join(separator);

                              AppSharedPrefs.get()
                                  .setAssetName(assetNamesString);
                              AppSharedPrefs.get().setAssetID(assetIDString);
                            });
                          },
                        );
                      }),
                    ),

                    SizedBox(
                      width: 10,
                    ),
                    /* Date and time  */
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, right: 10),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/dateimg.png',
                                // Replace with your image path
                                width: 20,
                                height: 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Date and Time',
                                style: TextStyle(
                                    fontSize: 16), // Adjust font size as needed
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFCBD4F4), width: 1),
                                    // Outline box with black border
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius as needed
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    dateOfArrival,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFCBD4F4), width: 1),
                                    // Outline box with black border
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius as needed
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    timeOfArrival,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        /* Property  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // Adjust the horizontal padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.customColor2,
                                      AppColors.customColor1,],
                                  ),

                                  border: Border.all(
                                      color: Colors.transparent,
                                      width:
                                          1), // Outline box with black border
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius as needed

                                  // Replace with your colors
                                ),
                                padding: EdgeInsets.only(left: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Property :',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFCBD4F4), width: 1),
                                    // Outline box with black border
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius as needed
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    PropertyName,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        /* Space / Floor  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // Adjust the horizontal padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.customColor2,
                                      AppColors.customColor1,],
                                  ),

                                  border: Border.all(
                                      color: Colors.transparent,
                                      width:
                                          1), // Outline box with black border
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius as needed

                                  // Replace with your colors
                                ),
                                padding: EdgeInsets.only(left: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Space / Floor :',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFCBD4F4), width: 1),
                                    // Outline box with black border
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius as needed
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    LevelName,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        /* Type  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // Adjust the horizontal padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.customColor2,
                                      AppColors.customColor1,],
                                  ),

                                  border: Border.all(
                                      color: Colors.transparent,
                                      width:
                                          1), // Outline box with black border
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius as needed

                                  // Replace with your colors
                                ),
                                padding: EdgeInsets.only(left: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Type :',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFCBD4F4), width: 1),
                                    // Outline box with black border
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius as needed
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Type,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        /* Sub Type  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // Adjust the horizontal padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.customColor2,
                                      AppColors.customColor1,],
                                  ),

                                  border: Border.all(
                                      color: Colors.transparent,
                                      width:
                                          1), // Outline box with black border
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius as needed

                                  // Replace with your colors
                                ),
                                padding: EdgeInsets.only(left: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sub Type :',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFCBD4F4), width: 1),
                                    // Outline box with black border
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius as needed
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    SubType,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // Adjust the horizontal padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.customColor2,
                                      AppColors.customColor1,],
                                  ),

                                  border: Border.all(
                                      color: Colors.transparent,
                                      width:
                                      1), // Outline box with black border
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius as needed

                                  // Replace with your colors
                                ),
                                padding: EdgeInsets.only(left: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Priority :',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFCBD4F4), width: 1),
                                    // Outline box with black border
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius as needed
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    priority,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        /* Cause of fault  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/cause_of_fault.png', // Replace with your image path
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Cause of Fault',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  width: double.infinity,
                                  child: TextField(
                                    controller: textCauseOfFaultController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 40.0),
                                      hintText: '',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCBD4F4), width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCBD4F4), width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        /* Action Taken  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/action_taken.png', // Replace with your image path
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Action Taken',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  width: double.infinity,
                                  child: TextField(
                                    controller: textActionTakenController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 40.0),
                                      hintText: '',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCBD4F4), width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCBD4F4), width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        /* Additional Space  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                     Icons.account_tree_outlined
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Addn. Loc',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  width: double.infinity,
                                  child: TextField(
                                    controller: additionalSpaceController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0,),
                                      hintText: '',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCBD4F4), width: 1),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFCBD4F4), width: 1),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        /* Photo Taken  */
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Add this line
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/photo.png', // Replace with your image path
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Photo Taken',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Radio(
                                      value: true,
                                      // Other properties go here
                                      onChanged: (value) {
                                        setState(() {
                                          is_photos_view_visible =
                                              value!; // Update the selected ID
                                        });
                                      },
                                      groupValue: is_photos_view_visible,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(width: 5.0),
                                    Radio(
                                      value: false,
                                      // Other properties go here
                                      // Other properties go here
                                      onChanged: (value) {
                                        setState(() {
                                          is_photos_view_visible =
                                              value!; // Update the selected ID
                                        });
                                      },
                                      groupValue: is_photos_view_visible,
                                    ),
                                    Text(
                                      'No',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(width: 10.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        /* Photo Taken Part   */
                        Visibility(
                          visible: is_photos_view_visible,
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          /* if (_selectedBeforeImagePath != null &&
                                      _selectedBeforeImagePath!.isNotEmpty) {
                                    Utils.showInSnackBar(
                                      context,
                                      "Image already taken.",
                                      ToastType.Warning,
                                    );
                                  } else {
                                    PhotosChooseEvent = "Before";
                                    _showPhotoDialog(context);
                                  }*/

                                          _showPhotoDialog(context, "Before");
                                        },

                                        // Adjust the border radius as needed
                                        child: Container(
                                          width: 150.0,
                                          height: 130.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: beforeImageUploadPath !=
                                                          null &&
                                                      beforeImageUploadPath!
                                                          .isNotEmpty
                                                  ? NetworkImage(
                                                          beforeImageUploadPath!)
                                                      as ImageProvider<Object>
                                                  : AssetImage(
                                                      'assets/images/photo_man.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Before',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          /* if (afterImageUploadPath != null &&
                                    afterImageUploadPath!.isNotEmpty) {
                                  Utils.showInSnackBar(
                                    context,
                                    "Image already taken.",
                                    ToastType.Warning,
                                  );
                                } else {
                                  PhotosChooseEvent = "After";
                                  _showPhotoDialog(context);
                                }*/
                                          // setState(() {
                                          //   PhotosChooseEvent = "After";
                                          // });

                                          _showPhotoDialog(context,"After");
                                        },

                                        // Adjust the border radius as needed
                                        child: Container(
                                          width: 150.0,
                                          height: 130.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: afterImageUploadPath !=
                                                          null &&
                                                      afterImageUploadPath!
                                                          .isNotEmpty
                                                  ? NetworkImage(
                                                          afterImageUploadPath!)
                                                      as ImageProvider<Object>
                                                  : AssetImage(
                                                      'assets/images/photo_man.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'After',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                          ),
                        ),

                        /* line divider */
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 0.3,
                                  color: Colors.black,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Container(
                                  height: 0.3,
                                  color: Colors.black,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        /* Part Replacement  */
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          margin: EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/part_replacement.png',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Parts Replacement',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10.0),
                              Row(
                                children: [
                                  Radio(
                                    value: true,
                                    // Other properties go here
                                    onChanged: (value) {
                                      setState(() {
                                        is_part_replacement_view_visible =
                                            value!; // Update the selected ID
                                      });
                                    },
                                    groupValue:
                                        is_part_replacement_view_visible,
                                    // Add required properties for the radio button
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Yes',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(width: 5.0),
                                  Radio(
                                    value: false,
                                    // Other properties go here
                                    onChanged: (value) {
                                      setState(() {
                                        is_part_replacement_view_visible =
                                            value!; // Update the selected ID
                                      });
                                    },
                                    groupValue:
                                        is_part_replacement_view_visible,
                                    // Add required properties for the radio button
                                  ),
                                  Text(
                                    'No',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(width: 10.0),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.0),

                        /* Next   */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  20.0), // Adjust the vertical space as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center the button horizontally
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  String validationActionTaken =
                                      textActionTakenController.text;
                                  String validatingCauseOfFault =
                                      textCauseOfFaultController.text;
                                  if (validatingCauseOfFault.isEmpty) {
                                    Utils.showInSnackBar(
                                        context,
                                        "Please enter the cause of fault",
                                        ToastType.Warning);
                                  } else if (validationActionTaken.isEmpty) {
                                    Utils.showInSnackBar(
                                        context,
                                        "Please enter the valid action taken",
                                        ToastType.Warning);
                                  } else {
                                    String assetNamesString = "",
                                        assetIDString = "";
                                    if (assetname_list.length > 0) {
                                      String separator =
                                          ','; // Define your separator
                                      // Join the list elements with the separator
                                      assetNamesString =
                                          assetname_list.join(separator);
                                      assetIDString =
                                          assetid_List.join(separator);

                                      print(assetNamesString);
                                      print(assetIDString);
                                    }

                                    await AppSharedPrefs.get().setCauseOfFault(
                                        validatingCauseOfFault);
                                    await AppSharedPrefs.get()
                                        .setActionTaken(validationActionTaken);

                                    Navigator.pushNamed(
                                        context, '/pendingDetails2',
                                        arguments: {
                                          'IsPhotoTaken':
                                              is_photos_view_visible,
                                          'IsPartReplaced':
                                              is_part_replacement_view_visible,
                                          'AssetName': assetNamesString,
                                          'AssetID': assetIDString,
                                          "AfterPhotoSavedPath":
                                              afterImageUploadPath,
                                          "BeforePhotoSavedPath":
                                              beforeImageUploadPath,
                                          "ArrivalDate": dateOfArrival,
                                          "ArrivalTime": timeOfArrival,
                                          "additionalSpace": additionalSpaceController.text,
                                        });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets
                                      .zero, // Remove padding to allow the Container to take the entire button space
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.customColor2,
                                        AppColors.customColor1,
                                      ], // Replace with your gradient colors
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 136.0, minHeight: 45.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
              return Container();
            })),
          )),
    );
  }
}

// Custom Widget for Radio
/*class Radio extends StatefulWidget {
  final String id;
  final ValueChanged<String>? onChanged;
  final String? groupValue;

  Radio({
    required this.id,
    this.onChanged,
    this.groupValue,

    // Other properties go here
  });

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<Radio> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(widget.id); // Notify the parent widget about the selection
        }
      },
      child: Container(
        width: 25.0,
        height: 25.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey, // Change the outline color as needed
            width: 1.0, // Change the outline width as needed
          ),
          color: widget.groupValue == widget.id ? Colors.blue : Colors.white,
        ),
        child: widget.groupValue == widget.id
            ? Icon(
          Icons.check,
          size: 20.0,
          color: Colors.white, // Change color as needed
        )
            : null,
      ),
    );
  }



}*/

// Custom Widget for TextFormField
class TextFormField extends StatelessWidget {
  final String id;

  TextFormField({
    required this.id,
    // Other properties go here
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextField(
        maxLines: null, // Set maxLines to null for multiple lines support
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 50.0), // Adjust vertical padding as needed
          hintText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xFFCBD4F4),
                width: 1), // Regular border color and width
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xFFCBD4F4),
                width: 1), // Focused border color and width
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.transparent, // Change color as needed
        ),
      ),
    );
  }
}
