import 'package:flutter/material.dart';


import '../../../../../helpers/utils/utils.dart';
import '../../ppm_checkpoint/model/ppm_checklist_response_model.dart';
import '../../ppm_submit/model/ppm_submit_save.dart';

class PPMDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PPMChecklistScreen();
  }
}

class PPMChecklistScreen extends StatefulWidget {
  @override
  _PPMChecklistScreenState createState() => _PPMChecklistScreenState();
}

class _PPMChecklistScreenState extends State<PPMChecklistScreen> {
  late int currentIndex;
  late PPMCheckList currentCheckList;
  late List<PPMCheckList> ppmChecklist;
  late List<PPMCheckStatus> ppmCheckstatus;
  String checkpoint_name = "" , selectedStatus = "";
  int selectedIndex = -1;
  TextEditingController remarks_controller = TextEditingController();
  TextEditingController values_controller  = TextEditingController();
  PPMSubmitSaveModel submitSaveModel = PPMSubmitSaveModel();

  @override
  void initState() {
    super.initState();

    // Initialize variables here if necessary, but they should be set before use
    currentIndex = 0;
    ppmChecklist = [];
    ppmCheckstatus = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      ppmChecklist = args['ppmChecklist'];
      ppmCheckstatus = args['ppmCheckstatus'];
      currentIndex = args['initialIndex'] ?? 0; // Use default value if not provided
      currentCheckList = ppmChecklist[currentIndex]; // Initialize currentCheckList
      checkpoint_name = ppmChecklist[currentIndex].checkpointName;
      remarks_controller.text = ppmChecklist[currentIndex].remarks;
      values_controller.text  = ppmChecklist[currentIndex].readingValue;
      selectedStatus = currentCheckList.statusName;
      selectedIndex = ppmCheckstatus.indexWhere((status) => status.checkStatusName == selectedStatus);
    }
  }


  void _saveChanges() {
    // Save changes to your data source
    // For example, you can send the updated checkpoint to your API
    // or update it in your local state management
  }

  void _navigateForward() {
    if (currentIndex < ppmChecklist.length - 1) {
      setState(() {
        _saveCurrentItem();
        currentIndex++;
        _updateCurrentItem();

      });
    }
  }

  void _navigateBackward() {
    if (currentIndex > 0) {
      setState(() {

        _saveCurrentItem();
        currentIndex--;
        _updateCurrentItem();
      });
    }
  }


  void _saveCurrentItem() {
    ppmChecklist[currentIndex].remarks = remarks_controller.text;
    ppmChecklist[currentIndex].readingValue = values_controller.text;
    ppmChecklist[currentIndex].statusName = selectedStatus;
  }

  void _updateCurrentItem() {
    currentCheckList = ppmChecklist[currentIndex];
    checkpoint_name = currentCheckList.checkpointName;
    remarks_controller.text = currentCheckList.remarks;
    values_controller.text = currentCheckList.readingValue;
    selectedStatus = currentCheckList.statusName;
    selectedIndex = ppmCheckstatus.indexWhere((status) => status.checkStatusName == selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF006BE6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Checkpoint Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                bool canNavigate = true;
                for (var checkpoint in ppmChecklist) {
                  if (checkpoint.isMandatory == 1 &&
                      (checkpoint.statusName == "Not Done" ||
                          checkpoint.statusName == "Not Applicable")) {
                    canNavigate = false;
                    break;
                  }
                }

                if (canNavigate) {
                submitSaveModel.updatePPmCheckpointList(ppmChecklist);
                Navigator.pushNamed(context, '/ppmafterimages',);
                } else {
                  Utils.showInSnackBar(
                      context, "Please complete all mandatory checkpoints before proceeding.", ToastType.Warning);
                }

                // Add your button action here
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: Color(0xFF006BE6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF006BE6), // Blue background color
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Overview:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Current: ${currentIndex + 1} / Total: ${ppmChecklist.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      checkpoint_name,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF006BE6), // Blue background color
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Inputs:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<PPMCheckStatus>(
                      isExpanded: true,
                      value: selectedIndex != -1 ? ppmCheckstatus[selectedIndex] : null,
                      hint: Text('Select Status'),
                      items: ppmCheckstatus.map((PPMCheckStatus status) {
                        return DropdownMenuItem<PPMCheckStatus>(
                          value: status,
                          child: Text(status.checkStatusName),
                        );
                      }).toList(),
                      onChanged: (PPMCheckStatus? newValue) {
                        setState(() {
                          selectedStatus = newValue!.checkStatusName;
                          selectedIndex = ppmCheckstatus.indexOf(newValue);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Adjust width and height of TextFormField
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: remarks_controller,
                      decoration: InputDecoration(
                        labelText: 'Remarks',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.comment, // Replace with the desired icon
                          color: Color(0xFF006BE6), // Adjust the icon color if needed
                        ),
                      ),
                      keyboardType: TextInputType.text, // Adjust keyboard type if needed
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: values_controller,
                      decoration: InputDecoration(
                        labelText: 'Values',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.note_alt_sharp, // Replace with the desired icon
                          color: Color(0xFF006BE6), // Adjust the icon color if needed
                        ),
                      ),
                      keyboardType: TextInputType.number, // Adjust keyboard type if needed
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),

            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _navigateBackward,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF006BE6), backgroundColor: Colors.white, // Text and icon color
                      side: BorderSide(color: Color(0xFF006BE6), width: 2), // Border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Border radius
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back, // Change to the appropriate icon
                      color: Color(0xFF006BE6), // Icon color
                    ),
                    label: Text(
                      'Backward',
                      style: TextStyle(
                        color: Color(0xFF006BE6), // Text color
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateForward,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF006BE6), backgroundColor: Colors.white, // Text and icon color
                      side: BorderSide(color: Color(0xFF006BE6), width: 2), // Border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Border radius
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forward',
                          style: TextStyle(
                            color: Color(0xFF006BE6), // Text color
                            fontWeight: FontWeight.bold, // Text weight
                          ),
                        ),
                        SizedBox(width: 8), // Space between text and icon
                        Icon(
                          Icons.arrow_forward, // Change to the appropriate icon
                          color: Color(0xFF006BE6), // Icon color
                        ),
                      ],
                    ),
                  ),
                ),
              ],

            ),

            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}