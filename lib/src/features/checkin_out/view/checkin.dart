import 'package:cmms/src/constants/app_sizes.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/utils/app_shared_preference.dart';

class CheckInView extends StatefulWidget {
  @override
  _CheckInViewState createState() => _CheckInViewState();
}

class _CheckInViewState extends State<CheckInView> {
  bool checkInFlag = false;
  String prominentDisclosure = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProminentDiscloser();
  }

  Future<void> fetchProminentDiscloser() async {
    prominentDisclosure =
        await AppSharedPrefs.getProminentDisclosureLocationCheck();

    if (prominentDisclosure.isEmpty) {
      prominentDisclosureDialog();
    } else {
      _getLocationPermission();
      _loadCheckInStatus();
    }
    // Trigger a rebuild after fetching the username
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


  Future<void> _loadCheckInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    checkInFlag = prefs.getBool('checkinFlag') ?? false;
    print(checkInFlag);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final ppmlist =
                      await Navigator.pushNamed(context, '/dashboard');
                  Navigator.pop(context, ppmlist);
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
                'assets/images/ecms_logo.png', // replace with your image path
                width: 100,
                height: 20,
              ),*/
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/dashboard');
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'ATTENDANCE',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //gapH20,
                          ElevatedButton(
                            onPressed: checkInFlag
                                ? null // Disable button if the user has already checked in
                                : () {
                                    Navigator.pushNamed(context, '/qrScan',
                                        arguments: {
                                          'Types': 'CheckIn',
                                          'Location': 'Yes',
                                        });
                                    //Navigator.pushNamed(context, '/displayCheckIn');
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
                                color: AppColors.themeColor,
                                borderRadius: BorderRadius.circular(10.0), // ✅ apply here
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 250.0, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.exit_to_app, color: AppColors.whiteColor,),
                                      SizedBox(width: 8),
                                      Text(checkInFlag
                                          ? 'Checked In'
                                          : 'Check In',   style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),),
                                    ]),
                              ),
                            ),
                          ),
                          gapH20,
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/reportScreen');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: AppColors.themeColor,
                                borderRadius: BorderRadius.circular(10.0), // ✅ apply here
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 250.0, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.book  , color: AppColors.whiteColor,),
                                      SizedBox(width: 8),
                                      Text('Reports',   style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),),
                                    ]),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> prominentDisclosureDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Maintegra app collects location data to enable."),
          content: Text(
            "Confirm the technician's presence at the specified site, even when the app is closed or not in use. Please tap the accept button.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print("User clicked on the negative button");
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Sorry, you cannot proceed to the next step until you accept permission.",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text(
                "DENY",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                print("User clicked on the positive button");
                await AppSharedPrefs.get()
                    .setProminentDisclosureLocationCheck("yes");
                _getLocationPermission();
                _loadCheckInStatus();
                Navigator.pop(context);
              },
              child: Text(
                "ACCEPT",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }
}
