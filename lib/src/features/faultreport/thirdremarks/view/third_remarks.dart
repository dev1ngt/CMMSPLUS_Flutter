import 'package:cmms/src/features/faultreport/fourthlocation/view/fourth_location.dart';
import 'package:cmms/src/features/faultreport/secondpriority/view/second_priority.dart';
import 'package:cmms/src/features/faultreport/submit/model/fault_report_save_model_old.dart';
import 'package:cmms/src/features/faultreport/thirdremarks/bloc/remarks_event.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../firstmenu/view/first_menu.dart';
import '../../submit/model/fault_report_save_model.dart';
import '../../submit/model/upload_view_model.dart';
import '../bloc/remarks_bloc.dart';
import '../bloc/remarks_state.dart';

class FRThirdRemarks extends StatelessWidget {
  const FRThirdRemarks({super.key});

  @override
  Widget build(BuildContext context) {
    return FRThirdRemarksStf();
  }
}

class FRThirdRemarksStf extends StatefulWidget {
  const FRThirdRemarksStf({super.key});

  @override
  State<FRThirdRemarksStf> createState() => _FRThirdRemarksStf();
}

class _FRThirdRemarksStf extends State<FRThirdRemarksStf> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color
  UploadViewModel viewModel = UploadViewModel();
  String ProjectName = "",
      username = "",
      selected_type_name = "",
      description = "";
  String Is_list1 = "0";
  String desc = "0";
  TextEditingController _remarksController = TextEditingController();
  late RemarksBloc remarksBloc;
  String requestId = "0";

  String searchText = ''; // State variable to store the entered text

  @override
  void initState() {
    super.initState();

    try {
      if (context != null) {
        remarksBloc = RemarksBloc(RepositoryProvider.of<ApiService>(context))
          ..add(RemarkLoadEvent());
      }
      //print('TypeName: ${faultReportSaveModel.typeName}');
      fetchSharedData();
    } on Exception catch (e) {
      // TODO
    }
  }

  Future<void> fetchSharedData() async {
    username = await AppSharedPrefs.getUsername();
    Is_list1 = await AppSharedPrefs.getislist();
    desc = await AppSharedPrefs.getdesc();
    // desc = "hello";

    print("desc" + desc);

    if (Is_list1.contains("1")) {
      FaultReportOldSaveModel faultReportSaveModel1 =
          viewModel.faultReportoldSaveModel;
      if (faultReportSaveModel1.typeName != null) {
        selected_type_name = faultReportSaveModel1.typeName!;
        if (faultReportSaveModel1.description != null) {
          description = faultReportSaveModel1.description!;
          _remarksController.text = description;
        }
      }
    } else {
      FaultReportSaveModel faultReportSaveModel =
          viewModel.faultReportSaveModel;
      if (faultReportSaveModel.typeName != null) {
        selected_type_name = faultReportSaveModel.typeName!;
        if (faultReportSaveModel.description != null) {
          description = faultReportSaveModel.description!;
          _remarksController.text = description;
        }
      }
    }
    _remarksController.text = desc;

    setState(() {}); // Trigger a rebuild after fetching the username
  }

  @override
  Widget build(BuildContext context) {

    requestId = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (context) => remarksBloc,
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
                    customColor2,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body: BlocListener<RemarksBloc, RemarksState>(
            listener: (context, state) async {
              if (state is BlocButtonClickedState) {
                print("Great");
                Navigator.pushNamed(context, "/faultReportLocation",
                  arguments: requestId,
                );
              }
            },
            child: BlocBuilder<RemarksBloc, RemarksState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Other widgets...

                          Container(
                            height: 70,
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFCBD4F4), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .manage_accounts_outlined, // Change the icon as needed
                                  color: Colors.black, // Set the icon color
                                ),
                                SizedBox(
                                    width:
                                    8), // Adjust the spacing between icon and text
                                Expanded(
                                  child: Text(
                                    username +
                                        ' I can assist you with submitting a  new ' +
                                        selected_type_name +
                                        ' work request',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            height: 90,
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFCBD4F4), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .manage_accounts_outlined, // Change the icon as needed
                                  color: Colors.black, // Set the icon color
                                ),
                                SizedBox(
                                    width:
                                    8), // Adjust the spacing between icon and text
                                Expanded(
                                  child: Text(
                                    "Can you tell me us a little bit about your request so we can bring the right tool for the job",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // Dynamic list of chips with delete option
                          Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(6),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchText = value
                                            .toLowerCase(); // Convert to lowercase for case-insensitive search
                                      });
                                    },
                                    controller: _remarksController,
                                    maxLines: null,
                                    maxLength: 2000,
                                    maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 70.0),
                                      // Add the search icon here
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
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                      10.0), // Adjust the right padding as needed
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Add your button's onPressed logic here
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              customColor2,
                                              customColor1,
                                            ], // Replace with your gradient colors
                                          ),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 150.0, minHeight: 45.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Back',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                      10.0), // Adjust the right padding as needed
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Add your button's onPressed logic here
                                        String remarks = _remarksController.text;
                                        if (remarks.isEmpty) {
                                          Utils.showInSnackBar(
                                              context,
                                              "Please enter the description.",
                                              ToastType.Warning);
                                        } else {
                                          if (Is_list1.contains("1")) {
                                            viewModel.updateFaultReportSaveModel31(
                                                remarks);
                                          } else {
                                            viewModel.updateFaultReportSaveModel3(
                                                remarks);
                                          }

                                          print('ok');
                                          remarksBloc.add(NextClickEvent());
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              customColor2,
                                              customColor1,
                                            ], // Replace with your gradient colors
                                          ),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 150.0, minHeight: 45.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
