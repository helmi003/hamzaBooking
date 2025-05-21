import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hamzabooking/utils/colors.dart';

PreferredSizeWidget backAppBar(BuildContext context, String text) {
  return AppBar(
    backgroundColor: bgColor,
    centerTitle: true,
    title: Text(
      text,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: darkColor,
      ),
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back, size: 24.h, color: darkColor),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    elevation: 0,
  );
}
