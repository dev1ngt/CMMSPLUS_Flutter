import 'dart:developer';

import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/api/firebase_api.dart';
import 'package:cmms/src/features/myfaultreport/list/view/my_fault_request_list.dart';

import 'package:cmms/src/features/adhocinspection/view/add_new/view/adhoc_add_new_view.dart';
import 'package:cmms/src/features/adhocinspection/view/adhoc_inspection.dart';
import 'package:cmms/src/features/adhocinspection/view/adhoc_list.dart';
import 'package:cmms/src/features/all_requestlist/list/view/all_request_list.dart';
import 'package:cmms/src/features/all_requestlist/view/view/all_request_list_view.dart';
import 'package:cmms/src/features/checkin_out/bloc/location_bloc.dart';
import 'package:cmms/src/features/checkin_out/bloc/location_event.dart';
import 'package:cmms/src/features/checkin_out/bloc/location_state.dart';
import 'package:cmms/src/features/checkin_out/view/checkin.dart';
import 'package:cmms/src/features/checkin_out/view/display_checkin.dart';
import 'package:cmms/src/features/checkin_out/view/get_lat_long.dart';
import 'package:cmms/src/features/checkin_out/view/report.dart';
import 'package:cmms/src/features/closed/list/view/closed_list.dart';
import 'package:cmms/src/features/closed/view/view/closed_details.dart';
import 'package:cmms/src/features/contract/view/contractcode.dart';
import 'package:cmms/src/features/dashboard/View/dashboard.dart';
import 'package:cmms/src/features/faultreport/allmenu/view/all_menu.dart';
import 'package:cmms/src/features/faultreport/fifthroom/view/fifth_room.dart';
import 'package:cmms/src/features/faultreport/firstmenu/view/first_menu.dart';
import 'package:cmms/src/features/faultreport/fourthlocation/view/fourth_location.dart';
import 'package:cmms/src/features/faultreport/secondpriority/view/second_priority.dart';
import 'package:cmms/src/features/faultreport/submit/view/summary_submit.dart';
import 'package:cmms/src/features/faultreport/subtype/view/subtype_view.dart';
import 'package:cmms/src/features/faultreport/thirdremarks/view/third_remarks.dart';
import 'package:cmms/src/features/forgotpassword/view/forgotpassword.dart';
import 'package:cmms/src/features/inprogress/list/view/inprogress_list.dart';
import 'package:cmms/src/features/inprogress/view/view/inprogress_details.dart';

