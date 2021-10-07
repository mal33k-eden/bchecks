import 'package:flutter/material.dart';

const textFieldDecorator = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green),
    ),
    border: OutlineInputBorder());

final ButtonStyle btnStyle = ElevatedButton.styleFrom(
    primary: Colors.green[900],
    textStyle: const TextStyle(fontSize: 20),
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20));

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

//validations
String? validateTextField(String? value) {
  if (value!.isEmpty) {
    return "field cannot be empty";
  }
  return null;
}

String? validatePasswordField(String? value) {
  if (value!.isEmpty) {
    return "field cannot be empty";
  } else if (value.length < 8) {
    return 'password is less';
  }
  return null;
}

String? validateRePasswordField(
    String? value, TextEditingController passController) {
  if (value!.isEmpty) {
    return "field cannot be empty";
  } else if (value.length < 8) {
    return 'password too short';
  } else if (value != passController.text) {
    return 'passwords do not match';
  }
  return null;
}

void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
