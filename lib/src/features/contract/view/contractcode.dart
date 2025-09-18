import 'package:cmms/src/features/contract/bloc/contractcode_bloc.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api/api_service.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/utils.dart';
import '../bloc/contractcode_event.dart';
import '../bloc/contractcode_state.dart';

class ContractCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContractCodeBloc>(
          create: (context) => ContractCodeBloc(RepositoryProvider.of<ApiService>(context)),
        ),

      ],
      child: ContractCode(),
    );
  }
}

class ContractCode extends StatefulWidget {
  const ContractCode({Key? key}) : super(key: key);

  @override
  State<ContractCode> createState() => _ContractCodeState();
}

class _ContractCodeState extends State<ContractCode> {
  TextEditingController _contractCodeController = TextEditingController();

  late ContractCodeBloc contractCodeBloc;


  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    contractCodeBloc = ContractCodeBloc(RepositoryProvider.of<ApiService>(context));
  }

  @override
  void dispose() {
    contractCodeBloc.close();
    _contractCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => contractCodeBloc,
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
            Image.asset(
              'assets/images/ecms_logo.png',
              width: 100,
              height: 20,
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
      body: Center(
        child: SingleChildScrollView( // This will enable scrolling
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize column height
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Minimize column height
                      children: [
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Contract Code',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center, // Center the text horizontally
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 50,
                              child: TextFormField(
                                textAlign: TextAlign.center, // Center the input text
                                controller: _contractCodeController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.only(left: 10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            String code = _contractCodeController.text;

                            if (code.isEmpty) {
                              Utils.showInSnackBar(context, "Invalid Contract Code.", ToastType.Error);
                            } else {
                              var connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.none) {
                                Utils.showInSnackBar(context, "No internet connection.", ToastType.Error);

                              } else {
                                await AppSharedPrefs.get().setContractCode(code);
                                contractCodeBloc.add(LoadContractCodeEvent(code));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.customColor2, AppColors.customColor1],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 150.0, minHeight: 45.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Submit',
                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                              ),
                            ),
                          ),
                        ),

                        /*  API Calls */


                        BlocListener<ContractCodeBloc, ContractCodeState>(
                          listener: (context, state) async {
                            if (state is ContractCodeLoadedState) {

                              if (state.screenMappingMobile.isError == true) {
                                Utils.showInSnackBar(context, state.screenMappingMobile.message.toString(), ToastType.Warning);
                              } else {
                              //  Utils.showInSnackBar(context, "Code", ToastType.Success);
                                String code = _contractCodeController.text;
                                String baseUrl = state.screenMappingMobile.data!.url.toString()+'/'
                                    +state.screenMappingMobile.data!.apiRoute.toString()+'/';
                                //String baseUrl = state.screenMappingMobile.data.endpoint;
                                await AppSharedPrefs.get()
                                    .setBaseUrl(baseUrl);
                                print(baseUrl);

                                Navigator.pushNamed(context, '/login');

                              }
                            } else if (state is ContractCodeErrorState) {

                              Utils.showInSnackBar(context, state.errorMessage, ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<ContractCodeBloc, ContractCodeState>(
                            builder: (context, state) {
                              if (state is ContractCodeLoadingState) {
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Image.asset(
        'assets/images/bottom_building.png',
        width: MediaQuery.of(context).size.width,
      ),
    ),) );
  }
}