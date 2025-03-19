import 'dart:core';
//import 'package:firebase_database/firebase_database.dart';

class EventModel {
  var id;
  String titolo;
  String descrizione;
  String immagineCaricata;
  DateTime dataInizio;
  DateTime dataFine;
  String luogo;
  int prezzo;
  bool isFavourite;
  List<String> eventAttendees;

  EventModel(
      this.titolo,
      this.descrizione,
      this.immagineCaricata,
      this.dataInizio,
      this.dataFine,
      this.luogo,
      this.prezzo,
      this.isFavourite,
      this.eventAttendees);

  //TODO: sistemare la factory

  // factory EventModel.fromSnap(DataSnapshot model) {
  //   return EventModel(
  //     model.child('titolo').toString(),
  //     model.child('descrizione').toString(),
  //     "",
  //     model.child('dataInizio'),
  //     model.child('dataFine'),
  //     model.child('oraInizio').toString(),
  //     model.child('oraFine').toString(),
  //     model.child('luogo').toString(),
  //     int.parse(model.child('prezzo').toString()),
  //     List.empty()
  //   );
  // }
}
