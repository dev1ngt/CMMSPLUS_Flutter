import 'package:cmms/src/features/faultreport/submit/model/fault_report_save_model.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';

import '../../../faultreport/submit/model/fault_report_save_model_old.dart';
import '../../../faultreport/submit/model/upload_view_model.dart';
import '../../../myfaultreport/list/bloc/request_list_bloc_my_fault.dart';
import '../../../myfaultreport/list/bloc/request_list_event_my_fault.dart';
import '../../../myfaultreport/list/bloc/request_list_state_my_fault.dart';
import '../../../pendingresponse/model/property_model.dart';

import '../model/myfault_list_model.dart';

class MyFaultlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyFaultlistBloc>(
          create: (context) =>
              MyFaultlistBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: MyFaultlistWidgetContent(),
    );
  }
}

class MyFaultlistWidgetContent extends StatefulWidget {
  @override
  _MyFaultlistWidgetContentState createState() =>
      _MyFaultlistWidgetContentState();
}

class _MyFaultlistWidgetContentState extends State<MyFaultlistWidgetContent> {

  int page = 0;
  ScrollController _scrollController = ScrollController();
  late MyFaultlistBloc requestListBloc;
  List<RequestData1> allListData = [];

  int selectedIndex = -1;
  late String selectedStatus = "";
  late int selectedID = 0;
  late String type = "single";
  List<Property> propertyList = [];
  bool _hasMoreData = true;
  bool _isLoadingMore = false;
  bool loadStopForOneData = false;

  int _selectedTabIndex = 0;

  void _onScroll() {
    if (_hasMoreData &&
        !_isLoadingMore &&
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
        page++;
      });
      String status = _selectedTabIndex == 0 ? "Ongoing" : "Closed";
      requestListBloc.add(MyFaultlistLoadEvent(page, '', status));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    requestListBloc = BlocProvider.of<MyFaultlistBloc>(context);
    requestListBloc.add(MyFaultlistLoadEvent(page, '', 'Ongoing'));
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
          /*    const Spacer(),
              Image.asset(
                'assets/images/ecms_logo.png',
                width: 100,
                height: 20,
              ),*/
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/dashboard'),
                child: Image.asset(
                  'assets/images/ic_home.png',
                  width: 20,
                  height: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.whiteColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Text(
                      'MY FAULT REPORT',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: InkWell(
                      onTap: () async {

                        String subType = _selectedTabIndex == 0 ? "ongoing" : "closed";

                        final result = await Navigator.pushNamed(
                          context,
                          '/searchCases',
                          arguments: {
                            'propertyId': selectedID,
                            'propertyName': selectedStatus,
                            'type': 'myfault',
                            'subType': subType,
                          },
                        );

                        if (result != null && result is String) {
                          final selectedRequestId = result;
                          allListData.clear();
                          loadStopForOneData = true;
                          String status = _selectedTabIndex == 0 ? "Ongoing" : "Closed";
                          requestListBloc.add(MyFaultlistLoadEvent(0, selectedRequestId, status));
                        }
                      },
                      child: const Icon(Icons.search_sharp),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton("Ongoing", 0),
                  const SizedBox(width: 10),
                  _buildTabButton("Closed", 1),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            setState(() {
              _selectedTabIndex = index;
              page = 0;
              allListData.clear();
              _hasMoreData = true;
              _isLoadingMore = false;
              loadStopForOneData = false;
            });
            String status = _selectedTabIndex == 0 ? "Ongoing" : "Closed";
            requestListBloc.add(MyFaultlistLoadEvent(page, '', status));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
         /* decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            gradient: isSelected
                ? LinearGradient(
              colors: [AppColors.customColor1,
                AppColors.customColor2,],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : null,
            border: Border.all(color: Colors.black12),
          ),*/
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.themeColor   // selected tab color
                : Colors.grey.shade200,    // unselected tab color
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return BlocConsumer<MyFaultlistBloc, MyFaultlistState>(
      listener: (context, state) {
        if (state is MyFaultlistErrorState) {
          Utils.showInSnackBar(context, state.error, ToastType.Error);
        } else if (state is MyFaultlistLoadedState) {
          if (page == 0) allListData.clear();
          allListData.addAll(state.closedList);
          _isLoadingMore = false;
          _hasMoreData = state.closedList.isNotEmpty;
        }
      },
      builder: (context, state) {
        if (allListData.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: allListData.length + 1,
          itemBuilder: (context, index) {
            if (index < allListData.length) {
              final data = allListData[index];
              return _buildRequestCard(data);
            } else {
              if (_hasMoreData && !loadStopForOneData && allListData.length > 9) {
                return const Center(child: CircularProgressIndicator());
              } else if (!loadStopForOneData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No more data'),
                  ),
                );
              }
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildRequestCard(RequestData1 data) {
    return GestureDetector(
      onTap: () {
        AppSharedPrefs.get().setislist(data.originalMessage.toString());
        AppSharedPrefs.get().setattachurl(data.Attachment.toString());

        UploadViewModel viewModel = UploadViewModel();
        FaultReportOldSaveModel faultReportSaveModel1 = viewModel.faultReportoldSaveModel;
        FaultReportSaveModel faultReportSaveModel = viewModel.faultReportSaveModel;

        faultReportSaveModel1.additionalSpace = data.additionalSpace;
        faultReportSaveModel.additionalSpace = data.additionalSpace;

        bool submitBtn = _selectedTabIndex == 1;

        Navigator.pushNamed(
          context,
          '/myFaultReportView',
          arguments: {
            'RequestID': data.id.toString(),
            'IsSubmitButton': submitBtn,
          },
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
                _buildRow(context, 'REQ BY', data.requestedBy),
                _buildRow(context, 'REGION', data.regionName),
                _buildRow(context, 'PROPERTY', data.property),
                _buildRow(context, 'SPACE / FLOOR', data.spaceFloor),
                _buildRow(context, 'TYPE', data.type),
                _buildRow(context, 'SUBTYPE', data.subType),
                _buildRow(context, 'STATUS', data.status),
                _buildRow(context, 'DESCRIPTION', data.originalMessage),
                _buildRow(context, 'ADDN. LOC', data.additionalSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, top: 4.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: Text(
              ": $value",
              maxLines: null,
              overflow: TextOverflow.visible,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

