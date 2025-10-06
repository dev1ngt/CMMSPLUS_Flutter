import 'package:cmms/src/features/faultreport/fifthroom/view/fifth_room.dart';
import 'package:cmms/src/features/faultreport/fourthlocation/model/location_response.dart';
import 'package:cmms/src/features/faultreport/submit/model/fault_report_save_model_old.dart';
import 'package:cmms/src/features/faultreport/thirdremarks/view/third_remarks.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../submit/model/fault_report_save_model.dart';
import '../../submit/model/upload_view_model.dart';
import '../bloc/fourth_location_bloc.dart';
import '../bloc/fourth_location_event.dart';
import '../bloc/fourth_location_state.dart';

class FRFourthLocation extends StatelessWidget {
  const FRFourthLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return FRFourthLocationStf();
  }
}

class FRFourthLocationStf extends StatefulWidget {
  const FRFourthLocationStf({super.key});

  @override
  State<FRFourthLocationStf> createState() => _FRFourthLocation();
}

class _FRFourthLocation extends State<FRFourthLocationStf> {

  UploadViewModel viewModel = UploadViewModel();
  String ProjectName = "", username = "", selected_type_name = "";
  late FRFourthLocationBloc frFourthLocationBloc;
  String Is_list1 = "0";
  String requestId = "0";
  String searchText = ''; // State variable to store the entered text

  @override
  void initState() {
    super.initState();

    try {
      if (context != null) {
        frFourthLocationBloc =
            FRFourthLocationBloc(RepositoryProvider.of<ApiService>(context));
      }

      FaultReportSaveModel faultReportSaveModel =
          viewModel.faultReportSaveModel;
      if (faultReportSaveModel.typeName != null) {
        selected_type_name = faultReportSaveModel.typeName!;
      }
      FaultReportOldSaveModel faultReportSaveModel1 =
          viewModel.faultReportoldSaveModel;
      if (faultReportSaveModel1.typeName != null) {
        selected_type_name = faultReportSaveModel1.typeName!;
      }
      checkInternetAndFetchData();
      fetchSharedData();
      checkInternetConnection();
    } on Exception catch (e) {
      // TODO
    }
  }

  @override
  void dispose() {
    frFourthLocationBloc.close();
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
      //frFourthLocationBloc.add(FRFourthLocationFetchEvent());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args = ModalRoute.of(context)!.settings.arguments;
        if (args != null && args is String) {
          requestId = args;
          frFourthLocationBloc.add(FRFourthLocationFetchEvent(requestId));
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
    setState(() {}); // Trigger a rebuild after fetching the username
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => frFourthLocationBloc,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
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
             /* Spacer(),
              Image.asset(
                'assets/images/ecms_logo.png',
                width: 100,
                height: 20,
              ),*/
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
                          "Search for a location",
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
                        BlocBuilder<FRFourthLocationBloc,
                            FRFourthLocationState>(
                          builder: (context, state) {
                            if (state is FRFourthLocationInitial) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is FRFourthLocationLoaded) {
                              // Display the items in a row format once the data is loaded

                              // Filter the items based on the entered text
                              List<Location> filteredItems = state
                                  .locationlist.locations
                                  .where((item) => item.propertyName
                                  .toLowerCase()
                                  .startsWith(searchText))
                                  .toList();

                              return Container(
                                height:
                                350, // Set a fixed height or use constraints child: ListView.builder(
                                child: ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final property = filteredItems[index];

                                    final isSelected = property.isSelected == 1;

                                    return InkWell(
                                      onTap: () {
                                        try {
                                          int property_id = property.id;
                                          String property_name = property.propertyName;

                                          if (Is_list1.contains("1")) {
                                            viewModel.updateFaultReportSaveModel41(property_id, property_name);
                                          } else {
                                            viewModel.updateFaultReportSaveModel4(property_id, property_name);
                                          }

                                          Navigator.pushNamed(context, "/faultReportRoom",
                                            arguments: requestId,
                                          );
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Card(
                                        color: isSelected ? Color(0xFFCBD4F4) : Colors.white,
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  property.propertyName,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                    color: isSelected ? Colors.blue.shade800 : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
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
                            } else if (state is FRFourthLocationError) {
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
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.circular(20.0), // ✅ apply corner here
                        ),
                        child: Container(
                          constraints:
                          BoxConstraints(maxWidth: 150.0, minHeight: 45.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Back',
                            style:
                            TextStyle(fontSize: 14.0, color: Colors.white),
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
