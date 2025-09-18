import 'package:cmms/src/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../cm_summary/model/cm_submit_request_model.dart';
import '../../cm_summary/model/cm_submit_save.dart';
import '../bloc/cmdetails_bloc.dart';
import '../bloc/cmdetails_event.dart';
import '../bloc/cmdetails_state.dart';
import '../bloc/start_time_update/starttime_bloc.dart';
import '../bloc/start_time_update/starttime_event.dart';
import '../bloc/start_time_update/starttime_state.dart';

class CMDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CMDetailsBloc>(
          create: (context) => CMDetailsBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<StartTimeBloc>(
          create: (context) => StartTimeBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: CMDetailsViewState(),
    );

  }
}

class CMDetailsViewState extends StatefulWidget {
  @override
  _CMDetailsViewState createState() => _CMDetailsViewState();
}

class _CMDetailsViewState extends State<CMDetailsViewState> {
  @override
  bool _ApiCalled = false;
  late CMDetailsBloc cmDetailsBloc;
  late StartTimeBloc startTimeBloc;
  String taskNo = "", createdDate = "" , description = "" ,natureOfComplaint = "",
  priority = "" ,location = "" , building = "" ,floor = "" , area = "" , responseTime = "",
  fixTime = "" , assetname = "" , assettagno = "";
  String cmid = "";
  String startTime = "";
  CMSubmitSaveModel viewModel = CMSubmitSaveModel();


  void initState() {
    super.initState();
    cmDetailsBloc = BlocProvider.of<CMDetailsBloc>(context);
    startTimeBloc  = BlocProvider.of<StartTimeBloc>(context);

    CMSubmitRequestModel faultReportSaveModel = viewModel.cmSubmitRequestModel;
    if( faultReportSaveModel.startTime != null){
      startTime = faultReportSaveModel.startTime!;
    }

  }

  @override
  void dispose() {
    super.dispose();
    getSharedPrefe();
  }

  Future<void> getSharedPrefe() async {
    cmid = await AppSharedPrefs.getCMID();
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("CMID")) {
      final String cmID_ = args['CMID'] as String;
      if(!_ApiCalled){
        var connectivityResult =  (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          Utils.showInSnackBar(
            context,
            "No internet connection.",
            ToastType.Error,
          );
        } else {
          _ApiCalled = true;
          cmid = cmID_;
          cmDetailsBloc.add(CMDetailsFetchEvent(cmID_)); // Initial fetch
        }
      }
    }
    return BlocProvider(
      create: (context) => cmDetailsBloc,
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
            'CM Details',
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
                  String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);
                  if(startTime.isEmpty){
                    startTime = formattedDate;
                    viewModel.updateCMWorkOrderStartTime(formattedDate , );
                    var connectivityResult =  (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                    Utils.showInSnackBar(
                    context,
                    "No internet connection.",
                    ToastType.Error,
                    );
                    } else {
                      startTimeBloc.add(
                          StartTimeFetchEvent(formattedDate, cmid));
                    }
                  }
                  else {
                    Navigator.pushNamed(context, '/cmbeforeimage');
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



                      BlocListener<CMDetailsBloc, CMDetailsState>(
                        listener: (context, state) {
                          if (state is CMDetailsSuccessState) {
                            setState(() {
                              taskNo = state.moduleResponse.data.taskNo ;
                              createdDate = state.moduleResponse.data.createdDate;
                              description = state.moduleResponse.data.description;
                              natureOfComplaint = state.moduleResponse.data.natureOfComplaint;
                              priority = state.moduleResponse.data.priority ;
                              location =  state.moduleResponse.data.location;
                              building = state.moduleResponse.data.building;
                              floor = state.moduleResponse.data.floor;
                              area = state.moduleResponse.data.area;
                              responseTime = state.moduleResponse.data.responseTime;
                              fixTime = state.moduleResponse.data.fixTime;
                              assetname  = state.moduleResponse.data.assetName;
                              assettagno  = state.moduleResponse.data.assetTagNo;
                            });
                          } else if (state is CMDetailsFailureState) {
                            Utils.showInSnackBar(context, state.loginError, ToastType.Warning);
                          }
                        },
                        child: BlocBuilder<CMDetailsBloc, CMDetailsState>(
                          builder: (context, state) {
                            if (state is CMDetailsLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),


                      /* Start Time and Status Update API */
                      BlocListener<StartTimeBloc, StartTimeState>(
                        listener: (context, state) {
                          if (state is StartTimeSuccessState) {

                              Utils.showInSnackBar(context,  state.moduleResponse.message, ToastType.Success);
                              Navigator.pushNamed(context, '/cmbeforeimage');

                          } else if (state is StartTimeFailureState) {
                            Utils.showInSnackBar(context, state.error, ToastType.Warning);
                          }
                        },
                        child: BlocBuilder<StartTimeBloc, StartTimeState>(
                          builder: (context, state) {
                            if (state is StartTimeLoading) {
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
                            _buildRow('Wo No.', taskNo),
                            _buildRow('Created Date', createdDate),
                            _buildRow('Nature of Complaint', natureOfComplaint),
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
                        _buildRow('Location', location),
                        _buildRow(
                            'Building', building),
                        _buildRow('Floor', floor),
                        _buildRow('Area', area),
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
                          'SLA Details',
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
                            _buildRow('Response Time', responseTime),
                            _buildRow('Fix Time', fixTime),
                          ],
                        ),
                      ),
                    ],
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
      ), );
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
