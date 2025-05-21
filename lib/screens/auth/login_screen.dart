// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/screens/auth/forgetpassword_screen.dart';
import 'package:hamzabooking/screens/auth/register_screen.dart';
import 'package:hamzabooking/screens/tab_screen.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/button_widget.dart';
import 'package:hamzabooking/widgets/error_popup.dart';
import 'package:hamzabooking/widgets/passwordfield_widget.dart';
import 'package:hamzabooking/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool obscureText = true;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Image.asset('assets/images/logo.png', height: 100.h),
                  SizedBox(height: 10.h),
                  Text(
                    "Connectez-vous pour accéder à votre compte",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: darkColor,
                    ),
                    textAlign: TextAlign.center,
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
                  PasswordFieldWidget(
                    "Mot de passe",
                    obscureText,
                    passwordController,
                    () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      } else if (value.length < 6) {
                        return 'Le mot de passe doit comporter au moins 6 caractères';
                      }
                      return null;
                    },
                    AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetpasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Mot de passe oublié?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: dSilverColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ButtonWidget(
                    login,
                    'Se connecter',
                    isLoading,
                    false,
                    primaryColor,
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Vous n'avez pas de compte ? ",
                        children: [
                          TextSpan(
                            text: "Registre",
                            style: TextStyle(
                              color: redColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                        style: TextStyle(fontSize: 16, color: darkColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  hideText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> login() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser!.uid)
                .get();
        if (userSnapshot.exists) {
          final prefs = await SharedPreferences.getInstance();
          UserModel userData = UserModel.fromJson(userSnapshot.data()!);
          userData.uid = auth.currentUser!.uid;
          prefs.setString('user', json.encode(userData.toJson()));
          Provider.of<UserProvider>(context, listen: false).setUser(userData);
          Navigator.pushNamedAndRemoveUntil(
            context,
            TabScreen.routeName,
            (Route<dynamic> route) => false,
          );
        } else {
          showDialog(
            context: context,
            builder: ((context) {
              return ErrorPopUp("Alert", "L'utilisateur n'existe pas", redColor);
            }),
          );
        }
      } catch (onError) {
        showDialog(
          context: context,
          builder: ((context) {
            return ErrorPopUp("Alert", onError.toString(), redColor);
          }),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
