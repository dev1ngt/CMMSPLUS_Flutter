import 'package:cmms/src/features/adhocinspection/bloc/adhoc_bloc.dart';
import 'package:cmms/src/features/adhocinspection/bloc/adhoc_event.dart';
import 'package:cmms/src/features/adhocinspection/bloc/adhoc_state.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/api_service.dart';
import '../model/adhoc_list_response_model.dart';

class AdhocList extends StatelessWidget {
  const AdhocList({super.key});

  @override
  Widget build(BuildContext context) {
    return AdhocListState();
  }
}

class AdhocListState extends StatefulWidget {
  const AdhocListState({super.key});

  @override
  State<AdhocListState> createState() => _AdhocListState();
}

class _AdhocListState extends State<AdhocListState>
    with SingleTickerProviderStateMixin {

  ApiService apiService = ApiService();
  late AdhocListBloc adhocListBloc;
  late List<InspectionList> _inspectionlist;
  late List<InspectionList> _inspectionlistNewItems;
  String tab_click_status = "";
  ScrollController _scrollController = ScrollController();
  int pending_count = 0, completed_count = 0;
  int page = 0;
  bool _isLoadingMore = true; // Flag to indicate if loading more data is in progress

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    adhocListBloc = AdhocListBloc(RepositoryProvider.of<ApiService>(context))
      ..add(FetchAdhocListEvent(status_type: '0', page_no: 0));
    tab_click_status = "0";
    _inspectionlist = [];
  }

  void _onScroll() {
    if (_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
        page++;
      });
      adhocListBloc.add(FetchAdhocListEvent(status_type: tab_click_status, page_no: page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => adhocListBloc,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(context, '/dashboard');
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
               /* Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png',
                  width: 100,
                  height: 20,
                ),*/
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle your onClick event here
                    Navigator.pushNamed(context,
                        '/adhocAddNewView'); // Example: Navigate to home page
                  },
                  child: Image.asset(
                    'assets/images/add.png', // replace with your image path
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
                    AppColors.whiteColor
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: BlocBuilder<AdhocListBloc, AdhocListMyState>(
              builder: (context, state) {
                if (state is AdhocListInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AdhocListLoaded) {
                  _inspectionlist = state.adhoclist.inspectionList!;
                  //_inspectionlist.addAll(_inspectionlistNewItems);
                  pending_count = state.adhoclist.statusArrays![0].pending!;
                  completed_count = state.adhoclist.statusArrays![0].completed!;
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
                        "ADHOC INSPECTION LIST",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      controller: _scrollController,
                      itemCount: _inspectionlist.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == _inspectionlist.length) {
                          if (_isLoadingMore) {
                            return Container();
                          } else {
                            return ListTile(
                              title: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        } else {
                          InspectionList data = _inspectionlist[index];
                          return GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, '/adhocInspection',
                                arguments: {
                                   'inspectionID': data.inspectionId,
                                  'WebView': data.webViewUrl,
                                  // Add more parameters as needed
                                },);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 1),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildRow(context, 'INSPECTION ID', data.templateId),
                                      _buildRow(context, 'TITLE', data.templateTitle),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }




  Widget _buildRow(BuildContext context, String? title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, top: 4.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,// Adjust alignment for multiline text
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3, // Adjust the ratio of title to value width
            child: Text(
              ": " + value.toString(),
              maxLines: null, // Allow text to take multiple lines
              overflow: TextOverflow.visible, // Let text expand
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
