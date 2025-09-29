import 'dart:io';

import 'package:cmms/src/constants/app_sizes.dart';
import 'package:cmms/src/features/dashboard/View/dashboard.dart';
import 'package:cmms/src/features/login/bloc/login_bloc.dart';
import 'package:cmms/src/features/login/model/login_model.dart';
import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
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
  bool _isInvalidLoginToastShown = false;
  bool _isLoading = false;
  var logger = Logger();
  LoginInput loginData = LoginInput();

  late LoginBloc loginBloc;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String ContractCode = "";

  late ConnectivityResult _connectivityResult;

  bool _obscureText = true;
  String FCMToken = "";

  @override
  void initState() {
    super.initState();
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
    setState(() {});
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
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(20.00),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
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
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo and Title Section
                          Image.asset(
                            'assets/images/cmms_plus_logo.png',
                            width: 200,
                            height: 80,
                          ),
                          gapH10,
                          Text(
                            'Computerized Maintenance',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Management System',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          gapH32,
                          // Login Card
                          Container(
                            padding: EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                gapH5,
                                Text(
                                  'Sign in to your account',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                gapH32,
                                // Username Field
                                Text(
                                  'Username',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                gapH8,
                                Container(
                                  height: 50,
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your username',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
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
                                        borderSide: BorderSide(color: AppColors.customColor1),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                    ),
                                  ),
                                ),
                                gapH20,
                                // Password Field
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                gapH8,
                                Container(
                                  height: 50,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
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
                                        borderSide: BorderSide(color: AppColors.customColor1),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                gapH12,
                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("Forgot Password ");
                                      _showDialog(context);
                                    },
                                    child: Text(
                                      'Forget Password ?',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                gapH32,
                                // Submit Button
                                _isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
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
                                      backgroundColor: Color(0xFF0A2647),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'SUBMIT',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
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
                String email = _emailController.text;
                if (email.isNotEmpty) {
                  Navigator.of(context).pop();
                  loginBloc.add(ForgotPasswordClickEvent(email: email));
                } else {
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
      _handleNavigation(resetPassword!);
    }
  }
}