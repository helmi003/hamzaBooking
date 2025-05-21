// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamzabooking/utils/colors.dart';

class PasswordFieldWidget extends StatelessWidget {
  final String label;
  final bool obsecure;
  final TextEditingController controller;
  final VoidCallback setObsecure;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  const PasswordFieldWidget(
    this.label,
    this.obsecure,
    this.controller,
    this.setObsecure,
    this.validator,
    this.autovalidateMode,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            autovalidateMode: autovalidateMode,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: darkColor,
            controller: controller,
            validator: validator,
            obscureText: obsecure,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: darkColor.withValues(alpha: 0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: darkColor.withValues(alpha: 0.5)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: redColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: redColor),
              ),
              hintText: label,
              hintStyle: TextStyle(color: dSilverColor, fontSize: 16.sp),
              suffixIcon: InkWell(
                onTap: setObsecure,
                child: Icon(
                  obsecure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  color: darkColor.withValues(alpha: 0.5),
                  size: 18.sp,
                ),
              ),
            ),
            style: TextStyle(color: textColor, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
