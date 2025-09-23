import 'dart:io' show Platform;
import 'package:cmms/src/constants/app_sizes.dart';
import 'package:cmms/src/features/checkin_out/bloc/location_event.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_service.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/utils.dart';
import '../../checkin_out/bloc/location_bloc.dart';
import '../../inprogress/list/view/inprogress_list.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../bloc/log/logger_bloc.dart';
import '../bloc/log/logger_event.dart';
import '../model/dasboard_count_model.dart';
import '../model/log/logger_model_response.dart';

class DashBoardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<DashboardBloc>(
          create: (context) =>
              DashboardBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<LoggerBloc>(
          create: (context) =>
              LoggerBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: DashBoard(),
    );
  }
}

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  GlobalKey _popupMenuKey = GlobalKey();
  String username = "";
  String userid = "";
  String contractCode = "";
  late DashboardBloc dashboardBloc;
  late LoggerBloc loggerBloc;
  int notificationCount = 0;
  LoggerInput loggerData = LoggerInput();

  @override
  void initState() {
    super.initState();
    dashboardBloc = DashboardBloc(RepositoryProvider.of<ApiService>(context));
    loggerBloc = LoggerBloc(RepositoryProvider.of<ApiService>(context));
    checkInternetAndFetchData();
    fetchUsername();
    fetchUserID();
  }

  @override
  void dispose() {
    dashboardBloc.close();
    loggerBloc.close();
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
      dashboardBloc.add(LoadDashboardEvent());
    }
  }

  Future<void> fetchUsername() async {
    contractCode = await AppSharedPrefs.getContractCode();
    username = await AppSharedPrefs.getUsername();
    setState(() {}); // Trigger a rebuild after fetching the username
  }

  Future<void> fetchUserID() async {
    userid = await AppSharedPrefs.getUserID();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      // Code specific to Android
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("This is Android");
      loggerData.model_name = androidInfo.model + " - " + androidInfo.brand;
    } else if (Platform.isIOS) {
      // Code specific to iOS
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      loggerData.model_name = iosInfo.model + " - " + iosInfo.name;
      print("This is iOS");
    }
    loggerData.user_id = int.parse(userid);
    loggerData.contract_code = contractCode;

    setState(() {});
  }

  Future<void> webCheckout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('checkinFlag', false);
    prefs.setString('checkInPropertyId', '');
    prefs.setString('checkInLat', '');
    prefs.setString('checkInLong', '');
    prefs.setString('checkInRadius', '');
    prefs.setString('checkInPunchId', '');
    prefs.setString('checkInAttendanceId', '');
  }

  Future<void> _loadDashboardData() async {
    print("Refreshing dashboard...");
    dashboardBloc.add(LoadDashboardEvent());
    await Future.delayed(Duration(seconds: 1)); // simulate network delay
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => dashboardBloc,
      child: WillPopScope(
        onWillPop: () async {
          // Handle back button press
          print("back");
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle the click event for the notification button
                    print("Notification");
                    Navigator.pushNamed(
                      context, "/notificationList",
                      // Add more parameters as needed
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 40,
                        color: Colors.black,
                      ),
                      Positioned(
                        top:
                        -1, // Adjust the top position to center the circle vertically
                        right:
                        -1, // Adjust the right position to center the circle horizontally
                        child: Container(
                          width:
                          23, // Increase the width to provide enough space for the circle
                          height:
                          23, // Increase the height to provide enough space for the circle
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Center(
                            child: BlocBuilder<DashboardBloc, DashboardState>(
                              builder: (context, state) {
                                if (state is DashboardLoadedState) {
                                  if (state.screenMappingMobile.resetPassword ==
                                      1) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.pushNamed(
                                          context, '/resetPassword');
                                    });
                                  }
                                  if (state.screenMappingMobile.forcedLogin ==
                                      1) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      AppSharedPrefs.get().setUsername("");
                                      Navigator.pushNamed(context, '/login');
                                    });
                                  }
                                  if (state.screenMappingMobile.fromWebLogout ==
                                      1) {
                                    webCheckout();
                                  }

                                  notificationCount = state
                                      .screenMappingMobile.notificationCount;
                                }
                                return Text(
                                  notificationCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    12, // Adjust the font size for better visibility
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                gapW48,
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/images/ecms_logo.png',
                      // replace with your image path
                      width: 100,
                      height: 40,
                    ),
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
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 4.0,
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Confirmation',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Do you want to exit?',
                                      style: TextStyle(fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16.0),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        SizedBox(width: 16.0),
                                        ElevatedButton(
                                          onPressed: () async {
                                            //Navigator.of(context).pop();
                                            dashboardBloc.add(LogoutEvent());
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      username,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  gapW12,
                  PopupMenuButton<String>(
                    key: _popupMenuKey,
                    onSelected: (String choice) {
                      if (choice == 'ChangePassword') {
                        print("change password");
                        Navigator.pushNamed(
                          context, "/forgotPassword",
                          // Add more parameters as needed
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'ChangePassword',
                          child: Text('Change Password'),
                        ),
                      ];
                    },
                  ),
                  gapW12,
                ],
              ),
            ],
          ),
          body: BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is DashboardLoadedState) {
                if (state.screenMappingMobile.fromWebLogout == 1) {
                  // webCheckout();
                }
                notificationCount = state.screenMappingMobile.notificationCount;
              } else if (state is LogoutSuccessState) {

                if(state.logoutResponseModel.status == 'success'){
                  Utils.showInSnackBar(
                      context,
                      state.logoutResponseModel.message,
                      ToastType.Success);

                  AppSharedPrefs.get().setUsername("");

                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }

              } else if (state is LogoutErrorState) {
                Utils.showInSnackBar(
                    context,
                    state.errorMessage,
                    ToastType.Warning);
              }
            },
            child: Stack(
              children: [
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoadedState) {
                      loggerData.action_data = state.screenMappingMobile.toString();

                      return Stack(
                        children: [
                          FutureBuilder<bool>(
                            future: isPushNotificationEnabled(),
                            builder: (context, snapshot) {
                              bool permissionGranted = snapshot.data ?? false;

                              Widget banner;

                              if (!permissionGranted) {
                                banner = _buildBanner(
                                  message: 'Notification permission is disabled. Tap to enable.',
                                  color: Colors.red[100]!,
                                  onTap: () {
                                    openAppSettings();
                                  },
                                );
                              } else {
                                int notificationStatus = state.screenMappingMobile.notificationStatus;
                                banner = _buildBanner(
                                  message: notificationStatus == 1
                                      ? 'Push notification is active.'
                                      : 'Push notification is inactive.',
                                  color: notificationStatus == 1 ? Colors.green[300]! : Colors.red[100]!,
                                );
                              }

                              return Container(
                                color: Colors.white,
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                                child: Column(
                                  children: [
                                    banner,
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          _loadDashboardData();
                                        },
                                        child: GridView.builder(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                          ),
                                          itemCount: state.screenMappingMobile.screenMappingMobile.length,
                                          itemBuilder: (context, index) {
                                            return DashboardItem(
                                              state.screenMappingMobile.screenMappingMobile[index],
                                              loggerBloc,
                                              loggerData,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // Show logout loader if needed
                          if (state.isLoggingOut)
                            Container(
                              color: Colors.black.withOpacity(0.4),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      );
                    }
                    else if (state is DashboardErrorState) {
                      return Center(child: Text('Error: ${state.errorMessage}'));
                    } else {
                      return Center(child: Text('Unknown state'));
                    }
                  },
                ),

                // Show loading overlay during logout
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is LogoutLoadingState) {
                      return Container(
                        color: Colors.black.withOpacity(0.4),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),


        ),
      ),
    );
  }
}


Future<bool> isPushNotificationEnabled() async {
  NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}


Widget _buildBanner({required String message, required Color color, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}


class DashboardItem extends StatelessWidget {
  final ScreenMappingMobile item;
  LoggerBloc loggerBloc;
  LoggerInput loggerInput;
  DashboardItem(this.item, this.loggerBloc, this.loggerInput);

  String getIconAssetPath(int menuID) {
    switch (menuID) {
      case 3:
        return 'assets/images/pendingresponse.png';
      case 4:
        return 'assets/images/inprogress.png';
      case 8:
        return 'assets/images/closed.png';
      case 9:
        return 'assets/images/qrscan.png';
      case 10:
        return 'assets/images/ppm.png';
      case 11:
        return 'assets/images/qrscan.png';
    // Add more cases as needed for other menu IDs
      default:
        return 'assets/images/inprogress.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          // Handle item click

          try {
            // Log API call when the card is clicked
            loggerInput.action_field = item.menuID.toString();
            loggerInput.error_field = "no error";
            loggerBloc.add(LoadLoggerEvent(loggerInput));

            print("great work");
            print(item.menuID);
            if (item.menuID == 3) {
              await AppSharedPrefs.get()
                  .setIsPendingListEdit(item.isEdit.toString());
              Navigator.pushNamed(context, '/pendingList');
            } else if (item.menuID == 4) {
              await AppSharedPrefs.get()
                  .setIsinProgresslistEdit(item.isEdit.toString());
              print("In Progress");
              Navigator.pushNamed(context, '/inprogressList');
            } else if (item.menuID == 8) {
              print("Closed ");
              Navigator.pushNamed(context, '/closedList');
            } else if (item.menuID == 9) {
              Navigator.pushNamed(context, '/qrScan', arguments: {
                'Types': 'Dashboard',
              });
              print("QR Scan");
            } else if (item.menuID == 10) {
              print("PPM");
              Navigator.pushNamed(context, '/ppmList');
            } else if (item.menuID == 11) {
              print("Fault Report");
              Navigator.pushNamed(context, '/faultReportMenu');
            } else if (item.menuID == 13) {
              print("Request List");
              /* Label changes as per request - RequestList to Assigned to me */
              Navigator.pushNamed(context, '/requestList');
            } else if (item.menuID == 14) {
              print("Request List");
              /*New All menu */
              Navigator.pushNamed(context, '/allRequestList');
            } else if (item.menuID == 15) {
              print("Attendance");
              /*New All menu */
              Navigator.pushNamed(context, '/checkIn');
            } else if (item.menuID == 12) {
              print("Attendance");
              /*New All menu */
              Navigator.pushNamed(context, '/adhocScreen');
            } else if (item.menuID == 17) {
              print("My fault Report");
              /*New All menu */
              Navigator.pushNamed(context, '/myfaultreport');
            } else {
              Utils.showInSnackBar(
                context,
                "Invalid menu, kindle contact the admin",
                ToastType.Error,
              );
            }
          } catch (e) {
            print("An error occurred: $e");

            loggerInput.action_field = item.menuID.toString();
            loggerInput.error_field = e.toString();
            loggerBloc.add(LoadLoggerEvent(loggerInput));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  getIconAssetPath(item.menuID),
                  width: 67,
                  height: 67,
                ),
                if (item.features != "Fault Report" &&
                    item.features != "Attendance")
                  Positioned(
                    top: -1,
                    right: 1,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.3,
                        ),
                      ),
                      child: Text(
                        "${item.count}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(item.features),
          ],
        ),
      ),
    );
  }
}
