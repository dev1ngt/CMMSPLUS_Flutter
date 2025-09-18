import 'package:cmms/src/features/faultreport/fifthroom/model/request/room_request_model.dart';
import 'package:cmms/src/features/faultreport/fourthlocation/view/fourth_location.dart';
import 'package:cmms/src/features/faultreport/submit/model/fault_report_save_model_old.dart';
import 'package:cmms/src/features/faultreport/submit/view/summary_submit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../submit/model/fault_report_save_model.dart';
import '../../submit/model/upload_view_model.dart';
import '../bloc/fifth_room_bloc.dart';
import '../bloc/fifth_room_event.dart';
import '../bloc/fifth_room_state.dart';
import '../model/response/room_response_model.dart';

class FRFifthRoom extends StatelessWidget {
  const FRFifthRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return FRFifthRoomStf();
  }
}

class FRFifthRoomStf extends StatefulWidget {
  const FRFifthRoomStf({super.key});

  @override
  State<FRFifthRoomStf> createState() => _FRFifthRoom();
}

class _FRFifthRoom extends State<FRFifthRoomStf> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color
  UploadViewModel viewModel = UploadViewModel();
  String ProjectName = "", username = "", selected_type_name = "";
  late FRFifthRoomBloc frFifthRoomBloc;
  int propertyid = 0;
  int RequestID = 0;
  String Is_list1 = "0";
  String RequestID_str = "0";
  String searchText = ''; // State variable to store the entered text
  RoomRequestModel roomRequestModel = RoomRequestModel();
  String requestId = "0";

  @override
  void initState() {
    super.initState();

    try {
      if (context != null) {
        frFifthRoomBloc =
            FRFifthRoomBloc(RepositoryProvider.of<ApiService>(context));
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
    frFifthRoomBloc.close();
    super.dispose();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Handle no internet connection
      Utils.showInSnackBar(context, "No Internet Connection.", ToastType.Error);
    }
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
     // frFifthRoomBloc.add(FRFifthRoomFetchEvent(roomRequestModel));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args = ModalRoute.of(context)!.settings.arguments;
        if (args != null && args is String) {
          requestId = args;
          frFifthRoomBloc.add(FRFifthRoomFetchEvent(roomRequestModel, requestId));
        }
      });
    }
  }

  Future<void> fetchSharedData() async {
    username = await AppSharedPrefs.getUsername();
    Is_list1 = await AppSharedPrefs.getislist();
    RequestID_str = await AppSharedPrefs.getrequestid();
    print("RequestID_str" + RequestID_str);

    if (Is_list1.contains("1")) {
      FaultReportOldSaveModel faultReportSaveModel1 =
          viewModel.faultReportoldSaveModel;
      if (faultReportSaveModel1.typeName != null) {
        selected_type_name = faultReportSaveModel1.typeName!;
        propertyid = faultReportSaveModel1.propertyId!;
        roomRequestModel.propertyId = propertyid;
        RequestID = int.parse(RequestID_str);
        print("RequestID" + RequestID.toString());
        // RequestID = faultReportSaveModel1.id!;
        faultReportSaveModel1.id = RequestID;
      }
    } else {
      FaultReportSaveModel faultReportSaveModel =
          viewModel.faultReportSaveModel;
      if (faultReportSaveModel.typeName != null) {
        selected_type_name = faultReportSaveModel.typeName!;
        propertyid = faultReportSaveModel.propertyId!;
        roomRequestModel.propertyId = propertyid;
      }
    }

    setState(() {}); // Trigger a rebuild after fetching the username
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => frFifthRoomBloc,
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
                          "Select the room",
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
                        BlocBuilder<FRFifthRoomBloc, FRFifthRoomState>(
                          builder: (context, state) {
                            if (state is FRFifthRoomInitial) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is FRFifthRoomLoaded) {
                              // Display the items in a row format once the data is loaded

                              // Filter the items based on the entered text
                              List<Room> filteredItems = state.roomlist.rooms
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
                                          int room_id = item.id;

                                          if (Is_list1.contains("1")) {
                                            viewModel.updateFaultReportSaveModel51(room_id);
                                          } else {
                                            viewModel.updateFaultReportSaveModel5(room_id);
                                          }

                                          Navigator.pushNamed(context, "/faultReportSummary",
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
                                            children: [
                                              SizedBox(width: 4),
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
                            } else if (state is FRFifthRoomError) {
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
