

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';

import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/preference_keys.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../dashboard/View/dashboard.dart';

import '../../../pendingresponse/model/property_model.dart';
import '../../../request/list/bloc/property/property_bloc.dart';
import '../../../request/list/bloc/property/property_event.dart';
import '../../../request/list/bloc/property/property_state.dart';
import '../../view/view/inprogress_details.dart';
import '../bloc/inprogress_list_bloc.dart';
import '../bloc/inprogress_list_event.dart';
import '../bloc/inprogress_list_state.dart';
import '../model/inprogress_list_model.dart';


class InProgressList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InProgressListBloc>(
          create: (context) =>
              InProgressListBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PropertyBloc>(
          create: (context) =>
              PropertyBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: InProgressListStateful(),
    );
  }
}

class InProgressListStateful extends StatefulWidget {
  @override
  _InProgressListStateful createState() => _InProgressListStateful();
}

class _InProgressListStateful extends State<InProgressListStateful> {
  late InProgressListBloc inProgressListBloc;
  late PropertyBloc propertyBloc;
  int page = 0; // Initial page number
  ScrollController _scrollController = ScrollController();
  List<InProgressData> allListData = [];
  bool _isLoadingMore = true; // Flag to indicate if loading more data is in progress
  int selectedIndex = -1;
  late String selectedStatus = "";
  late int selectedID  = 0;
  List<Property> propertyList = [];

  void _onScroll() {
    if (_isLoadingMore && _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
        page++;
      });
      inProgressListBloc.add(FetchInProgressListEvent(page, selectedID));
    }
  }


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

 /*   PropertyModel mockPropertyModel = PropertyModel.mockData();
    propertyList.addAll(mockPropertyModel.property);*/

    inProgressListBloc = InProgressListBloc(
      RepositoryProvider.of<ApiService>(context),
    )..add(FetchInProgressListEvent(page , selectedID));

    propertyBloc = BlocProvider.of<PropertyBloc>(context);
    propertyBloc.add(PropertyFetchEvent());

  }

  @override
  void dispose() {
    inProgressListBloc.close();
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
    Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color

    return BlocProvider(
      create: (context) => inProgressListBloc,
      child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/ic_back.png',
                        // Replace with your ic_back image asset
                        width: 25,
                        height: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/images/ecms_logo.png', // replace with your image path
                    width: 100,
                    height: 20,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Handle your onClick event here
                      Navigator.pushNamed(context, '/dashboard'); // Example: Navigate to home page
                    },
                    child: Image.asset(
                      'assets/images/ic_home.png', // replace with your image path
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      customColor1,
                      customColor2
                    ], // Replace with your gradient colors
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            body:  Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(  // Center the text
                child: Text(
                  'IN-PROGRESS LIST',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,  // Center-align the text
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlocBuilder<PropertyBloc, PropertyState>(
                builder: (context, state) {
                  if (state is PropertyLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PropertySuccessState) {
                    propertyList = state.moduleResponse.property;
                    return DropdownButtonFormField<Property>(
                      isExpanded: true,
                      value: selectedIndex != -1
                          ? propertyList[selectedIndex]
                          : null,
                      hint: Text('Select a property'),
                      items: propertyList.map((Property status) {
                        return DropdownMenuItem<Property>(
                          value: status,
                          child: Text(status.proname),
                        );
                      }).toList(),
                      onChanged: (Property? newValue) {
                        setState(() {
                          selectedStatus = newValue!.proname;
                          selectedID = newValue!.proid;
                          allListData
                              .clear(); // Clear the list before loading new data
                          _isLoadingMore = true;
                          page = 0; // Reset page to 0 to start fresh
                          inProgressListBloc.add(FetchInProgressListEvent(page , selectedID));

                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),

              BlocListener<InProgressListBloc, InProgressListState>(
                  listener: (context, state) {
                    if (state is InProgressListErrorState) {
                      // Handle error state
                      Utils.showInSnackBar(context, state.error, ToastType.Error);
                    }

                    if(state is InProgressListLoadedState){
                      List<InProgressData> list = state.inProgressList;
                      if (list.isEmpty) {
                        if (allListData.isNotEmpty) {
                          Utils.showInSnackBar(context, "No more data available.", ToastType.Warning);
                          setState(() {
                            _isLoadingMore = false;
                          });
                        } }

                    }
                  },
               child:  BlocBuilder<InProgressListBloc, InProgressListState>(
                    builder: (context, state) {
                      if (state is InProgressListLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is InProgressListLoadedState) {
                        List<InProgressData> list = state.inProgressList;
                        if (list.isEmpty) {
                          if (allListData.isNotEmpty) {
                           // _isLoadingMore = true;
                          } else {
                            return Center(
                              child: Text('No data available'),
                            );
                          }
                        }
                        allListData.addAll(list);
                        return Flexible(
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: _calculateListItemCount(),
                                      itemBuilder: (BuildContext context, int index) {

                                        if (index == allListData.length) {
                                          if(_isLoadingMore){
                                            return Container();
                                          }
                                          else {
                                            return ListTile(
                                              title: Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                            );
                                          }

                                        } else {
                                          InProgressData data = allListData[index];

                                          return GestureDetector(
                                            onTap: () async {
                                              await AppSharedPrefs.get()
                                                  .setCaseID( data.cwRequestListId.toString()!);

                                              Navigator.pushNamed(context, "/inprogressDetails" ,
                                                arguments: {
                                                  'SubmitBtnShow': data.cwRequestListId.toString(),
                                                  // Add more parameters as needed
                                                },);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Card(
                                                color: Colors.white,
                                                elevation: 4,
                                                margin: const EdgeInsets.symmetric(vertical: 1),
                                                child: ListTile(
                                                  title: Text(
                                                    "#" + data.caseId,
                                                    style: const TextStyle(color: Colors.black),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      _buildRichText('Company Name', data.companyName),
                                                      SizedBox(height: 8),
                                                      _buildRichText('Date and Time of Arrival', data.dateOfArrival + " / " + data.timeOfArrival),
                                                      SizedBox(height: 8),
                                                      _buildRichText('Property Name', data.propertyName),
                                                      SizedBox(height: 8),
                                                      _buildRichText('Status', data.status),
                                                      // Add more fields as needed
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                  )
                        );
                      }
                      return Container();
                    }) ),
          ],),),)),);
  }

  // Function to calculate the item count for the ListView.builder
  int _calculateListItemCount() {
    if (_isLoadingMore) {
      // If loading more is in progress, return allListData.length + 1
      return allListData.length + 1;
    } else {
      // Otherwise, return only allListData.length
      return allListData.length;
    }
  }
}

Widget _buildRichText(String fieldName, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 1,
        child: Text(
          fieldName ,
          style: const TextStyle(color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          ": " + value,
          style: const TextStyle(color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

// Example of calling addValue
void doUpdateValue(PreferenceKeys baseURL, int isEdit) async {
  // Create an instance of AppSharedPrefs
  AppSharedPrefs appSharedPrefs = AppSharedPrefs.get();
  // Call addValue with the appropriate parameters
  await appSharedPrefs.addValue(baseURL, isEdit.toString());
}
