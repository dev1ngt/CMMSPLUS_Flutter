import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:cmms/src/features/pendingresponse/view/pendinglist.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/TechnicianInitiateRequestModel.dart';
import 'package:cmms/src/features/pendingresponsedetails/view/pendingdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import '../../../api/api_service.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/utils.dart';
import '../bloc/details_part2/details_part2_bloc.dart';
import '../bloc/details_part2/details_part2_event.dart';
import '../bloc/details_part2/details_part2_state.dart';

class PendingDetails2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PendingDetails_2();
  }
}

class PendingDetails_2 extends StatefulWidget {
  @override
  PendingDetails_State2 createState() => PendingDetails_State2();
}

class PendingDetails_State2 extends State<PendingDetails_2> {
  late DetailsPart2Bloc _bloc;

  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color
  String selectedStatus = ''; // Add this line

  String CaseIDName = "",
      UserName = "",
      PropertyName = "",
      BlockName = " ",
      LevelName = "",
      Type = " ",
      SubType = "",
      AssetName = "",
      UserRole = "",
      UserID = "",
      AssetID = "",
      CauseOfFault = "",
      ActionTaken = "",
      CompanyName = "",
      CaseID = "",
      additionalSpace = "";

  String selectedRadio = "", selectedRadioNew = "";
  String? _techSignPath,
      _cilentSignPath,
      After_Photo_Path = "",
      Before_Photo_Path = "",
      signType = "";
  TechnicianInitiateRequestModel technicianInitiateRequestModel =
      TechnicianInitiateRequestModel();
  List<Photo> photo_list = [];
  bool status_type_choose = true;
  int? followup_action_choose = 0, status_action = 1;
  int isPhotoTaken = 0, isItemReplaced = 0, isPartRelacement = 0;
  TextEditingController textEstimatedTimeController = TextEditingController();
  TextEditingController textEstimatedAmountController = TextEditingController();
  TextEditingController textVendorController = TextEditingController();
  String ArrivalDate = "",
      ArrivalTime = "",
      EstimatedAmount = "",
      EstimatedTime = "",
      vendorName = "";

  // Define the font size and color
  double fontSize = 14.0;
  Color textColor = Colors.black; // Change this to your desired color

