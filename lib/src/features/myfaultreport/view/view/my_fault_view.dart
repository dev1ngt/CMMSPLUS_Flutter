import 'dart:io';

//import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../api/api_service.dart';
import '../../../../helpers/utils/AlertDialog.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../pendingresponsedetails/bloc/asset_scan/asset_bloc.dart';
import '../../../pendingresponsedetails/bloc/asset_scan/asset_event.dart';
import '../../../request/view/model/request_list_view_model.dart';
import '../bloc/request_view_bloc_my_fault.dart';
import '../bloc/request_view_event_my_fault.dart';
import '../bloc/request_view_state_my_fault.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;


class MyFaultView extends StatelessWidget {
  const MyFaultView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<AssetScanBloc>(
          create: (context) =>
              AssetScanBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<MyFaultRequestViewBloc>(
          create: (context) => MyFaultRequestViewBloc(
              RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: MyFaultViewState(),
    );
  }
}

class MyFaultViewState extends StatefulWidget {
  const MyFaultViewState({super.key});

  @override
  State<MyFaultViewState> createState() => _MyFaultViewStateState();
}

class _MyFaultViewStateState extends State<MyFaultViewState> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color

  String userid = "";
  bool isShowRequestHistory = false;
  bool _isAPICalled = true;

  late MyFaultRequestViewBloc requestViewBloc;
  List<RequestHistory> requestHistory = [];
  String commentsTxt = "";
  TextEditingController commentsController = TextEditingController();
  String RequestID = "";

  String uploadPath = "",
      documentType = "";
  bool uploadStatus = false;
  bool is_photos_view_visible = true;
  //late PDFDocument document;
  bool isSubmitting = false;

  int _maxFiles = 0;
  final int _maxFileSizeMB = 5;
  List<Multipleimage> uploadedFiles = [];
  String requestId = "";

  String additionalSpace = "";
  int selectedUserId = 0, selectedStatusID = 0;
  late AssetScanBloc assetScanBloc;
  bool isClosed = false;


  Future<void> saveSelectedImagePathToPrefs(String imagePath) async {
    await AppSharedPrefs.get().setAfterImagePath(imagePath);
  }

