

import 'package:cmms/src/features/closed/list/model/closed_list_model.dart';
import 'package:cmms/src/features/closed/view/view/closed_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../dashboard/View/dashboard.dart';
import '../../../pendingresponse/model/property_model.dart';
import '../../../request/list/bloc/property/property_bloc.dart';
import '../../../request/list/bloc/property/property_event.dart';
import '../../../request/list/bloc/property/property_state.dart';
import '../bloc/closed_list_bloc.dart';
import '../bloc/closed_list_event.dart';
import '../bloc/closed_list_state.dart';

void main() {
  runApp(ClosedList());
}

class ClosedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClosedListBloc>(
          create: (context) => ClosedListBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<PropertyBloc>(
          create: (context) => PropertyBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: ClosedWidgetContent(),
    );
  }
}

class ClosedWidgetContent extends StatefulWidget {
  @override
  _ClosedWidgetContentState createState() => _ClosedWidgetContentState();
}

class _ClosedWidgetContentState extends State<ClosedWidgetContent> {
  Color customColor1 = Color(0xFFCBD4F4);
  Color customColor2 = Color(0xFFF7D9E3);
  int page = 0; // Initial page number
  ScrollController _scrollController = ScrollController();
  late ClosedListBloc closedListBloc;
  List<ClosedData> allListData = [];
  late int selectedID = 0;
  late String selectedStatus = "";
  List<Property> propertyList = [];
  int selectedIndex = -1;
  late PropertyBloc propertyBloc;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool loadStopForOneData = false;


  void _onScroll() {
    if (_hasMoreData &&
        !_isLoadingMore &&
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() => _isLoadingMore = true);
      page++;
      closedListBloc.add(FetchClosedListEvent(selectedID, page, ''));
    }
  }


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    propertyBloc = BlocProvider.of<PropertyBloc>(context);
    propertyBloc.add(PropertyFetchEvent());

    closedListBloc = BlocProvider.of<ClosedListBloc>(context);
    closedListBloc.add(FetchClosedListEvent(selectedID, page, ''));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    closedListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png',
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
                    customColor2,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'CLOSED',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      child: InkWell(
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/searchCases',
                              arguments: {
                                'propertyId': selectedID,
                                'propertyName': selectedStatus,
                                'type': 'closed',
                                'subType': '',
                              },
                            );

                            if (result != null && result is String) {
                              final selectedRequestId = result;
                              allListData.clear();
                              loadStopForOneData = true;
                              print('Received requestId: $selectedRequestId');
                              closedListBloc.add(FetchClosedListEvent(selectedID, 0, selectedRequestId));
                            }
                          },
                          child: Icon(Icons.search_sharp)),
                    )
                  ],
                ),
                SizedBox(height: 10),
                BlocBuilder<PropertyBloc, PropertyState>(
                  builder: (context, state) {
                    if (state is PropertyLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is PropertySuccessState) {
                      propertyList = state.moduleResponse.property;
                      return DropdownButtonFormField<Property>(
                        isExpanded: true,
                        value: selectedIndex != -1 ? propertyList[selectedIndex] : null,
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
                            selectedID = newValue.proid;
                            page = 0;
                            allListData.clear();
                            _isLoadingMore = false;
                            loadStopForOneData = false;
                            _hasMoreData = true;
                            closedListBloc.add(FetchClosedListEvent(selectedID, page, ''));
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Property',
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
                SizedBox(height: 10),
                BlocConsumer<ClosedListBloc, ClosedListState>(
                  listener: (context, state) {
                    if (state is ClosedListErrorState) {
                      Utils.showInSnackBar(context, state.error, ToastType.Error);
                    } else if (state is ClosedListLoadedState) {
                      if (page == 0) allListData.clear();
                      allListData.addAll(state.closedList);
                      _isLoadingMore = false;
                      _hasMoreData = state.closedList.isNotEmpty;
                    }
                  },
                  builder: (context, state) {

                    if (allListData.isEmpty) {
                      return Expanded(child: Center(child: Text('No data available')));
                    }

                    return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: allListData.length + 1,
                        itemBuilder: (context, index) {
                          if (index < allListData.length) {
                            final data = allListData[index];
                            return _buildRequestCard(data);
                          } else{
                            if (_hasMoreData && loadStopForOneData == false && allListData.length>9) {
                              return Center(child: CircularProgressIndicator());
                            } else if (loadStopForOneData == false) {
                              return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No more data'),
                                  ));
                            }
                          }
                        },
                      ),
                    );

                  },
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildRequestCard(ClosedData data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/closedDetails',
          arguments: {'ClosedID': data.id.toString()},
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow(context, 'REQ ID', data.requestId),
                _buildRow(context, 'REQ BY', data.requestedBy, showPhoneIcon: true, phoneNumber: data.mobile),
                _buildRow(context, 'REGION', data.regionName),
                _buildRow(context, 'PROPERTY', data.property),
                _buildRow(context, 'SPACE / FLOOR', data.spaceFloor),
                _buildRow(context, 'TYPE', data.type),
                _buildRow(context, 'SUBTYPE', data.subType),
                _buildRow(context, 'STATUS', data.status),
                _buildRow(context, 'DESCRIPTION', data.originalMessage),
                _buildRow(context, 'PRIORITY', data.priorityName),
                _buildRow(context, 'ADDN. LOC', data.additionalSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildRow(BuildContext context, String title, String value,
      {bool showPhoneIcon = false, String? phoneNumber}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ": $value",
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                if (showPhoneIcon && phoneNumber != null)
                  InkWell(
                    onTap: () {
                      _showPhoneDialog(context, phoneNumber);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.phone, color: Colors.black, size: 20),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhoneDialog(BuildContext context, String phoneNumber) {
    final TextEditingController controller = TextEditingController(text: phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 15), // Space above the TextFormField
              TextFormField(
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
