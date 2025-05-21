// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamzabooking/utils/colors.dart';

class BottomSheetCamera extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  BottomSheetCamera(this.onPressed, this.onPressed2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: <Widget>[
          Text("Choisissez votre photo:",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: lightColor)),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                  onPressed: onPressed,
                  icon: Icon(
                    FontAwesomeIcons.camera,
                    color: lightColor,
                  ),
                  label: Text("Appareil photo",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: lightColor))),
              TextButton.icon(
                  onPressed: onPressed2,
                  icon: Icon(
                    FontAwesomeIcons.image,
                    color: lightColor,
                  ),
                  label: Text("Galerie",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: lightColor))),
            ],
          )
        ],
      ),
    );
  }
}
