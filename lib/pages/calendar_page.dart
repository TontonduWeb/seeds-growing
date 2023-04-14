import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool _isSemisInterieur = false;
  bool _isSemisExterieur = false;
  bool isPlantation = false;
  List<Filtre> _semisInterieur = <Filtre>[];
  List<Filtre> _semisExterieur = <Filtre>[];
  List<Filtre> _plantation = <Filtre>[];

  SemisDataSource _semisDataSource =
      SemisDataSource(<Filtre>[], <Filtre>[], <Filtre>[]);

  @override
  void initState() {
    super.initState();
    _semisDataSource =
        SemisDataSource(_semisInterieur, _semisExterieur, _plantation);
    getSemisInterieur().then((object) => setState(() {
          _semisInterieur = object['semisInterieur'] as List<Filtre>;
        }));
    getSemisExterieur().then((object) => setState(() {
          _semisExterieur = object['semisExterieur'] as List<Filtre>;
        }));
    getPlantation().then((object) => setState(() {
          _plantation = object['plantation'] as List<Filtre>;
        }));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Calendrier'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Row(
                  children: <Widget>[
                    Switch(
                      value: _isSemisInterieur,
                      onChanged: (value) {
                        getSemisInterieur().then((object) => setState(() {
                              if (value) {
                                _semisInterieur =
                                    object['semisInterieur'] as List<Filtre>;
                                _semisDataSource.appointments!
                                    .addAll(_semisInterieur);
                                _semisDataSource.notifyListeners(
                                    CalendarDataSourceAction.reset,
                                    _semisInterieur);
                              } else {
                                for (int i = 0;
                                    i < _semisInterieur.length;
                                    i++) {
                                  _semisDataSource.appointments!
                                      .remove(_semisInterieur[i]);
                                }
                                _semisInterieur.clear();
                                _semisDataSource.notifyListeners(
                                    CalendarDataSourceAction.reset,
                                    _semisInterieur);
                              }
                              _isSemisInterieur = value;
                            }));
                      },
                      activeTrackColor:
                          const Color(0xff28a5a8).withOpacity(0.5),
                      activeColor: const Color(0xff28a5a8).withOpacity(1),
                    ),
                    const Text(
                      'Semis Interieur',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                        value: _isSemisExterieur,
                        onChanged: (value) {
                          getSemisExterieur().then((object) => setState(() {
                                if (value) {
                                  _semisExterieur =
                                      object['semisExterieur'] as List<Filtre>;
                                  _semisDataSource.appointments!
                                      .addAll(_semisExterieur);
                                  _semisDataSource.notifyListeners(
                                      CalendarDataSourceAction.reset,
                                      _semisExterieur);
                                } else {
                                  for (int i = 0;
                                      i < _semisExterieur.length;
                                      i++) {
                                    _semisDataSource.appointments!
                                        .remove(_semisExterieur[i]);
                                  }
                                  _semisExterieur.clear();
                                  _semisDataSource.notifyListeners(
                                      CalendarDataSourceAction.reset,
                                      _semisExterieur);
                                }
                                _isSemisExterieur = value;
                              }));
                        },
                        activeTrackColor:
                            const Color(0xff5ba87f).withOpacity(0.5),
                        activeColor: const Color(0xff5ba87f).withOpacity(1)),
                    const Text(
                      'Semis Exterieur',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                        value: isPlantation,
                        onChanged: (value) {
                          getPlantation().then((object) => setState(() {
                                if (value) {
                                  _plantation =
                                      object['plantation'] as List<Filtre>;
                                  _semisDataSource.appointments!
                                      .addAll(_plantation);
                                  _semisDataSource.notifyListeners(
                                      CalendarDataSourceAction.reset,
                                      _plantation);
                                } else {
                                  for (int i = 0; i < _plantation.length; i++) {
                                    _semisDataSource.appointments!
                                        .remove(_plantation[i]);
                                  }
                                  _plantation.clear();
                                  _semisDataSource.notifyListeners(
                                      CalendarDataSourceAction.reset,
                                      _plantation);
                                }
                                isPlantation = value;
                              }));
                        },
                        activeTrackColor:
                            const Color(0xff396ba8).withOpacity(0.5),
                        activeColor: const Color(0xff396ba8).withOpacity(1)),
                    const Text(
                      'Plantation',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SfCalendar(
                  view: CalendarView.month,
                  monthViewSettings: const MonthViewSettings(showAgenda: true),
                  showDatePickerButton: true,
                  dataSource: _semisDataSource),
            ),
          ],
        ),
      );
}

