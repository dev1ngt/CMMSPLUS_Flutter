import 'dart:typed_data';

import 'package:cmms/src/features/faultreport/submit/model/fault_report_save_model_old.dart';
import 'package:cmms/src/features/faultreport/thirdremarks/view/third_remarks.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../firstmenu/view/first_menu.dart';
import '../../submit/model/fault_report_save_model.dart';
import '../../submit/model/upload_view_model.dart';
import '../bloc/second_priority_bloc.dart';
import '../bloc/second_priority_event.dart';
import '../bloc/second_priority_state.dart';
import '../model/priority_response.dart';

class FRSecondPriority extends StatelessWidget {
  const FRSecondPriority({super.key});

  @override
  Widget build(BuildContext context) {
    return FRASecondPriorityStf();
  }
}

class FRASecondPriorityStf extends StatefulWidget {
  const FRASecondPriorityStf({super.key});

  @override
  State<FRASecondPriorityStf> createState() => _FRSecondPriorityStf();
}

class _FRSecondPriorityStf extends State<FRASecondPriorityStf> {


  UploadViewModel viewModel = UploadViewModel();
  String ProjectName = "", username = "", selected_type_name = "";
  late FRSecondPriorityBloc frSecondPriorityBloc;
  String Is_list1 = "0";
  String searchText = ''; // State variable to store the entered text

  @override
  void initState() {
    super.initState();

    try {
      if (context != null) {
        frSecondPriorityBloc =
            FRSecondPriorityBloc(RepositoryProvider.of<ApiService>(context));
      }

      fetchSharedData();

      checkInternetAndFetchData();
      checkInternetConnection();
    } on Exception catch (e) {
      // TODO
    }
  }

  @override
  void dispose() {
    frSecondPriorityBloc.close();
    super.dispose();
  }

  Future<void> checkInternetAndFetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Utils.showInSnackBar(
        context,
        "No internet connection.",
        ToastType.Error,
      );
    } else {
      frSecondPriorityBloc.add(FRSecondPriorityFetchEvent());
    }
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Handle no internet connection
      Utils.showInSnackBar(context, "No Internet Connection.", ToastType.Error);
    }
  }

  Future<void> fetchSharedData() async {
    username = await AppSharedPrefs.getUsername();
    Is_list1 = await AppSharedPrefs.getislist();

    if (Is_list1.contains("1")) {
      FaultReportOldSaveModel faultReportSaveModel1 =
          viewModel.faultReportoldSaveModel;
      if (faultReportSaveModel1.typeName != null) {
        selected_type_name = faultReportSaveModel1.typeName!;
      }
    } else {
      FaultReportSaveModel faultReportSaveModel =
          viewModel.faultReportSaveModel;
      if (faultReportSaveModel.typeName != null) {
        selected_type_name = faultReportSaveModel.typeName!;
      }
    }

    setState(() {}); // Trigger a rebuild after fetching the username
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => frSecondPriorityBloc,
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
                  Navigator.pushNamed(
                      context, '/dashboard'); // Example: Navigate to home page
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Other widgets...

                Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFCBD4F4), width: 2),
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
                          width: 8), // Adjust the spacing between icon and text
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
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFCBD4F4), width: 2),
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
                          width: 8), // Adjust the spacing between icon and text
                      Expanded(
                        child: Text(
                          "Select the closest item that represents your request",
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
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            hintText: 'Search',
                            prefixIcon:
                            Icon(Icons.search), // Add the search icon here
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
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // Use BlocBuilder to handle Bloc states
                        BlocBuilder<FRSecondPriorityBloc,
                            FRSecondPriorityState>(
                          builder: (context, state) {
                            if (state is FRSecondPriorityInitial) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is FRSecondPriorityLoaded) {
                              // Display the items in a row format once the data is loaded

                              // Filter the items based on the entered text
                              List<Priority> filteredItems = state
                                  .prioritylist.priorities
                                  .where((item) => item.name
                                  .toLowerCase()
                                  .startsWith(searchText))
                                  .toList();

                              return Container(
                                height:
                                350, // Set a fixed height or use constraints child: ListView.builder(
                                child: ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    // Ensure the index is within the valid range
                                    return InkWell(
                                      onTap: () {
                                        try {
                                          // String type_name = filteredItems[index].name;
                                          int priority_id =
                                              filteredItems[index].id;
                                          if (Is_list1.contains("1")) {
                                            viewModel
                                                .updateFaultReportSaveModel21(
                                                priority_id.toString());
                                          } else {
                                            viewModel
                                                .updateFaultReportSaveModel2(
                                                priority_id.toString());
                                          }

                                          Navigator.pushNamed(
                                              context, '/faultReportRemarks');
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation:
                                        2, // Adjust the elevation as needed

                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(width: 4),
                                              Text(filteredItems[index].name),
                                              Spacer(), // Add Spacer widget to push the icon to the right
                                              Icon(Icons.arrow_forward_ios),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (state is FRSecondPriorityError) {
                              return Center(
                                child: Text('Error loading data'),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: EdgeInsets.only(
                      right: 10.0), // Adjust the right padding as needed
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
                              AppColors.customColor2,
                              AppColors.customColor1,
                            ], // Replace with your gradient colors
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          constraints:
                          BoxConstraints(maxWidth: 150.0, minHeight: 45.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Back',
                            style:
                            TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
