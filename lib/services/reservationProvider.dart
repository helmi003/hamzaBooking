import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamzabooking/models/application_model.dart';
import 'package:hamzabooking/models/reservation_model.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/error_popup.dart';

class ReservationProvider with ChangeNotifier {
  Future<void> createOffer(ReservationModel newReservation) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .add(newReservation.toJson());
  }

  Future<void> updateOffer(ReservationModel updatedReservation) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(updatedReservation.id)
        .update(updatedReservation.toJson());
  }

  Future<void> deleteOffer(String offerId) async {
    try {
      final applications =
          await FirebaseFirestore.instance
              .collection('applications')
              .where('offerId', isEqualTo: offerId)
              .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in applications.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(offerId)
          .delete();
    } catch (e) {
      throw Exception(
        "Échec de la suppression de l'offre et des applications: $e",
      );
    }
  }

  Future<void> submitApplication(
    BuildContext context,
    UserModel user,
    ReservationModel offer,
    DateTime offerDate,
  ) async {
    try {
      if (offer.id.isEmpty) {
        throw Exception('Offer ID is empty');
      }

      final docRef =
          FirebaseFirestore.instance.collection('applications').doc();

      if (docRef.id.isEmpty) {
        throw Exception('Failed to generate document ID');
      }

      final application = ApplicationModel(
        docRef.id,
        offer.id,
        user.uid,
        '${user.firstName} ${user.lastName}',
        user.email,
        offer.title,
        offer.postedByName,
        offer.postedByUid,
        offerDate,
        ApplicationStatus.pending,
        DateTime.now(),
      );

      await docRef.set(application.toJson());

      showDialog(
        context: context,
        builder:
            (context) => ErrorPopUp(
              "Success",
              'Application submitted successfully!',
              greenColor,
            ),
      );
    } catch (e) {
      print('Application error: $e');
      showDialog(
        context: context,
        builder:
            (context) => ErrorPopUp(
              "Error",
              'Failed to apply: ${e.toString()}',
              redColor,
            ),
      );
    }
  }

  Future<void> cancelApplication(
    BuildContext context,
    UserModel user,
    ReservationModel offer,
  ) async {
    try {
      if (offer.id.isEmpty) {
        throw Exception('Offer ID is empty');
      }

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('applications')
              .where('offerId', isEqualTo: offer.id)
              .where('applicantId', isEqualTo: user.uid)
              .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No application found to cancel');
      }

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      showDialog(
        context: context,
        builder:
            (context) => ErrorPopUp(
              "Cancelled",
              'Application removed successfully!',
              yellowColor,
            ),
      );
    } catch (e) {
      print('Cancellation error: $e');
      showDialog(
        context: context,
        builder:
            (context) => ErrorPopUp(
              "Error",
              'Failed to cancel: ${e.toString()}',
              redColor,
            ),
      );
    }
  }
}
