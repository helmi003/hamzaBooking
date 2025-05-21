// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/screens/auth/profile_screen.dart';
import 'package:hamzabooking/screens/reservations/all_reservations.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});
  static const routeName = "/TabScreen";

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentIndex = 0;
  late List<Widget> children;
  late UserModel user;
  bool printerLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context, listen: false).user;
    children = [
      AllOffers(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          IndexedStack(index: currentIndex, children: children),
          if (printerLoading)
            Positioned.fill(
              child: Container(
                color: darkColor.withValues(alpha: 0.5),
                child: Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: primaryColor,
                    size: 25.w,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: darkColor.withValues(alpha: 0.1),
                ),
              ],
            ),
            child: GNav(
              tabBorderRadius: 16.r,
              activeColor: primaryColor,
              tabBackgroundColor: primaryColor,
              padding: EdgeInsets.all(10),
              iconSize: 22.sp,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              gap: 8,
              tabs: [
                GButton(
                  icon: FontAwesomeIcons.calendarDays,
                  text: 'Toutes les réservations',
                  iconColor: primaryColor,
                  iconActiveColor: lightColor,
                  textColor: lightColor,
                ),
                GButton(
                  icon: FontAwesomeIcons.user,
                  text: 'Profil',
                  iconColor: primaryColor,
                  iconActiveColor: lightColor,
                  textColor: lightColor,
                ),
              ],
            ),
          ),
          if (printerLoading)
            Positioned.fill(
              child: Container(color: darkColor.withValues(alpha: 0.5)),
            ),
        ],
      ),
    );
  }
}
