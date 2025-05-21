import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/screens/tab_screen.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/back_appbar.dart';
import 'package:hamzabooking/widgets/button_widget.dart';
import 'package:hamzabooking/widgets/error_popup.dart';
import 'package:hamzabooking/widgets/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserModel user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController organizationNameController = TextEditingController();

  bool isLoading = false;
  bool obscureText = true;

  void selectRole(Rolemodel role) {
    setState(() {
      firstNameController.clear();
      lastNameController.clear();
      organizationNameController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    setState(() {
      if (user.role == Rolemodel.user) {
        firstNameController.text = user.firstName;
        lastNameController.text = user.lastName;
      } else {
        organizationNameController.text = user.organizationName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: backAppBar(context, "Update your account"),
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
                  SizedBox(height: 20.h),
                  if (user.role == Rolemodel.user) ...[
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
                  if (user.role == Rolemodel.manager) ...[
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
                  SizedBox(height: 20.h),
                  ButtonWidget(
                    updateProfile,
                    'Modifier',
                    isLoading,
                    false,
                    primaryColor,
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

  Future<void> updateProfile() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        setState(() => isLoading = true);

        final userModel = UserModel(
          user.uid,
          user.role == Rolemodel.manager ? organizationNameController.text : "",
          user.role == Rolemodel.user ? firstNameController.text : "",
          user.role == Rolemodel.user ? lastNameController.text : "",
          user.email,
          user.role,
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
