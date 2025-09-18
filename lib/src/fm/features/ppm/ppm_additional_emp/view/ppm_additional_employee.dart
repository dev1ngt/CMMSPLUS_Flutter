


import 'package:cmms/src/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../../../../../helpers/utils/app_shared_preference.dart';
import '../../../../../helpers/utils/utils.dart';
import '../../ppm_submit/model/ppm_submit_request_model.dart';
import '../../ppm_submit/model/ppm_submit_save.dart';
import '../bloc/ppm_add_emp_bloc.dart';

import '../bloc/ppm_add_emp_event.dart';
import '../bloc/ppm_add_emp_state.dart';
import '../model/ppm_add_emp_response_model.dart';



class PPMAdditionalEmployeeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PPMAddEmpBloc>(
          create: (context) => PPMAddEmpBloc(RepositoryProvider.of<ApiService>(context)),
        ),

      ],
      child: PPMAdditionalEmployeeState(),
    );

  }
}

class PPMAdditionalEmployeeState extends StatefulWidget {
  @override
  _PPMAdditionalEmployeeState createState() => _PPMAdditionalEmployeeState();
}

class _PPMAdditionalEmployeeState extends State<PPMAdditionalEmployeeState> {
  @override
  bool _ApiCalled = false;
  late PPMAddEmpBloc ppmAddEmpBloc;
  String cmid = "";
  late List<PPMAllEmpList> allemplist = [];
  late List<PPMAssignedEmployeeList> assignedemplist = [];
  String searchText = '';
  PPMSubmitSaveModel submitSaveModel = PPMSubmitSaveModel();

  final PPMAdditionalEmployeeModel ppmAdditionalEmpModel = PPMAdditionalEmployeeModel.mockData();

  // Function to add employee to assigned list
  void addToAssignedList(PPMAllEmpList employee) {
    setState(() {
      allemplist.remove(employee);
      assignedemplist.add(PPMAssignedEmployeeList(id: employee.id, name: employee.name));
      //selectedEmployees.add(employee);
    });
  }

  // Function to remove employee from assigned list
  void removeFromAssignedList(PPMAssignedEmployeeList employee) {
    setState(() {
      assignedemplist.remove(employee);
      allemplist.add(PPMAllEmpList(id: employee.id, name: employee.name));
      //selectedEmployees.removeWhere((emp) => emp.id == employee.id);
    });
  }

  void initState() {
    super.initState();
    ppmAddEmpBloc = BlocProvider.of<PPMAddEmpBloc>(context);

    try {

     /* allemplist  = ppmAdditionalEmpModel.data;
      assignedemplist  = ppmAdditionalEmpModel.assignedEmployee;*/
      PPMSubmitRequestModelOne ppmSubmitRequestModel = submitSaveModel.ppmSubmitRequestModel;
      if( ppmSubmitRequestModel.assignedEmp != null){
        assignedemplist.addAll(ppmSubmitRequestModel.assignedEmp!);
      }

    } on Exception catch (e) {
      // TODO
    }

  }

  @override
  void dispose() {
    super.dispose();
    ppmAddEmpBloc.close();
  }

  Future<void> getSharedPrefe() async {
    cmid = await AppSharedPrefs.getCMID();
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("PPMID")) {
      final String ppmid = args['PPMID'] as String;
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
          ppmAddEmpBloc.add(PPMAddEmpFetchEvent(ppmid)); // Initial fetch
        }
      }
    }
    return BlocProvider(
      create: (context) => ppmAddEmpBloc,
      child: WillPopScope(
        onWillPop: () async {
          submitSaveModel.updateAdditionalEmployee(assignedemplist);
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

                    submitSaveModel.updateAdditionalEmployee(assignedemplist);
                    Navigator.pushNamed(context, '/ppmsubmit');
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
                        BlocListener<PPMAddEmpBloc, PPMAddEmpState>(
                          listener: (context, state) {
                            if (state is PPMAddEmpSuccessState) {
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
                            } else if (state is PPMAddEmpFailureState) {
                              Utils.showInSnackBar(context, state.loginError, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<PPMAddEmpBloc, PPMAddEmpState>(
                            builder: (context, state) {
                              if (state is PPMAddEmpLoading) {
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
                              PPMAssignedEmployeeList employee = assignedemplist[index];
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
                            PPMAllEmpList employee = allemplist[index];
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
