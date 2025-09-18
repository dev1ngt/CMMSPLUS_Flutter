import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cmms/src/features/ppm/list/model/ppm_list_response_model.dart';
import 'package:cmms/src/features/ppm/list/view/ppm_list.dart';
import 'package:cmms/src/features/ppm/view/bloc/asset/asset_event.dart';
import 'package:cmms/src/features/ppm/view/bloc/asset/asset_state.dart';
import 'package:cmms/src/features/ppm/view/bloc/ppm_details_bloc.dart';
import 'package:cmms/src/features/ppm/view/model/asset/AssetResponse.dart';
import 'package:cmms/src/features/ppm/view/model/ppm_details_temp_singleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';
 import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:webview_flutter/webview_flutter.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/AlertDialog.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../closed/view/model/closed_response_model.dart';
import '../../../pendingresponse/model/asset_model.dart';
import '../../../pendingresponsedetails/bloc/asset_scan/asset_bloc.dart';
import '../../../pendingresponsedetails/bloc/asset_scan/asset_event.dart';
import '../../../pendingresponsedetails/bloc/asset_scan/asset_state.dart';
import '../../../pendingresponsedetails/bloc/details_part1/UploadFilesBloc.dart';
import '../../../pendingresponsedetails/bloc/details_part1/UploadFilesEvent.dart';
import '../../../pendingresponsedetails/bloc/details_part1/UploadFilesState.dart';
import '../../../pendingresponsedetails/bloc/details_part2/details_part2_bloc.dart';
import '../../../pendingresponsedetails/bloc/details_part2/details_part2_event.dart';
import '../../../pendingresponsedetails/bloc/details_part2/details_part2_state.dart';
import '../../../pendingresponsedetails/view/pendingdetails2.dart';
import '../../view/bloc/asset/asset_bloc.dart';
import '../../view/bloc/ppm_details_event.dart';
import '../../view/bloc/ppm_details_state.dart';
import '../../view/model/ppm_details_response_model.dart';
import '../../view/model/ppm_details_submit_request.dart';
import '../../view/model/ppm_details_temp_data.dart';
import '../bloc/ppm_det_completed_bloc.dart';
import '../bloc/ppm_det_completed_event.dart';
import '../bloc/ppm_det_completed_state.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class PPMCompletedDetails extends StatelessWidget {
  const PPMCompletedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<AssetScanBloc>(
          create: (context) =>
              AssetScanBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<MultipleAssetsBloc>(
          create: (context) =>
              MultipleAssetsBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<DetailsPart2Bloc>(
          create: (context) =>
              DetailsPart2Bloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PPMDetailsBloc>(
          create: (context) =>
              PPMDetailsBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<UploadFilesBloc>(
          create: (context) =>
              UploadFilesBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PPMCompletedBloc>(
          create: (context) =>
              PPMCompletedBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: PPMCompletedDetailsState(),
    );
  }
}

class PPMCompletedDetailsState extends StatefulWidget {
  const PPMCompletedDetailsState({super.key});

  @override
  State<PPMCompletedDetailsState> createState() =>
      _PPMDCompletedetailsStateState();
}

class _PPMDCompletedetailsStateState extends State<PPMCompletedDetailsState> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color
  List<String> assetname_list = []; // Initial chip data
  List<int> assetid_List = [];
  PPMDetailsTempSingletonModel ppmDetailsTempSingletonModel =
      PPMDetailsTempSingletonModel();
  List<Map<String, String>> photoSets = [];
  int currentIndex = 0;
  String MultiplePhotosCurrentClick = "";
  bool visibilityAdditionalDocument = true;
  String _selectedSignPath = "", QRResult = "", webview_path = "";
  //late WebViewController controller;
  //late WebViewController _webViewController;

  bool isShowRequestHistory = false;
  bool isClosed = false;
  List<PPMDetailsScheduleHistory> requestHistory = [];
  bool is_photos_view_visible = true;
  TextEditingController commentsController = TextEditingController();
  String commentsTxt = "";
  List<PPMDetailsMultipleImage> uploadedFiles = [];
  late PPMDetailsBloc requestViewBloc;
  int _maxFiles = 0;
  final int _maxFileSizeMB = 5;
  String requestId = "";
  int propertyID = 0;
  int selectedUserId = 0, selectedStatusID = 0;
  String RequestID = "";
  String additionalSpace = "";
  bool _isAPICalled = true;
  InAppWebViewController? _webViewController;
  bool isWebViewVisible = false;
  bool _assetApiCalled = false, _multiassetsApiCalled = false;
  late AssetScanBloc assetScanBloc;
  late UploadFilesBloc _uploadFileBloc;
  late MultipleAssetsBloc multipleAssetsBloc;
  late DetailsPart2Bloc _detailsPart2Bloc;
  late PPMDetailsBloc ppmDetailsBloc;
  late PPMCompletedBloc ppmCompletedBloc;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController textVendorController = TextEditingController();
  String  ppmid = "";

  String userid = "";
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _selectedImagePath = "", afterImageUploadPath = "";
  bool uploadStatus = false;
  String AdditionalDocumentGallery = "", AdditionalDocUploadPath = "";
  String _techSignPath = "",
      _cilentSignPath = "",
      vendorName = "",
      signType = "";
  bool isSubmitting = false;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  UniqueKey _key = UniqueKey();

  bool isDataAlreadyPresent(
      String data, List<String> assetnameList, List<int> assetIDList) {
    if (assetnameList.isNotEmpty && assetIDList.isNotEmpty) {
      return assetnameList.contains(data) || assetIDList.contains(data);
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    assetScanBloc = BlocProvider.of<AssetScanBloc>(context);
    assetScanBloc.add(AssetScanEventInit());

    multipleAssetsBloc = BlocProvider.of<MultipleAssetsBloc>(context);
    multipleAssetsBloc.add(MultipleAssetsEventInit());

    _detailsPart2Bloc = BlocProvider.of<DetailsPart2Bloc>(context);
    _detailsPart2Bloc.add(SignFileInitEvent());

    ppmDetailsBloc = BlocProvider.of<PPMDetailsBloc>(context);
    ppmDetailsBloc.add(PPMDetailsInitEvent());

    _uploadFileBloc = BlocProvider.of<UploadFilesBloc>(context);
    _uploadFileBloc.add(UploadInProgressEvent());

    ppmCompletedBloc = BlocProvider.of<PPMCompletedBloc>(context);
    ppmCompletedBloc.add(PPMCompletedInitEvent());

    // setState(() {
    //   PPMDetailsTempModel ppmDetailsTempModel =
    //       ppmDetailsTempSingletonModel.ppmDetailsTempModel;
    //   if (ppmDetailsTempModel.assetName != null) {
    //     assetname_list = ppmDetailsTempModel.assetName!;
    //     assetid_List = ppmDetailsTempModel.assetID!;
    //   }
    // });

    fetchUserID();

    super.initState();
  }

  Future<void> fetchUserID() async {
    userid = await AppSharedPrefs.getUserID();
    vendorName = await AppSharedPrefs.getVendorName();
    ppmid = await AppSharedPrefs.getSubSchduleID();
    print('sub_schedule_id' + ppmid.toString());
    print(userid);
    setState(() {
      textVendorController.text = vendorName;
    });
  }

  _imageFromCamera() async {
    // Generate a timestamp for the file name
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        _selectedImagePath = pickedImage.path;
        print(_selectedImagePath);
      });

      // Create a File object using the path
      File selectedImageFile = File(_selectedImagePath!);
      _uploadFileBloc
          .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
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
    /* if (image.lengthSync() > 1000000) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image Size should be less than 1000KB.");
      return false;
    }*/
    return true;
  }

  _imageFromGallery() async {
    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        AdditionalDocumentGallery = pickedImage.path;
      });

      // Create a File object using the path
      File selectedImageFile = File(AdditionalDocumentGallery!);
      _uploadFileBloc
          .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
    }
    final File fileImage = File(pickedImage.path);
    if (imageConstraint(fileImage))
      setState(() {
        _image = fileImage;
      });
  }

  @override
  void dispose() {
    _uploadFileBloc.close();
    multipleAssetsBloc.close();
    _detailsPart2Bloc.close();
    ppmDetailsBloc.close();
    assetScanBloc.close();
    ppmCompletedBloc.close();
    super.dispose();
  }

  void _showPhotoDialog(BuildContext context) {
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
                  'Add Photo or Document',
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
                      _imageFromCamera1();
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromCamera1();
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
                      _imageFromGallery1();
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromGallery1();
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
                    _pickDocument1();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Documents'),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      /*if (args.containsKey('QRResult') && !_assetApiCalled) {
        QRResult = args['QRResult'];
        AssetInput assetInput = AssetInput()..id = QRResult!;
        _assetApiCalled = true;
        assetScanBloc.add(FetchAssetScanEvent(assetInput));
      }*/

      if (args.containsKey('WebView')) {
        webview_path = args['WebView'];
      }

      if (args.containsKey('PPMID') && !_multiassetsApiCalled) {
        final String ppmidStr = args['PPMID'];

        if (ppmidStr != null) {
          MultiAssetInput assetInput = MultiAssetInput()..id = ppmidStr;
          _multiassetsApiCalled = true;
          multipleAssetsBloc.add(MultipleAssetsFetchEvent(assetInput));
          //ppmCompletedBloc.add(PPMCompletedStartEvent(sub_schedule_id: ppmidStr));
          ppmDetailsBloc.add(PPMDetailsLoadEvent(ppmidStr));
        }
      }
    }
  }
  void showCommentsDialog(BuildContext context, String comments) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6, // max height if content is large
                    minWidth: 280,
                    maxWidth: 320,
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      comments.isNotEmpty ? comments : "No comments available",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => assetScanBloc),
        BlocProvider(create: (_) => multipleAssetsBloc),
        BlocProvider(create: (_) => ppmCompletedBloc),
      ],
      child: WillPopScope(
          onWillPop: () async {
            assetname_list.clear();
            assetid_List.clear();
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
                      setState(() {
                        ppmDetailsTempSingletonModel.removeAllTempList();
                        assetname_list.clear();
                        assetid_List.clear();
                      });
                      final ppmlist =
                          await Navigator.pushNamed(context, '/ppmList');
                      Navigator.pop(context, ppmlist);
                    },
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
                  Spacer(),
                  Image.asset(
                    'assets/images/ecms_logo.png',
                    width: 100,
                    height: 20,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Handle your onClick event here
                      Navigator.pushNamed(context,
                          '/dashboard'); // Example: Navigate to home page
                    },
                    child: Image.asset(
                      'assets/images/ic_home.png',
                      // replace with your image path
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
                      customColor1,
                      customColor2,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocListener<PPMDetailsBloc, PPMDetailsStateI>(
                      listener: (context, state) async {
                        if (state is PPMDetailsLoadedState) {
                          print("✅ PPMDetailsLoadedState received");

                          setState(() {
                            _isAPICalled = false;
                            requestHistory.clear();
                            uploadedFiles.clear();
                            selectedUserId = state.ppmViewModel.data?.assignedToId ?? 0;
                           // ppmid = state.ppmViewModel.data!.scheduleId;
                            requestHistory.addAll(state.ppmViewModel.data?.scheduleHistoryData ?? []);
                            uploadedFiles.addAll(state.ppmViewModel.data?.multipleImage ?? []);
                            _maxFiles = state.ppmViewModel.data!.maxFile ?? 0;
                            webview_path = state.ppmViewModel.data!.webViewUrl;
                            propertyID = state.ppmViewModel.data!.priorityId ?? 0;
                          });
                        } else if (state is PPMDetailsErrorState) {
                          Utils.showInSnackBar(
                            context,
                            state.error,
                            ToastType.Warning,
                          );
                        }
                      },
                      child: BlocBuilder<PPMDetailsBloc, PPMDetailsStateI>(
                        builder: (context, state) {
                          if (state is PPMDetailsInitialState) {
                            return Center(child: CircularProgressIndicator());
                          }

                          // You can replace this with your actual content
                          return Container();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [


                        Text('Request History:',
                            style:
                            TextStyle(fontSize: 19, color: Colors.black)),
                        IconButton(
                          icon: isShowRequestHistory
                              ? Icon(Icons.keyboard_arrow_up)
                              : Icon(Icons.keyboard_arrow_down),
                          onPressed: () {
                            setState(() {
                              isShowRequestHistory =
                              !isShowRequestHistory; // Toggle visibility
                            });

                            // Handle inspection expand
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isShowRequestHistory,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tap to view full comments',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: requestHistory.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  showCommentsDialog(context, requestHistory[index].comments ?? '');
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 4, // Adjust elevation as needed
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0),
                                  child: ListTile(
                                    //  title: Text(requestHistory[index].updateDate),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /* TYPE / Updated Date */
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: 'Type:',
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: requestHistory[index]
                                                              .type,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            // Optional: Adjust the space between the columns
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: 'Update Date:',
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: requestHistory[index]
                                                              .updateDate,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        /* Assigned to & Updated By */
                                        SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: 'Assigned To:',
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: requestHistory[index]
                                                              .assignedTo,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            // Optional: Adjust the space between the columns
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: 'Updated By:',
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: requestHistory[index]
                                                              .updatedBy,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        /* */

                                        SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: 'Comments:',
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: requestHistory[index]
                                                              .comments,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            // Optional: Adjust the space between the columns
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: 'Status:',
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style:
                                                      DefaultTextStyle.of(context)
                                                          .style,
                                                      children: [
                                                        TextSpan(
                                                          text: requestHistory[index]
                                                              .status,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // You can customize the appearance of each request history item here
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Other widgets...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assets:',
                          style: TextStyle(fontSize: 19, color: Colors.black),
                        ),
                        IconButton(
                          icon: Icon(Icons.qr_code_2_outlined),
                          iconSize: 40,
                          onPressed: () {

                            Navigator.pushNamed(
                              context,
                              "/qrScan",
                              arguments: {
                                'Types': 'PPMCompletedDetails',
                              },
                            ).then((result) {
                              if (result != null &&
                                  result is Map<String, dynamic> && !_assetApiCalled) {
                                final qrResult = result['QRResult'];

                                AssetInput assetInput = AssetInput()
                                  ..id = qrResult!
                                  ..propertyId = propertyID.toString();
                                _assetApiCalled = true;
                                assetScanBloc
                                    .add(FetchAssetScanEvent(assetInput));
                              }
                            });
                          },
                        ),
                      ],
                    ),

                    // Asset Scan Result
                    BlocListener<AssetScanBloc, AssetScanState>(
                      listener: (context, state) async {
                        if (state is AssetScanLoadedState) {
                          setState(() {
                            _assetApiCalled = false;
                          });
                          if(state.asset_response.status == "True") {
                        //  Utils.showInSnackBar(context,state.asset_response.message, ToastType.Success);
                          String name =
                              state.asset_response.assetData.assetName;
                          if (isDataAlreadyPresent(
                              name, assetname_list, assetid_List)) {
                            print("Data available");
                            Utils.showInSnackBar(
                                context,
                                "Scanned asset already available in list",
                                ToastType.Warning);
                          } else {
                            print("data not avaialble");
                            setState(() {
                              assetname_list.add(
                                  state.asset_response.assetData.assetName);
                              assetid_List
                                  .add(state.asset_response.assetData.assetId);
                              ppmDetailsTempSingletonModel.updateAssetData(
                                  assetid_List, assetname_list);
                            });
                          }
                          }
                          else {
                            Utils.showInSnackBar(context, state.asset_response.message, ToastType.Warning);
                          }

                        } else if (state is AssetScanErrorState) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<AssetScanBloc, AssetScanState>(
                          builder: (context, state) {
                        if (state is AssetScanInprogressState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }),
                    ),

                    // Multiple Asset show from scheduleid
                    BlocListener<MultipleAssetsBloc, MultipleAssetsState>(
                      listener: (context, state) async {
                        if (state is MultipleAssetsLoadedState) {
                         // Utils.showInSnackBar(context, state.asset_response.message, ToastType.Success);

                          if (state.asset_response.assets.length > 0) {
                            List<Assets> assets = state.asset_response.assets;
                            List<String> assetname = [];
                            List<int> assetid = [];
                            // Accessing parsed data
                            assets.forEach((asset) {
                              print(
                                  'Asset ID: ${asset.assetId}, Asset Name: ${asset.assetName}');
                              assetname.add(asset.assetName);
                              assetid.add(asset.assetId);
                            });

                            setState(() {
                              assetid_List.addAll(assetid);
                              assetname_list.addAll(assetname);
                              ppmDetailsTempSingletonModel.updateAssetData(
                                  assetid_List, assetname_list);
                            });
                          }
                        } else if (state is MultipleAssetsErrorState) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child:
                          BlocBuilder<MultipleAssetsBloc, MultipleAssetsState>(
                              builder: (context, state) {
                        if (state is MultipleAssetsInProgressState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }),
                    ),

                    /*   View sub schedule API  */
                    BlocListener<PPMCompletedBloc, PPMCompletedState>(
                      listener: (context, state) async {
                        if (state is PPMCompletedSuccess) {
                          setState(() {
                            if (state.schedule.data.finalDocument.isEmpty) {
                              AdditionalDocUploadPath = "";
                              visibilityAdditionalDocument = true;
                            } else {
                              AdditionalDocUploadPath =
                                  state.schedule.data.finalDocument;
                              visibilityAdditionalDocument =
                                  !visibilityAdditionalDocument;
                            }

                            if (state.schedule.data.technicianDescription
                                .isNotEmpty) {
                              _descriptionController.text =
                                  state.schedule.data.technicianDescription;
                            }

                            if (state.schedule.data.technicianSign.isNotEmpty) {
                              _techSignPath =
                                  state.schedule.data.technicianSign;
                            }

                            if (state
                                .schedule.data.clientSignature.isNotEmpty) {
                              _cilentSignPath =
                                  state.schedule.data.clientSignature;
                            }

                            if (state.schedule.data.trackData.length > 0) {
                              for (var trackItem
                                  in state.schedule.data.trackData) {
                                photoSets.add({
                                  'id': trackItem.id.toString(),
                                  'beforeImage': trackItem.beforeImage,
                                  'afterImage': trackItem.afterImage,
                                });
                              }
                            } else {
                              photoSets.add({
                                'id': '',
                                'beforeImage': '',
                                'afterImage': '',
                              });
                            }
                          });
                        } else if (state is PPMCompletedFailure) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<PPMCompletedBloc, PPMCompletedState>(
                          builder: (context, state) {
                        if (state is PPMCompletedInProgress) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }),
                    ),

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
                              ppmDetailsTempSingletonModel.updateAssetData(
                                  assetid_List, assetname_list);
                            });
                          },
                        );
                      }),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Inspection:',
                            style:
                                TextStyle(fontSize: 19, color: Colors.black)),
                        IconButton(
                          icon: isWebViewVisible
                              ? Icon(Icons.keyboard_arrow_up)
                              : Icon(Icons.keyboard_arrow_down),
                          onPressed: () {
                            if (webview_path != null &&
                                webview_path.isNotEmpty) {
                              print(webview_path);
                              setState(() {
                                isWebViewVisible =
                                    !isWebViewVisible; // Toggle visibility
                              });
                            } else {
                              Utils.showInSnackBar(context, "Invalid WebView",
                                  ToastType.Warning);
                            }

                            // Handle inspection expand
                          },
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    // Example for RecyclerView

                    Visibility(
                      visible: isWebViewVisible,
                      child: Container(
                        height: 500,
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: WebUri.uri(Uri.parse(webview_path)),
                          ),
                          onWebViewCreated: (controller) {
                            _webViewController = controller;
                          },
                          gestureRecognizers: gestureRecognizers,
                        ),
                      ),
                    ),

                    /*Text(
                      "Additional Document:",
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),

                    Column(
                      children: [
                        Visibility(
                          visible: visibilityAdditionalDocument,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.upload_file_outlined),
                                iconSize: 40,
                                color: Colors.grey,
                                onPressed: () {
                                  MultiplePhotosCurrentClick = "AddDoc";
                                  _showPhotoDialogGallery(context);
                                },
                              ),
                              Text("(OR)"),
                              IconButton(
                                icon: Icon(Icons.camera_alt_outlined),
                                iconSize: 40,
                                color: Colors.grey,
                                onPressed: () {
                                  MultiplePhotosCurrentClick = "AddDoc";
                                  _showPhotoDialog(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: !visibilityAdditionalDocument,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150.0,
                                height: 130.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AdditionalDocUploadPath != null &&
                                            AdditionalDocUploadPath!.isNotEmpty
                                        ? NetworkImage(AdditionalDocUploadPath!)
                                            as ImageProvider<Object>
                                        : AssetImage(
                                            'assets/images/photo_man.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                iconSize: 40,
                                color: Colors.red,
                                onPressed: () {
                                  // Handle delete action
                                  setState(() {
                                    AdditionalDocUploadPath = "";
                                    visibilityAdditionalDocument =
                                        !visibilityAdditionalDocument;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),*/

                    BlocListener<UploadFilesBloc, UploadFilesState>(
                      listener: (context, state) async {
                        if (state is UploadFilesSuccess) {
                          Utils.showInSnackBar(
                              context,
                              state.fileuploadresponse.message!,
                              ToastType.Success);
                          try {
                            setState(() {
                              if (MultiplePhotosCurrentClick == 'before') {
                                photoSets[currentIndex]['beforeImage'] =
                                    state.fileuploadresponse.uploadedpath!;
                              } else if (MultiplePhotosCurrentClick ==
                                  "after") {
                                photoSets[currentIndex]['afterImage'] =
                                    state.fileuploadresponse.uploadedpath!;
                              } else {
                                AdditionalDocUploadPath =
                                    state.fileuploadresponse.uploadedpath!;
                                visibilityAdditionalDocument =
                                    !visibilityAdditionalDocument;
                              }
                            });
                          } catch (e) {
                            print(e);
                          }
                        } else if (state is UploadFilesFailure) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<UploadFilesBloc, UploadFilesState>(
                          builder: (context, state) {
                        if (state is UploadFilesInitial) {
                          // return Center(
                          //   child: CircularProgressIndicator(),
                          // );
                        }
                        return Container();
                      }),
                    ),

                   /* Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40,
                            color: Colors.transparent,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Photos',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Column(
                            children: List.generate(photoSets.length, (index) {
                              return Column(
                                children: [
                                  if (photoSets.length > 1)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 10, right: 10),
                                        child: IconButton(
                                          icon: Icon(Icons
                                              .remove_circle_outline_rounded),
                                          iconSize: 40,
                                          onPressed: () {
                                            // Handle button press to remove the photo set
                                            setState(() {
                                              photoSets.removeAt(index);
                                            });
                                          },
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 40,
                                              color: Colors.transparent,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                'BEFORE',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                currentIndex = index;
                                                MultiplePhotosCurrentClick =
                                                    "before";
                                                _showPhotoDialog(context);
                                              },
                                              child: Container(
                                                width: 150.0,
                                                height: 130.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: photoSets[index][
                                                                    'beforeImage'] !=
                                                                null &&
                                                            photoSets[index][
                                                                    'beforeImage']!
                                                                .isNotEmpty
                                                        ? NetworkImage(photoSets[
                                                                    index][
                                                                'beforeImage']!)
                                                            as ImageProvider<
                                                                Object>
                                                        : AssetImage(
                                                            'assets/images/photo_man.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 40,
                                              color: Colors.transparent,
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 15),
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                'AFTER',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                MultiplePhotosCurrentClick =
                                                    "after";
                                                currentIndex = index;
                                                _showPhotoDialog(context);
                                              },
                                              child: Container(
                                                width: 150.0,
                                                height: 130.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: photoSets[index][
                                                                    'afterImage'] !=
                                                                null &&
                                                            photoSets[index][
                                                                    'afterImage']!
                                                                .isNotEmpty
                                                        ? NetworkImage(photoSets[
                                                                    index]
                                                                ['afterImage']!)
                                                            as ImageProvider<
                                                                Object>
                                                        : AssetImage(
                                                            'assets/images/photo_man.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                          if (photoSets.isNotEmpty)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(top: 10, right: 10),
                                child: IconButton(
                                  icon: Icon(Icons.add_circle_outline_rounded),
                                  iconSize: 40,
                                  onPressed: () {
                                    // Handle button press to add a new photo set
                                    setState(() {
                                      photoSets.add({
                                        'id': '',
                                        'beforeImage': '',
                                        'afterImage': '',
                                      });
                                    });
                                  },
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),*/

                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      "Vendor:",
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),

                    TextFormField(
                      controller: textVendorController,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        hintText: '',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFCBD4F4), width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFCBD4F4), width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Description:",
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 40.0),
                        hintText: '',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFCBD4F4), width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFCBD4F4), width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Attachments:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle the click event here
                            // Toggle the visibility or perform any other action
                            setState(() {
                              is_photos_view_visible = !is_photos_view_visible;
                            });
                          },
                          child: Icon(
                            is_photos_view_visible ? Icons.remove : Icons.add,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),

                    Visibility(
                        visible: is_photos_view_visible,
                        child: _buildFileGrid()),
                    BlocListener<PPMDetailsBloc, PPMDetailsStateI>(
                      listener: (context, state) {
                        if (state is PPMUploadFilesSuccess) {
                          final uploadedPath = state.fileuploadresponse.uploadedpath!;
                          final fileType = _getFileType(uploadedPath);
                          if (mounted) {
                            setState(() {
                              uploadedFiles.add(
                                PPMDetailsMultipleImage(
                                  id: 0,
                                  type: fileType,
                                  path: uploadedPath,
                                ),
                              );
                            });
                          }
                        } else if (state is PPMDetailsSubmitUploadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Upload failed: ${state.error}")),
                          );
                        }
                      },
                      child: BlocBuilder<PPMDetailsBloc, PPMDetailsStateI>(
                        builder: (context, state) {
                          if (state is PPMDetailsInitialState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(); // Or whatever UI you use
                        },
                      ),
                    ),
                    /*Container(
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Tech Sign',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(height: 5.0),
                                    GestureDetector(
                                      onTap: () {
                                        signType = "Tech";
                                        SignatureDialog.showSignatureDialog(context, _detailsPart2Bloc);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        width: 150.0,
                                        height: 140.0,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: Color(0xFFCBD4F4),
                                            width: 1.0,
                                          ),
                                          image: DecorationImage(
                                            image: _techSignPath != null && _techSignPath!.isNotEmpty
                                                ? NetworkImage(_techSignPath!)
                                                : AssetImage('assets/images/signature.png') as ImageProvider,
                                            fit: BoxFit.contain, // or use BoxFit.cover if you prefer full fill
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.0),
                              // Add this SizedBox for horizontal spacing
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Client Sign',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(height: 5.0),
                                    GestureDetector(
                                      onTap: () {
                                        signType = "Client";
                                        SignatureDialog.showSignatureDialog(context, _detailsPart2Bloc);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        width: 150.0,
                                        height: 140.0,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: Color(0xFFCBD4F4),
                                            width: 1.0,
                                          ),
                                          image: DecorationImage(
                                            image: _cilentSignPath != null && _cilentSignPath!.isNotEmpty
                                                ? NetworkImage(_cilentSignPath!)
                                                : AssetImage('assets/images/signature.png') as ImageProvider,
                                            fit: BoxFit.contain, // or BoxFit.cover, depending on your preference
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),*/

                    /* Signature save */

                    BlocListener<DetailsPart2Bloc, DetailsPart2State>(
                      listener: (context, state) async {
                        if (state is SignUploadSuccess) {
                          setState(() {
                            if (signType == "Tech") {
                              _techSignPath =
                                  state.fileuploadresponse.uploadedpath!;
                            } else if (signType == "Client") {
                              _cilentSignPath =
                                  state.fileuploadresponse.uploadedpath!;
                            }
                          });
                        } else if (state is SignUploadFailure) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<DetailsPart2Bloc, DetailsPart2State>(
                          builder: (context, state) {
                        if (state is DetailsPart2InProgress) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    /* Submit data for upload*/

                    BlocListener<PPMDetailsBloc, PPMDetailsStateI>(
                      listener: (context, state) async {
                        if (state is PPMDetailsSubmitUploadSuccess) {
                          isSubmitting = false;
                          if (state.submitResponseModel.status!) {
                            Utils.showInSnackBar(
                                context,
                                state.submitResponseModel.message!,
                                ToastType.Success);
                            Navigator.pushNamed(
                              context,
                              '/dashboard',
                            );
                          } else {
                            Utils.showInSnackBar(
                                context,
                                state.submitResponseModel.message!,
                                ToastType.Warning);
                          }
                        } else if (state is PPMDetailsSubmitUploadFailure) {
                          isSubmitting = false;
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<PPMDetailsBloc, PPMDetailsStateI>(
                          builder: (context, state) {
                        if (state is PPMDetailsSubmitUploadInProgress) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }),
                    ),

                    Center(
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                String description =
                                    _descriptionController.text;
                                if (description.isEmpty) {
                                  Utils.showInSnackBar(context,
                                      "Enter the description", ToastType.Error);
                                } else {
                                  setState(() {
                                    isSubmitting = true;
                                  });

                                  String asset_ids = assetid_List.join(',');
                                  PPMSubmitRequestModel ppmsubmit =
                                      PPMSubmitRequestModel();
                                  ppmsubmit.finalDocument =
                                      AdditionalDocUploadPath;
                                  ppmsubmit.technicianDescription = description;
                                  ppmsubmit.subScheduleId = int.tryParse(ppmid);
                                  ppmsubmit.userId = int.parse(userid);
                                  ppmsubmit.trackData =
                                      convertMapListToModelList(photoSets);
                                  ppmsubmit.assetId = asset_ids;
                                  ppmsubmit.technicianSign = _techSignPath;
                                  ppmsubmit.clientSignature = _cilentSignPath;
                                  ppmsubmit.vendor = textVendorController.text;
                                  ppmsubmit.assigneeToID = selectedUserId;
                                  ppmsubmit.multipleImage = uploadedFiles.map((file) => Multipleimage1(id: file.id, path: file.path, type: file.type)).toList();

                                  ppmDetailsBloc
                                      .add(PPMDetailsSubmitEvent(ppmsubmit));
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSubmitting ? customColor1 : null,
                          padding: EdgeInsets.zero,
                          // Remove padding to allow the Container to take the entire button space
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                customColor2,
                                customColor1
                              ], // Replace with your gradient colors
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 136.0, minHeight: 45.0),
                            alignment: Alignment.center,
                            child: Text(
                              isSubmitting ? 'Submitting...' : 'Submit',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
  bool _canAddFile(File file) {
    final fileSizeMB = file.lengthSync() / (1024 * 1024);
    if (uploadedFiles.length >= _maxFiles) {
      _showLimitDialog("You can only add up to $_maxFiles files.");
      return false;
    } else if (fileSizeMB > _maxFileSizeMB) {
      _showLimitDialog("File size must be less than $_maxFileSizeMB MB.");
      return false;
    }
    return true;
  }


  void _showLimitDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Limit Exceeded"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }


  String _getFileType(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    if (ext == '.pdf') return 'pdf';
    if (ext == '.xls' || ext == '.xlsx') return 'excel';
    if (ext == '.jpg' || ext == '.jpeg') return 'image';
    return 'document'; // fallback
  }


  Future<void> _imageFromCamera1() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (_canAddFile(file)) {
        ppmDetailsBloc.add(PPMUploadFileInProgressEvent(file, path.basename(file.path)));
      }
    }
  }


  Future<void> _imageFromGallery1() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (_canAddFile(file)) {
        ppmDetailsBloc.add(PPMUploadFileInProgressEvent(file, path.basename(file.path)));
      }
    }
  }


  Future<void> _pickDocument1() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      if (_canAddFile(file)) {
        ppmDetailsBloc.add(PPMUploadFileInProgressEvent(file, path.basename(file.path)));
      }
    }
  }

  Widget _buildFileGrid() {
    final showAddButton = !isClosed && uploadedFiles.length < _maxFiles;
    final itemCount = uploadedFiles.length + (showAddButton ? 1 : 0);



    return Container(
      height: 300,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFCBD4F4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          if (showAddButton && index == itemCount - 1) {
            return _buildAddButton();
          }

          final filePath = uploadedFiles[index].path;
          final fileName = path.basename(filePath);
          final isImage = _isImageFile(filePath);


          return Stack(
            children: [
              GestureDetector(
                onTap: () => _openFile(uploadedFiles[index].path, context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isImage
                        ? Image.network(filePath, fit: BoxFit.cover)
                        : _buildDocThumbnail(fileName),
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete File"),
                          content: Text("Are you sure you want to delete this file?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final imageId = uploadedFiles[index].id;

                        if(imageId!=0){
                          ppmDetailsBloc.add(PPMDeleteUploadedFileEvent(id: imageId, ppmScheduleId: ppmid as String));
                        } else {
                          Utils.showInSnackBar(
                              context,
                              "Attachment deleted successfully.",
                              ToastType.Success);
                        }


                        setState(() {
                          uploadedFiles.removeAt(index);
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
  Widget _buildAddButton() {
    final int count = uploadedFiles.length;


    return GestureDetector(
      onTap: () => _showPhotoDialog(context),
      child: Stack(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 40, color: Colors.grey.shade700),
                SizedBox(height: 8),
                Text(
                  "Not more than 5 MB",
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${count}/$_maxFiles',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isImageFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png'].contains(ext);
  }

  Future<String> _downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Widget _buildDocThumbnail(String fileName) {
    final ext = path.extension(fileName).toLowerCase();

    IconData icon;
    Color iconColor;

    if (ext == '.pdf') {
      icon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (ext == '.xls' || ext == '.xlsx') {
      icon = Icons.grid_on;
      iconColor = Colors.green;
    } else if (ext == '.doc' || ext == '.docx') {
      icon = Icons.description;
      iconColor = Colors.blue;
    } else {
      icon = Icons.insert_drive_file;
      iconColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: iconColor),
          SizedBox(height: 8),
          Text(
            fileName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  Future<void> _openFile(String filePath, BuildContext context) async {
    final isImage = _isImageFile(filePath);

    if (isImage) {
      // Show image in dialog
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            padding: EdgeInsets.all(8),
            child: filePath.startsWith('http')
                ? Image.network(filePath)
                : Image.file(File(filePath)),
          ),
        ),
      );
    } else {
      String localPath;

      if (filePath.startsWith('http')) {
        final fileName = path.basename(filePath);
        final dir = await getTemporaryDirectory();
        localPath = '${dir.path}/$fileName';

        // Download if it doesn't exist
        if (!File(localPath).existsSync()) {
          localPath = await _downloadFile(filePath, fileName);
        }
      } else {
        localPath = filePath;
      }

      final result = await OpenFile.open(localPath);
      if (result.type != ResultType.done) {
        _showAlertDialog(
          context,
          title: "Error",
          content:
          "Unable to open the document. Make sure an app that supports this file type is installed.",
        );
      }
    }
  }

  void _showAlertDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  List<TrackDatum> convertMapListToModelList(
      List<Map<String, String>> mapList) {
    List<TrackDatum> modelList = [];
    for (var map in mapList) {
      TrackDatum model = TrackDatum(
        id: map['id'],
        afterImage: map['afterImage'],
        beforeImage: map['beforeImage'],
      );
      modelList.add(model);
    }
    return modelList;
  }
}

class ChipWithDelete extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const ChipWithDelete({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: onDelete,
    );
  }
}