  // Define the state variable to store newTextString
  String newTextString = '';
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchCaseIDName();
    fetchPropertyName();
    fetchBlockName();
    fetchLevelName();
    fetchType();
    fetchSubType();
    fetchAssetName();
    fetchUserRole();
    fetchCaseID();
    _bloc = DetailsPart2Bloc(RepositoryProvider.of<ApiService>(context))
      ..add(SignFileInitEvent());
    fetchSignPath();
    fetchUserID();
    // Set newTextString when the state is initialized
    newTextString = "Another String";
  }

  Future<void> fetchUsername() async {
    UserName = await AppSharedPrefs.getUsername();
    setState(() {});
  }

  Future<void> fetchCaseIDName() async {
    CaseIDName = await AppSharedPrefs.getCaseIDName();
    setState(() {});
  }

  Future<void> fetchSignPath() async {
    _techSignPath = await AppSharedPrefs.getSignImagePath();
    _cilentSignPath = await AppSharedPrefs.getClientSignImagePath();
    setState(() {
      _techSignPath = _techSignPath;
      _cilentSignPath = _cilentSignPath;
    });
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

  Future<void> fetchCaseID() async {
    CaseID = await AppSharedPrefs.getCaseID();
    setState(() {
      CaseID = CaseID;
    });
  }

  Future<void> fetchAssetName() async {
    AssetName = await AppSharedPrefs.getAssetName();
    AssetID = await AppSharedPrefs.getAssetID();
    CauseOfFault = await AppSharedPrefs.getCauseOfFault();
    ActionTaken = await AppSharedPrefs.getActionTaken();
    CompanyName = await AppSharedPrefs.getCompanyName();
    After_Photo_Path = await AppSharedPrefs.getAfterImagePath();
    EstimatedAmount = await AppSharedPrefs.getEstmatedAmount();
    EstimatedTime = await AppSharedPrefs.getEstdTimeOfCompletion();
    vendorName = await AppSharedPrefs.getVendorName();

    setState(() {
      textEstimatedAmountController.text = EstimatedAmount;
      textEstimatedTimeController.text = EstimatedTime;
      textVendorController.text = vendorName;
    });
  }

  Future<void> fetchUserRole() async {
    UserRole = await AppSharedPrefs.getUserRole();
    setState(() {});
  }

  Future<void> fetchUserID() async {
    UserID = await AppSharedPrefs.getUserID();
    print("UserID" + UserID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Check if args is not null and contains the required parameters
    if (args != null && args.containsKey('IsPhotoTaken')) {
      final bool isPhotoTaken_ = args['IsPhotoTaken'] as bool;
      print('isPhotoTaken' + isPhotoTaken_.toString());
      isPhotoTaken = isPhotoTaken_ ? 1 : 0;
    }
    if (args != null && args.containsKey('IsPartReplaced')) {
      final bool IsPartReplaced_ = args['IsPartReplaced'] as bool;
      print('IsPartReplaced' + IsPartReplaced_.toString());
      isPartRelacement = IsPartReplaced_ ? 1 : 0;
    }
    if (args != null && args.containsKey('AssetName')) {
      final String AssetName_ = args['AssetName'] as String;
      print('AssetName' + AssetName_);
      AssetName = AssetName_;
    }
    if (args != null && args.containsKey('AssetID')) {
      final String AssetID_ = args['AssetID'] as String;
      print('AssetID' + AssetID_);
      AssetID = AssetID_;
    }
    if (args != null && args.containsKey('AfterPhotoSavedPath')) {
      final String AfterPhotoSavedPath = args['AfterPhotoSavedPath'] as String;
      print('AfterPhotoSavedPath' + AfterPhotoSavedPath);
      After_Photo_Path = AfterPhotoSavedPath;
    }

    if (args != null && args.containsKey('BeforePhotoSavedPath')) {
      final String BeforePhotoSavedPath =
          args['BeforePhotoSavedPath'] as String;
      print('BeforePhotoSavedPath' + BeforePhotoSavedPath);
      Before_Photo_Path = BeforePhotoSavedPath;
    }

    if (args != null && args.containsKey('ArrivalDate')) {
      final String ArrivalDate_ = args['ArrivalDate'] as String;
      print('ArrivalDate' + ArrivalDate_);
      ArrivalDate = ArrivalDate_;
    }

    if (args != null && args.containsKey('ArrivalTime')) {
      final String ArrivalTime_ = args['ArrivalTime'] as String;
      print('ArrivalTime' + ArrivalTime_);
      ArrivalTime = ArrivalTime_;
    }

    if (args != null && args.containsKey('additionalSpace')) {
      final String addnLoc = args['additionalSpace'] as String;
      print('additionalSpace' + addnLoc);
      additionalSpace = addnLoc;
    }

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    // Create a Text widget with desired font size and color
    Text originalTextWidget = Text(
      formattedDate,
      style: TextStyle(fontSize: fontSize, color: textColor),
    );

    // Extract the TextStyle from the original Text widget
    TextStyle textStyle = originalTextWidget.style ?? TextStyle();

    return BlocProvider(
        create: (context) => _bloc,
        child: WillPopScope(
            onWillPop: () async {
              await AppSharedPrefs.get()
                  .setEstmatedAmount(textEstimatedAmountController.text);
              await AppSharedPrefs.get()
                  .setEstdTimeOfCompletion(textEstimatedTimeController.text);

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
                        AppSharedPrefs.get().setEstmatedAmount(
                            textEstimatedAmountController.text);
                        AppSharedPrefs.get().setEstdTimeOfCompletion(
                            textEstimatedTimeController.text);
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
                      'assets/images/ecms_logo.png',
                      // replace with your image path
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
              body: BlocListener<DetailsPart2Bloc, DetailsPart2State>(
                listener: (context, state) async {
                  if (state is DetailsPart2Initial) {
                  } else if (state is SignUploadSuccess) {
                    print(state.fileuploadresponse.uploadedpath);
                    setState(() {
                      if (signType == "Tech") {
                        _techSignPath = state.fileuploadresponse.uploadedpath;
                      } else if (signType == "Client") {
                        _cilentSignPath = state.fileuploadresponse.uploadedpath;
                      }
                    });
                    if (signType == "Tech") {
                      await AppSharedPrefs.get().setSignImagePath(
                          state.fileuploadresponse.uploadedpath!);
                    } else {
                      await AppSharedPrefs.get().setClientSignImagePath(
                          state.fileuploadresponse.uploadedpath!);
                    }

                    print("listener called");
                  } else if (state is SubmitUploadInit) {
                  } else if (state is SubmitUploadSuccess) {

                    setState(() {
                      isSubmitting = false;
                    });

                    Utils.showInSnackBar(context,
                        state.submitResponseModel.message!, ToastType.Success);
                    Navigator.pushNamed(context, '/dashboard');

                    await AppSharedPrefs.get().setAssetName("");
                    await AppSharedPrefs.get().setAssetID("");
                    await AppSharedPrefs.get().setCauseOfFault("");
                    await AppSharedPrefs.get().setActionTaken("");
                    await AppSharedPrefs.get().setCompanyName("");
                    await AppSharedPrefs.get().setAfterImagePath("");
                    await AppSharedPrefs.get().setSignImagePath("");
                    await AppSharedPrefs.get().setEstmatedAmount("");
                    await AppSharedPrefs.get().setEstdTimeOfCompletion("");
                    await AppSharedPrefs.get().setClientSignImagePath("");
                  } else if (state is SubmitUploadFailure) {
                    setState(() {
                      isSubmitting = false;
                    });
                    Utils.showInSnackBar(
                        context, state.error!, ToastType.Error);
                    print(state.error);
                  }
                },
                child: SingleChildScrollView(
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
                                border:
                                    Border.all(color: Colors.blue, width: 1),
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
                                  colors: [customColor2, customColor1],
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
                                  CaseIDName,
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
                      /* Status checkbox  */
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
                      /*  Status checkbox end here */
                      SizedBox(width: 20),
                      /* Estimated Amount */
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        // Adjust the horizontal padding as needed
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 57,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [customColor2, customColor1],
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
                                'Estimated \n Amount :',
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
                                child: TextField(
                                  controller: textEstimatedAmountController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: '',
                                    // Remove underline by setting border to InputBorder.none
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /* Estd Time of Completion (Hrs) */
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
                                  colors: [customColor2, customColor1],
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
                                'Estd Time of\n Completion (Hrs) :',
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
                                child: TextField(
                                  controller: textEstimatedTimeController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: '',
                                    // Remove underline by setting border to InputBorder.none
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /* Vendor */

                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        // Adjust the horizontal padding as needed
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 57,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [customColor2, customColor1],
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
                                'Vendor :',
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
                                child: TextField(
                                  controller: textVendorController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: '',
                                    // Remove underline by setting border to InputBorder.none
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                          ],
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
                      // Follow Up Action Required End

                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
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
                                        'Name',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(height: 10.0),
                                      Container(
                                        height: 55,
                                        margin: EdgeInsets.only(left: 10),
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
                                          UserName,
                                          style: TextStyle(color: Colors.black),
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
                                          /*   if(_techSignPath!.isEmpty){
                                    signType = "Tech";
                                    SignatureDialog.showSignatureDialog(context, _bloc);
                                  }
                                  else {
                                    print("is_not_empty");
                                    Utils.showInSnackBar(context, "Signature already taken", ToastType.Warning);
                                  }*/
                                          signType = "Tech";
                                          SignatureDialog.showSignatureDialog(
                                              context, _bloc);
                                          // Handle the click event here
                                          print('Container clicked!');
                                          // Add your custom logic or navigate to another screen
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 5.0),
                                          width: 150.0,
                                          height: 130.0,
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
                                                image: _techSignPath != null &&
                                                        _techSignPath!
                                                            .isNotEmpty
                                                    ? NetworkImage(
                                                            _techSignPath!)
                                                        as ImageProvider<Object>
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Designation',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(height: 10.0),
                                      Container(
                                        height: 55,
                                        margin: EdgeInsets.only(left: 10),
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
                                          UserRole,
                                          style: TextStyle(color: Colors.black),
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
                                          /*if(_cilentSignPath!.isEmpty){
                                    signType = "Client";
                                    SignatureDialog.showSignatureDialog(context, _bloc);
                                  }
                                  else {
                                    print("is_not_empty");
                                    Utils.showInSnackBar(context, "Signature already taken", ToastType.Warning);
                                  }*/
                                          if (status_action == 0) {
                                            Utils.showInSnackBar(
                                                context,
                                                "When the status is 'Pending,' client signing is disabled",
                                                ToastType.Warning);
                                          } else {
                                            signType = "Client";
                                            SignatureDialog.showSignatureDialog(
                                                context, _bloc);
                                            print('Container clicked!');
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 5.0),
                                          width: 150.0,
                                          height: 130.0,
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
                                                image: _cilentSignPath !=
                                                            null &&
                                                        _cilentSignPath!
                                                            .isNotEmpty
                                                    ? NetworkImage(
                                                            _cilentSignPath!)
                                                        as ImageProvider<Object>
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

                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await AppSharedPrefs.get().setEstmatedAmount(
                                    textEstimatedAmountController.text);
                                await AppSharedPrefs.get()
                                    .setEstdTimeOfCompletion(
                                        textEstimatedTimeController.text);
                                Navigator.pop(
                                  context,
                                );
                                // Handle button click
                              },
                              style: ElevatedButton.styleFrom(
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
                                    'Back',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30.0),
                            ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                try {
                                  if (_techSignPath != null && _techSignPath!.isNotEmpty) {
                                    if (status_action == 0 && followup_action_choose == 0) {
                                      Utils.showInSnackBar(
                                        context,
                                        "Please choose the followup action",
                                        ToastType.Error,
                                      );
                                    } else {
                                      setState(() {
                                        isSubmitting = true;
                                      });


                                      String EstdTimeofCompletion = textEstimatedTimeController.text;
                                      int EstdAmount = int.parse(textEstimatedAmountController.text);

                                      photo_list.add(Photo(
                                        beforePhoto: Before_Photo_Path,
                                        afterPhoto: After_Photo_Path,
                                      ));

                                      technicianInitiateRequestModel
                                        ..caseId = int.parse(CaseID)
                                        ..userId = int.parse(UserID)
                                        ..companyName = CompanyName
                                        ..nameOfPersonnel = UserName
                                        ..dateOfArrival = ArrivalDate
                                        ..timeOfArrival = ArrivalTime
                                        ..causeOfFault = CauseOfFault
                                        ..actionTaken = ActionTaken
                                        ..photoTaken = isPhotoTaken
                                        ..partsReplacement = isPartRelacement
                                        ..itemReplaced = "No"
                                        ..responseTime = 0
                                        ..downTime = 0
                                        ..status = status_action
                                        ..estTimeCompletion = EstdTimeofCompletion
                                        ..followUpAction = followup_action_choose
                                        ..quoteAmount = EstdAmount
                                        ..pendingItemReplaced = "No"
                                        ..pendingDateOfCompletion = ""
                                        ..pendingStartTime = ""
                                        ..pendingEndTime = ""
                                        ..pendingDownTime = 0
                                        ..userName = UserName
                                        ..userDesignation = UserRole
                                        ..userSignature = _techSignPath
                                        ..contractorName = CompanyName
                                        ..designation = UserRole
                                        ..signature = ""
                                        ..quoteRefNo = ""
                                        ..quoteDownTime = ""
                                        ..quoteDate = ""
                                        ..assetId = AssetID
                                        ..photo = photo_list
                                        ..vendor = textVendorController.text
                                        ..clientSignature = _cilentSignPath
                                        ..additionalSpace = additionalSpace;

                                      _bloc.add(SubmitClickEvent(technicianInitiateRequestModel));
                                    }
                                  } else {
                                    Utils.showInSnackBar(context, "Please tech sign", ToastType.Warning);
                                  }
                                } catch (e) {
                                  print(e.toString());
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSubmitting ? customColor1 : null,
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
                                  constraints: BoxConstraints(maxWidth: 150.0, minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                   'Submit',
                                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
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
    final SignatureController _controller1 =
        SignatureController(points: exportedPoints);

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

      Uint8List signedImageBytes =
          await addTextToImage(signatureImageBytes, timestamp1);
      File sign =
          await convertBytesToFile(signedImageBytes!, "Signature", timestamp);
      bloc.add(SignFileInProgressEvent(sign, "Signature"));
    }

    // File sign = await convertBytesToFile(signatureImageBytes! , "Signature" , timestamp);
    // bloc.add(SignFileInProgressEvent(sign , "Signature"));
    // Convert Uint8List to Image widget
    //  final Image signatureImageWidget = Image.memory(Uint8List.fromList(signatureImageBytes as List<int>));

    // Implement your logic to save or use the signature image bytes
    print('Signature image saved.');
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

  final String fullFileName = '$fileName.png'; // <- fix here

  final String filePath = '${appDocumentsDirectory.path}/$fullFileName';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Signature Dialog Example'),
        ),
        body: Center(
          child: MyButton(),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('Open Signature Dialog'),
    );
  }
}
