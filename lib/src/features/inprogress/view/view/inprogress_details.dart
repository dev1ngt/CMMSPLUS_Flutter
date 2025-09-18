import 'dart:io';
import 'dart:typed_data';

import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/features/inprogress/list/view/inprogress_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../faultreport/submit/bloc/summary_submit_event.dart';
import '../../../pendingresponsedetails/bloc/details_part1/UploadFilesBloc.dart';
import '../../../pendingresponsedetails/bloc/details_part1/UploadFilesEvent.dart';
import '../../../pendingresponsedetails/bloc/details_part1/UploadFilesState.dart';
import '../../../pendingresponsedetails/bloc/details_part2/details_part2_bloc.dart';
import '../../../pendingresponsedetails/bloc/details_part2/details_part2_event.dart';
import '../../../pendingresponsedetails/bloc/details_part2/details_part2_state.dart';
import '../../../pendingresponsedetails/view/pendingdetails2.dart';
import '../bloc/InProgressViewBloc.dart';
import '../bloc/InProgressViewEvent.dart';
import '../bloc/InProgressViewState.dart';
import '../model/inprogress_response_model.dart';
import '../model/inprogress_submit_request_model.dart';

class InProgressDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<InProgressViewBloc>(
          create: (context) =>
              InProgressViewBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<UploadFilesBloc>(
          create: (context) =>
              UploadFilesBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<DetailsPart2Bloc>(
          create: (context) =>
              DetailsPart2Bloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: InprogressDetails(),
    );
    // return InprogressDetails();
  }
}

class InprogressDetails extends StatefulWidget {
  @override
  _InProgressDetailsWidgetState createState() =>
      _InProgressDetailsWidgetState();
}

