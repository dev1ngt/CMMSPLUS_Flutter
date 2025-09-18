import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../cm_summary/model/cm_submit_request_model.dart';
import '../../cm_summary/model/cm_submit_save.dart';
import '../bloc/root_cause_state.dart';
import '../bloc/rootcause_bloc.dart';
import '../bloc/rootcause_event.dart';
import '../model/rootcause_response_model.dart';

class CMAnalysisDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RootCauseBloc>(
          create: (context) => RootCauseBloc(RepositoryProvider.of<ApiService>(context)),
        ),

      ],
      child: CMAnalysisDetailsState(),
    );

  }
}

class CMAnalysisDetailsState extends StatefulWidget {
  @override
  _CMAnalysisDetailsState createState() => _CMAnalysisDetailsState();
}

class _CMAnalysisDetailsState extends State<CMAnalysisDetailsState> {
  String cmid = "";
  TextEditingController rootcause_controller = TextEditingController();
  TextEditingController observation_controller = TextEditingController();
  int rootCasueID = 0;
  late List<RootCauseDetail> rootCauseDetails = [];
  late RootCauseBloc rootCauseBloc;
  bool _ApiCalled =  false;
  CMSubmitSaveModel cmSubmitSaveModel = CMSubmitSaveModel();

  @override
  void initState() {
    super.initState();
    getSharedPrefe();

    try {
      CMSubmitRequestModel cmSubmitRequestModel = cmSubmitSaveModel.cmSubmitRequestModel;
      if( cmSubmitRequestModel.rootCauseName != null){
        rootcause_controller.text = cmSubmitRequestModel.rootCauseName!;
        observation_controller.text = cmSubmitRequestModel.observation!;
        print("observation " + cmSubmitRequestModel.rootCauseName!);
      }

    } on Exception catch (e) {
      // TODO
    }

    var connectivityResult =  (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Utils.showInSnackBar(
        context,
        "No internet connection.",
        ToastType.Error,
      );
    } else {
      rootCauseBloc = BlocProvider.of<RootCauseBloc>(context);
      rootCauseBloc.add(RootCauseFetchEvent());
    }
  }

  Future<void> getSharedPrefe() async {
    cmid = await AppSharedPrefs.getCMID();
    setState(() {});
  }

  @override
  void dispose() {
    rootcause_controller.dispose();
    observation_controller.dispose();
    super.dispose();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Analysis Detail(s)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('dd-MM-yyyy').format(now);
                print(formattedDate);
                print(cmid);

                 if(observation_controller.text.isEmpty){
                   Utils.showInSnackBar(context,  "Enter the observation" , ToastType.Error);
                }
                else if(rootcause_controller.text.isEmpty){
                  Utils.showInSnackBar(context,  "Enter the root cause" , ToastType.Error);
                }
                else {

                   cmSubmitSaveModel.updateCMWorkOrderObservationRootcause(observation_controller.text, rootcause_controller.text , rootCasueID);
                   Navigator.pushNamed(context, '/cmpostimages');
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
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF006BE6), // Blue background color
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Observation * ',
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
                          Expanded(
                            child: SizedBox(
                              height: 200, // Fixed height for the TextFormField container
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primaryColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextFormField(
                                  controller: observation_controller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
                        'Root Cause  *',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                controller: rootcause_controller,
                                decoration: InputDecoration(
                                  labelText: 'Enter Root Cause',
                                  suffixIcon: Autocomplete<RootCauseDetail>(
                                    displayStringForOption: (RootCauseDetail option) => option.name,
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return const Iterable<RootCauseDetail>.empty();
                                      }
                                      return rootCauseDetails.where((RootCauseDetail option) {
                                        return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                      });
                                    },
                                    onSelected: (RootCauseDetail selection) {
                                      setState(() {
                                        rootcause_controller.text = selection.name;
                                        rootCasueID  = selection.id;
                                        // phone_controller.text = selection.customerMobno;
                                        // address_controller.text = selection.customerAddress;
                                        // customerID = int.parse(selection.customerIDPK);
                                      });
                                      debugPrint('You just selected ${selection.name}');
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          labelText: 'Select Root Cause',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                                          ),
                                        ),
                                        onFieldSubmitted: (String value) {
                                          onFieldSubmitted();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),


              /* Root Cause*/
              BlocListener<RootCauseBloc, RootCauseState>(
                listener: (context, state) {
                  if (state is RootCauseLoaded) {

                    setState(() {
                      rootCauseDetails.addAll(state.rootcause.data);
                    });

                  } else if (state is RootCauseError) {
                    Utils.showInSnackBar(context, state.error, ToastType.Warning);
                  }
                },
                child: BlocBuilder<RootCauseBloc, RootCauseState>(
                  builder: (context, state) {
                    if (state is RootCauseInProgress) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container();
                  },
                ),
              ),


            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating action button press
          _showMenu(context);
        },
        backgroundColor: Color(0xFF006BE6),
        child: Icon(Icons.more_horiz_sharp , color: AppColors.whiteColor,),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    final RenderBox fabRenderBox = context.findRenderObject() as RenderBox;
    final Offset fabOffset = fabRenderBox.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      fabOffset.dx,
      fabOffset.dy - fabRenderBox.size.height, // Position menu above the FAB
      fabOffset.dx + fabRenderBox.size.width,
      fabOffset.dy, // Bottom position set to the FAB's top position
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: Text('Material Request'),
          value: 1,
        ),
        PopupMenuItem(
          child: Text('Hold'),
          value: 2,
        ),

      ],
    ).then((value) {
      if (value != null) {
        // Handle menu item selection if needed
        switch (value) {
          case 1:
          // Handle Option 1

        Navigator.pushNamed(context, '/cmmaterialview' ,
        arguments: {
        'CMID': "1",
                  },);

            break;
          case 2:
          // Handle Option 2
            break;

        }
      }
    });
  }
}

