// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hamzabooking/utils/colors.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isLoading;
  final bool transparent;
  final Color color;

  const ButtonWidget(
    this.onTap,
    this.label,
    this.isLoading,
    this.transparent,
    this.color, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28.h,
      child: IntrinsicWidth(
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              transparent ? Colors.transparent : color,
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side:
                    transparent
                        ? BorderSide(color: color, width: 1.5)
                        : BorderSide.none,
              ),
            ),
          ),
          onPressed: !isLoading ? onTap : () {},
          child: Center(
            child:
                isLoading
                    ? CircularProgressIndicator(
                      color: transparent ? primaryColor : lightColor,
                    )
                    : Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: transparent ? primaryColor : lightColor,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
