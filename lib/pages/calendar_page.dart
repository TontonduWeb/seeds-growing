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
  List<CalendarResource> resources = <CalendarResource>[];

  @override
  void initState() {
    super.initState();
    getSemis().then((object) => setState(() {
          _semisInterieur = object['semisInterieur'] as List<Semis>;
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
          dataSource: SemisDataSource(_semisInterieur, resources),
          resourceViewSettings: const ResourceViewSettings(
              showAvatar: true, visibleResourceCount: 1),
        ),
      );
}

Future<Map<String, List>> getSemis() async {
  List<Semis>? semisInterieur = <Semis>[];

  List<CalendarResource> resourcesColl = <CalendarResource>[];

  final userPlants =
      await FirebaseFirestore.instance.collection('userPlante').get();

  List<Semis> semisInterieurs = <Semis>[];
  for (var i = 0; i < userPlants.docs.length; i++) {
    final document = userPlants.docs[i].data();
    if (document['id_semis_interieur'] == null) continue;
    semisInterieurs.add(
      await FirebaseFirestore.instance
          .collection('semis_interieur_ref')
          .doc(document['id_semis_interieur'])
          .get()
          .then((value) => Semis(
                value['legumes'],
                value['recurrence_semis_interieur'].toDate(),
                Color(value['color']),
                value['isAllDay'],
                ['2'],
              )),
    );
  }

  semisInterieur = semisInterieurs
      .map((semis) => Semis(
            semis.legumes,
            semis.recurrence,
            semis.color,
            semis.isAllDay,
            semis.resourceIds,
          ))
      .cast<Semis>()
      .toList();

  resourcesColl.add(
    CalendarResource(
      displayName: 'Interieur',
      color: const Color(0xff28a5a8),
      id: '2',
    ),
  );

  return {'semisInterieur': semisInterieur, 'resourcesColl': resourcesColl};
}

class SemisDataSource extends CalendarDataSource {
  bool _isSemisInterned = false;
  bool _isSemisExterne = false;
  List<Appointment>? _isSemisInternedAppointments, _isSemisExterneAppointments;
  List<Appointment>? _appointments;

  SemisDataSource? _semisDataSource;
  List<Semis>? _semisInterieur;
  SemisDataSource(
      List<Semis> semisInterieur, List<CalendarResource> resourcesColl) {
    appointments = semisInterieur;

    resources = resourcesColl;
  }

  void initState() {
    _semisDataSource = SemisDataSource(_semisInterieur!, resources!);
    initState();
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
