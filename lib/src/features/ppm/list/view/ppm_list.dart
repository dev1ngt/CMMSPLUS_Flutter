import 'package:cmms/src/features/dashboard/View/dashboard.dart';
import 'package:cmms/src/features/ppm/view/view/ppm_details.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../bloc/ppm_bloc.dart';
import '../bloc/ppm_event.dart';
import '../bloc/ppm_state.dart';
import '../model/ppm_list_response_model.dart';


class PPMList extends StatelessWidget {
  const PPMList({super.key});

  @override
  Widget build(BuildContext context) {
    return PPMListState();
  }
}

class PPMListState extends StatefulWidget {
  const PPMListState({super.key});

  @override
  State<PPMListState> createState() => _PPMListStateState();
}

class _PPMListStateState extends State<PPMListState>
    with SingleTickerProviderStateMixin {

  ApiService apiService = ApiService();
  late TabController _tabController;
  late PPMListBloc ppmListBloc;
  late List<ParentItem> parentItems_pendinglist;
  late List<ParentItem> parentItems_completed;
  late List<ParentItem> parentItems_closed;
  String tab_click_status = "";
  int pending_count = 0, completed_count = 0, closed_count = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this); // Adjust the length based on the number of tabs
    ppmListBloc = PPMListBloc(RepositoryProvider.of<ApiService>(context))
      ..add(FetchPPMListEvent(status_type: '1'));
    tab_click_status = "1";
    parentItems_completed = [];
    parentItems_closed = [];
    parentItems_pendinglist = [];
    // apiService.getPPMList().then((value) => {
    //
    //   print(value.parentItems[0].monthName)
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ppmListBloc,
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
                    Navigator.pushNamed(context, '/dashboard');
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
                    AppColors.customColor1,
                    AppColors.customColor2,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body: BlocBuilder<PPMListBloc, PPMListMyState>(
            builder: (context, state) {
              if (state is PPMListInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PPMListLoaded) {
                if (tab_click_status.contains("1")) {
                  parentItems_pendinglist = state.ppmlist.parentItems;
                  pending_count = state.ppmlist.statusArrays[0].pending;
                  closed_count = state.ppmlist.statusArrays[0].closed;
                  completed_count = state.ppmlist.statusArrays[0].completed;
                } else if (tab_click_status.contains("2")) {
                  parentItems_completed = state.ppmlist.parentItems;
                  print(parentItems_completed);
                  pending_count = state.ppmlist.statusArrays[0].pending;
                  closed_count = state.ppmlist.statusArrays[0].closed;
                  completed_count = state.ppmlist.statusArrays[0].completed;
                } else {
                  parentItems_closed = state.ppmlist.parentItems;
                  pending_count = state.ppmlist.statusArrays[0].pending;
                  closed_count = state.ppmlist.statusArrays[0].closed;
                  completed_count = state.ppmlist.statusArrays[0].completed;
                }
              }

              // Add your logic to handle other states if needed
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "PPM LIST",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.red,
                      indicatorColor: Colors.red,
                      onTap: (index) {
                        // Handle tab click and call API based on the selected tab
                        _handleTabClick(index);
                      },
                      tabs: [
                        _buildTabWithCount('PENDING', pending_count),
                        _buildTabWithCount('COMPLETED', completed_count),
                        _buildTabWithCount('CLOSED', closed_count),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          child: Center(
                              child: _buildExpandableList(
                                  parentItems_pendinglist)),
                        ),
                        Container(
                          child: Center(
                              child:
                                  _buildExpandableList(parentItems_completed)),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height - 10,
                          child: Center(
                              child: _buildExpandableList(parentItems_closed)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleTabClick(int tabIndex) {
    // Add logic to call API based on the selected tab index
    switch (tabIndex) {
      case 0:
        // Call API for PENDING tab
        setState(() {
          tab_click_status = "1";
        });
        _callApiForTab('PENDING');

        break;
      case 1:
        // Call API for COMPLETED tab
        setState(() {
          tab_click_status = "2";
        });
        _callApiForTab('COMPLETED');

        break;
      case 2:
        // Call API for CLOSED tab
        setState(() {
          tab_click_status = "3";
        });
        _callApiForTab('CLOSED');

        break;
    }
  }

  void _callApiForTab(String tab) {
    // Add your API call logic here based on the selected tab
    // You may use ppmListBloc.add(FetchPPMListEvent()) or any other suitable approach
    // to fetch data for the selected tab
    ppmListBloc.add(FetchPPMListEvent(
      status_type: tab_click_status,
    ));
    print(tab);
  }

  Tab _buildTabWithCount(String label, int count) {
    return Tab(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(label),
              SizedBox(width: 2), // Adjust the spacing as needed
            ],
          ),
          Positioned(
            right: 0,
            top: -4,

            // Adjust the top position as needed
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red, // Customize the color as needed
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableList(List<ParentItem> parentItems) {
    if (parentItems.isEmpty) {
      return Center(
        child: Text('No data available'),
      );
    }
    return ListView.builder(
      itemCount: parentItems.length,
      itemBuilder: (context, index) {
        final parentItem = parentItems[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text(parentItem.monthName),
            subtitle: Text('Count: ${parentItem.count}'),
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: parentItem.childItems.length,
                itemBuilder: (context, i) {
                  final childItem = parentItem.childItems[i];
                  return GestureDetector(
                    onTap: () => _handleCardTap(childItem),
                    child: _buildInspectionCard(childItem),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isNavigating = false;

  Future<void> _handleCardTap(ChildItem childItem) async {
    if (_isNavigating) return;
    _isNavigating = true;

    await AppSharedPrefs.get().setVendorName(childItem.vendor!);
    await AppSharedPrefs.get().setSubSchduleID(childItem.scheduleId!.toString());

    String route = tab_click_status == "1"
        ? '/ppmDetails'
        : tab_click_status == "2"
        ? '/ppmCompletedDetails'
        : '/ppmClosedDetails';

    Navigator.pushNamed(
      context,
      route,
      arguments: {
        'WebView': childItem.webViewUrl,
        'PPMID': childItem.scheduleId.toString(),
      },
    ).then((_) => _isNavigating = false);
  }

  Widget _buildInspectionCard(ChildItem childItem) {
    return Padding(
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
              _buildRow(context, 'PPM / Inspection ID', childItem.inspectionId ?? ''),
              _buildRow(context, 'Inspection Type', childItem.inspectionType ?? ''),
              _buildRow(context, 'Region', childItem.regionName ?? ''),
              _buildRow(context, 'Property Name', childItem.propertyName ?? ''),
              _buildRow(context, 'Priority', childItem.priority ?? ''),
              _buildRow(context, 'Start Date', childItem.scheduleStartDateTime ?? ''),
              _buildRow(context, 'End Date', childItem.scheduleEndDateTime ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String title, String value) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
