import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hamzabooking/models/reservation_model.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/screens/offers/edit_reservation_screen.dart';
import 'package:hamzabooking/services/reservationProvider.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/back_appbar.dart';
import 'package:hamzabooking/widgets/button_widget.dart';

class ReservationDetails extends StatefulWidget {
  final ReservationModel offer;
  const ReservationDetails(this.offer, {super.key});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');
  late UserModel user;
  bool alreadyApplied = false;
  bool loading = true;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    _checkIfAlreadyApplied();
  }

  Future<void> _checkIfAlreadyApplied() async {
    final applicationRef = FirebaseFirestore.instance
        .collection('applications')
        .where('offerId', isEqualTo: widget.offer.id)
        .where('applicantId', isEqualTo: user.uid);

    final existingApplications = await applicationRef.get();
    if (mounted) {
      setState(() {
        alreadyApplied = existingApplications.docs.isNotEmpty;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: backAppBar(context, "Détails de l'offre"),
      body: SafeArea(
        child:
            loading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      SizedBox(height: 20.h),
                      _sectionCard("Informations sur la réservation", [
                        _infoRow(
                          FontAwesomeIcons.tag,
                          "Catégorie: ${widget.offer.category}",
                        ),
                        _infoRow(
                          FontAwesomeIcons.users,
                          "Capacité: ${widget.offer.capacity}",
                        ),
                        _infoRow(
                          FontAwesomeIcons.moneyBill,
                          "${widget.offer.price} DT",
                        ),
                        _infoRow(
                          FontAwesomeIcons.calendarDays,
                          "Date début: ${dateFormat.format(widget.offer.startDate)}",
                        ),
                        _infoRow(
                          FontAwesomeIcons.calendarCheck,
                          "Date fin: ${dateFormat.format(widget.offer.endDate)}",
                        ),
                        _infoRow(
                          FontAwesomeIcons.clock,
                          "Créé: ${dateFormat.format(widget.offer.createdAt)}",
                        ),
                      ]),

                      SizedBox(height: 16.h),
                      _sectionCard("Description", [
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            widget.offer.description,
                            style: TextStyle(fontSize: 14.sp, color: darkColor),
                          ),
                        ),
                      ]),

                      SizedBox(height: 30.h),
                      if (user.role == Rolemodel.user)
                        Center(
                          child: ButtonWidget(
                            alreadyApplied
                                ? () => cancelApplication(
                                  context,
                                  user,
                                  widget.offer,
                                )
                                : () {
                                  showApllicationDialog();
                                },
                            alreadyApplied
                                ? "Déjà appliqué"
                                : "Postulez maintenant",
                            false,
                            !alreadyApplied,
                            primaryColor,
                          ),
                        ),
                      if (user.role == Rolemodel.admin)
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ButtonWidget(
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => EditReservationScreen(
                                            widget.offer,
                                          ),
                                    ),
                                  );
                                },
                                "Modifier l'offre",
                                false,
                                false,
                                primaryColor,
                              ),

                              ButtonWidget(
                                () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text(
                                            "Êtes-vous sûr de vouloir supprimer cette offre?",
                                            style: TextStyle(fontSize: 18.sp),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Annuler"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await context
                                                    .read<ReservationProvider>()
                                                    .deleteOffer(
                                                      widget.offer.id,
                                                    );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Supprimer"),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                "Supprimer l'offre",
                                false,
                                false,
                                redColor,
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.offer.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          "Publié par: ${widget.offer.postedByName}",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: darkColor,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: primaryColor),
          SizedBox(width: 8.w),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp))),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          ...children,
        ],
      ),
    );
  }

  Future<void> submitApplication(
    BuildContext context,
    UserModel user,
    ReservationModel offer,
    DateTime? selectedDate,
  ) async {
    await context.read<ReservationProvider>().submitApplication(
      context,
      user,
      offer,
      selectedDate ?? DateTime.now(),
    );
    setState(() => alreadyApplied = true);
  }

  Future<void> cancelApplication(
    BuildContext context,
    UserModel user,
    ReservationModel offer,
  ) async {
    await context.read<ReservationProvider>().cancelApplication(
      context,
      user,
      offer,
    );
    setState(() => alreadyApplied = false);
  }

  showApllicationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Sélectionnez une date",
              style: TextStyle(fontSize: 18.sp),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.offer.startDate.isAtSameMomentAs(widget.offer.endDate)
                      ? "Date unique: ${DateFormat('dd MMM yyyy').format(widget.offer.startDate)}"
                      : "Choisissez une date entre ${DateFormat('dd MMM yyyy').format(widget.offer.startDate)} et ${DateFormat('dd MMM yyyy').format(widget.offer.endDate)}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 20.h),
                ListTile(
                  title: Text(
                    selectedDate != null
                        ? "Date sélectionnée: ${DateFormat('dd MMM yyyy').format(selectedDate!)}"
                        : widget.offer.startDate.isAtSameMomentAs(
                          widget.offer.endDate,
                        )
                        ? "Date fixe: ${DateFormat('dd MMM yyyy').format(widget.offer.startDate)}"
                        : "Aucune date sélectionnée",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  trailing: Icon(Icons.calendar_today, size: 20.sp),
                  onTap: () async {
                    if (widget.offer.startDate.isAtSameMomentAs(
                      widget.offer.endDate,
                    )) {
                      setState(() => selectedDate = widget.offer.startDate);
                    } else {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: widget.offer.startDate,
                        firstDate: widget.offer.startDate,
                        lastDate: widget.offer.endDate,
                        helpText: "Sélectionnez votre date",
                        cancelText: "Annuler",
                        confirmText: "Confirmer",
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler", style: TextStyle(color: Colors.grey)),
              ),
              ButtonWidget(
                widget.offer.startDate.isAtSameMomentAs(widget.offer.endDate)
                    ? () {
                      setState(() => selectedDate = widget.offer.startDate);
                      submitApplication(
                        context,
                        user,
                        widget.offer,
                        selectedDate,
                      );
                      Navigator.pop(context);
                    }
                    : selectedDate == null
                    ? () {}
                    : () {
                      submitApplication(
                        context,
                        user,
                        widget.offer,
                        selectedDate,
                      );
                      Navigator.pop(context);
                    },
                "Confirmer",
                false,
                false,
                primaryColor,
              ),
            ],
          ),
    );
  }
}
