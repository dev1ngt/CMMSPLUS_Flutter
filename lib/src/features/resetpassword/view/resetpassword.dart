import 'package:cmms/src/features/login/View/login.dart';
import 'package:cmms/src/features/resetpassword/bloc/resetpass_bloc.dart';
import 'package:cmms/src/features/resetpassword/bloc/resetpass_state.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../api/api_service.dart';
import '../../../constants/app_sizes.dart';
import '../../../helpers/utils/app_shared_preference.dart';
import '../../../helpers/utils/utils.dart';
import '../../login/model/login_model.dart';
import '../bloc/resetpass_event.dart';

class ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResetPasswordView();
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordView();
}

class _ResetPasswordView extends State<ResetPasswordView> {
  bool _isInvalidLoginToastShown = false; // Add this flag
  bool _isLoading = false;
  var logger = Logger();
  LoginInput loginData = LoginInput();

  //final LoginBloc loginBloc = LoginBloc();
  late ResetPassBloc resetPassBloc;
  bool _obscureText_current_psw = true,
      _obscureText_new_psw = true,
      _obscureText_confirm_psw = true;
  TextEditingController _currentPasswordController = TextEditingController();

  TextEditingController _newPasswordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();



  String username = '';

  @override
  void initState() {
    super.initState();

    if (context != null) {
      resetPassBloc = ResetPassBloc(RepositoryProvider.of<ApiService>(context))
        ..add(ResetPassFetchEvent());
    }
    _isLoading = false;
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    username = await AppSharedPrefs.getUsername();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showInSnackBar(
          context, "Your password has expired. Please change your password",
          ToastType.Error);
    });
  }
  void _navigateToNextPage(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  void _handleNavigation() {
    AppSharedPrefs.get().setUsername("");
    Navigator.pushNamed(context, '/login');
  }


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (context) => resetPassBloc,
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
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
              /*  Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png',
                  // replace with your image path
                  width: 100,
                  height: 20,
                ),*/
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle your onClick event here
                    Navigator.pushNamed(context,
                        '/dashboard'); // Example: Navigate to home page
                  },
                  child: Image.asset(
                    'assets/images/ic_home.png',
                    // replace with your image path
                    width: 20,
                    height: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
        /*    flexibleSpace: Container(
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
          body: BlocListener<ResetPassBloc, ResetPassState>(
            listener: (context, state) async {
              if (state is ResetPassLoadedState) {
                if (state.resetResponseModel.isError) {
                  _isLoading = false;
                  Utils.showInSnackBar(context,
                      state.resetResponseModel.message, ToastType.Error);
                } else {
                  Utils.showInSnackBar(context,
                      state.resetResponseModel.message, ToastType.Success);

                  _handleNavigation();
                 // _navigateToNextPage(context);
                 /* WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSharedPrefs.get().setUsername("");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  });*/

                 /* Future.delayed(Duration.zero, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  });*/

                }
              } else if (state is ResetPassErrorState) {
                _isLoading = false;

                Utils.showInSnackBar(
                    context, "Invalid Login", ToastType.Error);
              }
            },
            child: BlocBuilder<ResetPassBloc, ResetPassState>(
                builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "RESET PASSWORD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      // Adjust padding as needed
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText_current_psw
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText_current_psw =
                                                !_obscureText_current_psw;
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      // Adjust padding as needed
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText_new_psw
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText_new_psw =
                                                !_obscureText_new_psw;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  gapH10,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      // Adjust padding as needed
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText_confirm_psw
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText_confirm_psw =
                                                !_obscureText_confirm_psw;
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
                                            if (new_pass == username) {
                                              Utils.showInSnackBar(
                                                  context,
                                                  "Password cannot be same as username.",
                                                  ToastType.Error);
                                            } else {
                                              checkPassword(new_pass);
                                            }
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
                                          color: AppColors.themeColor,
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
                                                color: Colors.white),
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
       /*   bottomNavigationBar: Image.asset(
            'assets/images/bottom_building.png',
            // Replace with your image path
            width: MediaQuery.of(context).size.width,
          ),*/
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

  void checkPassword(String password) {
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#\^=%`()-_+<>?/,.$&*~]'));
    bool hasMinLength = password.length >= 8;

    // Check each condition and show a Toast message if it's missing
    if (!hasLowercase ||
        !hasUppercase ||
        !hasDigit ||
        !hasSpecialChar ||
        !hasMinLength) {
      Utils.showInSnackBar(
          context,
          "Password must contain :\n"
          "- 8 characters\n"
          "- 1 uppercase\n"
          "- 1 lowercase\n"
          "- 1 number\n"
          "- 1 special character\n",
          ToastType.Error);
    } else {
      // Final validation: if all conditions are met
      if (hasLowercase &&
          hasUppercase &&
          hasDigit &&
          hasSpecialChar &&
          hasMinLength) {
        setState(() {
          _isLoading = true;
          _isInvalidLoginToastShown = false;
        });

        resetPassBloc.add(SubmitClickEvent(
          current_password: _currentPasswordController.text.toString(),
          new_password: _newPasswordController.text.toString(),
          confirm_password: _confirmPasswordController.text.toString(),
        ));
      }

    }
  }
}
