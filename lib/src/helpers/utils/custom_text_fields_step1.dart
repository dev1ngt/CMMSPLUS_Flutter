import 'package:flutter/material.dart';

class CustomTextFormFieldStep1 extends StatefulWidget {
  final String id;

  CustomTextFormFieldStep1({required this.id});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();

// Expose the validateText method
  String validateTextOutsideState() {
    return _CustomTextFormFieldState().validateText();
  }


}

class _CustomTextFormFieldState extends State<CustomTextFormFieldStep1> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: _textEditingController,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
          hintText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCBD4F4), width: 1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  String validateText() {
    String enteredText = _textEditingController.text;
    String id = widget.id;

    // Perform your validation logic based on id
    if (id == 'cause_of_fault') {
      // Validation logic for 'cause_of_fault'
      if (enteredText.isEmpty) {
        return 'Please enter a valid cause of fault';
      }
    } else if (id == 'action_taken') {
      // Validation logic for 'action_taken'
      // You can customize this based on your needs
      if (enteredText.isEmpty) {
        return 'Please enter a valid action taken';
      }
    }

    // Add more validation as needed
    return ''; // Return an empty string if validation passes
  }
}