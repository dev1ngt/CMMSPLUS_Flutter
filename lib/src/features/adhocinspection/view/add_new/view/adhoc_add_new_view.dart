
import 'dart:math';

import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../api/api_service.dart';
import '../../../../../helpers/utils/app_shared_preference.dart';
import '../../../../../helpers/utils/utils.dart';
import '../../../../pendingresponse/model/property_model.dart';
import '../bloc/adhoc_add_new_view_bloc.dart';
import '../bloc/adhoc_add_new_view_event.dart';
import '../bloc/adhoc_add_new_view_state.dart';
import '../model/adhoc_add_new_asset_model.dart';
import '../model/adhoc_add_new_space_floor_model.dart';
import '../model/adhoc_addnew_view_model.dart';
class AdhocAddNewView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdhocAddNewViewBloc>(
          create: (context) => AdhocAddNewViewBloc(RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: PurchaseRequestScreen(),
    );
  }
}

class PurchaseRequestScreen extends StatefulWidget {
  @override
  _PurchaseRequestScreen createState() => _PurchaseRequestScreen();
}

class _PurchaseRequestScreen extends State<PurchaseRequestScreen> {

  late AdhocAddNewViewBloc addNewViewBloc;
  bool isDataLoading = true;
  String? regionName = "";
  List<AdhocProperty> propertyList = [];
  List<SpaceFloor> spaceFloorList = [];
  List<InspectionClass> insepctionClassList = [];
  List<AdhocAsset> assetList = [];
  List<SpaceFloorFilter> spaceFloorFilterlist = [];
  List<AdhocAssetFilter> assetFilterList = [];

  final TextEditingController _inspectorController = TextEditingController();
  final TextEditingController _occupantController = TextEditingController();
  final TextEditingController _locationBlockController = TextEditingController();

  bool showRegionField = false;
  String? selectedPropertyName = "";
  String? selectedSpaceFloorName = "";
  String? selectedInspectionClassName = "";
  String? selectedAssetName = "";
  String webUrl = "", myToken = "" ,username = "";

  String token = "";
  int? selectedPropertyID = 0;
  int? selectedSpaceFloorID = 0;
  int? selectedInspectionClassID = 0;
  int? selectedAssetID = 0;

  late InAppWebViewController _controller;
  bool isWebViewVisible = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    addNewViewBloc = BlocProvider.of<AdhocAddNewViewBloc>(context);
    addNewViewBloc.add(AdhocAddNewViewItemEvent());
    fetchUsername();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  Future<void> fetchUsername() async {
    username = await AppSharedPrefs.getUsername();
    token = await AppSharedPrefs.getAccessToken();
    setState(() {
      _inspectorController.text = username;

    });
  }

  @override
  void dispose() {
    addNewViewBloc.close();
    _inspectorController.clear();
    _occupantController.clear();
    _locationBlockController.clear();
    super.dispose();
  }

  String generateCode(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    // Generate a random string of the specified length
    String code = List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
    return code;
  }

