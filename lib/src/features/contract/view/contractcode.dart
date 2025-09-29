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
  bool isLoading = false;

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
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(20.00),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
          ),
          body: Stack(
            children: [
              // Background Image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash_screen_empty.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Main Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // CMMS+ Logo
                              Image.asset(
                                'assets/images/cmms_plus_logo.png',
                                width: 150,
                                height: 60,
                              ),
                              SizedBox(height: 40),
                              // Contract Code Input
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 55,
                                    child: TextFormField(
                                      controller: _contractCodeController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Contract Code',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
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
                                    backgroundColor: Color(0xFF1E3A5F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'SUBMIT',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),

                              /* API Calls */
                              BlocListener<ContractCodeBloc, ContractCodeState>(
                                listener: (context, state) async {
                                  if (state is ContractCodeLoadedState) {
                                    if (state.screenMappingMobile.isError == true) {
                                      Utils.showInSnackBar(context, state.screenMappingMobile.message.toString(), ToastType.Warning);
                                    } else {
                                      String code = _contractCodeController.text;
                                      String baseUrl = state.screenMappingMobile.data!.url.toString() + '/' +
                                          state.screenMappingMobile.data!.apiRoute.toString() + '/';
                                      await AppSharedPrefs.get().setBaseUrl(baseUrl);
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
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A5F)),
                                          ),
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}