import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hamzabooking/utils/colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final bool required;
  final IconData icon;
  final TextInputType type;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  const TextFieldWidget(
    this.label,
    this.required,
    this.icon,
    this.type,
    this.controller,
    this.validator,
    this.autovalidateMode, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              children: [
                required
                    ? TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: redColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                    : TextSpan(),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            autovalidateMode: autovalidateMode,
            keyboardType: type,
            cursorColor: textColor,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: darkColor.withValues(alpha:0.5)),
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
              suffixIcon: Icon(
                icon,
                color: darkColor.withValues(alpha: 0.5),
                size: 18.sp,
              ),
            ),
            style: TextStyle(color: textColor, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
