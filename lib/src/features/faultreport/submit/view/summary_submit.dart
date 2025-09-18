import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cmms/src/features/faultreport/fifthroom/view/fifth_room.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../api/api_service.dart';
import '../../../../helpers/utils/AlertDialog.dart';
import '../../../../helpers/utils/app_shared_preference.dart';
import '../../../../helpers/utils/image_utils.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../../helpers/utils/utils.dart';
import '../../../../helpers/utils/vertical_step.dart';
import '../../firstmenu/view/first_menu.dart';
import '../bloc/summary_submit_bloc.dart';
import '../bloc/summary_submit_event.dart';
import '../bloc/summary_submit_state.dart';
import '../model/fault_report_save_model.dart';
import '../model/fault_report_save_model_old.dart';
import '../model/priority_request_model.dart';
import '../model/priority_response_model.dart';
import '../model/upload_view_model.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class FRSubmit extends StatelessWidget {
  const FRSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return FRSubmitStf();
  }
}

class FRSubmitStf extends StatefulWidget {
  const FRSubmitStf({super.key});

  @override
  State<FRSubmitStf> createState() => _FRSubmitStf();
}

class _FRSubmitStf extends State<FRSubmitStf> {
  Color customColor1 = Color(0xFFCBD4F4); // Replace with your custom color
  Color customColor2 = Color(0xFFF7D9E3); // Replace with your custom color
  UploadViewModel viewModel = UploadViewModel();
  bool isButtonVisible = true;
  bool isSubmitting = false;
  String isButtonVisible_val = "1";
  String ProjectName = "",
      username = "",
      selected_type_name = "",
      selected_sub_type_name = "",
      description = "",
      location = "",
      selected_prority_name = "",
      region_name = "";
  String Is_list1 = "0";
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addnLocController = TextEditingController();
  String firstname = "",
      lastname = "",
      email = "",
      phone = "",
      userid = "",
      attach_img = "",
      date_time = DateFormat('dd-MM-yyyy HHmm').format(DateTime.now());
  ImageProvider<Object>? imageProvider;
  late FRSubmitBloc frSubmitBloc;
  String searchText = '',
      _selectedImagePath = "",
      uploadPath = ""; // State variable to store the entered text
  final ImagePicker _picker = ImagePicker();
  bool uploadStatus = false;
  File? _image;
  bool is_photos_view_visible = false;
  String additionalSpace = "";
  String requestId = "0";
  int _maxFiles = 0;
  final int _maxFileSizeMB = 5;
  List<MultipleImage> uploadedFiles = [];


