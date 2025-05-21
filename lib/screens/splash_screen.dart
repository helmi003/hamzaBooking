// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hamzabooking/screens/auth/login_screen.dart';
import 'package:hamzabooking/screens/tab_screen.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamzabooking/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;

  getUser() async {
    User? firebaseUser = auth.currentUser;
    await firebaseUser?.reload();
    if (!mounted) return;
    firebaseUser = auth.currentUser;

    if (firebaseUser != null) {
      if (!mounted) return;
      setState(() {
        user = firebaseUser!;
        isloggedin = true;
      });
    }
  }

  @override
  void initState() {
    getUser();
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        bool loggedIn = await context.read<UserProvider>().tryAutoLogin();
        if (isloggedin && loggedIn) {
          Navigator.pushReplacementNamed(context, TabScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
      } catch (e) {
        print(e.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ScaleTransition(
        scale: _animation,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30.w),
            child: Image.asset('assets/images/logo_name.png'),
          ),
        ),
      ),
    );
  }
}
