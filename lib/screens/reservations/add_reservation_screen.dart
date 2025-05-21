import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hamzabooking/models/reservation_model.dart';
import 'package:hamzabooking/services/reservationProvider.dart';
import 'package:hamzabooking/widgets/choosePictureType.dart';
import 'package:hamzabooking/widgets/dropdown_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/back_appbar.dart';
import 'package:hamzabooking/widgets/button_widget.dart';
import 'package:hamzabooking/widgets/error_popup.dart';
import 'package:hamzabooking/widgets/textaria_widget.dart';
import 'package:hamzabooking/widgets/textfield_widget.dart';

class AddReservationScreen extends StatefulWidget {
  const AddReservationScreen({super.key});

  @override
  State<AddReservationScreen> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  bool isLoading = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  File? photo;
  ImagePicker imagePicker = ImagePicker();
  DateTime? startDate;
  DateTime? endDate;
  final formKey = GlobalKey<FormState>();
  late UserModel user;
  final List<String> categories = [
    "Salle de réunion",
    "Véhicule",
    "Matériel informatique",
    "Salle de conférence",
    "Autre",
  ];
  String selectedCategory = "Salle de réunion";

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: backAppBar(context, "Ajouter une réservation"),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                        ),
                        backgroundColor: Color(0xFF3C8CE7),
                        context: context,
                        builder:
                            ((builder) => BottomSheetCamera(
                              () {
                                takephoto(ImageSource.camera);
                              },
                              () {
                                takephoto(ImageSource.gallery);
                              },
                            )),
                      );
                    },
                    child:
                        photo == null
                            ? Image.asset(
                              "assets/images/image.png",
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            )
                            : Image.file(
                              photo!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                  ),
                  TextFieldWidget(
                    "Titre",
                    true,
                    Icons.title,
                    TextInputType.text,
                    titleController,
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Le titre est obligatoire'
                            : null,
                    AutovalidateMode.onUserInteraction,
                  ),
                  TextAreaWidget(
                    "Description",
                    true,
                    TextInputType.multiline,
                    descriptionController,
                    (value) =>
                        value == null || value.isEmpty
                            ? 'La description est obligatoire'
                            : null,
                    AutovalidateMode.onUserInteraction,
                  ),
                  TextFieldWidget(
                    "Prix",
                    true,
                    Icons.people,
                    TextInputType.number,
                    priceController,
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Le prix est requise'
                            : null,
                    AutovalidateMode.onUserInteraction,
                  ),
                  TextFieldWidget(
                    "Capacité",
                    true,
                    Icons.people,
                    TextInputType.number,
                    capacityController,
                    (value) =>
                        value == null || value.isEmpty
                            ? 'La capacité est requise'
                            : null,
                    AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 10.h),
                  DropdownWidget("Catégorie", selectedCategory, categories, (
                    value,
                  ) {
                    setState(() {
                      selectedCategory = value ?? "Salle de réunion";
                    });
                  }),
                  ListTile(
                    title: Text(
                      startDate != null
                          ? "Date de début: ${startDate!.toLocal().toString().split(' ')[0]}"
                          : "Sélectionnez la date de début",
                      style: TextStyle(fontSize: 16.sp, color: textColor),
                    ),
                    trailing: Icon(Icons.calendar_today, color: primaryColor),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => startDate = picked);
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      endDate != null
                          ? "Date de fin: ${endDate!.toLocal().toString().split(' ')[0]}"
                          : "Sélectionnez la date de fin",
                      style: TextStyle(fontSize: 16.sp, color: textColor),
                    ),
                    trailing: Icon(Icons.calendar_today, color: primaryColor),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: startDate ?? DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: ButtonWidget(
                      addReservation,
                      "Ajouter une réservation",
                      isLoading,
                      false,
                      primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  takephoto(ImageSource source) async {
    final pick = await imagePicker.pickImage(source: source);
    setState(() {
      if (pick != null) {
        setState(() {
          photo = File(pick.path);
        });
      }
    });
  }

  Future<void> addReservation() async {
    if (formKey.currentState?.validate() ?? false) {
      if (photo == null) {
        showDialog(
          context: context,
          builder:
              (context) =>
                  ErrorPopUp("Alert", "Veuillez choisir une image", redColor),
        );
      }
      try {
        setState(() => isLoading = true);
        final offer = ReservationModel(
          '',
          user.uid,
          user.organizationName,
          titleController.text.trim(),
          descriptionController.text.trim(),
          num.tryParse(priceController.text.trim()) ?? 0,
          int.tryParse(capacityController.text.trim()) ?? 0,
          selectedCategory,
          "https://media.licdn.com/dms/image/v2/C4D12AQFvR6webwTsKw/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1533823206296?e=2147483647&v=beta&t=yIPFxMRV1X6xGI1Hjd5ui9DzkDBJmuDfhhVkyZvuPA4",
          startDate ?? DateTime.now(),
          endDate ?? DateTime.now(),
          DateTime.now(),
        );

        await context.read<ReservationProvider>().createOffer(offer);
        Navigator.pop(context);
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => ErrorPopUp("Alert", error.toString(), redColor),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}
