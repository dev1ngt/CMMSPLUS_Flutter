import 'package:cmms/src/api/api_service.dart';
import 'package:cmms/src/fm/features/dashboard/bloc/module_bloc.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/utils.dart';
import '../bloc/module_event.dart';
import '../bloc/module_state.dart';
import '../model/model_response.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dashboard();
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late ModuleBloc moduleBloc;
  List<Module> moduleList = []; // List to hold Module objects
  String username = "";

  @override
  void initState() {
    super.initState();
    moduleBloc = ModuleBloc(RepositoryProvider.of<ApiService>(context));
    checkInternetAndFetchData();
    getSharedPrefe();
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
      moduleBloc.add(ModuleCountEvent());
    }
  }

  Future<void> getSharedPrefe() async {
    username = await AppSharedPrefs.getUsername();
    setState(() {});
  }

  Future<void> _refresh() async {
    await checkInternetAndFetchData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => moduleBloc,
        child: WillPopScope(
          onWillPop: () async {
            // Handle back button press
            print("back");
            return false;
          },
          child: BlocListener<ModuleBloc, ModuleState>(
            listener: (context, state) {
              if (state is ModuleSuccessState) {
                setState(() {
                  moduleList = state.moduleResponse.module;
                });
              } else if (state is ModuleFailureState) {
                // Handle failure state if needed
              }
            },
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left side: User image and information
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/images/user_avatar.png'), // Replace with your own image
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Hello,",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      username,
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Right side: Logout button
                            GestureDetector(
                              onTap: () {
                                _showCustomDialog();
                              },
                              child: Icon(
                                Icons.exit_to_app,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(60),
                            topLeft: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20.0,
                                  crossAxisSpacing: 20.0,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: moduleList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return DashboardCard(
                                    title: moduleList[index].title,
                                    total: moduleList[index].total,
                                    close: moduleList[index].completed,
                                  );
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
          ),
        ),
      ),
    );
  }

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF006BE6), // Blue background color
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Alert',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.pushNamed(context, '/loginfm');
                        await AppSharedPrefs.get().setUsername("");
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Color(0xFF006BE6),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
class DashboardCard extends StatelessWidget {
  final String title;
  final int total;
  final int close;

  const DashboardCard({
    required this.title,
    required this.total,
    required this.close,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.assignment; // Default icon

    // Map titles to corresponding icons
    Map<String, IconData> titleToIcon = {
      'CM': Icons.business,
      'PPM': Icons.note_alt_sharp,
      'Tenant': Icons.house_outlined,
      'Title C': Icons.school,
      // Add more mappings as needed
    };

    // Check if the title exists in the mapping
    if (titleToIcon.containsKey(title)) {
      iconData = titleToIcon[title]!;
    }

    return GestureDetector(
      onTap: () {
        // Navigate to a new screen on card click
        print(title);

        if(title == "CM"){
          Navigator.pushNamed(context, '/cmstatusview');
        }
        else if(title == "PM"){
          Navigator.pushNamed(context, '/ppmworkstatusview');
        }
        else if(title == "Tenant"){
          Navigator.pushNamed(context, '/complaintReg');
        }

      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 45,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.lightGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          close.toString(),
          style: TextStyle(
            color: Colors.lightGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


              Text(
                "/",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          total.toString(),
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
            ],
        ),


       /* Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.lightGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),*/
          ],
        ),
      ),
    );

  }


}