import 'package:cmms/src/features/login/View/login.dart';
import 'package:cmms/src/features/myfaultreport/view/view/my_fault_view.dart';
import 'package:cmms/src/features/notification/view/notification_list.dart';
import 'package:cmms/src/features/ppm/closed/view/ppm_closed_details.dart';
import 'package:cmms/src/features/ppm/completed/view/ppm_completed_details.dart';
import 'package:cmms/src/features/ppm/view/view/ppm_details.dart';
import 'package:cmms/src/features/publicwebview/view/publicwebview.dart';
import 'package:cmms/src/features/qrscn/view/qrcode_scan.dart';
import 'package:cmms/src/features/pendingresponsedetails/view/pendingdetails.dart';
import 'package:cmms/src/features/pendingresponsedetails/view/pendingdetails2.dart';
import 'package:cmms/src/features/ppm/list/view/ppm_list.dart';
import 'package:cmms/src/features/request/list/view/request_list.dart';
import 'package:cmms/src/features/request/search/view/search_cases.dart';
import 'package:cmms/src/features/request/view/view/request_list_view.dart';
import 'package:cmms/src/features/resetpassword/view/resetpassword.dart';
import 'package:cmms/src/fm/features/contract/view/contractcode.dart';
import 'package:cmms/src/fm/features/login/view/login.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cmms/src/features/pendingresponse/view/pendinglist.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/fm/features/cm/view/cmview.dart';
import 'src/fm/features/cm_additional_emp/view/cm_additional_employee.dart';
import 'src/fm/features/cm_afterimage/view/cm_afterimage.dart';
import 'src/fm/features/cm_beforeimage/view/cm_beforeimage.dart';
import 'src/fm/features/cm_material/view/cm_material_view.dart';
import 'src/fm/features/cm_occupant/view/cm_occupant_sign.dart';
import 'src/fm/features/cm_submit/view/cm_final_submit.dart';
import 'src/fm/features/cm_workstatus/view/cm_workstatus.dart';
import 'src/fm/features/cmanalysis/view/cmanalysis_details.dart';
import 'src/fm/features/cmdetails/view/cmdetailsview.dart';
import 'src/fm/features/dashboard/view/dashboard.dart';
import 'src/fm/features/ppm/ppm_additional_emp/view/ppm_additional_employee.dart';
import 'src/fm/features/ppm/ppm_barcode/view/ppm_barcode_view.dart';
import 'src/fm/features/ppm/ppm_checkpoint/view/ppm_checklist_view.dart';
import 'src/fm/features/ppm/ppm_checkpoint_details/view/ppm_checklist_details_view.dart';
import 'src/fm/features/ppm/ppm_list/view/ppm_listview.dart';
import 'src/fm/features/ppm/ppm_list_details/view/ppm_detailsview.dart';
import 'src/fm/features/ppm/ppm_postimage/view/ppm_postimage_view.dart';
import 'src/fm/features/ppm/ppm_preimage/view/ppm_beforeimage.dart';
import 'src/fm/features/ppm/ppm_status_view/view/ppm_statusview.dart';
import 'src/fm/features/ppm/ppm_submit/view/ppm_submit_view.dart';
import 'src/fm/features/tenant/complaint_reg/view/complaint_register.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool checkInFlag = prefs.getBool('checkinFlag') ?? false;
  print('Checkin flag is $checkInFlag...............................');
  await Firebase.initializeApp();
  try {
    await FirebaseApi().initNotification();
    print('Firebase notifications initialized.');
  } catch (e) {
    print('Skipping notification setup: $e');
  }



  // Initialize Foreground Task for location tracking in background
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'location_tracking',
      channelName: 'Location Tracking',
      channelDescription: 'Tracking user location in background',
      channelImportance: NotificationChannelImportance.HIGH,
      priority: NotificationPriority.HIGH,
    ),
    iosNotificationOptions: IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
      eventAction: ForegroundTaskEventAction.repeat(5000),
    ),
  );
  runApp(
    RepositoryProvider(
      create: (context) => ApiService(),
      child: MyApp(checkInFlag: checkInFlag),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool checkInFlag;

  MyApp({required this.checkInFlag});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final bloc = LocationBloc();
        return bloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          // '/': (context) => SplashScreen(),
          '/': (context) => SplashScreen(checkInFlag: checkInFlag),
          '/contractCode': (context) => ContractCodeScreen(),
          '/login': (context) => LoginScreen(),
          '/dashboard': (context) => DashBoardView(),
          '/pendingList': (context) => PendingList(),
          '/pendingDetails': (context) => PendingDetails(),
          '/pendingDetails2': (context) => PendingDetails2(),
          '/inprogressList': (context) => InProgressList(),
          '/inprogressDetails': (context) => InProgressDetailsView(),
          '/closedList': (context) => ClosedList(),
          '/closedDetails': (context) => ClosedDetailsView(),
          '/faultReportMenu': (context) => FRFirstMenu(),
          '/faultReportAllMenu': (context) => FRAllMenu(),
          '/faultReportSubtype': (context) => SubtypeView(),
          '/faultReportRemarks': (context) => FRThirdRemarks(),
          '/faultReportLocation': (context) => FRFourthLocation(),
          '/faultReportRoom': (context) => FRFifthRoom(),
          '/faultReportPriority': (context) => FRSecondPriority(),
          '/faultReportSummary': (context) => FRSubmit(),
          '/ppmList': (context) => PPMList(),
          '/ppmDetails': (context) => PPMDetails(),
          '/qrScan': (context) => QRCodeScan(),
          '/forgotPassword': (context) => ForgotPassword(),
          '/ppmCompletedDetails': (context) => PPMCompletedDetails(),
          '/ppmClosedDetails': (context) => PPMClosedDetails(),
          '/publicWebView': (context) => PublicWebView(),
          '/requestList': (context) => RequestList(),
          '/requestView': (context) => RequestView(),
          '/notificationList': (context) => NotificationList(),
          '/allRequestList': (context) => AllRequestList(),
          '/allRequestDetailsView': (context) => AllRequestView(),
          '/checkIn': (context) => CheckInView(),
          '/displayCheckIn': (context) => DisplayCheckin(),
          '/reportScreen': (context) => ReportScreen(),
          '/adhocScreen': (context) => AdhocList(),
          '/adhocInspection': (context) => AdhocInspection(),
          '/resetPassword': (context) => ResetPassword(),
          '/latLong': (context) => LatLongListScreen(),
          '/adhocAddNewView': (context) => AdhocAddNewView(),
          '/myfaultreport': (context) => MyFaultlist(),
          '/searchCases': (context) => SearchCasesPage(),
          '/myFaultReportView': (context) => MyFaultView(),
          // Add more routes for other screens here

          '/contractcodefm': (context) => ContractCodeScreenFM(),
          '/loginfm': (context) => LoginScreenFM(),
          '/dashboardfm': (context) => DashboardScreen(),
          // FM Project:
          '/cmview': (context) => CMView(),
          '/cmdetailsview': (context) => CMDetailsView(),
          '/cmbeforeimage': (context) => CMBeforeImageView(),
          '/cmanalysisdetails': (context) => CMAnalysisDetailsView(),
          '/cmpostimages': (context) => CMAfterImageView(),
          '/cmadditionalemp': (context) => CMAdditionalEmployeeView(),
          '/cmoccupantsign': (context) => CMOccupantSignView(),
          '/cmfinalsubmit': (context) => CMFinalSubmitView(),
          '/cmstatusview': (context) =>  CMWorkStatusView(),
          '/cmmaterialview': (context) => CMMaterialView(),

          '/ppmworkstatusview': (context) => PPMWorkStatusView(),
          '/ppmlist': (context) => PPMListView(),
          '/ppmdetails': (context) => PPMDetailsView(),
          '/ppmbarcode': (context) => PPMBarcodeView(),
          '/qrScan': (context) => QRCodeScan(),
          '/ppmbeforeimages': (context) => PPMBeforeImageView(),
          '/ppmcheckpoint': (context) => PPMChecklistView(),
          '/ppmcheckdetails': (context) => PPMDetailView(),
          '/ppmafterimages': (context) => PPMPostImageView(),
          '/ppmadditionalemp': (context) => PPMAdditionalEmployeeView(),
          '/ppmsubmit': (context) => PPMFinalSubmitView(),

          '/complaintReg': (context) => ComplaintRegisterView(),



        },
        onGenerateRoute: (settings) {
          // Handle unknown routes here
          return MaterialPageRoute(
            builder: (context) {
              // Show snack bar message for unknown routes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Route not found"),
                  ),
                );
              });
              // Navigate to the SplashScreen as fallback
              return SplashScreen(
                checkInFlag: checkInFlag,
              );
            }, // Create a screen for unknown routes
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool checkInFlag;

  SplashScreen({required this.checkInFlag});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    String baseUrl = await AppSharedPrefs.getBaseUrl();
    String username = await AppSharedPrefs.getUsername();

    print('Base URL: $baseUrl');
    print('Username: $username');

    await _getLocationPermission();

    // Example: Navigate to a different screen after 5 seconds
    if (baseUrl.isEmpty) {
      Timer(
        const Duration(seconds: 5),
            () => Navigator.pushNamed(context, '/contractcodefm'),
      );
    } else if (username.isEmpty) {
      Timer(
        const Duration(seconds: 5),
            () => Navigator.pushNamed(context, '/loginfm'),
      );
    } else {
      Timer(
        const Duration(seconds: 5),
            () => Navigator.pushNamed(context, '/dashboardfm'),
      );
    }
  }

  Future<void> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (BuildContext context, LocationState state) {
        if (widget.checkInFlag) {
          BlocProvider.of<LocationBloc>(context).add(CheckInEvent());
        }

        return Scaffold(
          body: Center(
            child: Image.asset(
              'assets/images/ecms_logo.png',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
