import 'package:cmms/src/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../../../../../helpers/utils/app_shared_preference.dart';
import '../../../../../helpers/utils/utils.dart';
import '../bloc/complaint_reg_bloc.dart';
import '../bloc/complaint_reg_event.dart';
import '../bloc/complaint_reg_state.dart';
import '../model/complaint_reg_response_model.dart';
import 'ComplaintHelper.dart';

class ComplaintRegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ComplaintRegisterBloc>(
          create: (context) =>
              ComplaintRegisterBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: ComplaintRegister(),
    );
  }
}

class ComplaintRegister extends StatefulWidget {
  @override
  _ComplaintRegisterState createState() => _ComplaintRegisterState();
}

class _ComplaintRegisterState extends State<ComplaintRegister> {
  String userid = "";
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _issuesController = TextEditingController();
  int selection_location_id = 0;
  late List<Complainer> complaintRegDetList = [];
  late List<NatureOfComplaint> natureofComplaint = [];
  late ComplaintRegisterBloc complaintRegisterBloc;
  String selectedNatureOfComplaint = "" , selectedRequesterName = "";
  int selected_requester_id = 0;
  int selected_nature_of_complaint = 0;
  ComplaintSubmitInput complaintSubmitInput = ComplaintSubmitInput();

  @override
  void initState() {
    super.initState();
    getSharedPrefe();

    var connectivityResult = (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Utils.showInSnackBar(
        context,
        "No internet connection.",
        ToastType.Error,
      );
    } else {
      complaintRegisterBloc = BlocProvider.of<ComplaintRegisterBloc>(context);
      complaintRegisterBloc.add(ComplaintRegisterFetchEvent());
    }
  }

  Future<void> getSharedPrefe() async {
    userid = await AppSharedPrefs.getUserID();
    setState(() {});
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _issuesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color customColor1 = Color(0xFF006BE6);
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
              'Complaint Registry',
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

                if (selectedRequesterName.isEmpty) {
                  Utils.showInSnackBar(
                      context, "Please select the requestor's name.", ToastType.Warning);
                } else if (selectedNatureOfComplaint.isEmpty) {
                  Utils.showInSnackBar(
                      context, "Please select the nature of the complaint.", ToastType.Warning);
                }else if (_issuesController.text.isEmpty) {
                  Utils.showInSnackBar(
                      context, "Please enter your complaint.", ToastType.Warning);
                }

                else {
                  // Add your submission logic here
                  complaintSubmitInput.natureofcomplaint_id = selected_nature_of_complaint;
                  complaintSubmitInput.description  = _issuesController.text;
                  complaintSubmitInput.complainer_id = selected_requester_id;
                  complaintSubmitInput.user_id  = int.parse(userid);

                  complaintRegisterBloc.add(ComplaintRegisterSubmitEvent(complaintSubmitInput));

                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Submit',
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



                    /* Root Cause*/
                    BlocListener<ComplaintRegisterBloc, ComplaintRegisterState>(
                      listener: (context, state) {
                        if (state is ComplaintRegisterLoaded) {
                          setState(() {
                            //  rootCauseDetails.addAll(state.rootcause.data);
                            complaintRegDetList.addAll(state.complaintreg.complainer);
                            natureofComplaint.addAll(state.complaintreg.natureOfComplaints);

                          });
                        } else if (state is ComplaintRegisterError) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<ComplaintRegisterBloc,
                          ComplaintRegisterState>(
                        builder: (context, state) {
                          if (state is ComplaintRegisterInProgress) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),


                   /* Submit */

                    /* Root Cause*/
                    BlocListener<ComplaintRegisterBloc, ComplaintRegisterState>(
                      listener: (context, state) {
                        if (state is ComplaintRegisterSubmitLoaded) {

                          Utils.showInSnackBar(
                              context, state.complaintreg.message!, ToastType.Success);

                          Navigator.pushNamed(context, '/dashboard');


                        } else if (state is ComplaintRegisterSubmitError) {
                          Utils.showInSnackBar(
                              context, state.error, ToastType.Warning);
                        }
                      },
                      child: BlocBuilder<ComplaintRegisterBloc,
                          ComplaintRegisterState>(
                        builder: (context, state) {
                          if (state is ComplaintRegisterSubmitInProgress) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                controller: _namecontroller,
                                decoration: InputDecoration(
                                  labelText: 'Select Requestor Name',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 10.0),
                                  suffixIcon: Autocomplete<Complainer>(
                                    displayStringForOption:
                                        (Complainer option) => option.name,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return const Iterable<Complainer>.empty();
                                      }
                                      return complaintRegDetList.where(
                                              (Complainer option) {
                                            return option.name.toLowerCase().contains(
                                                textEditingValue.text.toLowerCase());
                                          });
                                    },
                                    onSelected: (Complainer selection) {
                                      setState(() {
                                        selectedRequesterName = selection.name;
                                        selected_requester_id = selection.id;
                                        _namecontroller.text = selection.name;
                                        _emailController.text  = selection.email;
                                        _phoneController.text  = selection.mobile;
                                        _locationController.text = selection.location.name;
                                         selection_location_id = selection.location.id;

                                      });
                                      debugPrint(
                                          'You just selected ${selection.name}');
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController
                                        textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          labelText: 'Search Requestor Name',
                                          labelStyle: TextStyle(color: Colors.grey),  // Sets the label color
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            borderSide: BorderSide(color: customColor1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: customColor1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: customColor1),
                                          ),
                                          contentPadding:
                                          EdgeInsets.symmetric(
                                              vertical: 16.0,
                                              horizontal: 10.0),
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey),  // Sets the label color
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: Colors.grey),  // Sets the label color
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          labelStyle: TextStyle(color: Colors.grey),  // Sets the label color
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButtonFormField<String>(
                        value: natureofComplaint.any((item) => item.name == selectedNatureOfComplaint)
                            ? selectedNatureOfComplaint
                            : null,
                        onChanged: (newValue) {
                          setState(() {
                            selectedNatureOfComplaint = newValue!;
                            selected_nature_of_complaint = ComplaintHelper.getComplaintIdByName(natureofComplaint, newValue)!;
                          });
                        },
                        items: natureofComplaint.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.name,
                            child: Text(item.name),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Nature of Complaint',
                          labelStyle: TextStyle(color: Colors.grey),  // Sets the label color
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _issuesController,
                        maxLines: null,  // Allows unlimited lines
                        textInputAction: TextInputAction.newline,  // Adjusts keyboard action button
                        keyboardType: TextInputType.multiline,  // Allows multiline input
                        decoration: InputDecoration(
                          labelText: 'Brief Your Complaint',
                          labelStyle: TextStyle(color: Colors.grey),  // Sets the label color
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: customColor1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),


    );


  }

}

