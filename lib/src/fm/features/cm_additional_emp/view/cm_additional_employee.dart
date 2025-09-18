


import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../../../../helpers/utils/utils.dart';
import '../../cm_summary/model/cm_submit_request_model.dart';
import '../../cm_summary/model/cm_submit_save.dart';
import '../bloc/cm_add_emp_bloc.dart';
import '../bloc/cm_add_emp_event.dart';
import '../bloc/cm_add_emp_state.dart';
import '../model/cm_add_emp_response_model.dart';

class CMAdditionalEmployeeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CMAddEmpBloc>(
          create: (context) => CMAddEmpBloc(RepositoryProvider.of<ApiService>(context)),
        ),

      ],
      child: CMAdditionalEmployeeState(),
    );

  }
}

class CMAdditionalEmployeeState extends StatefulWidget {
  @override
  _CMAdditionalEmployeeState createState() => _CMAdditionalEmployeeState();
}

class _CMAdditionalEmployeeState extends State<CMAdditionalEmployeeState> {
  @override
  bool _ApiCalled = false;
  late CMAddEmpBloc cmAddEmpBloc;
  String cmid = "";
  late List<AllEmpList> allemplist = [];
  late List<AssignedEmployeeList> assignedemplist = [];
  String searchText = '';
  CMSubmitSaveModel viewModel = CMSubmitSaveModel();

  // Function to add employee to assigned list
  void addToAssignedList(AllEmpList employee) {
    setState(() {
      allemplist.remove(employee);
      assignedemplist.add(AssignedEmployeeList(id: employee.id, name: employee.name));
      //selectedEmployees.add(employee);
    });
  }

  // Function to remove employee from assigned list
  void removeFromAssignedList(AssignedEmployeeList employee) {
    setState(() {
      assignedemplist.remove(employee);
      allemplist.add(AllEmpList(id: employee.id, name: employee.name));
      //selectedEmployees.removeWhere((emp) => emp.id == employee.id);
    });
  }

  void initState() {
    super.initState();
    cmAddEmpBloc = BlocProvider.of<CMAddEmpBloc>(context);

    try {

      CMSubmitRequestModel cmSubmitRequestModel = viewModel.cmSubmitRequestModel;
      if( cmSubmitRequestModel.assignedEmp != null){
        assignedemplist.addAll(cmSubmitRequestModel.assignedEmp!);
      }

    } on Exception catch (e) {
      // TODO
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
          cmid  = cmID_;
          cmAddEmpBloc.add(CMAddEmpFetchEvent(cmID_)); // Initial fetch
        }
      }
    }
    return BlocProvider(
      create: (context) => cmAddEmpBloc,
      child: WillPopScope(
        onWillPop: () async {
          viewModel.updateCMWorkAdditionalEmp(assignedemplist);
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
              'Additional Force',
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

                    viewModel.updateCMWorkAdditionalEmp(assignedemplist);
                    Navigator.pushNamed(context, '/cmoccupantsign');


                    // Add your button action here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Next',
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
                        BlocListener<CMAddEmpBloc, CMAddEmpState>(
                          listener: (context, state) {
                            if (state is CMAddEmpSuccessState) {
                              setState(() {
                                allemplist.addAll(state.moduleResponse.data);
                                if(assignedemplist.length > 0){
                                  print("Material Added in list");
                                }
                                else {
                                  assignedemplist.addAll(
                                      state.moduleResponse.assignedEmployee);
                                }

                              });
                            } else if (state is CMAddEmpFailureState) {
                              Utils.showInSnackBar(context, state.loginError, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<CMAddEmpBloc, CMAddEmpState>(
                            builder: (context, state) {
                              if (state is CMAddEmpLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),


                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF006BE6), // Blue background color
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Assigned Employee List',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        /* List show inside the card Assigned Emp*/

                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: assignedemplist.length > 0 ? assignedemplist.length : 1,
                          itemBuilder: (context, index) {
                            if (assignedemplist.isEmpty) {
                              return Center(
                                child: Text(
                                  'No records found',
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            } else {
                              AssignedEmployeeList employee = assignedemplist[index];
                              return ListTile(
                                title: Text(employee.name),
                                // subtitle: Text('ID: ${employee.id.toString()}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    removeFromAssignedList(employee);
                                  },
                                ),
                              );
                            }
                          },
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
                            'All Employee List',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        /* All emplyee list will show here */

                        // Search TextField
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchText = value.toLowerCase();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // Filtered List
                        // Filtered List
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: allemplist.length,
                          itemBuilder: (context, index) {
                            AllEmpList employee = allemplist[index];
                            // Apply search filter
                            if (searchText.isEmpty ||
                                employee.name.toLowerCase().contains(searchText)) {
                              return ListTile(
                                title: Text(employee.name),
                                //subtitle: Text('ID: ${employee.id.toString()}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    addToAssignedList(employee);
                                  },
                                ),
                              );
                            } else {
                              return Container(); // Return empty container if not matching
                            }
                          },
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
}
