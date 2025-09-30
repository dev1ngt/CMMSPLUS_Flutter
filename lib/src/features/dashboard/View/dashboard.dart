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
    setState(() {});
  }

  Future<void> fetchUserID() async {
    userid = await AppSharedPrefs.getUserID();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("This is Android");
      loggerData.model_name = androidInfo.model + " - " + androidInfo.brand;
    } else if (Platform.isIOS) {
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
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dashboardBloc,
      child: WillPopScope(
        onWillPop: () async {
          print("back");
          return false;
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is DashboardLoadedState) {
                if (state.screenMappingMobile.fromWebLogout == 1) {
                  // webCheckout();
                }
                notificationCount = state.screenMappingMobile.notificationCount;
              } else if (state is LogoutSuccessState) {
                if (state.logoutResponseModel.status == 'success') {
                  Utils.showInSnackBar(context,
                      state.logoutResponseModel.message, ToastType.Success);

                  AppSharedPrefs.get().setUsername("");

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } else if (state is LogoutErrorState) {
                Utils.showInSnackBar(
                    context, state.errorMessage, ToastType.Warning);
              }
            },
            child: Stack(
              children: [
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoadedState) {
                      loggerData.action_data =
                          state.screenMappingMobile.toString();

                      return Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              _loadDashboardData();
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  // Welcome Section
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0A2647),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Welcome back,',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              username,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    notificationCount.toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                if (notificationCount > 0)
                                                  Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Card(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(8.0),
                                                        ),
                                                        elevation: 4.0,
                                                        child: Container(
                                                          padding:
                                                          EdgeInsets.all(
                                                              16.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                'Confirmation',
                                                                style:
                                                                TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 8.0),
                                                              Text(
                                                                'Do you want to exit?',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16.0),
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                              ),
                                                              SizedBox(
                                                                  height: 16.0),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                          context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'No'),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                      16.0),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      dashboardBloc
                                                                          .add(
                                                                          LogoutEvent());
                                                                    },
                                                                    child: Text(
                                                                        'Yes'),
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
                                              child: Icon(
                                                Icons.menu,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Statistics Section
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            'Active Tasks',
                                            '24',
                                            Colors.blue,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Completed Today',
                                            '8',
                                            Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Overdue',
                                            '3',
                                            Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Quick Actions
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Quick Actions',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  // Action Cards Grid
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 1.5,
                                      ),
                                      itemCount: state.screenMappingMobile
                                          .screenMappingMobile.length,
                                      itemBuilder: (context, index) {
                                        return DashboardItem(
                                          state.screenMappingMobile
                                              .screenMappingMobile[index],
                                          loggerBloc,
                                          loggerData,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),

                          if (state.isLoggingOut)
                            Container(
                              color: Colors.black.withOpacity(0.4),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      );
                    } else if (state is DashboardErrorState) {
                      return Center(
                          child: Text('Error: ${state.errorMessage}'));
                    } else {
                      return Center(child: Text('Unknown state'));
                    }
                  },
                ),
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

  Widget _buildStatCard(String label, String value, Color borderColor) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> isPushNotificationEnabled() async {
  NotificationSettings settings =
  await FirebaseMessaging.instance.getNotificationSettings();
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}

class DashboardItem extends StatelessWidget {
  final ScreenMappingMobile item;
  LoggerBloc loggerBloc;
  LoggerInput loggerInput;
  DashboardItem(this.item, this.loggerBloc, this.loggerInput);

  IconData getIconData(int menuID) {
    switch (menuID) {
      case 3:
        return Icons.pending_actions;
      case 4:
        return Icons.pending;
      case 8:
        return Icons.check_circle_outline;
      case 9:
        return Icons.qr_code_scanner;
      case 10:
        return Icons.description_outlined;
      case 11:
        return Icons.qr_code_scanner;
      case 15:
        return Icons.edit_note;
      case 12:
        return Icons.assignment;
      case 17:
        return Icons.report_problem_outlined;
      default:
        return Icons.dashboard;
    }
  }

  Color getIconColor(int menuID) {
    switch (menuID) {
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      case 8:
        return Colors.grey;
      case 9:
        return Colors.purple;
      case 10:
        return Colors.pink;
      case 11:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String getSubtitle(int menuID, int count) {
    if (item.features == "Fault Report") {
      return "Create Report";
    } else if (item.features == "Attendance") {
      return "Quick Access";
    } else if (item.features.contains("Scan QR")) {
      return "Quick Access";
    } else if (item.features.contains("PPM")) {
      return "Maintenance";
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          try {
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
              Navigator.pushNamed(context, '/requestList');
            } else if (item.menuID == 14) {
              print("Request List");
              Navigator.pushNamed(context, '/allRequestList');
            } else if (item.menuID == 15) {
              print("Attendance");
              Navigator.pushNamed(context, '/checkIn');
            } else if (item.menuID == 12) {
              print("Attendance");
              Navigator.pushNamed(context, '/adhocScreen');
            } else if (item.menuID == 17) {
              print("My fault Report");
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon and menu name on same line
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: getIconColor(item.menuID).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      getIconData(item.menuID),
                      color: getIconColor(item.menuID),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.features,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Count/subtitle below
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  getSubtitle(item.menuID, item.count),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}