  // Method to refresh the WebView when the URL is updated
  void _refreshWebView() {
    _controller.loadUrl(urlRequest: URLRequest(
        url: WebUri.uri(Uri.parse(webUrl))));

  }

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
          /*  Spacer(),
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
              colors: [
                AppColors.whiteColor
              ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Create Adhoc Inspection',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),

              BlocListener<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                listener: (context, state) async {
                  if (state is AdhocAddNewViewLoadedState) {
                    // Step 1: Show loader
                    setState(() {
                      isDataLoading = true;
                    });

                    // Step 2: Give UI a chance to rebuild and show the loader
                    //await Future.delayed(Duration(milliseconds: 100));

                    // Step 3: Do heavy processing
                    propertyList = state.addNewViewResponseModel.propertyList;
                    spaceFloorList = state.addNewViewResponseModel.spaceFloorList;
                    insepctionClassList = state.addNewViewResponseModel.inspectionClassList;
                    //assetList = state.addNewViewResponseModel.assetList;

                    // Step 4: Hide loader after work is done
                    setState(() {
                      isDataLoading = false;
                    });
                  } else if (state is AdhocAddNewViewErrorState) {
                    Utils.showInSnackBar(context, state.errorMessage, ToastType.Warning);
                  }
                },
                child: BlocBuilder<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                    builder: (context, state) {
                      if (state is AdhocAddNewViewLoadingState || isDataLoading) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16), // spacing between loader and text
                              Text(
                                "Please wait a moment...",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
              SizedBox(height: 10),
              if (showRegionField) ...[
                Row(
                  children: [
                    Icon(Icons.ac_unit_outlined),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        initialValue: regionName,
                        decoration: InputDecoration(
                          hintText: "Region",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 10),
              UniformInputFieldRow(
                child: DropdownField<AdhocProperty>(
                  icon: Icons.book,
                  hint: "Property *",
                  items: propertyList,
                  displayValue: (property) => property.propertyName,
                  onChanged: (property) {
                    selectedPropertyName = property?.propertyName;
                    selectedPropertyID = property?.id;
                    addNewViewBloc.add(AdhocAddNewSpaceFloorFilterEvent(selectedPropertyID!));
                    addNewViewBloc.add(AdhocAddNewAssetFilterEvent(selectedPropertyID!));
                    showRegionField = property != null;
                  },
                ),
              ),
              SizedBox(height: 10),

              // Asset  APIs Response
              BlocListener<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                listener: (context, state) async {
                  if (state is AdhocAddNewSpaceFloorLoadedState) {
                    setState(() {
                      if (state.addNewSpaceFloorModel.levelList.isNotEmpty) {
                        spaceFloorList.clear();
                        spaceFloorFilterlist.clear();
                        regionName = state.addNewSpaceFloorModel.regionName;
                        print("region2 $regionName");
                        spaceFloorFilterlist =
                            state.addNewSpaceFloorModel.levelList;
                        spaceFloorList = spaceFloorFilterlist
                            .map((e) =>
                            SpaceFloor(id: e.id, levelName: e.levelName))
                            .toSet()
                            .toList(); // Ensure unique items

                        // **Reset selected value if it no longer exists**
                        if (!spaceFloorList
                            .any((item) => item.id == selectedSpaceFloorID)) {
                          selectedSpaceFloorID = null;
                          selectedSpaceFloorName = null;
                        }
                      } else {
                        spaceFloorList.clear();
                        spaceFloorFilterlist.clear();
                        selectedSpaceFloorID = null;
                        selectedSpaceFloorName = null;
                      }
                    });
                  }  else if (state is AdhocAddNewSpaceFloorErrorState) {
                    Utils.showInSnackBar(context, state.errorMessage, ToastType.Warning);
                  }
                },
                child: BlocBuilder<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                    builder: (context, state) {
                      if (state is AdhocAddNewSpaceFloorLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                    }),
              ),


              UniformInputFieldRow(
                child:  DropdownField<SpaceFloor>(
                  icon: Icons.flood_rounded,
                  hint: 'Space / Floor *',
                  items: spaceFloorList,
                  displayValue: (spaceFloor) => spaceFloor.levelName,
                  value: spaceFloorList
                      .firstWhere(
                        (item) => item.id == selectedSpaceFloorID,
                    orElse: () => SpaceFloor(
                        id: -1, levelName: ''), // Dummy object
                  )
                      .id !=
                      -1
                      ? spaceFloorList.firstWhere(
                        (item) => item.id == selectedSpaceFloorID,
                    orElse: () => SpaceFloor(id: -1, levelName: ''),
                  )
                      : null,
                  // Ensure null if no valid match
                  onChanged: (spaceFloor) {
                    selectedSpaceFloorName = spaceFloor?.levelName;
                    selectedSpaceFloorID = spaceFloor?.id;
                  },
                ),
              ),
              SizedBox(height: 10),

              // Webview APIs Response
              BlocListener<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                listener: (context, state) async {
                  if (state is AdhocAddNewWebViewLoadedState) {
                    setState(() {
                      webUrl = state.adhocInspectionWebViewResponseModel.inspectionClassData.webViewUrl;
                      print(webUrl);
                    });

                    _refreshWebView();

                  } else if (state is AdhocAddNewWebViewErrorState) {
                    Utils.showInSnackBar(context, state.errorMessage, ToastType.Warning);
                  }
                },
                child: BlocBuilder<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                    builder: (context, state) {
                      if (state is AdhocAddNewWebViewLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                    }),
              ),

              UniformInputFieldRow(
                child: DropdownField<InspectionClass>(
                  icon: Icons.work,
                  hint: 'Inspection Class *',
                  items: insepctionClassList,
                  displayValue: (inspectionClass) => inspectionClass.templateTitle,
                  onChanged: (inspectionClass) {
                    selectedInspectionClassName = inspectionClass?.templateTitle;
                    selectedInspectionClassID = inspectionClass?.id;
                    myToken = generateCode(20);
                    addNewViewBloc.add(AdhocAddNewWebViewEvent(selectedInspectionClassID! ,myToken));

                  },
                ),
              ),
              SizedBox(height: 10),

              UniformInputFieldRow(
                child: Row(
                  children: [
                    Icon(Icons.man, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _inspectorController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Inspector *',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              UniformInputFieldRow(
                child: Row(
                  children: [
                    Icon(Icons.man, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _occupantController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Occupant',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),



              UniformInputFieldRow(
                child: Row(
                  children: [
                    Icon(Icons.location_city, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _locationBlockController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Location / Block',
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              // Asset  APIs Response
              BlocListener<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                listener: (context, state) async {
                  if (state is AdhocAddNewAssetLoadedState) {
                    setState(() {
                      assetList.clear();
                      assetFilterList.clear();

                      assetFilterList =
                          List.from(state.addNewAssetModel.assetList);
                      assetList = assetFilterList
                          .map((e) =>
                          AdhocAsset(id: e.id, assetName: e.assetName))
                          .toSet()
                          .toList(); // Ensure unique items

                      // Reset selection if the previously selected item is no longer in the list
                      if (!assetList
                          .any((item) => item.id == selectedAssetID)) {
                        selectedAssetID = 0;
                        selectedAssetName = null;
                      } else {
                        assetList.clear();
                        assetFilterList.clear();
                        selectedAssetID = 0;
                        selectedAssetName = null;
                      }
                    });
                  } else if (state is AdhocAddNewAssetErrorState) {
                    Utils.showInSnackBar(context, state.errorMessage, ToastType.Warning);
                  }
                },
                child: BlocBuilder<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                    builder: (context, state) {
                      if (state is AdhocAddNewAssetLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                    }),
              ),



              SizedBox(height: 10),

              UniformInputFieldRow(
                child: DropdownField<AdhocAsset>(

                  icon: Icons.web_asset,
                  hint: 'Asset',
                  items: assetList,
                  displayValue: (asset) => asset.assetName,
                  // assuming ContractType has a name property
                  value: assetList
                      .firstWhere(
                        (item) => item.id == selectedAssetID,
                    orElse: () => AdhocAsset(
                        id: -1, assetName: ''), // Dummy object
                  )
                      .id !=
                      -1
                      ? assetList.firstWhere(
                        (item) => item.id == selectedAssetID,
                    // Fix: Corrected ID reference
                    orElse: () => AdhocAsset(id: -1, assetName: ''),
                  )
                      : null,
                  // Ensure null if no valid match
                  onChanged: (asset) {
                    selectedAssetName = asset?.assetName;
                    selectedAssetID = asset?.id;
                    // Handle the selected contract type
                  },),
              ),
              SizedBox(height: 10),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Inspection:', style: TextStyle(fontSize: 19, color: Colors.black)),
                  IconButton(
                    icon: isWebViewVisible ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                    onPressed: () {

                      setState(() {
                        isWebViewVisible = !isWebViewVisible; // Toggle visibility
                      });

                      // Handle inspection expand
                    },
                  ),
                ],
              ),

              Visibility(
                visible: isWebViewVisible,

                child: Container(
                  width: double.infinity, // Take full width
                  height: 500, // Set a fixed height for the WebView
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
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
                ),),

              SizedBox(height: 10),


              // Submit  APIs Response
              BlocListener<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                listener: (context, state) async {
                  if (state is AdhocAddNewSubmitLoadedState) {

                    if(state.adhocInspectionSubmitModel.isError){
                      Utils.showInSnackBar(context,
                          state.adhocInspectionSubmitModel.message, ToastType.Error);

                    }
                    else {
                      Utils.showInSnackBar(context,
                          state.adhocInspectionSubmitModel.message, ToastType.Success);

                      Navigator.pushNamed(context, '/adhocScreen');
                    }




                  } else if (state is AdhocAddNewSubmitErrorState) {
                    Utils.showInSnackBar(context, state.errorMessage, ToastType.Warning);
                  }
                },
                child: BlocBuilder<AdhocAddNewViewBloc, AdhocAddNewViewState>(
                    builder: (context, state) {
                      if (state is AdhocAddNewSubmitLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                    }),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("ok");

                      if(selectedInspectionClassName!.isEmpty){
                        print("select an inspection class");
                        Utils.showInSnackBar(context,
                            "Select an inspection class", ToastType.Warning);


                      }
                      else if(selectedSpaceFloorName!.isEmpty){
                        print("select an space/floor class");
                        Utils.showInSnackBar(context,
                            "Select an space/floor ", ToastType.Warning);



                      }
                      else if(selectedPropertyName!.isEmpty){
                        print("select an property name class");
                        Utils.showInSnackBar(context,
                            "Select an property name ", ToastType.Warning);

                      }
                      else if(_inspectorController.text.isEmpty){
                        print("Inspector name needed");
                        Utils.showInSnackBar(context,
                            "Inspector name needed ", ToastType.Warning);
                      }
                      else {

                        addNewViewBloc.add(AdhocAddNewSubmitEvent(selectedInspectionClassID! , myToken , selectedPropertyID!, selectedSpaceFloorID!, selectedAssetID! , _occupantController.text , _locationBlockController.text ));

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
                        color: AppColors.themeColor, // ✅ use your theme color
                        borderRadius: BorderRadius.circular(10.0),
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
                ],
              )


            ],
          ),
        ),
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
class DropdownField<T> extends StatelessWidget {
  final IconData icon;
  final List<T> items;
  final String Function(T) displayValue;
  final ValueChanged<T?> onChanged;
  final String hint;
  final T? value; // <-- Add this

  const DropdownField({
    required this.icon,
    required this.items,
    required this.displayValue,
    required this.onChanged,
    required this.hint,
    this.value, // <-- Make it optional
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<T>(
            value: items.contains(value) ? value : null,
            // Ensure value exists in items
            isExpanded: true,
            decoration: InputDecoration(
              labelText: hint,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items
                .map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                displayValue(item),
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}



