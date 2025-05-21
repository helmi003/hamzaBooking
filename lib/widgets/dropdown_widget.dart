import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hamzabooking/utils/colors.dart';

class DropdownWidget extends StatelessWidget {
  final String label;
  final String selectedItem;
  final List<String> listItems;
  final ValueChanged<String?>? onChanged;

  const DropdownWidget(
    this.label,
    this.selectedItem,
    this.listItems,
    this.onChanged, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 5.h),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: bgColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: darkColor, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: darkColor, width: 0.5),
          ),
        ),
        value: selectedItem,
        validator: (value) =>
        value == null || value.isEmpty ? 'La catégorie est obligatoire' : null,
        items:
            listItems
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