class _InProgressDetailsWidgetState extends State<InprogressDetails> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color
  TextEditingController textCommentsController = TextEditingController();
  TextEditingController textCauseOfFault = TextEditingController();
  TextEditingController textActionTaken = TextEditingController();
  TextEditingController additionalSpaceController = TextEditingController();
  TextEditingController  EstimatedTimeOfCompletion = TextEditingController();
  TextEditingController EstimatedAmount = TextEditingController();
  TextEditingController followup_action_type_name = TextEditingController();
  TextEditingController textvendorName  = TextEditingController();
  bool isPhotoVisible = false;
  late UploadFilesBloc _uploadFileBloc;
  File? _image;
  late DetailsPart2Bloc _detailsPart2Bloc;
  late List<AfterFixPhoto> afterFixPhoto = [];
  bool isSubmitButtonVisible = true;
  bool isFirstPartVisible = false;
  bool isPartReplaced = false;
  bool isSecondPartVisible = false;
  String UserID = "", priority = "";
  String? _techSignPath, _cilentSignPath, _selectedImagePath;
  ApiService apiService = ApiService();
  bool status_type_choose = true;
  int status_action = 1;
  int? followup_action_choose = 0;
  String CompanyName = "",
      NameOfPersonal = "",
      DateOfArrival = "",
      TimeOfArrival = "",
      CauseOfFault = "",
      ActionTaken = "",
      ItemReplaced = "",
      Designation = "",

      beforePhotoSavedPath = "",
      fault_type_name = "",

      completedRemarks = "",
      vendorName = "",
      clientSignature = "",
      workStatus = "";
  int IsPhotoTaken = 0,
      isPartReplacement = 0,
      fault_status = 0,
      followup_action_status = 0,
      FaultId = 0,
      requestId = 0,
      submitFlag = 0,
      workStatus_id = 0;
  late InProgressViewBloc inProgressViewBloc;
  String PhotosChooseEvent = "", signType = "";
  String _selectedAfterImagePath = "",
      _selectedBeforeImagePath = "",
      afterImageUploadPath = "",
      beforeImageUploadPath = "";
  bool isSubmitting = false;

  final ImagePicker _picker = ImagePicker();
  InprogressSubmitRequestModel inprogressSubmitRequestModel =
      InprogressSubmitRequestModel();
  int ImageSavedId = 0;

  _imageFromCamera() async {
    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        if (PhotosChooseEvent == "After") {
          _selectedAfterImagePath = pickedImage.path;
        } else {
          _selectedBeforeImagePath = pickedImage.path;
        }
      });

      // Create a File object using the path
      if (PhotosChooseEvent == "After") {
        File selectedImageFile = File(_selectedAfterImagePath!);
        _uploadFileBloc
            .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
      } else {
        File selectedImageFile = File(_selectedBeforeImagePath!);
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


  _imageFromGallery() async {
    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        if (PhotosChooseEvent == "After") {
          _selectedAfterImagePath = pickedImage.path;
        } else {
          _selectedBeforeImagePath = pickedImage.path;
        }
      });

      // Create a File object using the path
      if (PhotosChooseEvent == "After") {
        File selectedImageFile = File(_selectedAfterImagePath!);
        _uploadFileBloc
            .add(UploadFileInProgressEvent(selectedImageFile, "Test.png"));
      } else {
        File selectedImageFile = File(_selectedBeforeImagePath!);
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

    fetchUserID();
    inProgressViewBloc = BlocProvider.of<InProgressViewBloc>(context);
    inProgressViewBloc.add(InProgressViewsInitEvent());
    inProgressViewBloc.add(InProgressViewsEvent());

    _uploadFileBloc = BlocProvider.of<UploadFilesBloc>(context);
    _uploadFileBloc.add(UploadInProgressEvent());

    _detailsPart2Bloc = BlocProvider.of<DetailsPart2Bloc>(context);
    _detailsPart2Bloc.add(SignFileInitEvent());
  }

  Future<void> fetchUserID() async {
    UserID = await AppSharedPrefs.getUserID();
    priority = await AppSharedPrefs.getPriority();
    setState(() {});
  }

  @override
  void dispose() {
    inProgressViewBloc.close();
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
                      _imageFromCamera();
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromCamera();
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
                      _imageFromGallery();
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromGallery();
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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('SubmitBtnShow')) {
      final String submitBtnVisible = args['SubmitBtnShow'] as String;
      print(' $submitBtnVisible');
     /* if (submitBtnVisible == "1") {
        isSubmitButtonVisible = true;
      } else {
        isSubmitButtonVisible = false;
      }*/
    }

    return BlocProvider(
      create: (context) => inProgressViewBloc,
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
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
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
                    customColor1,
                    customColor2
                  ], // Replace with your gradient colors
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
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
                    "IN-PROGRESS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0, // Adjust the font size as needed
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // Asset Scan Result
                BlocListener<InProgressViewBloc, InProgressViewState>(
                  listener: (context, state) async {
                    if (state is InProgressViewSuccess) {
                      print(state.inprogressResponseModel.message);
                      setState(() {
                        FaultId =
                            state.inprogressResponseModel.faultResponseView.id;
                        requestId = state.inprogressResponseModel.loginOfRequestView.id;
                        CompanyName = state.inprogressResponseModel
                            .faultResponseView.companyName;
                        NameOfPersonal = state.inprogressResponseModel
                            .faultResponseView.nameOfPersonnel;
                        DateOfArrival = state.inprogressResponseModel
                            .faultResponseView.dateOfArrival;
                        TimeOfArrival = state.inprogressResponseModel
                            .faultResponseView.timeOfArrival;
                        CauseOfFault = state.inprogressResponseModel.faultResponseView.causeOfFault;
                        textCauseOfFault.text = state.inprogressResponseModel.faultResponseView.causeOfFault;
                        textActionTaken.text = state.inprogressResponseModel.faultResponseView.actionTaken;
                        ActionTaken = state.inprogressResponseModel
                            .faultResponseView.actionTaken;
                        IsPhotoTaken = state.inprogressResponseModel
                            .faultResponseView.photoTaken;
                        isPartReplacement = state.inprogressResponseModel
                            .faultResponseView.partsReplacement;
                        ItemReplaced = state.inprogressResponseModel
                            .faultResponseView.itemReplaced;
                        Designation = state.inprogressResponseModel
                            .faultResponseView.designation;
                        EstimatedTimeOfCompletion.text = state
                            .inprogressResponseModel
                            .faultResponseView
                            .estTimeCompletion;
                        EstimatedAmount.text = state.inprogressResponseModel
                            .faultResponseView.quoteAmount;
                        fault_status = state
                            .inprogressResponseModel.faultResponseView.status;
                        followup_action_status = state.inprogressResponseModel
                            .faultResponseView.followUpAction;
                        _techSignPath = state.inprogressResponseModel
                            .faultResponseView.signature;
                        workStatus = state.inprogressResponseModel.loginOfRequestView.workStatusName;
                        workStatus_id = int.parse(state.inprogressResponseModel.loginOfRequestView.workStatusId);
                        submitFlag = state.inprogressResponseModel.submitFlag;
                        status_action = state.inprogressResponseModel.loginOfRequestView.statusAction;
                        followup_action_choose =  state.inprogressResponseModel.faultResponseView.followUpAction;

                        /*if(submitFlag == 0){
                          isSubmitButtonVisible = false;
                        }
                        else {
                          isSubmitButtonVisible = true;
                        }*/
                        textCommentsController.text = state.inprogressResponseModel.completedRemarks;
                        if(state.inprogressResponseModel.faultResponseView.clientSignature.isEmpty){
                          _cilentSignPath = "";
                        }
                        else {
                          _cilentSignPath = state.inprogressResponseModel.faultResponseView.clientSignature;
                        }
                        textvendorName.text   =state.inprogressResponseModel.faultResponseView.vendor;

                        print("isPartReplacement_" +
                            isPartReplacement.toString());

                       /* if (fault_status == 0) {
                          fault_type_name = "Pending";
                        } else {
                          fault_type_name = "Rectified";
                        }*/



                        if (state.inprogressResponseModel.images.length > 0) {
                          _selectedImagePath = state
                              .inprogressResponseModel.images[0].afterImage!;
                        }

                        /*if (followup_action_status == 1) {
                          followup_action_type_name = "Part Replacement";
                        } else if (followup_action_status == 2) {
                          followup_action_type_name = "Quotation";
                        } else if (followup_action_status == 3) {
                          followup_action_type_name = "Others";
                        }*/

                        if (IsPhotoTaken == 1) {
                          isPhotoVisible = true;
                        } else {
                          isPhotoVisible = false;
                        }

                        if (isPartReplacement == 1) {
                          // isFirstPartVisible  = true;
                          isPartReplaced = true;
                        } else {
                          //  isFirstPartVisible  = false;
                          isPartReplaced = false;
                        }

                        if(status_action == 1){
                          status_type_choose = true;
                        }
                        else {
                          status_type_choose = false;
                        }




                        if (state.inprogressResponseModel.images.length > 0) {
                          if (state.inprogressResponseModel.images[0].id! !=
                              null) {
                            ImageSavedId =
                                state.inprogressResponseModel.images[0].id!;
                          }

                          if (state.inprogressResponseModel.images[0]
                                  .afterImage! !=
                              null) {
                            afterImageUploadPath = state
                                .inprogressResponseModel.images[0].afterImage!;
                          }
                          if (state.inprogressResponseModel.images[0]
                                  .beforeImage! !=
                              null) {
                            beforeImageUploadPath = state
                                .inprogressResponseModel.images[0].beforeImage!;
                          }
                        }
                      });
                    } else if (state is InProgressViewFailure) {
                      Utils.showInSnackBar(
                          context, state.error, ToastType.Warning);
                    }
                  },
                  child: BlocBuilder<InProgressViewBloc, InProgressViewState>(
                      builder: (context, state) {
                    if (state is InProgressViewInfo) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container();
                  }),
                ),

                /* Section 1 start */
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFirstPartVisible = !isFirstPartVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            0.0), // Adjust the border radius as needed
                      ),
                      padding:
                          EdgeInsets.all(16.0), // Adjust the padding as needed
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Technician Response to Fault"),
                        Icon(
                          isFirstPartVisible ? Icons.remove : Icons.add,
                          size: 24.0,
                        ), // Adjust the size of the plus icon as needed
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Visibility(
                    visible: isFirstPartVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text("Company Name :", style: TextStyle(fontSize: 16)),
                        Container(
                          height: 45,
                          margin: EdgeInsets.only(top: 5),
                          width: double.infinity,
                          child:
                              Text(CompanyName, style: TextStyle(fontSize: 14)),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFCBD4F4), width: 1),
                            // Outline box with black border
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                          ),
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Name of Personnel :",
                            style: TextStyle(fontSize: 16)),
                        Container(
                          height: 45,
                          width: double.infinity,
                          // Set width to full view
                          margin: EdgeInsets.only(top: 5),
                          child: Text(NameOfPersonal,
                              style: TextStyle(fontSize: 14)),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFCBD4F4), width: 1),
                            // Outline box with black border
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                          ),
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Date & Time of Arrival :",
                            style: TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // Show the date picker bottom sheet
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),  // Disable past dates
                                    lastDate: DateTime(2100),
                                  );
                                  if (selectedDate != null) {
                                    // Handle the selected date
                                    setState(() {
                                      DateOfArrival = DateFormat('dd-MM-yyyy').format(selectedDate);
                                    });
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(DateOfArrival, style: TextStyle(fontSize: 14)),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFFCBD4F4), width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // Show the time picker bottom sheet
                                  TimeOfDay? selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (selectedTime != null) {
                                    // Handle the selected time
                                    setState(() {
                                      TimeOfArrival = selectedTime.format(context);
                                    });
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  margin: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(TimeOfArrival, style: TextStyle(fontSize: 14)),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFFCBD4F4), width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Cause of Fault :",
                            style: TextStyle(fontSize: 16)),
                        TextFormField(
                          controller: textCauseOfFault, // Controller to manage input
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10), // Adjust vertical padding to increase height
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
                            ),
                            hintText: 'Enter cause of fault', // Optional: placeholder text
                          ),
                          maxLines: null, // Allows for multi-line input
                          textAlignVertical: TextAlignVertical.top, // Align text at the top
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the cause of fault';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Action Taken :", style: TextStyle(fontSize: 16)),
                        TextFormField(
                          controller: textActionTaken, // Controller to manage input
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10), // Adjust vertical padding to increase height
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
                            ),
                            hintText: 'Enter action taken', // Optional: placeholder text
                          ),
                          maxLines: null, // Allows for multi-line input
                          textAlignVertical: TextAlignVertical.top, // Align text at the top
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the action taken';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Addn. Loc :", style: TextStyle(fontSize: 16)),
                        TextFormField(
                          controller: additionalSpaceController, // Controller to manage input
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10), // Adjust vertical padding to increase height
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
                            ),
                            hintText: 'Enter addn loc', // Optional: placeholder text
                          ),
                          textAlignVertical: TextAlignVertical.top, // Align text at the top
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Text("Priority :", style: TextStyle(fontSize: 16)),
                        Container(
                          height: 45,
                          margin: EdgeInsets.only(top: 5),
                          width: double.infinity,
                          child:
                          Text(priority, style: TextStyle(fontSize: 14)),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Color(0xFFCBD4F4), width: 1),
                            // Outline box with black border
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                          ),
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                        ),

                        Text("Photos Taken ?", style: TextStyle(fontSize: 16)),
                       /* Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: isPhotoVisible,
                              onChanged: null,
                            ),
                            Text("Yes"),
                            SizedBox(width: 20),
                            Radio(
                              value: false,
                              groupValue: isPhotoVisible,
                              onChanged: null,
                            ),
                            Text("No"),
                          ],
                        ),*/

                        Row(
                          children: [
                            Radio(
                              value: true,
                              // Other properties go here
                              onChanged: (value) {
                                setState(() {
                                  isPhotoVisible =
                                  value!; // Update the selected ID
                                  IsPhotoTaken = 1;
                                });
                              },
                              groupValue: isPhotoVisible,
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
                                  isPhotoVisible =
                                  value!; // Update the selected ID
                                  IsPhotoTaken = 0;
                                });
                              },
                              groupValue: isPhotoVisible,
                            ),
                            Text(
                              'No',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 10.0),
                          ],
                        ),

                        Visibility(
                          visible: isPhotoVisible,
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          PhotosChooseEvent = "Before";
                                          _showPhotoDialog(context);
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
                                          PhotosChooseEvent = "After";
                                          _showPhotoDialog(context);
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

                        // Take photo
                        BlocListener<UploadFilesBloc, UploadFilesState>(
                          listener: (context, state) async {
                            if (state is UploadFilesSuccess) {
                              Utils.showInSnackBar(
                                  context,
                                  state.fileuploadresponse.message!,
                                  ToastType.Success);
                              try {
                                setState(() {
                                  if (PhotosChooseEvent == 'Before') {
                                    beforeImageUploadPath =
                                        state.fileuploadresponse.uploadedpath!;
                                  } else if (PhotosChooseEvent == "After") {
                                    afterImageUploadPath =
                                        state.fileuploadresponse.uploadedpath!;
                                  } else {}
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

                        SizedBox(
                          height: 20,
                        ),
                        Text("Parts Replacement ?",
                            style: TextStyle(fontSize: 16)),
                       /* Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: isPartReplaced,
                              onChanged: null,
                            ),
                            Text("Yes"),
                            SizedBox(width: 20),
                            Radio(
                              value: false,
                              groupValue: isPartReplaced,
                              onChanged: null,
                            ),
                            Text("No"),
                          ],
                        ),
                        */

                        Row(
                          children: [
                            Radio(
                              value: true,
                              // Other properties go here
                              onChanged: (value) {
                                setState(() {
                                  isPartReplaced =
                                  value!; // Update the selected ID
                                  isPartReplacement = 1;
                                });
                              },
                              groupValue: isPartReplaced,
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
                                  isPartReplaced =
                                  value!; // Update the selected ID
                                  isPartReplacement = 0;
                                });
                              },
                              groupValue: isPartReplaced,
                            ),
                            Text(
                              'No',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 10.0),
                          ],
                        ),

                        /*Text("Item Replaced :", style: TextStyle(fontSize: 16)),
                        Container(
                          height: 45,
                          margin: EdgeInsets.only(left: 1),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFCBD4F4), width: 1),
                            // Outline box with black border
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                          ),
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(ItemReplaced),
                        ),*/

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Add this line
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/status.png',
                                      // Replace with your image path
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Status',
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
                                          status_type_choose =
                                          value!; // Update the selected ID
                                          //followup_action_choose = 0;
                                          status_action = 1;
                                        });
                                      },
                                      groupValue: status_type_choose,
                                    ),
                                    Text(
                                      'Rectified',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    Radio(
                                      value: false,
                                      // Other properties go here
                                      // Other properties go here
                                      onChanged: (value) {
                                        setState(() {
                                          status_type_choose =
                                          value!; // Update the selected ID
                                          status_action = 0;
                                          _cilentSignPath = "";
                                        });
                                      },
                                      groupValue: status_type_choose,
                                    ),
                                    Text(
                                      'Pending',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),


                        Visibility(
                          visible: !status_type_choose,
                          child: Padding(
                            padding:
                            EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Follow Up Action Required',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: followup_action_choose,
                                          onChanged: (value) {
                                            setState(() {
                                              followup_action_choose =
                                              value as int?;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Part Replacement',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        Radio(
                                          value: 2,
                                          groupValue: followup_action_choose,
                                          onChanged: (value) {
                                            setState(() {
                                              followup_action_choose =
                                              value as int?;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Quotation',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        Radio(
                                          value: 3,
                                          groupValue: followup_action_choose,
                                          onChanged: (value) {
                                            setState(() {
                                              followup_action_choose =
                                              value as int?;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Others',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                /*Section 1 end  */
                /* Section 2  start */

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSecondPartVisible = !isSecondPartVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            0.0), // Adjust the border radius as needed
                      ),
                      padding:
                          EdgeInsets.all(16.0), // Adjust the padding as needed
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Fault Closure by Technician"),
                        Icon(
                          isSecondPartVisible ? Icons.remove : Icons.add,
                          size: 24.0,
                        ), // Adjust the size of the plus icon as needed
                      ],
                    ),
                  ),
                ),
                /* Session 2 end */
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Visibility(
                    visible: isSecondPartVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Status :',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              color: Colors.blue,
                              // Set the background color to blue
                              child: Text(
                                workStatus,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Estimated Amount :',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        TextFormField(
                          controller: EstimatedAmount,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFFCBD4F4),
                                width: 1,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Estd Time of Completion :',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        TextFormField(
                          controller: EstimatedTimeOfCompletion, // Replace with a controller if needed
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFFCBD4F4),
                                width: 1,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                        /*SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Follow Up Action Required :',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        TextFormField(
                          controller: followup_action_type_name, // Use a controller if needed for managing text input
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFFCBD4F4),
                                width: 1,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),*/
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Vendor :',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        TextFormField(
                          controller: textvendorName, // Use the variable `vendorName` as the initial value
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),

                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Contractor Name',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(height: 5.0),
                                        Container(
                                          height: 45,
                                          margin: EdgeInsets.only(left: 1),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFFCBD4F4),
                                                width: 1),
                                            // Outline box with black border
                                            borderRadius: BorderRadius.circular(
                                                10), // Adjust the border radius as needed
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            NameOfPersonal,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Tech Sign',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(height: 5.0),
                                        GestureDetector(
                                          onTap: () {
                                            signType = "Tech";
                                            SignatureDialog.showSignatureDialog(
                                                context, _detailsPart2Bloc);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5.0),
                                            width: 150.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              // Replace with your desired color
                                              border: Border.all(
                                                  color: Color(0xFFCBD4F4),
                                                  width: 1.0),
                                            ),
                                            child: Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: _techSignPath != null && _techSignPath!.isNotEmpty
                                                      ? NetworkImage(
                                                              _techSignPath!)
                                                          as ImageProvider<
                                                              Object>
                                                      : AssetImage(
                                                          'assets/images/signature.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  // Add this SizedBox for horizontal spacing
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5.0),
                                        Text(
                                          'Designation',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(height: 5.0),
                                        Container(
                                          height: 45,
                                          margin: EdgeInsets.only(left: 1),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFFCBD4F4),
                                                width: 1),
                                            // Outline box with black border
                                            borderRadius: BorderRadius.circular(
                                                10), // Adjust the border radius as needed
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            Designation,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Client Sign',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(height: 5.0),
                                        GestureDetector(
                                          onTap: () {
                                            signType = "Client";
                                            SignatureDialog.showSignatureDialog(
                                                context, _detailsPart2Bloc);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5.0),
                                            width: 150.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              // Replace with your desired color
                                              border: Border.all(
                                                  color: Color(0xFFCBD4F4),
                                                  width: 1.0),
                                            ),
                                            child: Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: _cilentSignPath != null && _cilentSignPath!.isNotEmpty
                                                      ? NetworkImage(
                                                              _cilentSignPath!)
                                                          as ImageProvider<
                                                              Object>
                                                      : AssetImage(
                                                          'assets/images/signature.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /* Contract Name */
                        /*   Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Contractor Name',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(height: 5.0),
                                          Container(
                                            height: 45,
                                            margin: EdgeInsets.only(left: 1),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFFCBD4F4),
                                                  width: 1),
                                              // Outline box with black border
                                              borderRadius: BorderRadius.circular(
                                                  10), // Adjust the border radius as needed
                                            ),
                                            padding: EdgeInsets.only(left: 10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              NameOfPersonal,
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            'Designation',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(height: 5.0),
                                          Container(
                                            height: 45,
                                            margin: EdgeInsets.only(left: 1),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFFCBD4F4),
                                                  width: 1),
                                              // Outline box with black border
                                              borderRadius: BorderRadius.circular(
                                                  10), // Adjust the border radius as needed
                                            ),
                                            padding: EdgeInsets.only(left: 10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              Designation,
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    // Add this SizedBox for horizontal spacing
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Signature',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(height: 5.0),
                                          GestureDetector(
                                            onTap: () {
                                              // Handle the click event here
                                              print('Container clicked!');
                                              // Add your custom logic or navigate to another screen
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 5.0),
                                              width: 150.0,
                                              height: 140.0,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                // Replace with your desired color
                                                border: Border.all(
                                                    color: Color(0xFFCBD4F4),
                                                    width: 1.0),
                                              ),
                                              child: Container(
                                                width: 100.0,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: _techSignPath !=
                                                            null
                                                        ? NetworkImage(
                                                                _techSignPath!)
                                                            as ImageProvider<
                                                                Object>
                                                        : AssetImage(
                                                            'assets/images/signature.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/

                        /*  End up */
                      ],
                    ),
                  ),
                ),

                /* Signature save */

                BlocListener<DetailsPart2Bloc, DetailsPart2State>(
                  listener: (context, state) async {
                    if (state is SignUploadSuccess) {
                      setState(() {
                        if (signType == "Tech") {
                          _techSignPath =
                              state.fileuploadresponse.uploadedpath!;
                        } else {
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

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/action_taken.png',
                              // Replace with your image path
                              width: 20.0,
                              height: 20.0,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'Comments',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          child: TextField(
                            controller: textCommentsController,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 40.0),
                              hintText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        /*Submit */
                        Visibility(
                          visible: isSubmitButtonVisible,
                          child: ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () {

                              if (textCommentsController.text.isEmpty) {
                                Utils.showInSnackBar(context,
                                    "Enter the comments", ToastType.Error);
                              }
                              else {
                                if (ImageSavedId == 0) {
                                  afterFixPhoto = [];

                                  afterFixPhoto.add(AfterFixPhoto(
                                      id: 0,
                                      beforeImage: beforeImageUploadPath,
                                      afterImage: afterImageUploadPath));

                                } else {
                                  AfterFixPhoto updates_photo = AfterFixPhoto(
                                      id: ImageSavedId,
                                      afterImage: afterImageUploadPath,
                                      beforeImage: beforeImageUploadPath);
                                  afterFixPhoto.add(updates_photo);
                                }

                                setState(() {
                                  isSubmitting = true;
                                });

                                inprogressSubmitRequestModel.requestId = requestId;
                                inprogressSubmitRequestModel.faultId= FaultId;
                                inprogressSubmitRequestModel.userId =
                                    int.parse(UserID);
                                inprogressSubmitRequestModel.dateOfArrival = DateOfArrival;
                                inprogressSubmitRequestModel.timeOfArrival = TimeOfArrival;
                                inprogressSubmitRequestModel.causeOfFault = textCauseOfFault.text;
                                inprogressSubmitRequestModel.actionTaken = textActionTaken.text;
                                inprogressSubmitRequestModel.companyName = CompanyName;
                                inprogressSubmitRequestModel.nameOfPersonnel = NameOfPersonal;
                                inprogressSubmitRequestModel.contractorName = CompanyName;
                                inprogressSubmitRequestModel.completedRemarks =
                                    textCommentsController.text;
                                inprogressSubmitRequestModel.photoTaken = IsPhotoTaken;
                                inprogressSubmitRequestModel.partsReplacement =
                                    isPartReplacement;
                                inprogressSubmitRequestModel.itemReplaced =
                                    ItemReplaced;
                                inprogressSubmitRequestModel.estTimeCompletion = EstimatedTimeOfCompletion.text;
                                if(EstimatedAmount.text.isEmpty){
                                  inprogressSubmitRequestModel.quoteAmount = 0 ;
                                }
                                else {
                                  inprogressSubmitRequestModel.quoteAmount = int.parse(EstimatedAmount.text);
                                }

                                inprogressSubmitRequestModel.followUpAction = followup_action_choose;

                                inprogressSubmitRequestModel.status = workStatus_id;
                                inprogressSubmitRequestModel.userName =
                                    NameOfPersonal;
                                inprogressSubmitRequestModel.userDesignation =
                                    Designation;
                                inprogressSubmitRequestModel.userSignature =
                                    _techSignPath;
                                inprogressSubmitRequestModel.clientSignature = _cilentSignPath;
                                inprogressSubmitRequestModel.vendor = textvendorName.text;
                                inprogressSubmitRequestModel.statusAction = status_action;
                                inprogressSubmitRequestModel.photo = afterFixPhoto;
                                inprogressSubmitRequestModel.additionalSpace = additionalSpaceController.text;

                                inProgressViewBloc.add(InProgressSubmitEvent(
                                    inprogressSubmitRequestModel));
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
                                    maxWidth: 150.0, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),

                        /* Submit API */

                        BlocListener<InProgressViewBloc, InProgressViewState>(
                          listener: (context, state) async {
                            if (state is InProgressSubmitSuccess) {
                              setState(() {
                                isSubmitting = false;
                              });

                              if (state.submitResponseModel.status!) {
                                Utils.showInSnackBar(
                                    context,
                                    state.submitResponseModel.message!,
                                    ToastType.Success);

                                Navigator.pushNamed(
                                  context, "/dashboard",
                                  // Add more parameters as needed
                                );
                              } else {
                                Utils.showInSnackBar(
                                    context,
                                    state.submitResponseModel.message!,
                                    ToastType.Warning);
                              }
                            } else if (state is InProgressSubmitFailure) {
                              setState(() {
                                isSubmitting = false;
                              });
                              Utils.showInSnackBar(
                                  context, state.error, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<InProgressViewBloc,
                              InProgressViewState>(builder: (context, state) {
                            if (state is InProgressSubmitLoad) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container();
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showAlertDialog(
    {required BuildContext context,
    required String title,
    required String content}) {
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

/*Signature Pad*/

class SignatureDialog {
  static Future<void> showSignatureDialog(
      BuildContext context, DetailsPart2Bloc bloc) async {
    final SignatureController _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    // CLEAR CANVAS
   // _controller.clear();

// EXPORT BYTES AS PNG
// The exported image will be limited to the drawn area
  //  _controller.toPngBytes();

// isEmpty/isNotEmpty CAN BE USED TO CHECK IF SIGNATURE HAS BEEN PROVIDED
    _controller.isNotEmpty; //true if signature has been provided
    _controller.isEmpty; //true if signature has NOT been provided

// EXPORT POINTS (2D POINTS ROUGHLY REPRESENTING WHAT IS VISIBLE ON CANVAS)
    var exportedPoints = _controller.points;

//EXPORTED POINTS CAN BE USED TO INITIALIZE PREVIOUS CONTROLLER
    final SignatureController _controller1 = SignatureController(points: exportedPoints);


    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Signature Pad'),
          content: Container(
            height: 300,
            width: 300,
            child: Signature(
              controller: _controller1,
              height: 300,
              width: 300,
              backgroundColor: Colors.white,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                saveSignatureImage(_controller1, bloc);
                Navigator.pop(context); // Close the dialog after saving
              },
              child: Text('Save Signature'),
            ),
          ],
        );
      },
    );
  }

  static void saveSignatureImage(
      SignatureController controller, DetailsPart2Bloc bloc) async {
    final signatureImageBytes = await controller.toPngBytes();

    DateTime timestamp = DateTime.now();

    if (signatureImageBytes != null) {

      // Format the timestamp
      String timestamp1 = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      Uint8List signedImageBytes = await addTextToImage(signatureImageBytes, timestamp1);
      File sign =
      await convertBytesToFile(signedImageBytes!, "Signature", timestamp);

      bloc.add(SignFileInProgressEvent(sign, "Signature"));


    // Implement your logic to save or use the signature image bytes
    print('Signature image saved.');
  }
}}
