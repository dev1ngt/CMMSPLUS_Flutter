import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as my_location;
import 'package:geolocator/geolocator.dart' as my_geo;
import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';

import '../../../pendingresponse/locationvalidation/bloc/location_bloc.dart';
import '../../../pendingresponse/locationvalidation/bloc/location_event.dart';
import '../../../pendingresponse/locationvalidation/bloc/location_state.dart';
import '../../../pendingresponse/model/property_model.dart';
import '../bloc/property/property_bloc.dart';
import '../bloc/property/property_event.dart';
import '../bloc/property/property_state.dart';
import '../bloc/request_list_bloc.dart';
import '../bloc/request_list_event.dart';
import '../bloc/request_list_state.dart';
import '../model/request_list_model.dart';




class RequestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RequestListBloc>(
          create: (context) =>
              RequestListBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PropertyBloc>(
          create: (context) =>
              PropertyBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<LocationValidationBloc>(
          create: (context) => LocationValidationBloc(
              RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: RequestListWidgetContent(),
    );
  }
}

class RequestListWidgetContent extends StatefulWidget {
  @override
  _RequestListWidgetContentState createState() =>
      _RequestListWidgetContentState();
}

class _RequestListWidgetContentState extends State<RequestListWidgetContent> {

  String latitude = '';
  String longitude = '' , requestedID = "",propertyID = "";
  int page = 0;
  ScrollController _scrollController = ScrollController();
  late RequestListBloc requestListBloc;
  late PropertyBloc propertyBloc;
  List<RequestData> allListData = [];
  late LocationValidationBloc locationValidationBloc;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int selectedIndex = -1;
  late String selectedStatus = "";
  late int selectedID = 0;
  late String type = "single";
  List<Property> propertyList = [];
  bool loadStopForOneData = false;
  String prominentDisclosure = "";

  void _onScroll() {
    if (_hasMoreData &&
        !_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() => _isLoadingMore = true);
      page++;
      requestListBloc.add(RequestListLoadEvent(selectedID, type, '', page));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    propertyBloc = BlocProvider.of<PropertyBloc>(context);
    propertyBloc.add(PropertyFetchEvent());

    requestListBloc = BlocProvider.of<RequestListBloc>(context);
    requestListBloc.add(RequestListLoadEvent(selectedID, type, '', page));

    locationValidationBloc = BlocProvider.of<LocationValidationBloc>(context);
    locationValidationBloc.add(LocationEventInit());

    fetchProminentDiscloser();
  }

  Future<void> fetchProminentDiscloser() async {
    prominentDisclosure = await AppSharedPrefs.getProminentDisclosureCheck();

    if (prominentDisclosure.isEmpty) {
      prominentDisclosureDialog();
    } else {
      checkLocationPermissionWithRequest();
    }
    // Trigger a rebuild after fetching the username
  }

  @override
  void dispose() {
    _scrollController.dispose();
    locationValidationBloc.close();
    requestListBloc.close();
    propertyBloc.close();
    super.dispose();
  }

  void updateLocation(String lat, String long) {
    latitude = lat;
    longitude = long;
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
                await AppSharedPrefs.get().setProminentDisclosureCheck("yes");
                checkLocationPermissionWithRequest();
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

  Future<void> checkLocationPermission() async {
    my_location.PermissionStatus status = await my_location.Permission.location.status;

    if (status == PermissionStatus.granted) {
      // Location permission is granted
      print('Location permission granted');
      getCurrentLocation();
    } else {
      // Location permission is not granted, request it
      status = await my_location.Permission.locationWhenInUse.request();

      if (status == PermissionStatus.granted) {
        // Location permission granted after request
        print('Location permission granted after request');
        getCurrentLocation();
      } else {
        // Location permission denied
        print('Location permission denied');
      }
    }
  }

  Future<void> checkLocationPermissionWithRequest() async {
    // Check if location services are enabled
    bool serviceEnabled = await my_geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      Utils.showInSnackBar(
        context,
       "Location services are disabled.",
        ToastType.Error,
      );
      // Optionally prompt user to enable location services
      return;
    }

    // Check current permission status
    my_geo.LocationPermission permission = await my_geo.Geolocator.checkPermission();

    if (permission == my_geo.LocationPermission.denied) {
      // Request permission if denied
      permission = await my_geo.Geolocator.requestPermission();
      if (permission == my_geo.LocationPermission.denied) {
        print('Location permission denied.');
        Utils.showInSnackBar(
          context,
          "Location permission denied.",
          ToastType.Error,
        );
        return;
      }
    }

    if (permission == my_geo.LocationPermission.deniedForever) {
      // Permissions are permanently denied
      print('Location permission permanently denied.');
      Utils.showInSnackBar(
        context,
        "Location permission permanently denied.",
        ToastType.Error,
      );
      return;
    }
    Utils.showInSnackBar(
      context,
      "Location permission granted",
      ToastType.Success,
    );
    // If we get here → Permission granted
    print('Location permission granted');
    getCurrentLocation();
  }


  Future<void> getCurrentLocation() async {
    try {
      my_geo.Position position = await my_geo.Geolocator.getCurrentPosition(desiredAccuracy: my_geo.LocationAccuracy.high);

      String newLatitude = '${position.latitude}';
      String newLongitude = '${position.longitude}';

      // Only update state if the location changes
      if (newLatitude != latitude || newLongitude != longitude) {

        updateLocation(newLatitude, newLongitude);
        print("Latitude: $latitude, Longitude: $longitude");
      }

      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: Image.asset(
                  'assets/images/ic_home.png',
                  width: 20,
                  height: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          /*flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.whiteColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),*/
        ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: MultiBlocListener(
              listeners: [
                // LocationValidationBloc listener
                BlocListener<LocationValidationBloc, LocationValidationState>(
                  listener: (context, state) async {
                    if (state is LocationInitialState) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          content: ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('Loading...'),
                          ),
                        ),
                      );
                    } else if (state is LocationLoadedState) {
                      Navigator.pop(context); // close loading dialog
                      if (state.locationresponse.status) {
                        Navigator.pushNamed(
                          context,
                          '/requestView',
                          arguments: {
                            'RequestID': requestedID,
                            'PropertyID': propertyID,
                          },
                        );
                      } else {
                        Utils.showInSnackBar(
                          context,
                          state.locationresponse.message,
                          ToastType.Error,
                        );

                      }
                    }
                  },
                ),

                // RequestListBloc listener
                BlocListener<RequestListBloc, RequestListState>(
                  listener: (context, state) {
                    if (state is RequestListErrorState) {
                      Utils.showInSnackBar(context, state.error, ToastType.Error);
                    } else if (state is RequestListLoadedState) {
                      setState(() {
                        if (page == 0) allListData.clear();
                        allListData.addAll(state.closedList);
                        _isLoadingMore = false;
                        _hasMoreData = state.closedList.isNotEmpty;
                      });

                    }
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + search
                  Stack(
                    children: [
                      Center(
                        child: Text(
                          'MY CASES',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/searchCases',
                              arguments: {
                                'propertyId': selectedID,
                                'propertyName': selectedStatus,
                                'type': 'mycases',
                                'subType': '',
                              },
                            );

                            if (result != null && result is String) {
                              final selectedRequestId = result;
                              allListData.clear();
                              loadStopForOneData = true;
                              requestListBloc.add(
                                RequestListLoadEvent(
                                  selectedID,
                                  type,
                                  selectedRequestId,
                                  0,
                                ),
                              );
                            }
                          },
                          child: Icon(Icons.search_sharp),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Property dropdown
                  BlocBuilder<PropertyBloc, PropertyState>(
                    builder: (context, state) {
                      if (state is PropertyLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is PropertySuccessState) {
                        propertyList = state.moduleResponse.property;
                        return DropdownButtonFormField<Property>(
                          isExpanded: true,
                          value: selectedIndex != -1
                              ? propertyList[selectedIndex]
                              : null,
                          hint: Text('Select a property'),
                          items: propertyList.map((Property status) {
                            return DropdownMenuItem<Property>(
                              value: status,
                              child: Text(status.proname),
                            );
                          }).toList(),
                          onChanged: (Property? newValue) {
                            setState(() {
                              selectedStatus = newValue!.proname;
                              selectedID = newValue.proid;
                              page = 0;
                              allListData.clear();
                              loadStopForOneData = false;
                              _isLoadingMore = false;
                              _hasMoreData = true;
                              requestListBloc.add(
                                RequestListLoadEvent(
                                  selectedID,
                                  type,
                                  '',
                                  page,
                                ),
                              );
                            });
                          },
                          dropdownColor: Colors.white, // ✅ background color of dropdown menu
                          decoration: InputDecoration(
                            hintText: 'Select Property',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.white,        // ✅ textfield bg
                            filled: true,                   // ✅ enable fillColor
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),

                  SizedBox(height: 10),

                  // Request list
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: allListData.length + 1,
                      itemBuilder: (context, index) {
                        if (index < allListData.length) {
                          final data = allListData[index];
                          return _buildRequestCard(data);
                        } else {
                          if (_hasMoreData &&
                              !loadStopForOneData &&
                              allListData.length > 9) {
                            return Center(child: CircularProgressIndicator());
                          } else if (!loadStopForOneData) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('No more data'),
                              ),
                            );
                          }
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )


      ),
    );
  }

  Widget _buildRequestCard(RequestData data) {
    return GestureDetector(
      onTap: () {

        requestedID = data.id.toString();
        propertyID = data.propertyId;

        // Check if latitude is available
        if (latitude.isEmpty) {
          Utils.showInSnackBar(
              context, "sync up location data...", ToastType.Warning);
          checkLocationPermissionWithRequest();
        } else {
          // Make API call using bloc
          print("API Called");
          locationValidationBloc.add(FetchLocationEvent(
            latitude: latitude,
            longitude: longitude,
            propertyID: data.propertyId!,
          ));
        }

        // Navigator.pushNamed(
        //   context,
        //   '/requestView',
        //   arguments: {'RequestID': data.id.toString(), 'PropertyID': data.propertyId},
        // );



      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow(context, 'REQ ID', data.requestId),
                _buildRow(context, 'REQ BY', data.requestedBy,
                    showPhoneIcon: true, phoneNumber: data.mobile),
                _buildRow(context, 'REGION', data.regionName),
                _buildRow(context, 'PROPERTY', data.property),
                _buildRow(context, 'SPACE / FLOOR', data.spaceFloor),
                _buildRow(context, 'TYPE', data.type),
                _buildRow(context, 'SUBTYPE', data.subType),
                _buildRow(context, 'STATUS', data.status),
                _buildRow(context, 'DESCRIPTION', data.originalMessage),
                _buildRow(context, 'PRIORITY', data.priorityName),
                _buildRow(context, 'ADDN. LOC', data.additionalSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateListItemCount() {
    return _isLoadingMore ? allListData.length + 1 : allListData.length;
  }

  Widget _buildRow(BuildContext context, String title, String value,
      {bool showPhoneIcon = false, String? phoneNumber}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ": $value",
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                if (showPhoneIcon && phoneNumber != null)
                  InkWell(
                    onTap: () {
                      _showPhoneDialog(context, phoneNumber);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.phone, color: Colors.black, size: 20),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhoneDialog(BuildContext context, String phoneNumber) {
    final TextEditingController controller =
        TextEditingController(text: phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // ✅ White background
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 15), // Space above the TextFormField
              TextFormField(
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
