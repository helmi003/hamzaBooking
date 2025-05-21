import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hamzabooking/models/application_model.dart';
import 'package:hamzabooking/models/reservation_model.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/screens/auth/edit_profile_screen.dart';
import 'package:hamzabooking/screens/auth/login_screen.dart';
import 'package:hamzabooking/screens/offers/reservation_details.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/appbar_widget.dart';
import 'package:hamzabooking/widgets/button_widget.dart';
import 'package:hamzabooking/widgets/error_popup.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBarWidget(context, "Profil"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor,
                      child: Icon(Icons.person, size: 50, color: lightColor),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      user.role == Rolemodel.user
                          ? "${user.firstName} ${user.lastName}"
                          : user.organizationName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(user.email, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (user.role != Rolemodel.admin)
                          ButtonWidget(
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                ),
                              );
                            },
                            'Mettre à jour le profil',
                            false,
                            false,
                            primaryColor,
                          ),
                        ButtonWidget(
                          logout,
                          'Déconnexion',
                          isLoading,
                          false,
                          redColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
              if (user.role == Rolemodel.user) ...[
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 10.h),
                Text(
                  'Mes candidatures',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildJobSeekerApplications(user),
              ] else if (user.role == Rolemodel.manager) ...[
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 10.h),
                Text(
                  'Candidatures à mes offres',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildEnterpriseApplications(user),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobSeekerApplications(UserModel user) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('applications')
              .where('applicantId', isEqualTo: user.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'Aucune candidature pour le moment',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          );
        }

        final applications =
            snapshot.data!.docs.map((doc) {
              return ApplicationModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
            }).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index];
            return _buildJobSeekerApplicationCard(application);
          },
        );
      },
    );
  }

  Widget _buildEnterpriseApplications(UserModel user) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('applications').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'Aucune candidature pour vos offres pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          );
        }

        final applications =
            snapshot.data!.docs.map((doc) {
              return ApplicationModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
            }).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index];
            return _buildEnterpriseApplicationCard(application);
          },
        );
      },
    );
  }

  Widget _buildJobSeekerApplicationCard(ApplicationModel application) {
    return Card(
      color: lightColor,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    application.offerTitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(application.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    application.formatApplicationStatus(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _getStatusColor(application.status),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'At ${application.companyName}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Applied on ${_formatDate(application.createdAt)}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                ButtonWidget(
                  () {
                    _viewOfferDetails(application.offerId);
                  },
                  "View details",
                  false,
                  true,
                  primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnterpriseApplicationCard(ApplicationModel application) {
    return Card(
      color: lightColor,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    application.offerTitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(application.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    application.formatApplicationStatus(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _getStatusColor(application.status),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Demandeur: ${application.applicantName}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 4.h),
            Text(
              'E-mail: ${application.applicantEmail}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'Appliqué le ${_formatDate(application.createdAt)}',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            SizedBox(height: 12.h),
            if (application.status == ApplicationStatus.pending)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ButtonWidget(
                      () => _updateApplicationStatus(
                        application.id,
                        ApplicationStatus.accepted,
                      ),
                      "Accepter",
                      false,
                      false,
                      greenColor,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ButtonWidget(
                      () => _updateApplicationStatus(
                        application.id,
                        ApplicationStatus.rejected,
                      ),
                      "Rejeter",
                      false,
                      false,
                      redColor,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 8.h),
            Center(
              child: ButtonWidget(
                () {
                  _viewOfferDetails(application.offerId);
                },
                "Voir les détails de l'offre",
                false,
                true,
                primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .update({'status': status.name});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => ErrorPopUp(
                "Error",
                "Échec de la mise à jour de l'application: ${e.toString()}",
                redColor,
              ),
        );
      }
    }
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.accepted:
        return greenColor;
      case ApplicationStatus.rejected:
        return redColor;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _viewOfferDetails(String offerId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('reservations')
              .doc(offerId)
              .get();

      if (doc.exists) {
        final offer = ReservationModel.fromJson(doc.data()!);
        setState(() {
          offer.id = doc.id;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReservationDetails(offer)),
        );
      } else {
        showDialog(
          context: context,
          builder:
              (context) => ErrorPopUp("Error", 'Offre non trouvée', redColor),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => ErrorPopUp(
              "Error",
              "Échec de la mise à jour de l'application: ${e.toString()}",
              redColor,
            ),
      );
    }
  }

  logout() async {
    setState(() => isLoading = true);
    try {
      await auth.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user');
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (context) => ErrorPopUp("Alert", e.toString(), redColor),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