Future<Map<String, List>> getSemisInterieur() async {
  List<Filtre>? semisInterieur = <Filtre>[];

  final userPlants =
      await FirebaseFirestore.instance.collection('userPlante').get();

  List<Filtre> semisInterieurs = <Filtre>[];
  for (var i = 0; i < userPlants.docs.length; i++) {
    final document = userPlants.docs[i].data();
    if (document['id_semis_interieur'] == null) continue;
    semisInterieurs.add(
      await FirebaseFirestore.instance
          .collection('semis_interieur_ref')
          .doc(document['id_semis_interieur'])
          .get()
          .then((value) => Filtre(
                value['legumes'],
                value['recurrence_semis_interieur'].toDate(),
                Color(value['color']),
                value['isAllDay'],
                ['2'],
              )),
    );
  }

  semisInterieur = semisInterieurs
      .map((semis) => Filtre(
            semis.legumes,
            semis.recurrence,
            semis.color,
            semis.isAllDay,
            semis.resourceIds,
          ))
      .cast<Filtre>()
      .toList();

  return {'semisInterieur': semisInterieur};
}

Future<Map<String, List>> getSemisExterieur() async {
  List<Filtre>? semisExterieur = <Filtre>[];

  final userPlants =
      await FirebaseFirestore.instance.collection('userPlante').get();

  List<Filtre> semisExterieurs = <Filtre>[];
  for (var i = 0; i < userPlants.docs.length; i++) {
    final document = userPlants.docs[i].data();
    if (document['id_semis_exterieur'] == null) continue;
    semisExterieurs.add(
      await FirebaseFirestore.instance
          .collection('semis_exterieur_ref')
          .doc(document['id_semis_exterieur'])
          .get()
          .then((value) => Filtre(
                value['legumes'],
                value['recurrence_semis_extérieur'].toDate(),
                Color(value['color']),
                value['isAllDay'],
                ['2'],
              )),
    );
  }

  semisExterieur = semisExterieurs
      .map((semis) => Filtre(
            semis.legumes,
            semis.recurrence,
            semis.color,
            semis.isAllDay,
            semis.resourceIds,
          ))
      .toList();

  return {'semisExterieur': semisExterieur};
}

Future<Map<String, List>> getPlantation() async {
  List<Filtre>? plantation = <Filtre>[];

  final userPlants =
      await FirebaseFirestore.instance.collection('userPlante').get();

  List<Filtre> plantations = <Filtre>[];
  for (var i = 0; i < userPlants.docs.length; i++) {
    final document = userPlants.docs[i].data();
    if (document['id_plantation_ref'] == null) continue;
    plantations.add(
      await FirebaseFirestore.instance
          .collection('plantation_ref')
          .doc(document['id_plantation_ref'])
          .get()
          .then((value) => Filtre(
                value['legumes'],
                value['recurrence_plantation_exterieur'].toDate(),
                Color(value['color']),
                value['isAllDay'],
                ['3'],
              )),
    );
  }

  plantation = plantations
      .map((semis) => Filtre(
            semis.legumes,
            semis.recurrence,
            semis.color,
            semis.isAllDay,
            semis.resourceIds,
          ))
      .toList();

  return {'plantation': plantation};
}

class SemisDataSource extends CalendarDataSource {
  SemisDataSource(List<Filtre> semisInterieur, List<Filtre> semisExterieur,
      List<Filtre> plantation) {
    appointments = semisInterieur;
    appointments!.addAll(semisExterieur);
    appointments!.addAll(plantation);
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

class Filtre {
  Filtre(
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
