// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hamzabooking/utils/colors.dart';

class CircularLoadingWidget extends StatelessWidget {
  const CircularLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: primaryColor));
  }
}
