import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




import '../../../../helpers/utils/appcolors.dart';
import '../../../../helpers/utils/utils.dart';

import '../../cm_summary/model/cm_submit_save.dart';
import '../bloc/cmlist_bloc.dart';
import '../bloc/cmlist_event.dart';
import '../bloc/cmlist_state.dart';
import '../model/cm_model_response.dart';

class CMView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CMViewState();
  }
}

class CMViewState extends StatefulWidget {
  @override
  _CMViewState createState() => _CMViewState();
}

class _CMViewState extends State<CMViewState> with SingleTickerProviderStateMixin {
  late CMListBloc cmListBloc;
  bool _apiCalled = false;
  String type = "" , workcount = "0";
  List<TaskData> data = []; // Assuming you have a TaskData model

  @override
  void initState() {
    super.initState();
    cmListBloc = CMListBloc(RepositoryProvider.of<ApiService>(context));
    //cmListBloc.add(CMListCountEvent("Open"));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("Type")) {
      final String type_ = args['Type'] as String;
      final String workcount_  = args['WorkCount'] as String;
      if (!_apiCalled) {

        var connectivityResult =  (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          Utils.showInSnackBar(
            context,
            "No internet connection.",
            ToastType.Error,
          );
        } else {
          type   = type_;
          print(type);
          workcount = workcount_;
          _apiCalled = true;
          cmListBloc.add(CMListCountEvent(type_));
        }
      }
    }

    return Scaffold(
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
          'CM List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => cmListBloc,
        child: BlocListener<CMListBloc, CMListState>(
          listener: (context, state) {
            // Handle state changes
            if (state is CMListSuccessState) {
              setState(() {
                data = state.taskModel.data; // Assuming state.data holds the List<TaskData>
              });
            }
          },
          child: BlocBuilder<CMListBloc, CMListState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Static card at the top
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
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Work Status',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                              Text(
                                'Stage:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),),
                                SizedBox(width: 10),
                              Text(
                                type,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),),

                                SizedBox(width: 10),

                              Text(
                                 '(' + workcount + ')',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),),



                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (state is CMListLoading)
                      Center(child: CircularProgressIndicator()),
                    if (state is CMListSuccessState)
                      data.isEmpty
                          ? Center(child: Text('No records found.', style: TextStyle(fontSize: 18, color: Colors.grey)))
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          TaskData task = data[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            color: Colors.white,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.assignment, color: AppColors.primaryColor),
                                      SizedBox(width: 8),
                                      Text(task.taskNo),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.comment, color: AppColors.primaryColor),
                                      SizedBox(width: 8),
                                      Text(task.natureOfComplaint),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.date_range, color: AppColors.primaryColor),
                                      SizedBox(width: 8),
                                      Text(task.createdDate),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.graphic_eq, color: AppColors.primaryColor),
                                      SizedBox(width: 8),
                                      Text(task.priority),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
                                ],
                              ),
                              isThreeLine: false,
                              onTap: () {
                                _onTaskTap(context, task);
                              },
                            ),
                          );
                        },
                      ),
                    if (state is CMListFailureState)
                      Center(child: Text('An error occurred!')),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onTaskTap(BuildContext context, TaskData task) {
    // Perform any action when an item is clicked


    if (type == "Completed") {
      Utils.showInSnackBar(context, "This is completed work orders", ToastType.Warning);
    }
    else {
      CMSubmitSaveModel cmSubmitSaveModel = CMSubmitSaveModel();
      cmSubmitSaveModel.resetCMData();
      cmSubmitSaveModel.updateCMWorkOrderID(task.id);
      AppSharedPrefs.get().setCMID(task.id.toString());

      Navigator.pushNamed(
        context,
        '/cmdetailsview',
        arguments: {
          'CMID': task.id.toString(),
          // Add more parameters as needed
        },
      );
    }
  }
}