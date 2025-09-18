


import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../cm_additional_emp/model/cm_add_emp_response_model.dart';
import '../../cm_summary/model/cm_submit_request_model.dart';
import '../../cm_summary/model/cm_submit_save.dart';
import '../bloc/cm_material_bloc.dart';
import '../bloc/cm_material_event.dart';
import '../bloc/cm_material_state.dart';
import '../model/cm_material_response_model.dart';

class CMMaterialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CMMaterialBloc>(
          create: (context) => CMMaterialBloc(RepositoryProvider.of<ApiService>(context)),
        ),

      ],
      child: CMMaterialState(),
    );

  }
}

class CMMaterialState extends StatefulWidget {
  @override
  _CMMaterialState createState() => _CMMaterialState();
}

class _CMMaterialState extends State<CMMaterialState> {
  @override
  bool _ApiCalled = false;
  late CMMaterialBloc cmMaterialBloc;
  String cmid = "";
  late List<AllEmpListI> allemplist = [];
  late List<AssignedEmployeeListI> assignedemplist = [];
  String searchText = '';
  CMSubmitSaveModel viewModel = CMSubmitSaveModel();

  // Function to add employee to assigned list
  void addToAssignedList(AllEmpListI employee, int count) {
    setState(() {
      allemplist.remove(employee);
      assignedemplist.add(AssignedEmployeeListI(id: employee.id, name: employee.name));
      //selectedEmployees.add(employee);
    });
  }

  // Function to remove employee from assigned list
  void removeFromAssignedList(AssignedEmployeeListI employee) {
    setState(() {
      assignedemplist.remove(employee);
      allemplist.add(AllEmpListI(id: employee.id, name: employee.name));
      //selectedEmployees.removeWhere((emp) => emp.id == employee.id);
    });
  }

  void initState() {
    super.initState();
    cmMaterialBloc = BlocProvider.of<CMMaterialBloc>(context);

    try {

   /*   CMSubmitRequestModel cmSubmitRequestModel = viewModel.cmSubmitRequestModel;
      if( cmSubmitRequestModel.assignedEmp != null){
        assignedemplist.addAll(cmSubmitRequestModel.assignedEmp!);
      }*/

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
        _ApiCalled = true;
        cmid  = cmID_;
        cmMaterialBloc.add(CMMaterialFetchEvent(cmID_)); // Initial fetch
      }
    }
    return BlocProvider(
      create: (context) => cmMaterialBloc,
      child: WillPopScope(
        onWillPop: () async {
          //viewModel.updateCMWorkAdditionalEmp(assignedemplist);
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
              'Material View',
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

                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Request',
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
                        BlocListener<CMMaterialBloc, CMMaterialStateI>(
                          listener: (context, state) {
                            if (state is CMMaterialSuccessState) {
                              setState(() {
                                allemplist.addAll(state.moduleResponse.data);
                                assignedemplist.addAll(state.moduleResponse.assignedEmployee);

                              });
                            } else if (state is CMMaterialFailureState) {
                              Utils.showInSnackBar(context, state.materialError, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<CMMaterialBloc, CMMaterialStateI>(
                            builder: (context, state) {
                              if (state is CMMaterialLoading) {
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
                            'Selected Materials',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        /* List show inside the card Assigned Emp*/

                        Container(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Req Qty',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Action',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

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
                              AssignedEmployeeListI employee = assignedemplist[index];
                              return ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: employee.name,
                                        style: TextStyle(color: Colors.black), // Adjust the style as needed
                                      ),
                                    ],
                                  ),
                                ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor, // Set the light green background color here
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.grey, // Set the color of the outline here
                                            width: 1, // Set the width of the outline here
                                          ),
                                        ),
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                            color: Colors.black, // Set the dark font color here
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 25),
                                      IconButton(
                                        icon: Icon(Icons.delete_forever_outlined ,color:AppColors.primaryColor , ),
                                        onPressed: () {
                                          removeFromAssignedList(employee);
                                        },
                                      ),
                                    ],

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
                            'All Materials',
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
                        Container(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Available Stock',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Action',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: allemplist.length,
                          itemBuilder: (context, index) {
                            AllEmpListI employee = allemplist[index];
                            // Apply search filter
                            if (searchText.isEmpty ||
                                employee.name.toLowerCase().contains(searchText)) {
                              return ListTile(
                                title: Text(employee.name),
                                //subtitle: Text('ID: ${employee.id.toString()}'),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor, // Set the light green background color here
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.grey, // Set the color of the outline here
                                          width: 1, // Set the width of the outline here
                                        ),
                                      ),
                                      child: Text(
                                        '50',
                                        style: TextStyle(
                                          color: Colors.black, // Set the dark font color here
                                          fontSize: 14,

                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 25),
                                    IconButton(
                                      icon: Icon(Icons.add , color: AppColors.primaryColor,),
                                      onPressed: () {
                                        //addToAssignedList(employee);
                                        _showBottomSheet(context , employee , "Tools 12 SD" , 50);
                                      },
                                    ),
                                  ],
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

  void _showBottomSheet(BuildContext context, AllEmpListI employee, String materialName, int totalStockQty) {
    // Counter value
    int _count = 1;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              employee.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Total Stock: $totalStockQty',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                     /* Text(
                        employee.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red, // Background color for the button
                            ),
                            child: IconButton(
                              icon: Icon(Icons.remove, color: Colors.white), // Icon color
                              onPressed: () {
                                if (_count > 1) {
                                  setState(() {
                                    _count--;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 20), // Spacing between buttons and count
                          Text(
                            '$_count',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20), // Spacing between buttons and count
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green, // Background color for the button
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add, color: Colors.white), // Icon color
                              onPressed: () {
                                if (_count < totalStockQty) {
                                  setState(() {
                                    _count++;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Add the employee with the selected count to the assigned list
                          // You can modify the `addToAssignedList` method to accept a count
                          addToAssignedList(employee, _count);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: AppColors.primaryColor, // Color of the text and icon
                        ),
                        child: Text('ADD TO LIST'),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    top: 5,
                    child: Container(
                      width: 45, // Increase width
                      height: 45, // Increase height
                      child: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 35, // Increase icon size
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

