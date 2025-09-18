import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../api/api_service.dart';
import '../../../constants/app_sizes.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/utils.dart';
import '../../login/bloc/login_bloc.dart';
import '../../login/model/login_model.dart';
import '../bloc/forgotpass_bloc.dart';
import '../bloc/forgotpass_event.dart';
import '../bloc/forgotpass_state.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordView();
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordView();
}

class _ForgotPasswordView extends State<ForgotPasswordView> {
  bool _isInvalidLoginToastShown = false; // Add this flag
  bool _isLoading = false;
  var logger = Logger();
  LoginInput loginData = LoginInput();

  //final LoginBloc loginBloc = LoginBloc();
  late ForgotPassBloc forgotPassBloc;
  bool _obscureText_current_psw = true , _obscureText_new_psw = true, _obscureText_confirm_psw = true;
  TextEditingController _currentPasswordController = TextEditingController();

  TextEditingController _newPasswordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

  Color customColor1 = Color(0xFFCBD4F4);

  // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3);

  // Replace with your custom color

  @override
  void initState() {
    super.initState();

    if (context != null) {
      forgotPassBloc =
          ForgotPassBloc(RepositoryProvider.of<ApiService>(context))
            ..add(ForgotPassFetchEvent());
    }
    _isLoading = false;
  }

  void _handleNavigation() {
    Navigator.pushNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => forgotPassBloc,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/ic_back.png',
                        // Replace with your ic_back image asset
                        width: 25,
                        height: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/images/ecms_logo.png',
                    // replace with your image path
                    width: 100,
                    height: 20,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Handle your onClick event here
                      Navigator.pushNamed(context, '/dashboard'); // Example: Navigate to home page
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
            body: BlocListener<ForgotPassBloc, ForgotPassState>(
              listener: (context, state) async {
                if (state is ForgotPassLoadedState) {
                  if (state.forgotResponseModel.isError) {
                    _isLoading = false;
                    Utils.showInSnackBar(context,
                        state.forgotResponseModel.message, ToastType.Error);
                  } else {

                    Utils.showInSnackBar(context,
                        state.forgotResponseModel.message, ToastType.Success);
                    _handleNavigation();
                  }
                } else if (state is ForgotPassErrorState) {
                  _isLoading = false;

                  Utils.showInSnackBar(
                      context, "Invalid Login", ToastType.Error);
                }
              },
              child: BlocBuilder<ForgotPassBloc, ForgotPassState>(
                  builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                      'Current Password :',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    gapH5,
                                    TextFormField(
                                      controller: _currentPasswordController,
                                      obscureText: _obscureText_current_psw,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0), // Adjust padding as needed
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText_current_psw ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText_current_psw = !_obscureText_current_psw;
                                            });
                                          },
                                        ),
                                      ),

                                    ),
                                    gapH10,
                                    Text(
                                      'New Password :',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    gapH5,
                                    TextFormField(
                                      controller: _newPasswordController,
                                      obscureText: _obscureText_new_psw,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0), // Adjust padding as needed
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText_new_psw ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText_new_psw = !_obscureText_new_psw;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Confirm Password :',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    gapH5,
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: _obscureText_confirm_psw,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0), // Adjust padding as needed
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText_confirm_psw ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText_confirm_psw = !_obscureText_confirm_psw;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    gapH10,
                                  ],
                                ),
                                gapH20,
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () {
                                          // Handle button press
                                          // Handle button press
                                          String current_pass =
                                              _currentPasswordController.text;
                                          String confirm_pass =
                                              _confirmPasswordController.text;
                                          String new_pass =
                                              _newPasswordController.text;

                                          // Validate or process the data as needed
                                          if (current_pass.isNotEmpty &&
                                              confirm_pass.isNotEmpty &&
                                              new_pass.isNotEmpty) {
                                            if (new_pass == confirm_pass) {
                                              setState(() {
                                                _isLoading = true;
                                                _isInvalidLoginToastShown =
                                                    false;
                                              });

                                              forgotPassBloc
                                                  .add(SubmitClickEvent(
                                                current_password: current_pass,
                                                new_password: new_pass,
                                                confirm_password: confirm_pass,
                                              ));
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              Utils.showInSnackBar(
                                                  context,
                                                  "New and Confirm password should be same.",
                                                  ToastType.Error);
                                            }
                                          } else {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Utils.showInSnackBar(
                                                context,
                                                "Please fill all fields.",
                                                ToastType.Error);
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
                                              'Submit',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                gapH10,
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

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
