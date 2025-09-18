import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/features/dashboard/View/dashboard.dart';
import 'package:cmms/src/features/pendingresponse/locationvalidation/bloc/location_bloc.dart';
import 'package:cmms/src/features/pendingresponse/locationvalidation/bloc/location_state.dart';
import 'package:cmms/src/features/request/list/bloc/property/property_bloc.dart';
import 'package:cmms/src/helpers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cmms/src/features/pendingresponse/bloc/pending_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/preference_keys.dart';
import '../../pendingresponsedetails/view/pendingdetails.dart';
import '../../request/list/bloc/property/property_event.dart';
import '../../request/list/bloc/property/property_state.dart';
import '../bloc/pending_event.dart';
import '../bloc/pending_state.dart';
import '../locationvalidation/bloc/location_event.dart';
import '../model/pending_model.dart';
import '../model/property_model.dart';

class PendingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<InProgressBloc>(
          create: (context) =>
              InProgressBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<LocationValidationBloc>(
          create: (context) => LocationValidationBloc(
              RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PropertyBloc>(
          create: (context) =>
              PropertyBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: PendingListStateful(),
    );
  }
}

class PendingListStateful extends StatefulWidget {
  @override
  _PendingListStateful createState() => _PendingListStateful();
}

class _PendingListStateful extends State<PendingListStateful> {
  late InProgressBloc _bloc;
  late PropertyBloc propertyBloc;
  late LocationValidationBloc locationValidationBloc;
  String latitude = '';
  String longitude = '';
  String prominentDisclosure = "";
  ScrollController _scrollController = ScrollController();
  int page = 0; // Initial page number
  int selectedIndex = -1;
  late String selectedStatus = "";
  late int selectedID = 0;
  List<Property> propertyList = [];
  List<PendingRequest> allListData = [];
  List<StatusArray> statusData = [];
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String seletedStatus = "";
  String caseid = "";
  String priority = "";
  bool loadStopForOneData = false;

  void updateLocation(String lat, String long) {
    latitude = lat;
    longitude = long;
  }

  void _onScroll() {
    if (_hasMoreData &&
        !_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() => _isLoadingMore = true);
      page++;
      _bloc.add(FetchInProgressEvent(page, selectedID));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<InProgressBloc>(context);
    locationValidationBloc = BlocProvider.of<LocationValidationBloc>(context);
    locationValidationBloc.add(LocationEventInit());
    propertyBloc = BlocProvider.of<PropertyBloc>(context);
    propertyBloc.add(PropertyFetchEvent());

    fetchProminentDiscloser();
  }

  Future<void> fetchProminentDiscloser() async {
    prominentDisclosure = await AppSharedPrefs.getProminentDisclosureCheck();

    if (prominentDisclosure.isEmpty) {
      prominentDisclosureDialog();
    } else {
      checkLocationPermission();
    }
    // Trigger a rebuild after fetching the username
  }

  @override
  void dispose() {
    _bloc.close();
    locationValidationBloc.close();
    propertyBloc.close();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

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
                checkLocationPermission();
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
    PermissionStatus status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      // Location permission is granted
      print('Location permission granted');
      getCurrentLocation();
    } else {
      // Location permission is not granted, request it
      status = await Permission.locationWhenInUse.request();

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

  @override
  Widget build(BuildContext context) {
    Color customColor1 = Color(0xFFCBD4F4);
    Color customColor2 = Color(0xFFF7D9E3);

    return BlocProvider(
      create: (context) => _bloc,
      child: WillPopScope(
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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              'REQUESTOR PENDING LIST',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField<Property>(
                  isExpanded: true,
                  value:
                      selectedIndex != -1 ? propertyList[selectedIndex] : null,
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
                      allListData.clear();
                      statusData.clear();
                      page = 0;
                      _isLoadingMore = false;
                      loadStopForOneData = false;
                      _hasMoreData = true;
                      _bloc.add(FetchInProgressEvent(page, selectedID));
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<InProgressBloc, InProgressState>(
                      listener: (context, state) {
                        if (state is InProgressErrorState) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Error);
                        } else if (state is InProgressLoadedState) {
                          List<PendingRequest> list =
                              state.pendingList.pendingRequestList ?? [];
                          if (page == 0) allListData.clear();
                          allListData.addAll(list);
                          _isLoadingMore = false;
                          _hasMoreData = list.isNotEmpty;
                          /*if (list.isEmpty && page > 0) {
                            Utils.showInSnackBar(context,
                                "No more data available.", ToastType.Warning);
                          }*/
                        }
                      },
                    ),
                    BlocListener<LocationValidationBloc,
                        LocationValidationState>(
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
                          Navigator.pop(context);
                          if (state.locationresponse.status) {
                            if (seletedStatus == "New Request") {
                              Navigator.pushNamed(context, "/pendingDetails",
                                  arguments: {'priority': priority, });
                            } else {
                              Navigator.pushNamed(
                                context,
                                "/inprogressDetails",
                                arguments: {'SubmitBtnShow': caseid,  'priority': priority, },
                              );
                            }
                          } else {
                            Utils.showInSnackBar(
                                context,
                                state.locationresponse.message,
                                ToastType.Error);
                          }
                        }
                      },
                    ),
                    BlocListener<PropertyBloc, PropertyState>(
                      listener: (context, state) {
                        if (state is PropertySuccessState) {
                          setState(() {
                            propertyList.addAll(state.moduleResponse.property);
                          });

                          context
                              .read<InProgressBloc>()
                              .add(FetchInProgressEvent(page, selectedID));
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<InProgressBloc, InProgressState>(
                    builder: (context, state) {
                      if (state is InProgressInitialState &&
                          allListData.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (allListData.isEmpty) {
                        return Center(child: Text('No data available'));
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: allListData.length + 1,
                        itemBuilder: (context, index) {
                          if (index < allListData.length) {
                            return buildListTile(
                                context, allListData[index], allListData);
                          } else {
                            if (_hasMoreData && loadStopForOneData == false && allListData.length>9) {
                              return Center(child: CircularProgressIndicator());
                            } else if (loadStopForOneData == false) {
                              return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No more data'),
                                  ));
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(
      BuildContext context, PendingRequest request, List<PendingRequest> list) {
    if (list.isEmpty) {
      return Center(
        child: Text("No pending requests found."),
      );
    }
    return BlocBuilder<InProgressBloc, InProgressState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            // Set data in shared preferences
            seletedStatus = request.statusName!;
            caseid = request.id.toString();
            await AppSharedPrefs.get().setCaseID(request.id.toString());
            await AppSharedPrefs.get().setCaseIDName(request.caseId!);
            await AppSharedPrefs.get().setCompanyName(request.contractorName!);
            await AppSharedPrefs.get().setAssetName(request.asset!);
            await AppSharedPrefs.get().setAssetID(request.assetId!);
            await AppSharedPrefs.get().setPropertyName(request.property!);
            await AppSharedPrefs.get().setBlockName(request.block!);
            await AppSharedPrefs.get().setLevelName(request.level!);
            await AppSharedPrefs.get().setFaultTypeName(request.type!);
            await AppSharedPrefs.get().setFaultSubTypeName(request.subType!);
            await AppSharedPrefs.get()
                .setBeforePhotoPath(request.beforePhotoPath!);
            await AppSharedPrefs.get().setVendorName(request.vendor!);
            await AppSharedPrefs.get().setDesc(request.description!);
            await AppSharedPrefs.get().setPriority(request.priority!);

            // Check if latitude is available
            if (latitude.isEmpty) {
              Utils.showInSnackBar(
                  context, "sync up location data...", ToastType.Warning);
              checkLocationPermission();
            } else {
              // Make API call using bloc
              print("API Called");
              locationValidationBloc.add(FetchLocationEvent(
                latitude: latitude,
                longitude: longitude,
                propertyID: request.propertyId!,
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // Align to the start (top)
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Request ID ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight
                                  .normal, // Optional: Make it bold to stand out
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " + request.caseId!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight
                                  .normal, // Optional: Make it bold to stand out
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Name of Requestor",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " + request.requestorName!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Date and Time of Request",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " +
                                "${request.dateOfRequest} ${request.timeOfRequest}",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Fault Location",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " + request.property!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Status",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " + request.statusName!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Description",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " + request.description!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Addn. Loc",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " + request.additionalSpace!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Priority",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            ": " + request.priority!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color getStatusColor(String statusName) {
    switch (statusName) {
      case 'O':
        return Colors.green;
      case 'PR':
        return Colors.orange;
      case 'D':
        return Colors.cyan;
      case 'R':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
