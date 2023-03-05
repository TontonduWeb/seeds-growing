import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<SemisInterieur> _semisInterieur = <SemisInterieur>[];

  @override
  void initState() {
    super.initState();
    getTests().then((appointments) => setState(() {
          _semisInterieur = appointments;
        }));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Calendrier'),
        ),
        body: SfCalendar(
          view: CalendarView.schedule,
          monthViewSettings: const MonthViewSettings(showAgenda: true),
          firstDayOfWeek: 1,
          allowedViews: const <CalendarView>[
            CalendarView.schedule,
            CalendarView.month,
          ],
          scheduleViewSettings: const ScheduleViewSettings(
            monthHeaderSettings: MonthHeaderSettings(
              monthFormat: 'MMMM, yyyy',
              height: 100,
              textAlign: TextAlign.left,
              backgroundColor: Color.fromRGBO(29, 60, 69, 1.0),
              monthTextStyle: TextStyle(
                  color: Color.fromRGBO(255, 241, 225, 1.0),
                  fontSize: 25,
                  fontWeight: FontWeight.w400),
            ),
            weekHeaderSettings: WeekHeaderSettings(
              startDateFormat: 'dd MMM ',
              endDateFormat: 'dd MMM, yy',
              height: 50,
              textAlign: TextAlign.center,
              backgroundColor: Color.fromRGBO(210, 96, 26, 1.0),
              weekTextStyle: TextStyle(
                color: Color.fromRGBO(255, 241, 225, 1.0),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          showDatePickerButton: true,
          timeSlotViewSettings: const TimeSlotViewSettings(
              dayFormat: 'EEE', startHour: 24, endHour: 24),
          dataSource: AppointmentDataSource(_semisInterieur),
        ),
      );
}

final user = FirebaseAuth.instance.currentUser!;

// List<Meeting> _getDataSource() {
//     final List<Meeting> meetings = <Meeting>[];
//     final DateTime today = DateTime.now();
//     final DateTime startTime =
//         DateTime(today.year, today.month, today.day, 9, 0, 0);
//     final DateTime endTime = startTime.add(const Duration(hours: 2));
//     meetings.add(Meeting(
//         'Conference', startTime, endTime, const Color(0xFF0F8644), false));
//     return meetings;
//   }

Future<List<SemisInterieur>> getTests() async {
  List<SemisInterieur> semisInterieur = <SemisInterieur>[];
  final testCollection =
      FirebaseFirestore.instance.collection('semis_interieur_ref');

  final tests = await testCollection.get();

  semisInterieur = tests.docs
      .map(
        (doc) => SemisInterieur(
          doc['legumes'],
          doc['recurrence_semis_interieur'].toDate(),
          Color(doc['color']),
          doc['isAllDay'],
        ),
      )
      .toList();
  return semisInterieur;
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<SemisInterieur> semisInterieur) {
    appointments = semisInterieur;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].recurrence_semis_interieur;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index]
        .recurrence_semis_interieur
        .add(const Duration(days: 30));
  }

  @override
  String getSubject(int index) {
    return appointments![index].legumes;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay = true;
  }

  // @override
  // String getRecurrenceRule(int index) {
  //   return appointments![index].recurrenceRule = 'FREQ=YEARLY;INTERVAL=1';
  // }

}

class SemisInterieur {
  SemisInterieur(
    this.legumes,
    this.recurrence_semis_interieur,
    this.color,
    this.isAllDay,
    // this.recurrenceRule,
  );

  String legumes;
  DateTime recurrence_semis_interieur;
  Color color;
  bool isAllDay;
  // String recurrenceRule;
}
