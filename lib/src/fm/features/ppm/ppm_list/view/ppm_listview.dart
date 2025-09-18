




import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../helpers/utils/utils.dart';
import '../../ppm_submit/model/ppm_submit_save.dart';
import '../bloc/ppm_list_bloc.dart';
import '../bloc/ppm_list_event.dart';
import '../bloc/ppm_list_state.dart';
import '../model/ppm_list_response_model.dart';

class PPMListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PPMListViewState();
  }
}

class PPMListViewState extends StatefulWidget {
  @override
  _PPMListViewState createState() => _PPMListViewState();
}

class _PPMListViewState extends State<PPMListViewState> with SingleTickerProviderStateMixin {
  late PPMListBloc ppmListBloc;
  bool _apiCalled = false;
  String type = "" , workcount = "0";
  List<PPMTask> data = []; // Assuming you have a TaskData model

  @override
  void initState() {
    super.initState();
    ppmListBloc = PPMListBloc(RepositoryProvider.of<ApiService>(context));
   // data  = PPMList.getMockData().ppmTask;

  }

  @override
  void dispose() {
    ppmListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("Type")) {
      final String type_ = args['Type'] as String;
      final String workcount_  = args['WorkCount'] as String;
      if (!_apiCalled) {
        type   = type_;
        workcount = workcount_;
        var connectivityResult =  (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          Utils.showInSnackBar(
            context,
            "No internet connection.",
            ToastType.Error,
          );
        } else {
          _apiCalled = true;
          ppmListBloc.add(PPMListDataEvent(type_));
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
          'PPM  List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => ppmListBloc,
        child: BlocListener<PPMListBloc, PPMListState>(
          listener: (context, state) {
            // Handle state changes
            if (state is PPMListSuccessState) {
              setState(() {
                data = state.taskModel.ppmTask!; // Assuming state.data holds the List<TaskData>
              });
            }
          },
          child: BlocBuilder<PPMListBloc, PPMListState>(
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


                    /* Need to remove the this part once API get - use only mockdata */


                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        PPMTask task = data[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.white,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120, // Fixed width for labels
                                      child: Text("Task No " , style: TextStyle(color: AppColors.primaryColor), ),
                                    ),
                                    Expanded(
                                      child: Text(": "+ task.taskNo!),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120, // Fixed width for labels
                                      child: Text("Date " , style: TextStyle(color: AppColors.primaryColor), ),
                                    ),
                                    Expanded(
                                      child: Text(": "+task.scheduledDate!),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120, // Fixed width for labels
                                      child: Text("Frequency " , style: TextStyle(color: AppColors.primaryColor), ),
                                    ),
                                    Expanded(
                                      child: Text(": "+task.frequency!),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120, // Fixed width for labels
                                      child: Text("Asset Tag No ", style: TextStyle(color: AppColors.primaryColor), ),
                                    ),
                                    Expanded(
                                      child: Text(": "+task.assetTagNo!),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120, // Fixed width for labels
                                      child: Text("Asset Name " , style: TextStyle(color: AppColors.primaryColor), ),
                                    ),
                                    Expanded(
                                      child: Text(": "+task.assetName!),
                                    ),
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

                    /* Mockdata end*/

                    if (state is PPMListLoading)
                      Center(child: CircularProgressIndicator()),
                    if (state is PPMListSuccessState)
                     if(data.isEmpty)
                         Center(
                        child: Text(
                        'No records found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        ),
                    if (state is PPMListFailureState)
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

  void _onTaskTap(BuildContext context, PPMTask task) {
    // Perform any action when an item is clicked
    /* CMSubmitSaveModel cmSubmitSaveModel = CMSubmitSaveModel();
    cmSubmitSaveModel.updateCMWorkOrderID(task.id);
    AppSharedPrefs.get().setCMID(task.id.toString());
*/

    if (type == "Completed") {
      Utils.showInSnackBar(
          context, "This is completed work orders", ToastType.Warning);
    }
    else {
      AppSharedPrefs.get().setPPMID(task.ppmId.toString());
      PPMSubmitSaveModel viewModel = PPMSubmitSaveModel();
      viewModel.resetPPMData();
      Navigator.pushNamed(
        context,
        '/ppmdetails',
        arguments: {
          'PPMID': task.ppmId.toString(),
          // Add more parameters as needed
        },
      );
    }
  }
}