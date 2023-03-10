import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // List<Semis> _semisInterieur = <Semis>[];
  List<Semis> _semisExterieur = <Semis>[];
  List<CalendarResource> resources = <CalendarResource>[];

  @override
  void initState() {
    super.initState();
    // getSemisInterieur().then((object) => setState(() {
    //       _semisInterieur = object['semisInterieur'] as List<Semis>;
    //       resources = object['resourcesColl'] as List<CalendarResource>;
    //     }));
    getSemisExterieur().then((object) => setState(() {
          _semisExterieur = object['semisExterieur'] as List<Semis>;
          resources = object['resourcesColl'] as List<CalendarResource>;
        }));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Calendrier'),
        ),
        body: SfCalendar(
          view: CalendarView.timelineMonth,
          allowedViews: const [
            CalendarView.schedule,
            CalendarView.timelineMonth
          ],
          showDatePickerButton: true,
          dataSource: SemisExterieurDataSource(_semisExterieur, resources),
          resourceViewSettings: const ResourceViewSettings(showAvatar: true),
        ),
      );
}

// Future<Map<String, List>> getSemisInterieur() async {
//   List<Semis> semisInterieur = <Semis>[];
//   List<CalendarResource> resourcesColl = <CalendarResource>[];

//   final semisInterieurCollection =
//       FirebaseFirestore.instance.collection('semis_interieur_ref');

//   final semisInterieurs = await semisInterieurCollection.get();

//   semisInterieur = semisInterieurs.docs
//       .map(
//         (doc) => Semis(
//           doc['legumes'],
//           doc['recurrence_semis_interieur'].toDate(),
//           Color(doc['color']),
//           doc['isAllDay'],
//           ['1'],
//         ),
//       )
//       .toList();

//   resourcesColl.add(
//     CalendarResource(
//       displayName: 'Intérieur',
//       color: const Color.fromARGB(255, 46, 212, 104),
//       id: '1',
//     ),
//   );
//   return {'semisInterieur': semisInterieur, 'resourcesColl': resourcesColl};
// }

Future<Map<String, List>> getSemisExterieur() async {
  List<Semis> semisExterieur = <Semis>[];
  List<CalendarResource> resourcesColl = <CalendarResource>[];

  final semisExterieurCollection =
      FirebaseFirestore.instance.collection('semis_exterieur_ref');

  final semisExterieurs = await semisExterieurCollection.get();

  semisExterieur = semisExterieurs.docs
      .map(
        (doc) => Semis(
          doc['legumes'],
          doc['recurrence_semis_extérieur'].toDate(),
          Color(doc['color']),
          doc['isAllDay'],
          ['1'],
        ),
      )
      .toList();

  resourcesColl.add(
    CalendarResource(
      displayName: 'Exterieux',
      color: const Color.fromRGBO(210, 96, 26, 1.0),
      id: '1',
    ),
  );

  return {'semisExterieur': semisExterieur, 'resourcesColl': resourcesColl};
}

class SemisExterieurDataSource extends CalendarDataSource {
  SemisExterieurDataSource(
      List<Semis> semisExterieur, List<CalendarResource> resourcesColl) {
    appointments = semisExterieur;
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
}

// class SemisInterieurDataSource extends CalendarDataSource {
//   SemisInterieurDataSource(
//       List<Semis> semisInterieur, List<CalendarResource> resourcesColl) {
//     appointments = semisInterieur;
//     resources = resourcesColl;
//   }

//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].recurrence_semis_interieur;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index]
//         .recurrence_semis_interieur
//         .add(const Duration(days: 30));
//   }

//   @override
//   String getSubject(int index) {
//     return appointments![index].legumes;
//   }

//   @override
//   Color getColor(int index) {
//     return appointments![index].color;
//   }

//   @override
//   bool isAllDay(int index) {
//     return appointments![index].isAllDay = true;
//   }
// }

class Semis {
  Semis(
    this.legumes,
    this.recurrence_semis_interieur,
    this.color,
    this.isAllDay,
    this.resourceIds,
  );

  String legumes;
  DateTime recurrence_semis_interieur;
  Color color;
  bool isAllDay;
  List<String> resourceIds;
}
