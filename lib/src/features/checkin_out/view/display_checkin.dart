import 'dart:convert';

import 'package:cmms/src/constants/app_sizes.dart';
import 'package:cmms/src/features/checkin_out/model/checkin_model.dart';
import 'package:cmms/src/features/checkin_out/model/duty_type_model.dart';
import 'package:cmms/src/features/dashboard/View/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/utils.dart';
import '../bloc/battery_state.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class DisplayCheckin extends StatefulWidget {
  @override
  _DisplayCheckinState createState() => _DisplayCheckinState();
}

class _DisplayCheckinState extends State<DisplayCheckin> {
  String? selectedPlace; // For dropdown selection
  String? location;
  String? username;
  final LocationBloc locationBloc = LocationBloc();

  List<DutyTypeList> dutyTypeList = [];
  int selectedIndex = -1;

  String propertyId = '';
  String latLong = '';
  String dutyTypeId = '0';
  String userId = '';

  bool checkInFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsername();
    _dutyTypeApiCall(context);
  }

  Future<void> fetchUsername() async {
    username = await AppSharedPrefs.getUsername();
    userId = await AppSharedPrefs.getUserID();
    final prefs = await SharedPreferences.getInstance();
    checkInFlag = prefs.getBool('checkinFlag') ?? false;
    setState(() {}); // Trigger a rebuild after fetching the username
  }

  @override
  Widget build(BuildContext context) {
    Color customColor1 = Color(0xFFCBD4F4);
    Color customColor2 = Color(0xFFF7D9E3);

    String lat = '';
    String long = '';
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('QRResult')) {
      propertyId = args['QRResult'] as String;
    }
    if (args != null && args.containsKey('Lat')) {
      lat = args['Lat'] as String;
    }
    if (args != null && args.containsKey('Long')) {
      long = args['Long'] as String;
    }
    if (args != null && args.containsKey('Location')) {
      location = args['Location'] as String;
    }

    latLong = '$lat,$long';

    return WillPopScope(
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
                onTap: () async {
                  final ppmlist =
                      await Navigator.pushNamed(context, '/checkIn');
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
              Spacer(),
              Image.asset(
                'assets/images/ecms_logo.png', // replace with your image path
                width: 100,
                height: 20,
              ),
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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [customColor1, customColor2],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            /* if (location == null) {
              return Center(child: CircularProgressIndicator());
            }*/

            final currentDate = DateTime.now();

            return Padding(
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
                  // Display user details: Name, Street, Place, Date
                  Center(
                    child: Column(
                      children: [
                        Text('Name: $username',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                        gapH10,
                        Text(
                            'Time: ${currentDate.toLocal().toString().substring(11, 16)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                        gapH10,
                        Text('Location: $location',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                        gapH10,

                        // Dropdown menu
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField<DutyTypeList>(
                            isExpanded: true,
                            value: selectedIndex != -1
                                ? dutyTypeList[selectedIndex]
                                : null,
                            hint: Text('Select Duty Type'),
                            items: dutyTypeList.map((DutyTypeList status) {
                              return DropdownMenuItem<DutyTypeList>(
                                value: status,
                                child: Text(status.duty.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dutyTypeId = value!.id.toString();
                                print(dutyTypeId);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Select Duty Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        gapH20,

                        // Check-in button
                        ElevatedButton(
                          onPressed: checkInFlag
                              ? null // Disable button if the user has already checked in
                              : () async {
                                  _checkInApiCall(context);
                                },
                          /* onPressed: state.checkInFlag!
                              ? null // Disable button if the user has already checked in
                              : () async {
                                  if (state is LocationInRadiusState) {
                                    BlocProvider.of<LocationBloc>(context)
                                        .add(CheckInEvent());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Check In Successful")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "You are not within the radius.")),
                                    );
                                  }
                                },*/
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
                                  maxWidth: 250.0, minHeight: 45.0),
                              alignment: Alignment.center,
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.exit_to_app),
                                    SizedBox(width: 8),
                                    Text(checkInFlag
                                        ? 'Checked In'
                                        : 'Check In'),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _dutyTypeApiCall(BuildContext context) async {
    Map<String, String> headers = await getHeader();
    String baseUrl = await AppSharedPrefs.getBaseUrl();

    final url = Uri.parse("${baseUrl}getDutyType");

    Response response = await post(
      url,
      headers: headers,
    );

    try {
      print(url);
      if (response.statusCode == 200) {
        final data = DutyTypeModel.fromJson(json.decode(response.body));
        setState(() {
          dutyTypeList = data.dutyTypeList!;
        });
        print(data);
      } else {
        Utils.showInSnackBar(
            context, response.reasonPhrase.toString(), ToastType.Error);
      }
    } catch (e) {
      Utils.showInSnackBar(context, 'Error', ToastType.Error);
    }
  }

  Future<String> getContractCode() async {
    return await AppSharedPrefs.getContractCode();
  }

  Future<Map<String, String>> getHeader() async {
    return {
      'Content-type': 'application/json',
      'X-Project-Code': await getContractCode(),
    };
  }

  Future<void> _checkInApiCall(BuildContext context) async {
    Map<String, String> headers = await getHeader();
    String baseUrl = await AppSharedPrefs.getBaseUrl();
    String userId = await AppSharedPrefs.getUserID();

    final url = Uri.parse("${baseUrl}AddPunch?"
        "propert_id=$propertyId"
        "&userid=$userId"
        "&punch_location=$latLong"
        "&duty_type=$dutyTypeId"
        "&location_name=$location");

    Response response = await post(
      url,
      headers: headers,
    );

    try {
      print(url);
      if (response.statusCode == 200) {
        final data = CheckInModel.fromJson(json.decode(response.body));
        print(data);
        if (data.status == true) {
          checkInFlag = true;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('checkinFlag', true);
          prefs.setString(
              'checkInPropertyId', data.propertyInfo![0].propertyId.toString());
          prefs.setString('checkInLat', data.propertyInfo![0].lat.toString());
          prefs.setString('checkInLong', data.propertyInfo![0].lang.toString());
          prefs.setString(
              'checkInRadius', data.propertyInfo![0].radius.toString());
          prefs.setString(
              'checkInPunchId', data.propertyInfo![0].punchId.toString());
          prefs.setString('checkInAttendanceId',
              data.propertyInfo![0].attendanceId.toString());

          /*prefs.setString('checkInPropertyId', '1');
          prefs.setString('checkInLat', '11.0653244');
          prefs.setString('checkInLong', '77.0319305');
          prefs.setString('checkInRadius', '1.5');
          prefs.setString('checkInPunchId', '5');
          prefs.setString('checkInAttendanceId', '2');
          prefs.setBool('checkinFlag', true);*/

          BlocProvider.of<LocationBloc>(context).add(CheckInEvent());
          Utils.showInSnackBar(
              context, data.message.toString(), ToastType.Success);
          setState(() {});
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => DashBoardView()),
                ModalRoute.withName("/dashboard"));
            // Navigator. pushNamed(context, '/dashboard');
          });
        } else {
          Utils.showInSnackBar(
              context, data.message.toString(), ToastType.Error);
        }
      } else {
        Utils.showInSnackBar(
            context, response.reasonPhrase.toString(), ToastType.Error);
      }
    } catch (e) {
      Utils.showInSnackBar(context, 'Error', ToastType.Error);
    }
  }
}