  bool imageConstraint(File image) {
    if (!['bmp', 'jpg', 'jpeg', 'png', 'pdf']
        .contains(image.path.split('.').last.toString())) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image format should be jpg/jpeg/bmp.");
      return false;
    }
    return true;
  }

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

    assetScanBloc = BlocProvider.of<AssetScanBloc>(context);
    assetScanBloc.add(AssetScanEventInit());


    requestViewBloc = BlocProvider.of<MyFaultRequestViewBloc>(context);
    requestViewBloc.add(MyFaultRequestViewInitEvent());

    fetchUserID();
    super.initState();
  }

  Future<void> fetchUserID() async {
    userid = await AppSharedPrefs.getUserID();
  }

  @override
  void dispose() {
    requestViewBloc.close();
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
// Access parameters here
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey("RequestID")) {
      RequestID = args['RequestID'] as String;
      isClosed = args['IsSubmitButton'] as bool;
      if (_isAPICalled) {
        requestViewBloc.add(MyFaultRequestViewLoadEvent(int.parse(RequestID)));
        print("API Call Check");
      }
    }

    return BlocProvider(
      create: (context) => requestViewBloc,
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
                      Navigator.pop(context);
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
                    /* Request Detail View API */

                    BlocListener<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                      listener: (context, state) async {
                        if (state is MyFaultRequestViewLoadedState) {
                          if (state.requestViewModel.status!) {
                            setState(() {
                              _isAPICalled = false;
                              requestHistory.clear();

                              selectedUserId = state.requestViewModel.assignedToId;
                              selectedStatusID = state.requestViewModel.statusId;
                              additionalSpace = state.requestViewModel.additionalSpace;

                              requestId = state.requestViewModel.id.toString();
                              debugPrint('New request history: ${state.requestViewModel.requestHistory}');
                              requestHistory.addAll(state.requestViewModel.requestHistory);
                              uploadedFiles = state.requestViewModel.multipleimage;
                              _maxFiles = state.requestViewModel.maxFile;
                            });
                          } else {
                            Utils.showInSnackBar(
                                context,
                                state.requestViewModel.message!,
                                ToastType.Warning);
                          }
                        } else if (state is MyFaultRequestViewErrorState) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                          builder: (context, state) {
                            if (state is MyFaultRequestViewInitialState) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container();
                          }),
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
                                  debugPrint('Tapped on comment: ${requestHistory[index].comments}');
                                  showCommentsDialog(context, requestHistory[index].comments);
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

                    SizedBox(
                      height: 20,
                    ),
                    if(!isClosed)
                    Text(
                      'Comments:',
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),
                    if(!isClosed)
                    Visibility(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: commentsController,
                        onChanged: (value) {
                          setState(() {
                            commentsTxt = value.toLowerCase();
                            // Convert to lowercase for case-insensitive search
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          hintText: 'Comments',
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
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    if(!isClosed)
                    SizedBox(
                      height: 20,
                    ),

                    /*Photo upload */

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

                    BlocListener<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                      listener: (context, state) {
                        if (state is MyFaultUploadFilesSuccess) {
                          final uploadedPath = state.fileuploadresponse.uploadedpath!;
                          final fileType = _getFileType(uploadedPath);
                          if (mounted) {
                            setState(() {
                              uploadedFiles.add(
                                Multipleimage(
                                  id: 0,
                                  type: fileType,
                                  path: uploadedPath,
                                ),
                              );
                            });
                          }
                        } else if (state is MyFaultUploadFilesFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Upload failed: ${state.error}")),
                          );
                        }
                      },
                      child: BlocBuilder<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                        builder: (context, state) {
                          if (state is MyFaultUploadFilesInitial) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(); // Or whatever UI you use
                        },
                      ),
                    ),

                    BlocListener<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                      listener: (context, state) {
                        if (state is MyFaultDeleteFileSuccess) {
                          Utils.showInSnackBar(
                              context,
                              state.deleteFileResponseModel.message,
                              ToastType.Success);
                        } else if (state is DeleteFileFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error deleting file: ${state.error}")),
                          );
                        }
                      },
                      child: BlocBuilder<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                        builder: (context, state) {
                          if (state is MyFaultDeleteFileInProgress) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(); // Or whatever UI you use
                        },
                      ),
                    ),



                    BlocListener<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                      listener: (context, state) async {
                        if (state is MyFaultRequestViewSubmitLoadedState) {
                          setState(() {
                            isSubmitting = false;
                          });

                          if (state.requestViewModel.status!) {
                            Utils.showInSnackBar(
                                context,
                                state.requestViewModel.message!,
                                ToastType.Success);
                            Navigator.pushNamed(
                              context,
                              '/dashboard',
                            );
                          } else {
                            Utils.showInSnackBar(
                                context,
                                state.requestViewModel.message!,
                                ToastType.Warning);
                          }
                        } else if (state is MyFaultRequestViewSubmitErrorState) {
                          setState(() {
                            isSubmitting = false;
                          });
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<MyFaultRequestViewBloc, MyFaultRequestViewState>(
                          builder: (context, state) {
                            if (state is MyFaultRequestViewSubmitInitialState) {
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

                    if(!isClosed)
                    Center(
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                          if (commentsTxt.isEmpty) {
                            Utils.showInSnackBar(context, "Please enter your comment.", ToastType.Warning);
                            return;
                          }

                          setState(() {
                            isSubmitting = true;
                          });

                          requestViewBloc.add(MyFaultRequestViewSubmitEvent(
                            int.parse(userid),
                            int.parse(RequestID),
                            selectedUserId,
                            selectedStatusID,
                            commentsTxt,
                            additionalSpace,
                            uploadedFiles,
                            ""
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [customColor2, customColor1],
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 136.0, minHeight: 45.0),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                      ),


                    )

                    /*Submit button  */
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
        requestViewBloc.add(MyFaultUploadFileInProgressEvent(file, path.basename(file.path)));
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
        requestViewBloc.add(MyFaultUploadFileInProgressEvent(file, path.basename(file.path)));
      }
    }
  }


  Future<void> _pickDocument1() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      if (_canAddFile(file)) {
        requestViewBloc.add(MyFaultUploadFileInProgressEvent(file, path.basename(file.path)));
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
                          requestViewBloc.add(MyFaultDeleteUploadedFileEvent(id: imageId, requestId: requestId));
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


}