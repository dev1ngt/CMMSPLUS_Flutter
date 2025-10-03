import 'dart:convert';
import 'dart:io';

import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../../api/api_service.dart';
import '../../../helpers/utils/utils.dart';
import '../details_view_bloc/adhoc_details_state.dart';
import '../details_view_bloc/adhoc_details_view_bloc.dart';
import '../details_view_bloc/adhoc_details_view_event.dart';

class AdhocInspection extends StatelessWidget {
  const AdhocInspection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdhocDetailsViewBloc>(
          create: (context) => AdhocDetailsViewBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: AdhocInspectionView(),
    );
  }
}


class AdhocInspectionView extends StatefulWidget {
  const AdhocInspectionView({Key? key}) : super(key: key);

  @override
  _AdhocInspectionState createState() => _AdhocInspectionState();
}

class _AdhocInspectionState extends State<AdhocInspectionView> {
  late InAppWebViewController _controller;
  bool _isExpanded = true;
  late String webUrl;
  int inspectionID = 0;
  late AdhocDetailsViewBloc adhocDetailsViewBloc;
  final TextEditingController   regionController = TextEditingController();
  final TextEditingController _propertyController = TextEditingController();
  final TextEditingController _spaceFloorController = TextEditingController();
  final TextEditingController _inspectionClassController = TextEditingController();
  final TextEditingController _inspectorController = TextEditingController();
  final TextEditingController _occupantController = TextEditingController();
  final TextEditingController _locationBlockController = TextEditingController();
  final TextEditingController _assetController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _requestPermissions();

    adhocDetailsViewBloc = AdhocDetailsViewBloc(RepositoryProvider.of<ApiService>(context));

  }

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };


  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  @override
  void dispose() {
    regionController.dispose();
    _propertyController.dispose();
    _spaceFloorController.dispose();
    _inspectionClassController.dispose();
    _inspectorController.dispose();
    _occupantController.dispose();
    _locationBlockController.dispose();
    _assetController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access arguments safely here
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    webUrl = args['WebView'];
    inspectionID = args['inspectionID'];
    adhocDetailsViewBloc.add(AdhocDetailsViewPageEvent(inspectionID));
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => adhocDetailsViewBloc,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/adhocScreen');
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
             /*   Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png',
                  width: 100,
                  height: 20,
                ),*/
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  child: Image.asset(
                    'assets/images/ic_home.png',
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
                  colors: [AppColors.whiteColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "ADHOC INSPECTION VIEW",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 20),

                  BlocListener<AdhocDetailsViewBloc, AdhocDetailsViewState>(
                    listener: (context, state) {
                      if (state is AdhocDetailsViewLoadedState) {
                        setState(() {
                          regionController.text =
                              state.adhocDetailsViewModel.data.regionName;
                          _propertyController.text =
                              state.adhocDetailsViewModel.data.propertyName;
                          _spaceFloorController.text =
                              state.adhocDetailsViewModel.data.levelName;
                          _inspectionClassController.text =
                              state.adhocDetailsViewModel.data.inspectionClass;
                          _inspectorController.text =
                              state.adhocDetailsViewModel.data.inspector;
                          _occupantController.text =
                              state.adhocDetailsViewModel.data.occupant;
                          _locationBlockController.text =
                              state.adhocDetailsViewModel.data.location;
                          _assetController.text = state.adhocDetailsViewModel.data.assetName;
                        });
                      } else if (state is AdhocDetailsViewErrorState) {
                        Utils.showInSnackBar(
                            context, state.error, ToastType.Warning);
                      }
                    },
                    child: BlocBuilder<AdhocDetailsViewBloc,
                        AdhocDetailsViewState>(
                      builder: (context, state) {
                        if (state is AdhocDetailsViewLoadingState) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Container();
                      },
                    ),
                  ),
                  _buildInputField(Icons.ac_unit_outlined, regionController, 'Region',readOnly: true),
                  SizedBox(height: 10),
                  _buildInputField(Icons.book, _propertyController, 'Property'),
                  SizedBox(height: 10),
                  _buildInputField(
                      Icons.flood_rounded, _spaceFloorController, 'Space / Floor'),
                  SizedBox(height: 10),
                  _buildInputField(Icons.work,
                      _inspectionClassController, 'Inspection Class'),
                  SizedBox(height: 10),
                  _buildInputField(
                      Icons.man_2, _inspectorController, 'Inspector'),
                  SizedBox(height: 10),
                  _buildInputField(
                      Icons.man, _occupantController, 'Occupant'),
                  SizedBox(height: 10),
                  _buildInputField(Icons.location_city,
                      _locationBlockController, 'Location / Block'),
                  SizedBox(height: 20),
                  _buildInputField(Icons.web_asset,
                      _assetController, 'Asset'),
                  SizedBox(height: 20),

                  // WebView with inner scrolling
                  Container(
                    height: 400,  // Adjust height as needed
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.parse(webUrl)),
                      ),
                      onWebViewCreated: (controller) {
                        _controller = controller;
                      },
                      gestureRecognizers: gestureRecognizers,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, TextEditingController controller, String label,{
    bool readOnly = false,}) {
    return UniformInputFieldRow(
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: label,
              ),
            ),
          ),
        ],
      ),
    );
  }

}


class UniformInputFieldRow extends StatelessWidget {
  final Widget child;

  UniformInputFieldRow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: child, // Input field spans evenly across the row
        ),
      ],
    );
  }
}