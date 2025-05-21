import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamzabooking/widgets/cachedImageWidget.dart';
import 'package:hamzabooking/models/reservation_model.dart';
import 'package:hamzabooking/screens/offers/reservation_details.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/button_widget.dart';
import 'package:intl/intl.dart';

class ReservationWidget extends StatelessWidget {
  final ReservationModel reservation;
  const ReservationWidget(this.reservation, {super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: darkColor, width: 0.5),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: darkColor.withValues(alpha: 0.05),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            reservation.imageUrl,
            double.infinity,
            100,
            BoxFit.cover,
          ),
          Text(
            reservation.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: textColor,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "Par ${reservation.postedByName}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.calendarDays,
                size: 14.sp,
                color: primaryColor,
              ),
              SizedBox(width: 6.w),
              Text(
                "Du ${dateFormat.format(reservation.startDate)} au ${dateFormat.format(reservation.endDate)}",
                style: TextStyle(fontSize: 12.sp, color: textColor),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(FontAwesomeIcons.users, size: 14.sp, color: primaryColor),
              SizedBox(width: 6.w),
              Text(
                "Capacité: ${reservation.capacity} personnes",
                style: TextStyle(fontSize: 12.sp, color: textColor),
              ),
              SizedBox(width: 12.w),
              Icon(FontAwesomeIcons.tags, size: 14.sp, color: primaryColor),
              SizedBox(width: 6.w),
              Text(
                reservation.category,
                style: TextStyle(fontSize: 12.sp, color: textColor),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(FontAwesomeIcons.moneyBill, size: 14.sp, color: greenColor),
              SizedBox(width: 6.w),
              Text(
                "${reservation.price} DT",
                style: TextStyle(fontSize: 12.sp, color: greenColor),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            reservation.description,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 12.h),
          Center(
            child: ButtonWidget(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationDetails(reservation),
                  ),
                );
              },
              "Voir les détails",
              false,
              true,
              primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
