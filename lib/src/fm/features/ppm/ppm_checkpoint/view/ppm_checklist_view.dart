import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../helpers/utils/utils.dart';
import '../../ppm_submit/model/ppm_submit_request_model.dart';
import '../../ppm_submit/model/ppm_submit_save.dart';
import '../bloc/ppm_checkpoint_bloc.dart';
import '../bloc/ppm_checkpoint_event.dart';
import '../bloc/ppm_checkpoint_state.dart';
import '../model/ppm_checklist_response_model.dart';

class PPMChecklistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PPMChecklistScreen();
  }
}

class PPMChecklistScreen extends StatefulWidget {
  @override
  _PPMChecklistScreenState createState() => _PPMChecklistScreenState();
}

class _PPMChecklistScreenState extends State<PPMChecklistScreen> {
//  final PPMChecklistModel ppmChecklistModel = PPMChecklistModel.mockData();

  // Maintain a list of selected checkpoints
  final List<int> selectedCheckpoints = [];
  bool isSelectAllChecked = false;
  late String selectedStatus = "";
  late String remarks = "";
  late String values = "";
  int selectedIndex = -1;
  late PPMCheckpointBloc ppmCheckpointBloc;
  bool _ApiCalled = false;
  List<PPMCheckList> ppmChecklist = [];
  List<PPMCheckStatus> ppmCheckstatus = [];
  int totalcount = 0;
  PPMSubmitSaveModel submitSaveModel = PPMSubmitSaveModel();

