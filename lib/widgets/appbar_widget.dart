// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hamzabooking/utils/colors.dart';

PreferredSizeWidget appBarWidget(BuildContext context, String text) {
  return AppBar(
    backgroundColor: bgColor,
    title: Text(
      text,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: darkColor,
      ),
    ),
    centerTitle: true,
    elevation: 0,
  );
}
