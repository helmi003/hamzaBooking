import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamzabooking/screens/auth/login_screen.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/button_widget.dart';
import 'package:hamzabooking/widgets/error_popup.dart';
import 'package:hamzabooking/widgets/textfield_widget.dart';

class ForgetpasswordScreen extends StatefulWidget {
  const ForgetpasswordScreen({super.key});

  @override
  State<ForgetpasswordScreen> createState() => _ForgetpasswordScreenState();
}

class _ForgetpasswordScreenState extends State<ForgetpasswordScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                Image.asset('assets/images/logo.png', height: 100.h),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Entrez votre email et nous vous enverrons un lien de réinitialisation du mot de passe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: darkColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFieldWidget(
                  "E-mail",
                  false,
                  FontAwesomeIcons.envelope,
                  TextInputType.emailAddress,
                  emailController,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Veuillez saisir une adresse e-mail valide';
                    }
                    return null;
                  },
                  AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 200.h),
                ButtonWidget(
                  forgetPassword,
                  'Envoyez',
                  isLoading,
                  false,
                  primaryColor,
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    "Vous vous souvenez de votre compte?",
                    style: TextStyle(fontSize: 16.sp, color: darkColor),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Se connecter",
                      style: TextStyle(
                        color: redColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> forgetPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        setState(() => isLoading = true);
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        setState(() {
          emailController.clear();
        });
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        showDialog(
          context: context,
          builder: ((context) {
            return ErrorPopUp(
              "Success",
              "An email has been sent to reset your password",
              greenColor,
            );
          }),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder:
              (_) => ErrorPopUp(
                "Alert",
                "The email you entered is not registered",
                redColor,
              ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}
