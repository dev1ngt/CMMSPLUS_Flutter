import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/fm/features/login/model/login_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';

import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreenFM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  late LoginBloc loginBloc;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Initially obscure text
  LoginInputFM loginData = LoginInputFM();
  String contractCode = "";
  String  fcmToken = "";
  late ConnectivityResult _connectivityResult;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc(RepositoryProvider.of<ApiService>(context));
    loginBloc.add(LoginFetchEvent());
    checkInternetConnection();
    fetchContractCode();
    getAccessToken();
  }

  Future<void> fetchContractCode() async {
    contractCode = await AppSharedPrefs.getContractCode();
    setState(() {}); // Trigger a rebuild after fetching the data
  }


  Future<void> getAccessToken() async {
    fcmToken = await AppSharedPrefs.getAccessToken();
    print(fcmToken);
  }

  void _handleNavigation() {
    Navigator.pushNamed(context, '/dashboardfm');
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color customColor1 = Color(0xFF006BE6); // Primary color used in the gradient
    return BlocProvider(
        create: (context) => loginBloc,
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
      child: Scaffold(
        body: SingleChildScrollView(
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
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please enter the user credentials.",
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
                        const SizedBox(height: 150),
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Username',
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

                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // Handle login button press

                            String username = _usernameController.text;
                            String password = _passwordController.text;

                            // Validate or process the data as needed
                            if (username.isNotEmpty && password.isNotEmpty) {

                            loginData.username = username;
                            loginData.password = password;
                            loginData.token = fcmToken;
                            loginData.isAndriod = Platform.isAndroid? "1":"2";

                            loginBloc.add(LoginClickEvent(loginData));

                            } else {
                            Utils.showInSnackBar(context,"Please enter both username and password.",
                            ToastType.Error);
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

                        /* Load API */

                        BlocListener<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginSuccessState) {
                              print(state.loginResponse.message);
                              handleLoginState(state);
                              Utils.showInSnackBar(context, " Login Success", ToastType.Success);

                            } else if (state is LoginFailureState) {
                              print(state.toString());
                              Utils.showInSnackBar(context, "Invalid Login", ToastType.Warning);
                            }
                          },
                          child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoading) {
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
      ),
    ),);
  }

  Future<void> handleLoginState(LoginState state) async {
    if (state is LoginSuccessState) {

      String? userId = state.loginResponse.data?.userId.toString();
      String? username = state.loginResponse.data?.userName;
      String? token  = state.loginResponse.data?.token;
      String? clientToken = state.loginResponse.data?.xAuthClient;
      String? employeeid = state.loginResponse.data?.employeeId.toString();


      // Update data in shared preference
      await AppSharedPrefs.get().setUserID(userId!);
      await AppSharedPrefs.get().setUsername(username!);
      await AppSharedPrefs.get().setToken(token!);
      await AppSharedPrefs.get().setClientToken(clientToken!);
      await AppSharedPrefs.get().setEmployeeID(employeeid!);

      print(username);
      _handleNavigation(); // Use the navigation function
    }
  }
}

