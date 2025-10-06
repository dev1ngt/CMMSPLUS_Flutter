import 'package:cmms/src/features/faultreport/firstmenu/bloc/first_menu_event.dart';
import 'package:cmms/src/features/myfaultreport/view/bloc/request_view_bloc_my_fault.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../myfaultreport/view/bloc/request_view_event_my_fault.dart';
import '../../submit/model/upload_view_model.dart';
import '../bloc/first_menu_bloc.dart';
import '../bloc/first_menu_state.dart';

class FRFirstMenu extends StatelessWidget {
  const FRFirstMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<MyFaultRequestViewBloc>(
          create: (context) =>
              MyFaultRequestViewBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: FRFirstMenuStf(),
    );
  }
}

class FRFirstMenuStf extends StatefulWidget {
  const FRFirstMenuStf({super.key});

  @override
  State<FRFirstMenuStf> createState() => _FRFirstMenuStf();
}

class _FRFirstMenuStf extends State<FRFirstMenuStf> {

  String ProjectName = "";
  late FRFirstMenuBloc firstMenuBloc;
  UploadViewModel viewModel = UploadViewModel();
  String username = "", contract_name = "";
  String RequestID = "";
  String desc = "";
  String Is_list = "0";
  String Is_button_visible = "0";
  String Is_attchment = "0";
  String Is_list1 = "0";
  bool _isAPICalled = true;
  late MyFaultRequestViewBloc requestViewBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstMenuBloc = FRFirstMenuBloc(RepositoryProvider.of<ApiService>(context));
    requestViewBloc =
        MyFaultRequestViewBloc(RepositoryProvider.of<ApiService>(context));
    checkInternetAndFetchData();
    checkInternetConnection();
    fetchSharedData();
  }

  @override
  void dispose() {
    firstMenuBloc.close();
    super.dispose();
  }

  Future<void> checkInternetAndFetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Utils.showInSnackBar(
        context,
        "No internet connection.",
        ToastType.Error,
      );
    } else {
     // firstMenuBloc.add(FRFirstMenuFetchEvent());
    }
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Handle no internet connection
      Utils.showInSnackBar(context, "No Internet Connection.", ToastType.Error);
    }
  }

  Future<void> fetchSharedData() async {
    username = await AppSharedPrefs.getUsername();
    contract_name = await AppSharedPrefs.getContractCode();
    Is_list1 = await AppSharedPrefs.getislist();

    setState(() {}); // Trigger a rebuild after fetching the username
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey("RequestID")) {
      RequestID = args['RequestID'] as String;
      Is_list = args['Is_list'] as String;
      desc = args['DESCRIPTION'] as String;
      Is_button_visible = args['IsSubmitButton'] as String;

      firstMenuBloc.add(FRFirstMenuFetchEvent(RequestID));

      if (_isAPICalled) {
        requestViewBloc.add(MyFaultRequestViewLoadEvent(int.parse(RequestID)));
        print("API Call Check");
        print(RequestID);
        print("desc_" + desc);
        print("c" + Is_list);

        if (Is_list.contains("1")) {
          AppSharedPrefs.get().setislist(Is_list.toString());
          AppSharedPrefs.get().setrequestid(RequestID.toString());
          AppSharedPrefs.get().setdesc(desc);
          AppSharedPrefs.get().setisbuttonvisible(Is_button_visible.toString());

          print("API Call Check12");
        } else {
          AppSharedPrefs.get().setdesc("");
          AppSharedPrefs.get().setisbuttonvisible("1");
          AppSharedPrefs.get().setislist("0");
        }
        print("API Call Check32");
        print(Is_list);
      }
    } else {
      print("API_list");
      firstMenuBloc.add(FRFirstMenuFetchEvent("0"));
      AppSharedPrefs.get().setdesc("");
      AppSharedPrefs.get().setisbuttonvisible("1");
      AppSharedPrefs.get().setislist("0");
    }

    return BlocProvider(
      create: (context) => firstMenuBloc,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final dashboard =
                  await Navigator.pushNamed(context, '/dashboard');
                  Navigator.pop(context, dashboard);
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
            /*  Spacer(),
              Image.asset(
                'assets/images/ecms_logo.png',
                width: 100,
                height: 20,
              ),*/
              Spacer(),
              GestureDetector(
                onTap: () {
                  // Handle your onClick event here
                  Navigator.pushNamed(
                      context, '/dashboard'); // Example: Navigate to home page
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
         /* flexibleSpace: Container(
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
          ),*/
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Other widgets...

                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(6),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to the ' + contract_name + ' application',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'You can submit cases to request assistance from our facility management team.',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),

                // Dynamic list of chips with delete option
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(6),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Submit Request',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Hello ' +
                              username +
                              ', please select an request I can help you with',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        // Use BlocBuilder to handle Bloc states
                        BlocBuilder<FRFirstMenuBloc, FRFirstMenuState>(
                          builder: (context, state) {
                            if (state is FRFirstMenuInitial) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is FRFirstMenuLoaded) {
                              // Display the chips once the data is loaded
                              return Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: List.generate(
                                  state.ppmlist.allTypes.length,
                                      (index) {
                                        final isSelected = state.ppmlist.allTypes[index].isSelected == 1;
                                    return ChipWithClick(
                                      label: state.ppmlist.allTypes[index].requestType,
                                      isSelected: isSelected,
                                      onClick: () {
                                        try {
                                          if (Is_list.contains("1")) {
                                            print(Is_list1);
                                            viewModel
                                                .updateFaultReportSaveModel11(
                                                state.ppmlist
                                                    .allTypes[index].id,
                                                state
                                                    .ppmlist
                                                    .allTypes[index]
                                                    .requestType);
                                          } else {
                                            viewModel
                                                .updateFaultReportSaveModel1(
                                                state.ppmlist
                                                    .allTypes[index].id,
                                                state
                                                    .ppmlist
                                                    .allTypes[index]
                                                    .requestType);
                                          }

                                          String type_name = state.ppmlist
                                              .allTypes[index].requestType;

                                            print(type_name);
                                            Navigator.pushNamed(
                                              context,
                                              '/faultReportSubtype',
                                              arguments: RequestID,
                                            );


                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            } else if (state is FRFirstMenuError) {
                              return Center(
                                child: Text('Error loading chip data'),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class ChipWithClick extends StatelessWidget {
  final String label;
  final VoidCallback onClick;

  const ChipWithClick({required this.label, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick, // Handle chip click
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assessment_outlined,
                size: 18), // Adjust the size as needed
            SizedBox(
                width: 4), // Adjust the spacing between icon and text as needed
            Flexible(
              // Prevent overflow by wrapping text
              child: Text(
                label,
                overflow: TextOverflow.ellipsis, // Truncate if text is too long
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

class ChipWithClick extends StatelessWidget {
  final String label;
  final VoidCallback onClick;
  final bool isSelected;

  const ChipWithClick({
    required this.label,
    required this.onClick,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Use your theme colors
    final Color selectedColor = Color(0xFFCBD4F4);
    final Color unselectedColor = Color(0xFFF7D9E3);

    return InkWell(
      onTap: onClick,
      child: Chip(
        backgroundColor: isSelected ? selectedColor : null,
        shape: StadiumBorder(
          side: isSelected
              ? BorderSide(color: Colors.blue.shade700, width: 1.5)
              : BorderSide.none,
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assessment_outlined,
              size: 18,
              color: isSelected ? Colors.blue.shade700 : Colors.black54,
            ),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.blue.shade800 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

