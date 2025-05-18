import 'package:flutter/material.dart';


class ToastClass {

  static showToastClass ({required BuildContext context,required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
              duration: Duration(seconds: 3),
      ),
    );
  }
}