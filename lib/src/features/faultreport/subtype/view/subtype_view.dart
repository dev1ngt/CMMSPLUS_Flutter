import 'package:cmms/src/features/faultreport/firstmenu/view/first_menu.dart';
import 'package:cmms/src/features/faultreport/submit/model/fault_report_save_model_old.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../firstmenu/bloc/first_menu_bloc.dart';
import '../../firstmenu/bloc/first_menu_event.dart';
import '../../firstmenu/bloc/first_menu_state.dart';
import '../../firstmenu/model/request_type.dart';
import '../../secondpriority/view/second_priority.dart';
import '../../submit/model/fault_report_save_model.dart';
import '../../submit/model/upload_view_model.dart';
import '../bloc/subtype_bloc.dart';
import '../bloc/subtype_event.dart';
import '../bloc/subtype_state.dart';
import '../model/request/subtype_request_model.dart';
import '../model/response/subtype_response_model.dart';

class SubtypeView extends StatelessWidget {
  const SubtypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SubtypeViewStf();
  }
}

class SubtypeViewStf extends StatefulWidget {
  const SubtypeViewStf({super.key});

  @override
  State<SubtypeViewStf> createState() => _SubtypeViewStf();
}

class _SubtypeViewStf extends State<SubtypeViewStf> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color

  String ProjectName = "", username = "";
  late SubtypeBloc subtypeBloc;
  UploadViewModel viewModel = UploadViewModel();
  String searchText = ''; // State variable to store the entered text
  SubtypeRequestModel subtypeRequestModel = SubtypeRequestModel();
  String Is_list1 = "0";
  String requestId = "0";

  @override
  void initState() {
    // TODO: implement initState

    print("__ma" + Is_list1);

    subtypeBloc = SubtypeBloc(RepositoryProvider.of<ApiService>(context));
    checkInternetAndFetchData();
    super.initState();
    fetchSharedData();
    checkInternetConnection();
  }

  @override
  void dispose() {
    subtypeBloc.close();
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
   //   subtypeBloc.add(SubtypeFetchEvent(subtypeRequestModel));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args = ModalRoute.of(context)!.settings.arguments;
        if (args != null && args is String) {
          requestId = args;
          subtypeBloc.add(SubtypeFetchEvent(subtypeRequestModel, requestId));
        }
      });
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
    print("1__ma" + Is_list1);
    if (Is_list1.contains("1")) {
      FaultReportOldSaveModel faultReportSaveModel1 =
          viewModel.faultReportoldSaveModel;
      if (faultReportSaveModel1.typeName != null) {
        subtypeRequestModel.typeID = faultReportSaveModel1.type;
      }
    } else {
      FaultReportSaveModel faultReportSaveModel =
          viewModel.faultReportSaveModel;
      if (faultReportSaveModel.typeName != null) {
        subtypeRequestModel.typeID = faultReportSaveModel.type;
      }
    }
    setState(() {}); // Trigger a rebuild after fetching the username
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => subtypeBloc,
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
                              ' I can assist you with submitting a  new  others  work request',
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
                          "What subtype of request would you like  to submit",
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
                        BlocBuilder<SubtypeBloc, SubtypeState>(
                          builder: (context, state) {
                            if (state is SubtypeInitial) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is SubtypeLoaded) {
                              // Display the items in a row format once the data is loaded

                              // Filter the items based on the entered text
                              List<SubtypeData> filteredItems = state
                                  .subtypeResponseModel.data
                                  .where((item) => item.text
                                  .toLowerCase()
                                  .startsWith(searchText))
                                  .toList();

                              return Container(
                                height:
                                350, // Set a fixed height or use constraints child: ListView.builder(
                                child: ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredItems[index];

                                    final isSelected = item.isSelected == 1;

                                    return InkWell(
                                      onTap: () {
                                        try {

                                          if (Is_list1.contains("1")) {
                                            viewModel.updateFaultReportSaveModelSubType1(
                                              item.id,
                                              item.text,
                                            );
                                          } else {
                                            viewModel.updateFaultReportSaveModelSubType(
                                              item.id,
                                              item.text,
                                            );
                                          }

                                          Navigator.pushNamed(
                                              context, '/faultReportRemarks',
                                            arguments: requestId,
                                          );
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Card(
                                        color: isSelected ? Color(0xFFCBD4F4) : Colors.white, // Highlight color
                                        elevation: isSelected ? 4 : 2,
                                        shape: RoundedRectangleBorder(
                                          side: isSelected
                                              ? BorderSide(color: Colors.blue, width: 1.5)
                                              : BorderSide.none,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.text,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                    color: isSelected ? Colors.blue.shade800 : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 16,
                                                color: isSelected ? Colors.blue.shade800 : Colors.black45,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )

                              );
                            } else if (state is FRFirstMenuError) {
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
                              customColor2,
                              customColor1,
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
