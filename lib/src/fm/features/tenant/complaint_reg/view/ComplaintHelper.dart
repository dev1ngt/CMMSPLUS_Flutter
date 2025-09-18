import '../model/complaint_reg_response_model.dart';

class ComplaintHelper {
  // Method to get the ID from the natureofComplaint list based on the name
  static int? getComplaintIdByName(List<NatureOfComplaint> complaints, String name) {
    var selectedItem = complaints.firstWhere(
          (item) => item.name == name,
      orElse: () => NatureOfComplaint(id: 0, name: ''), // Return a default NatureOfComplaint
    );
    return selectedItem.id != 0 ? selectedItem.id : null; // Return null if no valid item was found
  }
}