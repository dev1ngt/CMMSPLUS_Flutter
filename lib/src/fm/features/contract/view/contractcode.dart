import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../api/api_service.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../bloc/contractcode_bloc.dart';
import '../bloc/contractcode_event.dart';
import '../bloc/contractcode_state.dart';

class ContractCodeScreenFM extends StatelessWidget {
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
  final TextEditingController _contractCodeController = TextEditingController();

  late ContractCodeBloc contractCodeBloc;
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color

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
    const Color customColor1 = Color(0xFF006BE6); // Primary color used in the gradient
    return BlocProvider(
        create: (context) => contractCodeBloc,
        child: WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return true;
    },
    child: Scaffold(
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xFF006BE6),
                Color(0xFF006BE6),
                Color(0xFF006BE6),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please enter your contract code to explore our app.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 200),
                      TextFormField(
                        textAlign: TextAlign.start,
                        controller: _contractCodeController,
                        decoration: InputDecoration(
                          hintText: 'Enter contract code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: customColor1, // Border color
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: customColor1, // Border color
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: customColor1, // Border color
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                        ),
                      ),

                      const SizedBox(height: 20),
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
                            gradient: const LinearGradient(
                              colors: [Color(0xFF006BE6), Color(0xFF006BE6)], // Blue gradient colors
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 150.0, minHeight: 45.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 14.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      /* APIs Calls */


                      BlocListener<ContractCodeBloc, ContractCodeState>(
                        listener: (context, state) async {
                          if (state is ContractCodeLoadedState) {

                            if (state.screenMappingMobile.isError) {
                              Utils.showInSnackBar(context, state.screenMappingMobile.message, ToastType.Warning);
                            } else {

                              await AppSharedPrefs.get()
                                  .setBaseUrl(state.screenMappingMobile.data.url);
                              Navigator.pushNamed(context, '/loginfm');

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



                      /*  End here  */
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),),);
  }
}