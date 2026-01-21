import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ShowAppSnackBar {
  static showSnakeBar({
    required BuildContext context,
    required String title,
    Color? backgroundColor,
    FlushbarPosition? flushbarPosition,
  }) {
    Flushbar(
      showProgressIndicator: false,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      flushbarPosition: flushbarPosition ?? FlushbarPosition.TOP,
      backgroundColor: backgroundColor ??Colors.orange,
      duration: const Duration(seconds: 3),
      messageText: Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
    ).show(context);
  }
}
