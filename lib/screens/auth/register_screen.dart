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
import 'package:hamzabooking/screens/auth/login_screen.dart';
import 'package:hamzabooking/screens/tab_screen.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/button_widget.dart';
import 'package:hamzabooking/widgets/error_popup.dart';
import 'package:hamzabooking/widgets/passwordfield_widget.dart';
import 'package:hamzabooking/widgets/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscureText = true;
  Rolemodel selectedRole = Rolemodel.user;

  void selectRole(Rolemodel role) {
    setState(() {
      selectedRole = role;
      firstNameController.clear();
      lastNameController.clear();
      organizationNameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      FocusScope.of(context).unfocus();
    });
  }

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
                  SizedBox(height: 20.h),
                  Text(
                    "Créez votre compte",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: darkColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonWidget(
                        () {
                          selectRole(Rolemodel.user);
                        },
                        "Utilisateur",
                        false,
                        selectedRole == Rolemodel.user,
                        primaryColor,
                      ),
                      SizedBox(width: 10),
                      ButtonWidget(
                        () {
                          selectRole(Rolemodel.manager);
                        },
                        "Manageur",
                        false,
                        selectedRole == Rolemodel.manager,
                        primaryColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  if (selectedRole == Rolemodel.user) ...[
                    TextFieldWidget(
                      "Prénom",
                      false,
                      FontAwesomeIcons.user,
                      TextInputType.name,
                      firstNameController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre prénom';
                        }
                        return null;
                      },
                      AutovalidateMode.onUserInteraction,
                    ),
                    TextFieldWidget(
                      "Nom",
                      false,
                      FontAwesomeIcons.user,
                      TextInputType.name,
                      lastNameController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom';
                        }
                        return null;
                      },
                      AutovalidateMode.onUserInteraction,
                    ),
                  ],
                  if (selectedRole == Rolemodel.manager) ...[
                    TextFieldWidget(
                      "Nom de l'organisation",
                      false,
                      FontAwesomeIcons.building,
                      TextInputType.name,
                      organizationNameController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre nom de l'organisation";
                        }
                        return null;
                      },
                      AutovalidateMode.onUserInteraction,
                    ),
                  ],
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
                  PasswordFieldWidget(
                    "Confirmez le mot de passe",
                    obscureText,
                    confirmPasswordController,
                    () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez confirmer votre mot de passe';
                      } else if (value != passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                    AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 20.h),
                  ButtonWidget(
                    register,
                    'Registre',
                    isLoading,
                    false,
                    primaryColor,
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Vous avez déjà un compte? ",
                        children: [
                          TextSpan(
                            text: "Se connecter",
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
                                        builder: (context) => LoginScreen(),
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

  Future<void> register() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        setState(() => isLoading = true);

        final result = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        final userModel = UserModel(
          result.user!.uid,
          selectedRole == Rolemodel.manager
              ? organizationNameController.text
              : "",
          selectedRole == Rolemodel.user ? firstNameController.text : "",
          selectedRole == Rolemodel.user ? lastNameController.text : "",
          emailController.text,
          selectedRole,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.uid)
            .set(userModel.toJson());

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', json.encode(userModel.toJson()));
        Provider.of<UserProvider>(context, listen: false).setUser(userModel);
        Navigator.pushReplacementNamed(context, TabScreen.routeName);
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => ErrorPopUp("Alert", e.toString(), redColor),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}
