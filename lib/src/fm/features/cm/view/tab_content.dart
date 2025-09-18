import 'package:cmms/src/helpers/utils/app_shared_preference.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/material.dart';


import '../../cm_summary/model/cm_submit_save.dart';
import '../model/cm_model_response.dart';

class TabContent extends StatelessWidget {
  final String title;
  final List<TaskData> data;

  const TabContent({
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    // Show a message when no records are found
    if (data.isEmpty) {
      return Center(
        child: Text('No records found.'),
      );
    }

    // Build the ListView with filtered data wrapped in Cards
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        TaskData task = data[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.white, // Set card background color to white
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment, color:AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text(task.taskNo),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.comment,  color:AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text(task.natureOfComplaint),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.date_range, color:AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text(task.createdDate),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.priority_high_outlined, color:AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text(task.priority),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward_ios, color:AppColors.primaryColor ),
              ],
            ),
            isThreeLine: false,
            onTap: () {
              _onTaskTap(context, task);
            },
          ),
        );
      },
    );
  }
}

void _onTaskTap(BuildContext context, TaskData task) {
  // Perform any action when an item is clicked
  // For example, navigate to a details screen
  CMSubmitSaveModel cmSubmitSaveModel = CMSubmitSaveModel();
  cmSubmitSaveModel.updateCMWorkOrderID(task.id);
  AppSharedPrefs.get().setCMID(task.id.toString());

  Navigator.pushNamed(context, '/cmdetailsview',
    arguments: {
      'CMID': task.id.toString(),
      // Add more parameters as needed
    },

  );
}
