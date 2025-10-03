import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/features/closed/view/bloc/closed_view_bloc.dart';
import 'package:cmms/src/features/closed/view/model/closed_response_model.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import '../../../../helpers/utils/AlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../bloc/closed_view_event.dart';
import '../bloc/closed_view_state.dart';

class ClosedDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<ClosedViewBloc>(
          create: (context) =>
              ClosedViewBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: ClosedDetails(),
    );
  }
}

class ClosedDetails extends StatefulWidget {
  @override
  _InProgressDetailsWidgetState createState() =>
      _InProgressDetailsWidgetState();
}

class _InProgressDetailsWidgetState extends State<ClosedDetails> {

  String userid = "";
  bool isShowRequestHistory = false;
  bool _isAPICalled = true;
  late ClosedViewBloc closedViewBloc;
  List<RequestHistory> requestHistory = [];
  String assigneeDropdownValue = "";
  String statusDropdownValue = "";
  TextEditingController commentsController = TextEditingController();
  int selectedUserId = 0, selectedStatusID = 0;
  String ClosedID = "";
  String priorityName = "";
  String additionalSpace = "";
  int priorityId = 0;

  String searchText = '',
      uploadPath = "",
      documentType = ""; // State variable to store the entered text
  bool uploadStatus = false;
  bool is_photos_view_visible = true;

  List<Multipleimage> uploadedFiles = [];

  @override
  void initState() {
    closedViewBloc = BlocProvider.of<ClosedViewBloc>(context);
    closedViewBloc.add(ClosedViewInitEvent());

    fetchUserID();
    super.initState();
  }

  Future<void> fetchUserID() async {
    userid = await AppSharedPrefs.getUserID();
  }

  @override
  void dispose() {
    closedViewBloc.close();
    super.dispose();
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
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey("ClosedID")) {
      ClosedID = args['ClosedID'] as String;
      if (_isAPICalled) {
        closedViewBloc.add(ClosedViewLoadEvent(int.parse(ClosedID)));
        print("API Call Check");
      }
    }

    return BlocProvider(
      create: (context) => closedViewBloc,
      child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
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
                /*  Spacer(),
                  Image.asset(
                    'assets/images/ecms_logo.png',
                    width: 100,
                    height: 20,
                  ),*/
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
                      AppColors.whiteColor
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

                    BlocListener<ClosedViewBloc, ClosedViewState>(
                      listener: (context, state) async {
                        if (state is ClosedViewLoadedState) {
                          if (state.closedViewModel.status) {
                            setState(() {
                              _isAPICalled = false;
                              requestHistory.clear();
                              priorityName =
                                  state.closedViewModel.priorityName;
                              additionalSpace =
                                  state.closedViewModel.additionalSpace;
                              requestHistory.addAll(
                                  state.closedViewModel.requestHistory);
                              assigneeDropdownValue =
                                  state.closedViewModel.assignedTo;
                              statusDropdownValue =
                                  state.closedViewModel.currentStatus;
                              selectedUserId =
                                  state.closedViewModel.assignedToId;
                              commentsController.text = state.closedViewModel.description;
                              selectedStatusID =
                                  state.closedViewModel.statusId;
                              uploadedFiles = state.closedViewModel.multipleimage;
                            });
                          } else {
                            Utils.showInSnackBar(
                                context,
                                state.closedViewModel.message!,
                                ToastType.Warning);
                          }
                        } else if (state is ClosedViewErrorState) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<ClosedViewBloc, ClosedViewState>(
                          builder: (context, state) {
                        if (state is ClosedViewInitialState) {
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

                    Text('Assigned To : ',
                        style: TextStyle(fontSize: 19, color: Colors.black)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Color(0xFFCBD4F4), width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        assigneeDropdownValue,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),


                    /*  End here */

                    SizedBox(
                      height: 20,
                    ),

                    Text('Status : ',
                        style: TextStyle(fontSize: 19, color: Colors.black)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Color(0xFFCBD4F4), width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        statusDropdownValue,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),

                    /*  End here */

                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      'Priority : ',
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Color(0xFFCBD4F4), width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        priorityName,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      'Addn. Loc : ',
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Color(0xFFCBD4F4), width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        additionalSpace,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Comments :',
                      style: TextStyle(fontSize: 19, color: Colors.black),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      controller: commentsController,
                      maxLines: null,
                      readOnly: true,
                      onChanged: (value) {
                        setState(() {

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
                    SizedBox(
                      height: 20,
                    ),

                    /*Photo upload */

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Attachments : "),
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

                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildFileGrid() {

    return Container(
      height: 300,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        itemCount: uploadedFiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {

          final filePath = uploadedFiles[index].path;
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
                        : _buildDocThumbnail(filePath),
                  ),
                ),
              ),
            ],
          );
        },
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