  @override
  void initState() {
    super.initState();

    ppmCheckpointBloc =
        PPMCheckpointBloc(RepositoryProvider.of<ApiService>(context));

    try {
      PPMSubmitRequestModelOne ppmSubmitRequestModel =
          submitSaveModel.ppmSubmitRequestModel;
      if (ppmSubmitRequestModel.ppmCheckpoints != null) {
        ppmChecklist.addAll(ppmSubmitRequestModel.ppmCheckpoints!);
      }
    } on Exception catch (e) {
      // TODO
    }
  }


  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF006BE6),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '    ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Alert',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Be aware, you are about to update all checkpoints.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            DropdownButtonFormField<PPMCheckStatus>(
                              isExpanded: true,
                              value: selectedIndex != -1
                                  ? ppmCheckstatus[selectedIndex]
                                  : null,
                              hint: Text('Select Status'),
                              items:
                                  ppmCheckstatus.map((PPMCheckStatus status) {
                                return DropdownMenuItem<PPMCheckStatus>(
                                  value: status,
                                  child: Text(status.checkStatusName),
                                );
                              }).toList(),
                              onChanged: (PPMCheckStatus? newValue) {
                                setState(() {
                                  selectedStatus = newValue!.checkStatusName;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Select Status',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Remarks',
                                labelText: 'Remarks',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.comment,
                                    color: Color(0xFF006BE6)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  remarks = value;
                                });
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Values',
                                labelText: 'Values',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.note_alt_sharp,
                                    color: Color(0xFF006BE6)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  values = value;
                                });
                              },
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                // Update ppmChecklistModel.ppmChecklist list

                                if (selectedStatus.isEmpty) {
                                  Utils.showInSnackBar(
                                      context,
                                      "Please select a status",
                                      ToastType.Warning);
                                } else {
                                  setState(() {
                                    for (var checkpoint in ppmChecklist) {
                                      if (selectedCheckpoints
                                          .contains(checkpoint.checkpointID)) {
                                        checkpoint.statusName = selectedStatus;
                                        checkpoint.remarks = remarks;
                                        checkpoint.readingValue = values;
                                      }
                                    }
                                  });
                                  // Close the bottom sheet and pass the updated list back
                                  Navigator.pop(context, ppmChecklist);
                                }
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: Color(0xFF006BE6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((updatedChecklist) {
      if (updatedChecklist != null) {
        setState(() {
          ppmChecklist = updatedChecklist;
        });
      }
    });
    ;
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      isSelectAllChecked = value ?? false;
      selectedCheckpoints.clear();
      if (isSelectAllChecked) {
        selectedCheckpoints.addAll(ppmChecklist.map((e) => e.checkpointID));
        _showBottomSheet(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("PPMID")) {
      final String ppmID_ = args['PPMID'] as String;
      if (!_ApiCalled) {
        var connectivityResult =  (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          Utils.showInSnackBar(
            context,
            "No internet connection.",
            ToastType.Error,
          );
        } else {
          _ApiCalled = true;
          ppmCheckpointBloc.add(
              PPMCheckpointFetchEvent(ppmID_)); // Initial fetch
        }
      }
    }

    return BlocProvider(
      create: (context) => ppmCheckpointBloc,
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
              'PPM CheckList',
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
                     // Check for mandatory checkpoints with status "Not Done" or "Not Applicable"
                    bool canNavigate = true;
                    for (var checkpoint in ppmChecklist) {
                      if (checkpoint.isMandatory == 1 &&
                          (checkpoint.statusName == "Not Done" ||
                              checkpoint.statusName == "Not Applicable")) {
                        canNavigate = false;
                        break;
                      }
                    }

                    if (canNavigate) {
                      submitSaveModel.updatePPmCheckpointList(ppmChecklist);
                      Navigator.pushNamed(context, '/ppmafterimages');
                    } else {
                      Utils.showInSnackBar(
                          context, "Please complete all mandatory checkpoints before proceeding.", ToastType.Warning);
                    }
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
          body: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
            child: Column(
              children: [
                // Display total count at the top inside a card
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Count: ${totalcount}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: <Widget>[
                                Text('ALL',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                Checkbox(
                                  value: isSelectAllChecked,
                                  onChanged: _toggleSelectAll,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                BlocListener<PPMCheckpointBloc, PPMCheckpointState>(
                  listener: (context, state) {
                    if (state is PPMCheckpointSuccessState) {
                      setState(() {
                        if (ppmChecklist.length > 0) {
                        } else {
                          ppmChecklist = state.moduleResponse.ppmChecklist;
                          ppmCheckstatus = state.moduleResponse.ppmCheckstatus;
                          totalcount = state.moduleResponse.totalCount;
                        }
                      });
                    } else if (state is PPMCheckpointFailureState) {
                      Utils.showInSnackBar(
                          context, state.loginError, ToastType.Warning);
                    }
                  },
                  child: BlocBuilder<PPMCheckpointBloc, PPMCheckpointState>(
                    builder: (context, state) {
                      if (state is PPMCheckpointLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                    },
                  ),
                ),

                // Expanded ListView to fit the remaining space
                Expanded(
                  child: ppmChecklist.isEmpty
                      ? Center(
                          child: Text(
                            'No records found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: ppmChecklist.length,
                          itemBuilder: (context, index) {
                            final checkpoint = ppmChecklist[index];
                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            checkpoint.checkpointName,
                                            softWrap: true,
                                            maxLines: 5,
                                            // You can adjust the max lines as per your need
                                            overflow: TextOverflow
                                                .ellipsis, // This will add ellipsis if the text exceeds the max lines
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      checkpoint.statusName,
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (checkpoint.isMandatory == 1
                                            ? Colors.red.withOpacity(0.1)
                                            : Colors.green.withOpacity(0.1)),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        checkpoint.isMandatory == 1
                                            ? 'Mandatory'
                                            : 'Non Mandatory',
                                        style: TextStyle(
                                          color: (checkpoint.isMandatory == 1
                                              ? Colors.red
                                              : Colors.green),
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: selectedCheckpoints
                                          .contains(checkpoint.checkpointID),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedCheckpoints
                                                .add(checkpoint.checkpointID);
                                          } else {
                                            selectedCheckpoints.remove(
                                                checkpoint.checkpointID);
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Handle row tap and navigate to detail screen

                                  Navigator.pushNamed(
                                      context, '/ppmcheckdetails',
                                      arguments: {
                                        'ppmChecklist': ppmChecklist,
                                        'ppmCheckstatus': ppmCheckstatus,
                                        'initialIndex': index,
                                      });
                                },
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
