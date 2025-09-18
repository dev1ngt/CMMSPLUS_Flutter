import 'package:cmms/src/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../helpers/utils/app_shared_preference.dart';
import '../../../../../helpers/utils/utils.dart';
import '../../../cm_summary/model/cm_submit_request_model.dart';
import '../../../cm_summary/model/cm_submit_save.dart';
import '../../ppm_submit/model/ppm_submit_request_model.dart';
import '../../ppm_submit/model/ppm_submit_save.dart';
import '../bloc/details/ppmdetails_bloc.dart';
import '../bloc/details/ppmdetails_event.dart';
import '../bloc/details/ppmdetails_state.dart';
import '../bloc/starttime/ppmstarttime_bloc.dart';
import '../bloc/starttime/ppmstarttime_event.dart';
import '../bloc/starttime/ppmstarttime_state.dart';
import '../model/ppmdetails_response_model.dart';

class PPMDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PPMDetailsBloc>(
          create: (context) =>
              PPMDetailsBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PPMStartTimeBloc>(
          create: (context) =>
              PPMStartTimeBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: PPMDetailsViewState(),
    );
  }
}

class PPMDetailsViewState extends StatefulWidget {
  @override
  _PPMDetailsViewState createState() => _PPMDetailsViewState();
}

class _PPMDetailsViewState extends State<PPMDetailsViewState> {
  @override
  bool _ApiCalled = false;
  late PPMDetailsBloc ppmDetailsBloc;
  late PPMStartTimeBloc ppmStartTimeBloc;
  String taskNo = "",
      scheduledDate = "",
      frequency = "",
      natureOfComplaint = "",
      priority = "",
      location = "",
      building = "",
      floor = "",
      area = "",
      subCategory = "",
      category = "",
      assetname = "",
      assettagno = "",
      assetno = "";
  bool isQrcode = false;
  String ppmid = "";
  String startTime = "";
  PPMSubmitSaveModel viewModel = PPMSubmitSaveModel();

  void initState() {
    super.initState();
    ppmDetailsBloc = BlocProvider.of<PPMDetailsBloc>(context);
    ppmStartTimeBloc = BlocProvider.of<PPMStartTimeBloc>(context);

    PPMSubmitRequestModelOne faultReportSaveModel =
        viewModel.ppmSubmitRequestModel;
    if (faultReportSaveModel.startTime != null) {
      startTime = faultReportSaveModel.startTime!;
    }
  }

  @override
  void dispose() {
    ppmDetailsBloc.close();
    ppmStartTimeBloc.close();
    super.dispose();
  }

  Future<void> getSharedPrefe() async {
    ppmid = await AppSharedPrefs.getPPMID();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("PPMID")) {
      final String ppmID_ = args['PPMID'] as String;
      if (!_ApiCalled) {
        var connectivityResult = (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          Utils.showInSnackBar(
            context,
            "No internet connection.",
            ToastType.Error,
          );
        } else {
          _ApiCalled = true;
          ppmid = ppmID_;
          ppmDetailsBloc.add(PPMDetailsFetchEvent(ppmid)); // Initial fetch
        }
      }
    }
    return BlocProvider(
      create: (context) => ppmDetailsBloc,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFF006BE6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'PPM Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: TextButton(
                  onPressed: () {
                    DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('dd-MM-yyyy HH:mm').format(now);
                    if (startTime.isEmpty) {
                      var connectivityResult =
                          (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        Utils.showInSnackBar(
                          context,
                          "No internet connection.",
                          ToastType.Error,
                        );
                      } else {
                        startTime = formattedDate;
                        viewModel.updatePPMWorkOrderStartTime(
                            formattedDate,
                            int.parse(ppmid),
                            assetno,
                            assettagno,
                            assetname,
                            isQrcode);
                        ppmStartTimeBloc.add(PPMStartTimeFetchEvent(formattedDate, ppmid));
                      }
                    } else {
                      Navigator.pushNamed(context, '/ppmbarcode',
                        arguments: {
                          'PPMID': ppmid,
                          // Add more parameters as needed
                        },);
                    }

                    // Add your button action here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    startTime.isEmpty ? 'Start' : 'Next',
                    style: TextStyle(
                      color: Color(0xFF006BE6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BlocListener<PPMDetailsBloc, PPMDetailsState>(
                          listener: (context, state) {
                            if (state is PPMDetailsSuccessState) {
                              setState(() {
                                taskNo = state.moduleResponse.data.ppmTaskNo;
                                scheduledDate =
                                    state.moduleResponse.data.scheduleDate;
                                frequency = state.moduleResponse.data.frequency;
                                location = state.moduleResponse.data.location;
                                building = state.moduleResponse.data.building;
                                floor = state.moduleResponse.data.floor;
                                area = state.moduleResponse.data.area;
                                category = state.moduleResponse.data.category;
                                subCategory =
                                    state.moduleResponse.data.subCategory;
                                assetname = state.moduleResponse.data.assetName;
                                assettagno =
                                    state.moduleResponse.data.assetTagNo;
                                assetno = state.moduleResponse.data.assetNo;
                                isQrcode = state.moduleResponse.data.isQrcode;
                              });
                            } else if (state is PPMDetailsFailureState) {
                              Utils.showInSnackBar(
                                  context, state.loginError, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<PPMDetailsBloc, PPMDetailsState>(
                            builder: (context, state) {
                              if (state is PPMDetailsLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),

                        /* Start Time and Status Update API */
                        BlocListener<PPMStartTimeBloc, PPMStartTimeState>(
                          listener: (context, state) {
                            if (state is PPMStartTimeSuccessState) {
                              Utils.showInSnackBar(
                                  context,
                                  state.moduleResponse.message,
                                  ToastType.Success);
                              Navigator.pushNamed(context, '/ppmbarcode');
                            } else if (state is PPMStartTimeFailureState) {
                              Utils.showInSnackBar(
                                  context, state.error, ToastType.Warning);
                            }
                          },
                          child:
                              BlocBuilder<PPMStartTimeBloc, PPMStartTimeState>(
                            builder: (context, state) {
                              if (state is PPMStartTimeLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        /* End here */

                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF006BE6), // Blue background color
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Work Orders Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              _buildRow('PPM Task No.', taskNo),
                              _buildRow('Scheduled Date', scheduledDate),
                              _buildRow('Frequency', frequency),
                              _buildRow('Priority', priority),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildRow('Category', category),
                          _buildRow('Sub Category', subCategory),
                          _buildRow('Building', building),
                          _buildRow('Floor', floor),
                          _buildRow('Area', area),
                          _buildRow('Location', location)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF006BE6), // Blue background color
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Asset Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              _buildRow('Asset Name', assetname),
                              _buildRow('Tag No.', assettagno),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // Ensure texts start from the starting point
        crossAxisAlignment: CrossAxisAlignment.center,
        // Align texts vertically centered
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              ": " + value,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
