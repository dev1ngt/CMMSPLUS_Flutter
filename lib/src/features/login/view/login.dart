import 'dart:io';

import 'package:cmms/src/constants/app_sizes.dart';
import 'package:cmms/src/features/dashboard/View/dashboard.dart';
import 'package:cmms/src/features/login/bloc/login_bloc.dart';
import 'package:cmms/src/features/login/model/login_model.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:cmms/src/helpers/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../api/api_service.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  bool _isInvalidLoginToastShown = false; // Add this flag
  bool _isLoading = false;
  var logger = Logger();
  LoginInput loginData = LoginInput();

  //final LoginBloc loginBloc = LoginBloc();
  late LoginBloc loginBloc;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String ContractCode = "";
  Color customColor1 = Color(0xFFCBD4F4);

  // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3);
  late ConnectivityResult _connectivityResult;

  // Replace with your custom color
  bool _obscureText = true; // Initially obscure text
  String FCMToken = "";

  @override
  void initState() {
    super.initState();
    //loginBloc = BlocProvider.of<LoginBloc>(context);
    if (context != null) {
      loginBloc = LoginBloc(RepositoryProvider.of<ApiService>(context))
        ..add(LoginFetchEvent());
    }
    _isLoading = false;
    checkInternetConnection();
    fetchContractCode();
    getAccessToken();
  }

  Future<void> fetchContractCode() async {
    ContractCode = await AppSharedPrefs.getContractCode();
    setState(() {}); // Trigger a rebuild after fetching the data
  }

  Future<void> getAccessToken() async {
    FCMToken = await AppSharedPrefs.getAccessToken();
  }

  void _handleNavigation(int resetPassword) {
    if (resetPassword == 1) {
      Navigator.pushNamed(context, '/resetPassword');
    } else {
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _connectivityResult = connectivityResult as ConnectivityResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => loginBloc,
        child: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
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
                      customColor1,
                      customColor2,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            body: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginSuccessState) {
                  if (state.loginResponse.message
                      .toString()
                      .toLowerCase()
                      .contains("login success")) {
                    handleLoginState(state);
                  } else {
                    _isLoading = false;
                    Utils.showInSnackBar(
                        context, "Invalid Login", ToastType.Error);
                  }
                } else if (state is LoginFailureState) {
                  _isLoading = false;
                  if (!_isInvalidLoginToastShown) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Utils.showInSnackBar(
                          context, "Invalid Login", ToastType.Error);
                    });
                    _isInvalidLoginToastShown = true;
                  }
                }

                if (state is ForgotPassLoadedState) {
                  _isLoading = false;
                  Utils.showInSnackBar(context,
                      state.forgotResponseModel.message, ToastType.Error);
                } else if (state is ForgotPassErrorState) {
                  _isLoading = false;
                  Utils.showInSnackBar(context, state.error, ToastType.Error);
                }
              },
              child:
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/client_logo.png',
                          // Make sure to replace this with your image path
                          width: MediaQuery.of(context).size.width,
                        ),
                        gapH20,
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.white,
                          // Set the background color to white
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                gapH10,
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    gapH5,
                                    Container(
                                      height: 50,
                                      child: TextFormField(
                                        textAlign: TextAlign.start,
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding:
                                              EdgeInsets.only(left: 10.0),
                                        ),
                                      ),
                                    ),
                                    gapH10,
                                    Text(
                                      'Password',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    gapH5,
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Adjust border radius as needed
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        // Adjust padding as needed
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                gapH20,
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () {
                                          if (_connectivityResult ==
                                              ConnectivityResult.none) {
                                            Utils.showInSnackBar(
                                                context,
                                                "No internet connection.",
                                                ToastType.Error);
                                          } else {
                                            String username =
                                                _usernameController.text;
                                            String password =
                                                _passwordController.text;

                                            // Validate or process the data as needed
                                            if (username.isNotEmpty &&
                                                password.isNotEmpty) {
                                              setState(() {
                                                _isLoading = true;
                                                _isInvalidLoginToastShown =
                                                    false;
                                              });

                                              loginData.username = username;
                                              loginData.password = password;
                                              loginData.token = FCMToken;
                                              loginData.isAndriod =
                                                  Platform.isAndroid
                                                      ? "1"
                                                      : "2";
                                              loginData.contractCode =
                                                  ContractCode;

                                              loginBloc.add(
                                                  LoginClickEvent(loginData));
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              Utils.showInSnackBar(
                                                  context,
                                                  "Please enter both username and password.",
                                                  ToastType.Error);
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          // Remove padding to allow the Container to take the entire button space
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                customColor2,
                                                customColor1
                                              ], // Replace with your gradient colors
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 150.0,
                                                minHeight: 45.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                gapH10,
                                GestureDetector(
                                  onTap: () {
                                    print("Forgot Password ");
                                    _showDialog(context);
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
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
                );
              }),
            ),
            bottomNavigationBar: Image.asset(
              'assets/images/bottom_building.png',
              // Replace with your image path
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ));
  }

  void _showDialog(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter your email to reset your password:'),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Reset password logic here
                String email = _emailController.text;
                if (email.isNotEmpty) {
                  // Check if the email is not empty
                  Navigator.of(context).pop();
                  loginBloc.add(ForgotPasswordClickEvent(
                      email: email)); // Pass the email to your Bloc
                } else {
                  // Show an error message or handle the case where the email is empty
                  Utils.showInSnackBar(
                      context, "Enter the mail address", ToastType.Error);
                }
              },
              child: Text('Reset Password'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleLoginState(LoginState state) async {
    if (state is LoginSuccessState) {
     // logger.e("Login2>>>", error: state.loginResponse.userinfo?.id);
      String? token = state.loginResponse.token;
      String? userId = state.loginResponse.userinfo?.id;
      String? username = state.loginResponse.userinfo?.username;
      String? email = state.loginResponse.userinfo?.email;
      String? phone = state.loginResponse.userinfo?.phone;
      String? role = state.loginResponse.userinfo?.role;
      String? firstname = state.loginResponse.userinfo?.firstName;
      String? lastname = state.loginResponse.userinfo?.lastName;
      int? resetPassword = state.loginResponse.resetPassword;
      String? uniqueId = state.loginResponse.userinfo?.uniqueId;

      // Update data in shared preference
      await AppSharedPrefs.get().setUserID(userId!);
      await AppSharedPrefs.get().setUsername(username!);
      await AppSharedPrefs.get().setEmail(email!);
      await AppSharedPrefs.get().setPhone(phone!);
      await AppSharedPrefs.get().setUserRole(role!);
      await AppSharedPrefs.get().setFirstname(firstname!);
      await AppSharedPrefs.get().setLastname(lastname!);
      await AppSharedPrefs.get().setUniqueId(uniqueId!);
      await AppSharedPrefs.get().setLoginToken(token!);

      _isLoading = false;
      _handleNavigation(resetPassword!); // Use the navigation function
    }
  }
}
