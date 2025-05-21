import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamzabooking/models/reservation_model.dart';
import 'package:hamzabooking/models/user.dart';
import 'package:hamzabooking/screens/reservations/add_reservation_screen.dart';
import 'package:hamzabooking/services/userProvider.dart';
import 'package:hamzabooking/utils/colors.dart';
import 'package:hamzabooking/widgets/offer_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AllOffers extends StatefulWidget {
  const AllOffers({super.key});

  @override
  State<AllOffers> createState() => _AllOffersState();
}

class _AllOffersState extends State<AllOffers> {
  bool showCalendarView = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ReservationModel>> _events = {};

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Toutes les réservations"),
        actions: [
          IconButton(
            icon: Icon(showCalendarView ? Icons.list : Icons.calendar_today),
            onPressed: () {
              setState(() {
                showCalendarView = !showCalendarView;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune offre trouvée.'));
          }

          final offers =
              snapshot.data!.docs
                  .where((doc) => doc.exists && doc.data() != null)
                  .map((doc) {
                    try {
                      return ReservationModel.fromJson(
                        doc.data() as Map<String, dynamic>,
                      )..id = doc.id;
                    } catch (e) {
                      print('Error parsing document ${doc.id}: $e');
                      return null;
                    }
                  })
                  .whereType<ReservationModel>()
                  .toList();

          if (offers.isEmpty) {
            return const Center(child: Text('No valid offers found.'));
          }

          // Group reservations by date for calendar view
          if (showCalendarView) {
            _events = {};
            for (var offer in offers) {
              final date = DateTime(
                offer.startDate.year,
                offer.startDate.month,
                offer.startDate.day,
              );
              if (_events[date] == null) {
                _events[date] = [];
              }
              _events[date]!.add(offer);
            }
          }

          return showCalendarView
              ? _buildCalendarView(offers)
              : _buildListView(offers);
        },
      ),
      floatingActionButton:
          user.role == Rolemodel.admin
              ? FloatingActionButton(
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddReservationScreen(),
                    ),
                  );
                },
                backgroundColor: primaryColor,
                child: const Icon(Icons.add, color: lightColor),
              )
              : null,
    );
  }

  Widget _buildCalendarView(List<ReservationModel> offers) {
    return Column(
      children: [
        TableCalendar<ReservationModel>(
          firstDay: DateTime.now().subtract(Duration(days: 365)),
          lastDay: DateTime.now().add(Duration(days: 365)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = DateTime(
                selectedDay.year,
                selectedDay.month,
                selectedDay.day,
              );
              _focusedDay = focusedDay;
            });
          },

          eventLoader: (day) {
            final normalizedDay = DateTime(day.year, day.month, day.day);
            return _events[normalizedDay] ?? [];
          },

          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
        Expanded(
          child:
              _selectedDay == null
                  ? Center(child: Text('Sélectionnez une date'))
                  : ListView.builder(
                    itemCount: _events[_selectedDay]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final offer = _events[_selectedDay]![index];
                      return ReservationWidget(offer);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildListView(List<ReservationModel> offers) {
    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, index) => ReservationWidget(offers[index]),
    );
  }
}
