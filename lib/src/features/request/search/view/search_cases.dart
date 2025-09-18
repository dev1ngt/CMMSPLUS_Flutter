import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import '../bloc/search_case_bloc.dart';
import '../bloc/search_case_event.dart';
import '../bloc/search_case_state.dart';
import '../model/search_response_model.dart';

class SearchCasesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCasesBloc>(
          create: (context) =>
              SearchCasesBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: SearchCases(),
    );
  }
}

class SearchCases extends StatefulWidget {
  @override
  _RequestListWidgetContentState createState() =>
      _RequestListWidgetContentState();
}

class _RequestListWidgetContentState extends State<SearchCases> {
  Color customColor1 = Color(0xFFCBD4F4);
  Color customColor2 = Color(0xFFF7D9E3);
  late SearchCasesBloc searchBloc;
  List<RequestIdItem> requestIdList = [];
  int propertyId = 0;
  String type = "";
  String subType = "";
  TextEditingController propertyController = TextEditingController();
  bool isPropertyVisible = true;

  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchCasesBloc>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        propertyId = args['propertyId'];
        propertyController.text = args['propertyName'];
        type = args['type'];
        subType = args['subType'];

        if(type == 'myfault'){
          isPropertyVisible = false;
        }
        if(propertyController.text.isEmpty){
          propertyController.text = "All";
        }
      });
    });
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => searchBloc,
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
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: Image.asset(
                  'assets/images/ic_home.png',
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
                colors: [customColor1, customColor2],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'SEARCH CASES',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if(isPropertyVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: propertyController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Property',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter Request Id',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onChanged: (value) {
                  searchBloc
                      .add(SearchCasesTextChanged(value, type, propertyId, subType));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchCasesBloc, SearchCasesState>(
                builder: (context, state) {
                  if (state is SearchCasesInitial) {
                    return Center(child: Text("Start typing to search"));
                  } else if (state is SearchCasesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SearchCasesLoaded) {
                    requestIdList = state.searchResponseModel.requestIdList;

                    if (requestIdList.isEmpty) {
                      return Center(child: Text('No data found'));
                    }

                    return ListView.builder(
                      itemCount: requestIdList.length,
                      itemBuilder: (context, index) {
                        final item = requestIdList[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0,left: 8.0, right: 8.0),
                          child: Card(
                            elevation: 4,
                            color: Colors.white,
                            child: ListTile(
                              title: Text(item.requestId),
                              onTap: () {
                                Navigator.pop(context, item.requestId);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SearchCasesError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
