import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../helpers/utils/utils.dart';
import '../bloc/cm_workstatus_bloc.dart';
import '../bloc/cm_workstatus_event.dart';
import '../bloc/cm_workstatus_state.dart';

class CMWorkStatusView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CMWorkStatus();
  }
}

class CMWorkStatus extends StatefulWidget {
  @override
  _CMWorkStatusViewState createState() => _CMWorkStatusViewState();
}

class _CMWorkStatusViewState extends State<CMWorkStatus> {
  late CMWorkStausBloc cmWorkStausBloc;
  List<CountItem> statusCounts = [];

  @override
  void initState() {
    super.initState();
    cmWorkStausBloc = CMWorkStausBloc(RepositoryProvider.of<ApiService>(context));
    _checkConnectivityAndLoadData();
  }

  Future<void> _checkConnectivityAndLoadData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Utils.showInSnackBar(
        context,
        "No internet connection.",
        ToastType.Error,
      );
    } else {
      cmWorkStausBloc.add(CMWorkStatusCountEvent("Close"));
    }
  }

  @override
  void dispose() {
    cmWorkStausBloc.close();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Hold':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getBackgroundColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.blue.withOpacity(0.1);
      case 'In Progress':
        return Colors.orange.withOpacity(0.1);
      case 'Completed':
        return Colors.green.withOpacity(0.1);
      case 'Hold':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'CM Work Status',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => cmWorkStausBloc,
        child: BlocListener<CMWorkStausBloc, CMWorkStatusState>(
          listener: (context, state) {
            if (state is CMWorkStatusSuccessState) {
              setState(() {
                statusCounts = [
                  CountItem(title: 'Open', count: state.taskModel.count.open, icon: Icons.edit_calendar),
                  CountItem(title: 'In Progress', count: state.taskModel.count.inProgress, icon: Icons.content_paste_go),
                  CountItem(title: 'Completed', count: state.taskModel.count.completed, icon: Icons.paste_rounded),
                  CountItem(title: 'Hold', count: state.taskModel.count.hold, icon: Icons.pending_actions),
                ];
              });
            }
          },
          child: BlocBuilder<CMWorkStausBloc, CMWorkStatusState>(
            builder: (context, state) {
              if (state is CMWorkStatusLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CMWorkStatusFailureState) {
                return Center(child: Text('Error: ${state.loginError}'));
              } else if (state is CMWorkStatusSuccessState) {
                return ListView.builder(
                  itemCount: statusCounts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: Icon(
                          statusCounts[index].icon,
                          size: 30.0,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          statusCounts[index].title,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: getBackgroundColor(statusCounts[index].title),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusCounts[index].count.toString(),
                                style: TextStyle(
                                  color: getStatusColor(statusCounts[index].title),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ],

                        ),
                        onTap: () {
                    // Handle item tap here
                    // For example, navigate to a new screen or show a dialog
                    print('Item tapped: ${statusCounts[index].title}');
                    String type = "";
                    if(statusCounts[index].title == "In Progress"){
                      type  = "InProgress";
                    }
                    else {
                      type  = statusCounts[index].title;
                    }

                    Navigator.pushNamed(context, '/cmview',
                    arguments: {
                    'Type': type,
                    'WorkCount': statusCounts[index].count.toString(),
                    // Add more parameters as needed
                    }
                    );

                    } ),);
                  },
                );
              } else {
                return Center(child: Text('No records found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
class CountItem {
  final String title;
  final int count;
  final IconData icon;

  CountItem({
    required this.title,
    required this.count,
    required this.icon,
  });
}