  _imageFromCamera() async {
    // Generate a timestamp for the file name
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        _selectedImagePath = pickedImage.path;
      });

      // Create a File object using the path
      File selectedImageFile = File(_selectedImagePath!);
      frSubmitBloc
          .add(uploadFileInProgressEvent(selectedImageFile, "Test.png"));
      //  saveSelectedImagePathToPrefs(_selectedImagePath!);
    }
    final File fileImage = File(pickedImage.path);

    if (imageConstraint(fileImage))
      setState(() {
        _image = fileImage;
      });
    if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
      imageProvider = FileImage(File(_selectedImagePath!));
    } else {
      imageProvider = AssetImage('assets/images/photo_man.png');
    }
  }

  Future<void> saveSelectedImagePathToPrefs(String imagePath) async {
    await AppSharedPrefs.get().setAfterImagePath(imagePath);
  }

  _imageFromGallery() async {
    final XFile pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    ) as XFile; // Change PickedFile to XFile
    if (pickedImage != null && imageConstraint(File(pickedImage.path))) {
      setState(() {
        _selectedImagePath = pickedImage.path;
      });
    }

    File selectedImageFile = File(_selectedImagePath!);
    frSubmitBloc.add(uploadFileInProgressEvent(selectedImageFile, "Test.png"));

    final File fileImage = File(pickedImage.path);
    if (imageConstraint(fileImage))
      setState(() {
        _image = fileImage;
      });
    if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
      imageProvider = FileImage(File(_selectedImagePath!));
    } else {
      imageProvider = AssetImage('assets/images/photo_man.png');
    }
  }

  bool imageConstraint(File image) {
    if (!['bmp', 'jpg', 'jpeg', 'png']
        .contains(image.path.split('.').last.toString())) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image format should be jpg/jpeg/bmp.");
      return false;
    }
    /*if (image.lengthSync() > 1000000) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image Size should be less than 1000KB.");
      return false;
    }*/
    return true;
  }

  @override
  void initState() {
    super.initState();

    try {
      if (context != null) {
        frSubmitBloc = FRSubmitBloc(RepositoryProvider.of<ApiService>(context))
          ..add(FRSubmitFetchEvent());
      }

      initializeControllers();
    } on Exception catch (e) {
      // TODO
    }
  }

  Future<String> getCurrentDateTime() async {
    try {
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm').format(now);
      return formattedDateTime;
    } catch (e) {
      throw Exception('Failed to get current date and time: $e');
    }
  }

  void initializeControllers() async {
    try {
      // Fetch shared preference values
      username = await AppSharedPrefs.getUsername();
      firstname = await AppSharedPrefs.getFirstname();
      lastname = await AppSharedPrefs.getLastname();
      email = await AppSharedPrefs.getEmail();
      phone = await AppSharedPrefs.getPhone();
      userid = await AppSharedPrefs.getUserID();
      Is_list1 = await AppSharedPrefs.getislist();
      attach_img = await AppSharedPrefs.getattachurl();

      isButtonVisible_val = await AppSharedPrefs.getisbuttonvisible();

      // Update text controllers with fetched values
      _firstNameController.text = firstname;
      _lastNameController.text = lastname;
      _emailController.text = email;
      _phoneController.text = phone;



      if (Is_list1.contains("1")) {
        if (isButtonVisible_val.contains("1")) {
          isButtonVisible = true;
          print("1_" + isButtonVisible_val);
        } else {
          isButtonVisible = false;
          print("2_" + isButtonVisible_val);
        }
        if (attach_img.isNotEmpty) {
          is_photos_view_visible = true;
          _selectedImagePath = attach_img;
          uploadPath = attach_img;
          print("attach_img1_" + attach_img);
          if (_selectedImagePath.startsWith("https")) {
            imageProvider = NetworkImage(_selectedImagePath);
          } else {
            imageProvider = AssetImage('assets/images/photo_man.png');
          }
        }
        FaultReportOldSaveModel faultReportSaveModel1 =
            viewModel.faultReportoldSaveModel;

        additionalSpace = faultReportSaveModel1.additionalSpace.toString();
        _addnLocController.text = additionalSpace;
        if (faultReportSaveModel1.typeName != null) {
          selected_type_name = faultReportSaveModel1.typeName.toString();
          selected_sub_type_name = faultReportSaveModel1.subTypeName.toString();
          location = faultReportSaveModel1.propertyName.toString();

          PriorityRequestModel priorityRequestModel = PriorityRequestModel(
              typeId: faultReportSaveModel1.type,
              subTypeId: faultReportSaveModel1.subTypeID,
              propertyId: faultReportSaveModel1.propertyId);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final args = ModalRoute.of(context)!.settings.arguments;
            if (args != null && args is String) {
              requestId = args;
              frSubmitBloc.add(FRPriorityEvent(priorityRequestModel, requestId));
            }
          });

        //  frSubmitBloc.add(FRPriorityEvent(priorityRequestModel));
        }
      } else {
        FaultReportSaveModel faultReportSaveModel =
            viewModel.faultReportSaveModel;
        additionalSpace = faultReportSaveModel.additionalSpace.toString();
        if (faultReportSaveModel.typeName != null) {
          selected_type_name = faultReportSaveModel.typeName.toString();
          selected_sub_type_name = faultReportSaveModel.subTypeName.toString();
          location = faultReportSaveModel.propertyName.toString();

          PriorityRequestModel priorityRequestModel = PriorityRequestModel(
              typeId: faultReportSaveModel.type,
              subTypeId: faultReportSaveModel.subTypeID,
              propertyId: faultReportSaveModel.propertyId);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final args = ModalRoute.of(context)!.settings.arguments;
            if (args != null && args is String) {
              requestId = args;
              frSubmitBloc.add(FRPriorityEvent(priorityRequestModel, requestId));
            }
          });

         // frSubmitBloc.add(FRPriorityEvent(priorityRequestModel));
        }
      }
    } catch (e) {
      // Handle exceptions if needed
      print('Error initializing controllers: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showPhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Photo or Document',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    // Check camera permission
                    var status = await Permission.camera.status;
                    if (status.isGranted) {
                      _imageFromCamera1();
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromCamera1();
                      } else {
                        // Handle denied permission
                        showAlertDialog(
                          context: context,
                          title: "Permission Denied",
                          content:
                          "Please enable camera permissions in settings.",
                        );
                      }
                    } else {
                      // Handle permissions that are permanently denied
                      showAlertDialog(
                        context: context,
                        title: "Permission Denied",
                        content:
                        "Please enable camera permissions in settings.",
                      );
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Camera'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    // Check camera permission
                    var status = await Permission.camera.status;
                    if (status.isGranted) {
                      _imageFromGallery1();
                    } else if (status.isDenied) {
                      // Request camera permission
                      var result = await Permission.camera.request();
                      if (result.isGranted) {
                        _imageFromGallery1();
                      } else {
                        // Handle denied permission
                        showAlertDialog(
                          context: context,
                          title: "Permission Denied",
                          content:
                          "Please enable camera permissions in settings.",
                        );
                      }
                    } else {
                      // Handle permissions that are permanently denied
                      showAlertDialog(
                        context: context,
                        title: "Permission Denied",
                        content:
                        "Please enable camera permissions in settings.",
                      );
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Gallery'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _pickDocument1();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Documents'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => frSubmitBloc,
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
                Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png',
                  width: 100,
                  height: 20,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle your onClick event here
                    Navigator.pushNamed(context,
                        '/dashboard'); // Example: Navigate to home page
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Other widgets...

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalStep(
                              title: 'Type of Request',
                              subtitle: selected_type_name,
                              isActive: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            VerticalStep(
                              title: 'SubType of Request',
                              subtitle: selected_sub_type_name,
                              isActive: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            VerticalStep(
                              title: 'Region',
                              subtitle: region_name,
                              isActive: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            VerticalStep(
                              title: 'Priority',
                              subtitle: selected_prority_name,
                              isActive: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            VerticalStep(
                              title: 'Location of Request',
                              subtitle: location,
                              isActive: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            VerticalStep(
                              title: 'Review Additional Information',
                              subtitle:
                              'Review any additional information here',
                              isActive: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  BlocBuilder<FRSubmitBloc, FRSubmitState>(
                    builder: (context, state) {
                      if (state is FRPriorityInProgress) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is FRPrioritySuccess) {
                        // Perform navigation or update state after build
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            int? priorityId =
                                state.priorityResponseModel.data?.priorityId;
                            if (Is_list1.contains("1")) {
                              viewModel.updateFaultReportSaveModel21(
                                  priorityId.toString());
                            } else {
                              viewModel.updateFaultReportSaveModel2(
                                  priorityId.toString());
                            }

                            selected_prority_name = state
                                .priorityResponseModel.data?.priorityName ??
                                'Default Name';
                            _maxFiles = state.priorityResponseModel.data!.maxFile;
                            uploadedFiles = state.priorityResponseModel.data!.multipleImage;
                            region_name = state.priorityResponseModel.data!.regionName;
                          });
                        });
                      } else if (state is FRPriorityFailure) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            viewModel.updateFaultReportSaveModel21("0");
                            selected_prority_name = "";
                            print("hello" + state.error);
                          });
                        });
                      }
                      return Container();
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Dynamic list of chips with delete option
                  Card(
                    color: Colors.white,
                    margin: EdgeInsets.all(6),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("First Name"),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                searchText = value
                                    .toLowerCase(); // Convert to lowercase for case-insensitive search
                              });
                            },
                            readOnly: true,
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              // Add the search icon here
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Text("Last Name"),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                searchText = value
                                    .toLowerCase(); // Convert to lowercase for case-insensitive search
                              });
                            },
                            readOnly: true,
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              // Add the search icon here
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Text("Email"),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                searchText = value
                                    .toLowerCase(); // Convert to lowercase for case-insensitive search
                              });
                            },
                            readOnly: true,
                            controller: _emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              // Add the search icon here
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Text("Phone"),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                searchText = value
                                    .toLowerCase(); // Convert to lowercase for case-insensitive search
                              });
                            },
                            readOnly: true,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              // Add the search icon here
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Text("Addn. Loc"),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                FaultReportSaveModel faultReportSaveModel =
                                    viewModel.faultReportSaveModel;

                                FaultReportOldSaveModel faultReportOldSaveModel =
                                    viewModel.faultReportoldSaveModel;

                                faultReportSaveModel.additionalSpace = value.toString();
                                faultReportOldSaveModel.additionalSpace = value.toString();
                                additionalSpace = value.toString();
                              });
                            },
                            controller: _addnLocController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              // Add the search icon here
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFCBD4F4), width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Add Attachments"),
                              GestureDetector(
                                onTap: () {
                                  // Handle the click event here
                                  // Toggle the visibility or perform any other action
                                  setState(() {
                                    is_photos_view_visible =
                                    !is_photos_view_visible;
                                  });
                                },
                                child: Icon(
                                  is_photos_view_visible
                                      ? Icons.remove
                                      : Icons.add,
                                  size: 20.0,
                                ),
                              ),
                            ],
                          ),

                          Visibility(
                              visible: is_photos_view_visible,
                              child: _buildFileGrid()),

                         /* Visibility(
                            visible: is_photos_view_visible,
                            child: Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showPhotoDialog(context);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      // Adjust the border radius as needed
                                      child: Container(
                                        width: 150.0,
                                        height: 130.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider ??
                                                AssetImage(
                                                    'assets/images/photo_man.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                ],
                              ),
                            ),
                          ),*/

                          BlocListener<FRSubmitBloc, FRSubmitState>(
                            listener: (context, state) {
                              if (state is UploadFilesSuccess) {
                                //    uploadPath = state.fileuploadresponse.uploadedpath!;

                                final uploadedPath = state.fileuploadresponse.uploadedpath!;
                                final fileType = _getFileType(uploadedPath);
                                if (mounted) {
                                  setState(() {
                                    uploadedFiles.add(
                                      MultipleImage(
                                        id: 0,
                                        type: fileType,
                                        path: uploadedPath,
                                      ),
                                    );
                                  });
                                }
                              } else if (state is UploadFilesFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Upload failed: ${state.error}")),
                                );
                              }
                            },
                            child: BlocBuilder<FRSubmitBloc, FRSubmitState>(
                              builder: (context, state) {
                                if (state is UploadFilesInitial) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                return Container(); // Or whatever UI you use
                              },
                            ),
                          ),

                          // Return the submit button
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

              BlocListener<FRSubmitBloc, FRSubmitState>(
                listener: (context, state) {
                  if (state is FRSubmitLoaded) {
                    isSubmitting = false;

                    if (Is_list1.contains("1")) {
                      viewModel.resetFaultReportData1();
                    } else {
                      viewModel.resetFaultReportData();
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print(state.submitresponse_.message);
                      Utils.showInSnackBar(
                        context,
                        state.submitresponse_.message.toString(),
                        ToastType.Success,
                      );
                      Navigator.pushNamed(context, "/dashboard");
                    });
                  } else if (state is FRSubmitError) {
                    isSubmitting = false;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print(state.error);
                      Utils.showInSnackBar(
                        context,
                        state.error.toString(),
                        ToastType.Warning,
                      );
                    });
                  }
                },
                child: BlocBuilder<FRSubmitBloc, FRSubmitState>(
                  builder: (context, state) {
                    if (state is FRSubmitInProgress) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(); // or your default UI
                  },
                ),
              ),


              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate back when the 'Back' button is pressed
                              Navigator.pop(
                                context,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    customColor2,
                                    customColor1,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 150.0, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Back',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Visibility(
                            visible: isButtonVisible,
                            child: ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () async {

                                var connectivityResult =
                                await Connectivity().checkConnectivity();
                                if (connectivityResult == ConnectivityResult.none) {
                                  Utils.showInSnackBar(
                                    context,
                                    "No internet connection.",
                                    ToastType.Error,
                                  );

                                  return;
                                }

                                setState(() {
                                  isSubmitting = true;
                                });

                                if (Is_list1.contains("1")) {
                                  viewModel.updateFaultReportSaveModel61(
                                      username,
                                      email,
                                      phone,
                                      date_time,
                                      int.parse(userid),
                                      uploadedFiles);
                                  frSubmitBloc.add(
                                      FRSubmitClick1(viewModel.faultReportoldSaveModel));
                                } else {
                                  viewModel.updateFaultReportSaveModel6(
                                      username,
                                      email,
                                      phone,
                                      date_time,
                                      int.parse(userid),
                                      uploadedFiles);
                                  frSubmitBloc
                                      .add(FRSubmitClick(viewModel.faultReportSaveModel));
                                }

                                // If needed, navigate or reset isSubmitting = false later
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: isSubmitting ? customColor1 : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: isSubmitting
                                      ? null
                                      : LinearGradient(
                                    colors: [
                                      customColor2,
                                      customColor1,
                                    ],
                                  ),
                                  color: isSubmitting ? customColor1 : null,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 150.0, minHeight: 45.0),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 12.0), // Add padding inside
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /*submit ended  */

                    ],
                  ),

                  // Return the submit button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  bool _canAddFile(File file) {
    final fileSizeMB = file.lengthSync() / (1024 * 1024);
    if (uploadedFiles.length >= _maxFiles) {
      _showLimitDialog("You can only add up to $_maxFiles files.");
      return false;
    } else if (fileSizeMB > _maxFileSizeMB) {
      _showLimitDialog("File size must be less than $_maxFileSizeMB MB.");
      return false;
    }
    return true;
  }


  void _showLimitDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Limit Exceeded"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }


  String _getFileType(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    if (ext == '.pdf') return 'pdf';
    if (ext == '.xls' || ext == '.xlsx') return 'excel';
    if (ext == '.jpg' || ext == '.jpeg') return 'image';
    return 'document'; // fallback
  }


  Future<void> _imageFromCamera1() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (_canAddFile(file)) {
        frSubmitBloc.add(uploadFileInProgressEvent(file, path.basename(file.path)));
      }
    }
  }


  Future<void> _imageFromGallery1() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (_canAddFile(file)) {
        frSubmitBloc.add(uploadFileInProgressEvent(file, path.basename(file.path)));
      }
    }
  }


  Future<void> _pickDocument1() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      if (_canAddFile(file)) {
        frSubmitBloc.add(uploadFileInProgressEvent(file, path.basename(file.path)));
      }
    }
  }


  Widget _buildFileGrid() {
    final showAddButton = uploadedFiles.length < _maxFiles;
    final itemCount = uploadedFiles.length + (showAddButton ? 1 : 0);



    return Container(
      height: 300,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFCBD4F4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          if (showAddButton && index == itemCount - 1) {
            return _buildAddButton();
          }

          final filePath = uploadedFiles[index].path;
          final fileName = path.basename(filePath);
          final file = File(filePath);
          final isImage = _isImageFile(filePath);


          return Stack(
            children: [
              GestureDetector(
                onTap: () => _openFile(uploadedFiles[index].path, context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isImage
                        ? Image.network(filePath, fit: BoxFit.cover)
                        : _buildDocThumbnail(fileName),
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete File"),
                          content: Text("Are you sure you want to delete this file?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final imageId = uploadedFiles[index].id;

                        if(imageId!=0){
                       //   frSubmitBloc.add(DeleteUploadedFileEvent(id: imageId, requestId: requestId));
                        } else {
                          Utils.showInSnackBar(
                              context,
                              "Attachment deleted successfully.",
                              ToastType.Success);
                        }


                        setState(() {
                          uploadedFiles.removeAt(index);
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    final int count = uploadedFiles.length;


    return GestureDetector(
      onTap: () => _showPhotoDialog(context),
      child: Stack(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 40, color: Colors.grey.shade700),
                SizedBox(height: 8),
                Text(
                  "Not more than 5 MB",
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${count}/$_maxFiles',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isImageFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png'].contains(ext);
  }

  Future<String> _downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Widget _buildDocThumbnail(String fileName) {
    final ext = path.extension(fileName).toLowerCase();

    IconData icon;
    Color iconColor;

    if (ext == '.pdf') {
      icon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (ext == '.xls' || ext == '.xlsx') {
      icon = Icons.grid_on;
      iconColor = Colors.green;
    } else if (ext == '.doc' || ext == '.docx') {
      icon = Icons.description;
      iconColor = Colors.blue;
    } else {
      icon = Icons.insert_drive_file;
      iconColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: iconColor),
          SizedBox(height: 8),
          Text(
            fileName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }



  Future<void> _openFile(String filePath, BuildContext context) async {
    final isImage = _isImageFile(filePath);

    if (isImage) {
      // Show image in dialog
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            padding: EdgeInsets.all(8),
            child: filePath.startsWith('http')
                ? Image.network(filePath)
                : Image.file(File(filePath)),
          ),
        ),
      );
    } else {
      String localPath;

      if (filePath.startsWith('http')) {
        final fileName = path.basename(filePath);
        final dir = await getTemporaryDirectory();
        localPath = '${dir.path}/$fileName';

        // Download if it doesn't exist
        if (!File(localPath).existsSync()) {
          localPath = await _downloadFile(filePath, fileName);
        }
      } else {
        localPath = filePath;
      }

      final result = await OpenFile.open(localPath);
      if (result.type != ResultType.done) {
        _showAlertDialog(
          context,
          title: "Error",
          content:
          "Unable to open the document. Make sure an app that supports this file type is installed.",
        );
      }
    }
  }

  void _showAlertDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

}
