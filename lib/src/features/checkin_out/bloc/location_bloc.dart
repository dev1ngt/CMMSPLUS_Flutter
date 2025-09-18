import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:background_task/background_task.dart';
import 'package:bloc/bloc.dart';
import 'package:cmms/main.dart';
import 'package:cmms/src/features/checkin_out/model/checkin_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  double targetLatitude = 0.0;
  double targetLongitude = 0.0;
  double radiusInMeters = 0.0;
  String punchId = '';
  String attendanceId = '';
  String propertyId = '';
  String checkOutLatLong = '';
  String checkoutLocation = '';
  bool checkInFlag = false;
  Position? _lastValidPosition;
  DateTime? _lastValidTime;

  StreamSubscription<Position>? _positionStream;

  LocationBloc() : super(LocationInitial()) {
    on<StartTracking>((event, emit) async {
      bool hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        return; // Show an error state or prompt the user to enable permissions
      }

      await _startLocationTracking();
    });

    on<StopTracking>((event, emit) async {
      if (checkInFlag) {
        checkInFlag = false;
        _checkOutApiCall();
      }
    });

    on<CheckInEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      bool isCheckIN = prefs.getBool('checkinFlag') ?? false;

      if (isCheckIN) {
        // Populate location and check-in details
        await _loadCheckInDetailsFromPreferences(prefs);
        checkInFlag = true;

        add(StartTracking());
      }
    });

    on<UpdateLocation>((event, emit) async {
      _handleLocationPermission();
      double distance = _calculateDistance(
        targetLatitude,
        targetLongitude,
        event.latitude,
        event.longitude,
      );
      print('Distance to target: ${distance.toStringAsFixed(2)} meters');
      print('Radius: $radiusInMeters meters');

      bool isWithinRadius = distance <= radiusInMeters;
      if (isWithinRadius) {
      } else {
        if (checkInFlag) {
          await _checkOutUser(event.latitude, event.longitude);
          add(StopTracking());
        }
      }
    });
  }

  Future<void> _startLocationTracking() async {
    if (Platform.isIOS) {
      await BackgroundTask.instance.start();
      BackgroundTask.instance.stream.listen((event) {
        commonAndroidIosTracking();
      });
    } else if (Platform.isAndroid) {
      await FlutterForegroundTask.startService(
        notificationTitle: 'Tracking Location',
        notificationText: 'Location tracking is active in background',
      );
      commonAndroidIosTracking();
    }
  }

  void commonAndroidIosTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Minimum distance in meters
      ),
    ).listen((Position position) {
      if (_lastValidPosition == null || _isValidPosition(position)) {
        _lastValidPosition =
            position; // Update the last valid position dynamically
        _lastValidTime =
            DateTime.now(); // Track the time of the last valid position
        add(UpdateLocation(position.latitude, position.longitude));
      }
    });

    // Start foreground service to repeat location tracking
    Timer.periodic(Duration(seconds: 10), (timer) async {
      if (_positionStream == null) {
        timer.cancel();
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      if (_lastValidPosition == null || _isValidPosition(position)) {
        _lastValidPosition =
            position; // Update the last valid position dynamically
        _lastValidTime =
            DateTime.now(); // Track the time of the last valid position
        add(UpdateLocation(position.latitude, position.longitude));
      }
    });
  }

  bool _isValidPosition(Position newPosition) {
    if (_lastValidPosition == null || _lastValidTime == null) {
      return true; // First position is always valid
    }

    double distance = Geolocator.distanceBetween(
      _lastValidPosition!.latitude,
      _lastValidPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    Duration timeDifference = DateTime.now().difference(_lastValidTime!);
    // Speed thresholds (in meters per second)
    double walkingSpeed = 1.39; // 5 km/h
    double runningSpeed = 4.17; // 15 km/h
    double drivingSpeed = 33.33; // 120 km/h

    // Speed in meters per second
    double speed = newPosition.speed;

    // Determine max reasonable distance based on speed
    double maxReasonableDistance = 0;
    if (speed <= walkingSpeed) {
      maxReasonableDistance =
          walkingSpeed * timeDifference.inSeconds; // walking
    } else if (speed <= runningSpeed) {
      maxReasonableDistance =
          runningSpeed * timeDifference.inSeconds; // running
    } else if (speed <= drivingSpeed) {
      maxReasonableDistance =
          drivingSpeed * timeDifference.inSeconds; // driving
    } else {
      maxReasonableDistance =
          drivingSpeed * timeDifference.inSeconds; // high speed
    }

    print(
        'Speed is $speed, distance is $distance, maxresdis is $maxReasonableDistance');
    // Ensure the distance is within the reasonable range
    return distance <= maxReasonableDistance;
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  Future<void> _checkOutUser(double lat, double lng) async {
    checkOutLatLong = '$lat,$lng';

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks[0];
    checkoutLocation =
        '${place.street}, ${place.locality}, ${place.country}, ${place.postalCode}';
  }

  Future<void> _checkOutApiCall() async {
    Map<String, String> headers = await getHeader();
    String baseUrl = await AppSharedPrefs.getBaseUrl();
    String userId = await AppSharedPrefs.getUserID();

    final url = Uri.parse("${baseUrl}PunchCheckOut?"
        "propert_id=$propertyId"
        "&userid=$userId"
        "&punch_id=$punchId"
        "&is_delay=1"
        "&check_out_location=$checkOutLatLong"
        "&check_out_place=$checkoutLocation"
        "&attendance_id=$attendanceId");

    try {
      final response = await post(url, headers: headers);
      if (response.statusCode == 200) {
        final data = CheckInModel.fromJson(json.decode(response.body));
        print(data);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('checkinFlag', false);
        prefs.setString('checkInPropertyId', '');
        prefs.setString('checkInLat', '');
        prefs.setString('checkInLong', '');
        prefs.setString('checkInRadius', '');
        prefs.setString('checkInPunchId', '');
        prefs.setString('checkInAttendanceId', '');

        final context = navigatorKey.currentState?.overlay?.context;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data.message.toString()),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
        }

        await BackgroundTask.instance.stop();
        await FlutterForegroundTask.stopService();
        await _positionStream?.cancel();
        _positionStream = null;
      }
    } catch (e) {
      print("Error checking out: $e");
    }
  }

  Future<Map<String, String>> getHeader() async {
    return {
      'Content-type': 'application/json',
      'X-Project-Code': await getContractCode(),
    };
  }

  Future<String> getContractCode() async {
    return await AppSharedPrefs.getContractCode();
  }

  Future<void> _loadCheckInDetailsFromPreferences(
      SharedPreferences prefs) async {
    // Load necessary values from SharedPreferences
    punchId = prefs.getString('checkInPunchId') ?? '';
    attendanceId = prefs.getString('checkInAttendanceId') ?? '';
    propertyId = prefs.getString('checkInPropertyId') ?? '';

    String lat = prefs.get('checkInLat').toString();
    targetLatitude = double.parse(lat);
    String long = prefs.get('checkInLong').toString();
    targetLongitude = double.parse(long);
    String rad = prefs.get('checkInRadius').toString();
    radiusInMeters = double.parse(rad);

    checkInFlag = prefs.getBool('checkinFlag') ?? false;

    // Optionally, you could also log or print the loaded data to verify
    print('Check-In details loaded: $punchId, $attendanceId, $propertyId, '
        'Lat: $targetLatitude, Long: $targetLongitude, Radius: $radiusInMeters');
  }

  /* Future<void> _saveLogs(double lat, double long) async {
    Map<String, String> headers = await getHeader();
    String baseUrl = await AppSharedPrefs.getBaseUrl();
    String userId = await AppSharedPrefs.getUserID();

    String latt = lat.toString();
    String longg = long.toString();

    final url = Uri.parse("${baseUrl}save_attendance_log?"
        "property_id=$propertyId"
        "&user_id=$userId"
        "&latitude=$latt"
        "&longitude=$longg");

    //print(url);
    try {
      final response = await post(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //print(data);
      }
    } catch (e) {
      print("Error checking out: $e");
    }
  }*/

  @override
  Future<void> close() {
    FlutterForegroundTask.stopService();
    BackgroundTask.instance.stop();
    _positionStream?.cancel();
    return super.close();
  }
}
