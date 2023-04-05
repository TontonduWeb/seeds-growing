import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Semis> _semisInterieur = <Semis>[];
  List<Semis> _semisExterieur = <Semis>[];
  List<Semis> _plantations = <Semis>[];
  List<CalendarResource> resources = <CalendarResource>[];

  @override
  void initState() {
    super.initState();
    getSemis().then((object) => setState(() {
          _semisInterieur = object['semisInterieur'] as List<Semis>;
          _semisExterieur = object['semisExterieur'] as List<Semis>;
          _plantations = object['plantations'] as List<Semis>;
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
            CalendarView.timelineDay,
            CalendarView.timelineWeek,
            CalendarView.timelineMonth,
          ],
          showDatePickerButton: true,
          dataSource: SemisDataSource(
              _semisExterieur, _semisInterieur, _plantations, resources),
          resourceViewSettings: const ResourceViewSettings(
              showAvatar: true, visibleResourceCount: 3),
        ),
      );
}

Future<Map<String, List>> getSemis() async {
  List<Semis> semisExterieur = <Semis>[];
  List<Semis> semisInterieur = <Semis>[];
  List<Semis> plantation = <Semis>[];
  List<CalendarResource> resourcesColl = <CalendarResource>[];

  final semisExterieurCollection =
      FirebaseFirestore.instance.collection('semis_exterieur_ref');
  final semisInterieurCollection =
      FirebaseFirestore.instance.collection('semis_interieur_ref');
  final plantationsCollection =
      FirebaseFirestore.instance.collection('plantation_ref');

  final semisExterieurs = await semisExterieurCollection.get();
  final semisInterieurs = await semisInterieurCollection.get();
  final plantations = await plantationsCollection.get();

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

  semisInterieur = semisInterieurs.docs
      .map(
        (doc) => Semis(
          doc['legumes'],
          doc['recurrence_semis_interieur'].toDate(),
          Color(doc['color']),
          doc['isAllDay'],
          ['2'],
        ),
      )
      .toList();

  plantation = plantations.docs
      .map(
        (doc) => Semis(
            doc['legumes'],
            doc['recurrence_plantation_exterieur'].toDate(),
            Color(doc['color']),
            true,
            ['3']),
      )
      .toList();

  resourcesColl.add(
    CalendarResource(
      displayName: 'Exterieur',
      color: const Color(0xff5ba87f),
      id: '1',
    ),
  );
  resourcesColl.add(
    CalendarResource(
      displayName: 'Interieur',
      color: const Color(0xff28a5a8),
      id: '2',
    ),
  );
  resourcesColl.add(
    CalendarResource(
      displayName: 'Plantation',
      color: const Color(0xff396ba8),
      id: '3',
    ),
  );

  return {
    'semisExterieur': semisExterieur,
    'semisInterieur': semisInterieur,
    'plantations': plantation,
    'resourcesColl': resourcesColl
  };
}

class SemisDataSource extends CalendarDataSource {
  SemisDataSource(List<Semis> semisExterieur, List<Semis> semisInterieur,
      List<Semis> plantation, List<CalendarResource> resourcesColl) {
    appointments = semisInterieur;
    appointments!.addAll(semisExterieur);
    appointments!.addAll(plantation);

    resources = resourcesColl;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].recurrence;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].recurrence.add(const Duration(days: 30));
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

  @override
  List<Object> getResourceIds(int index) {
    return appointments![index].resourceIds;
  }
}

class Semis {
  Semis(
    this.legumes,
    this.recurrence,
    this.color,
    this.isAllDay,
    this.resourceIds,
  );

  String legumes;
  DateTime recurrence;
  Color color;
  bool isAllDay;
  List<String> resourceIds;
}

// class Plantation {
//   Plantation(
//     this.legumes,
//     this.recurrence,
//     this.color,
//     this.isAllDay,
//     this.resourceIds,
//   );

//   String legumes;
//   DateTime recurrence;
//   Color color;
//   bool isAllDay;
//   List<String> resourceIds;
// }
