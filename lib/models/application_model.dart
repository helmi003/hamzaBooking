import 'package:cloud_firestore/cloud_firestore.dart';

enum ApplicationStatus { pending, accepted, rejected }

class ApplicationModel {
  final String id;
  final String offerId;
  final String applicantId;
  final String applicantName;
  final String applicantEmail;
  final String offerTitle;
  final String companyName;
  final String companyId;
  final DateTime offerDate;
  final ApplicationStatus status;
  final DateTime createdAt;

  ApplicationModel(
    this.id,
    this.offerId,
    this.applicantId,
    this.applicantName,
    this.applicantEmail,
    this.offerTitle,
    this.companyName,
    this.companyId,
    this.offerDate,
    this.status,
    this.createdAt,
  );

  factory ApplicationModel.fromJson(Map<String, dynamic> json, String id) {
    return ApplicationModel(
      id,
      json['offerId'] as String,
      json['applicantId'] as String,
      json['applicantName'] as String,
      json['applicantEmail'] as String,
      json['offerTitle'] as String,
      json['companyName'] as String,
      json['companyId'] as String,
      parseFirestoreDate(json['offerDate']),
      parseApplicationStatus(json['status'] as String?),
      DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'applicantEmail': applicantEmail,
      'offerTitle': offerTitle,
      'companyName': companyName,
      'companyId': companyId,
      'offerDate': offerDate,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static ApplicationStatus parseApplicationStatus(String? status) {
    switch (status) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'accepted':
        return ApplicationStatus.accepted;
      case 'rejected':
        return ApplicationStatus.rejected;
      default:
        return ApplicationStatus.pending;
    }
  }

  String formatApplicationStatus() {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  static DateTime parseFirestoreDate(dynamic date) {
  if (date == null) return DateTime.now();
  if (date is Timestamp) return date.toDate();
  if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
  return DateTime.now();
}
}
