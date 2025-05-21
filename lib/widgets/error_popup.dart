// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/button_widget.dart';

class ErrorPopUp extends StatelessWidget {
  final String title;
  final String errorMsg;
  final Color color;
  ErrorPopUp(this.title, this.errorMsg, this.color);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: lightColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 22.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        errorMsg,
        style: TextStyle(fontSize: 16.sp, color: darkColor),
      ),
      actions: <Widget>[
        ButtonWidget(
          () {
            Navigator.of(context).pop();
          },
          "D'accord",
          false,
          false,
          primaryColor
        ),
      ],
    );
  }
}
