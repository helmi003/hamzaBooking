import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hamzabooking/screens/auth/login_screen.dart';
import 'package:hamzabooking/screens/splash_screen.dart';
import 'package:hamzabooking/screens/tab_screen.dart';
import 'package:hamzabooking/services/reservationProvider.dart';
import 'package:hamzabooking/services/userProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(396, 642),
      builder: (context, child) {
        return MaterialApp(
          title: 'Hamza Booking',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: SplashScreen(),
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            TabScreen.routeName: (context) => const TabScreen(),
          },
        );
      },
    );
  }
}
