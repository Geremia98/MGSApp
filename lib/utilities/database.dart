// import 'package:fancy_app/utilities/models.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class Database {
//   static final FirebaseDatabase db = FirebaseDatabase.instance;

//   Database();

//   static Future<bool> writeEvent(EventModel e) async {
//     if(FirebaseAuth.instance.currentUser != null){
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       DatabaseReference ref = db.ref("events");
//       DatabaseReference newEventRef = ref.push();
//       e.id = newEventRef.key;
//       newEventRef.set({
//         'organizzatore':uid,
//         'titolo':e.titolo,
//         'descrizione': e.descrizione,
//         'dataInizio': e.dataInizio,
//         'dataFine': e.dataFine,
//         'oraInizio': e.oraInizio,
//         'oraFine': e.oraFine,
//         'luogo': e.luogo,
//         'prezzo': e.prezzo,
//       });
//       DatabaseReference ref2 = db.ref("$uid/created");
//       var createdEvents =await ref2.get();
//       String events = createdEvents.value.toString();
//       String eventid = e.id;
//       events+=",$eventid";
//       ref2.set('$events');
//       return true;
//     }else{
//       return false;
//     }
//   }

//   Future<List<EventModel>> readEventList() async {
//     List<EventModel> events = new List.empty();
//     if(FirebaseAuth.instance.currentUser != null){
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       DatabaseReference ref = db.ref("$uid/created");
//       final dbSnapshot = await ref.get();
//       if (dbSnapshot.exists){
//         List<String> colli = dbSnapshot.value.toString().split(",");
//         print(colli.join(","));
//         List<EventModel> events = new List.empty();
//         colli.forEach((element) async {
//           if(element!= null){
//             events.add(await readEvent(element));
//           }
//         });
//         debugPrint(dbSnapshot.value.toString());
//       }
//     }
//     for(EventModel e in events){
//       print(e);
//     }
//     return events;
//   }

//   Future<EventModel> readEvent(String id) async {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;
//     DatabaseReference ref = db.ref("events/$id");
//     final dbSnapshot = await ref.get();
//     print(dbSnapshot.value.toString());
//     return EventModel.fromSnap(dbSnapshot);
//   }


//   Future<bool> inviteToEvent(String eventID, String invitee) async {
//     DatabaseReference ref = db.ref("$invitee/invited");
//     var invitedEvents =await ref.get();
//     String events = invitedEvents.value.toString();
//     events+=",$eventID";
//     ref.set(events);
//     DatabaseReference ref2 = db.ref("events/$eventID/invited");
//     var eventsInvited =await ref.get();
//     String inviteds = eventsInvited.value.toString();
//     inviteds+=",$invitee";
//     ref2.set('$inviteds');
//     return true;
//   }

//   Future<bool> decideInvitation(bool choice, String eventID) async {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;
//     DatabaseReference ref = db.ref("$uid/invited");
//     var invitedEvents =await ref.get();
//     List<String> events = invitedEvents.value.toString().split(",");
//     events.remove(eventID);
//     String eventsd = events.join(",");
//     ref.set("$eventsd");
//     DatabaseReference ref2 = db.ref("events/$eventID/invited");
//     var invitedd = await ref2.get();
//     List<String> invitedguests = invitedd.value.toString().split(",");
//     invitedguests.remove(uid);
//     String iv = invitedguests.join(",");
//     ref2.set("$iv");
//     if(choice){
//       DatabaseReference ref3 = db.ref("events/$eventID/participants");
//       var invitedd = await ref3.get();
//       String invitedguests = invitedd.value.toString();
//       invitedguests+=",$uid";
//       ref3.set("$invitedguests");
//     }
//     return true;
//   }

//   void setUsernameToPool(String uid, String username){
//     DatabaseReference ref = db.ref("users/$uid");
//     ref.set({
//       "username":username,
//     });
//   }

//   Future<Map<String, String>> getUsernames() async {
//     debugPrint("getusernames");
//     Map<String, String> userandnames = {};
//     DatabaseReference ref = db.ref("users");
//     DataSnapshot users = await ref.get();
//     for(DataSnapshot ds  in users.children){
//       var key = ds.key;
//       userandnames.addAll({'$key':ds.child("username").value.toString()});
//     }
//     print(userandnames);
//     return userandnames;
//   }


//   Future<bool> deleteEvent(EventModel e) async {
//     if (FirebaseAuth.instance.currentUser != null && e.id != null) {
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       String iden = e.id;
//       DatabaseReference ref = db.ref("events/$iden");
//       var newEventRef = ref.remove();
//       DatabaseReference ref2 = db.ref("$uid/created");
//       var createdEvents = await ref2.get();
//       List<String> events = createdEvents.value.toString().split(",");
//       String eventid = e.id;
//       events.remove(eventid);
//       String ev = events.join(",");
//       ref2.set("$ev");
//       return true;
//     } else {
//       return false;
//     }
//   }

//   bool editEvent(EventModel e) {
//     if (FirebaseAuth.instance.currentUser != null && e.id != null) {
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       String iden = e.id;
//       DatabaseReference ref = db.ref("events/$iden");
//       String date = e.data;
//       String eventDesc = e.descrizione;
//       var newEventRef = ref.set({
//         'organizzatore':uid,
//         'titolo':e.titolo,
//         'descrizione': e.descrizione,
//         'data': e.data,
//         'oraInizio': e.oraInizio,
//         'oraFine': e.oraFine,
//         'luogo': e.luogo,
//         'prezzo': e.prezzo,
//       });
//       return true;
//     } else {
//       return false;
//     }
//   }

//   bool addCalendarEvent(EventModel e) {
//     return false;
//   }

//   Object readCalendarEventList() {
//     return new Object();
//     //TODO da sostituire con il read del calendario
//   }

//   Object readCalendarEvent() {
//     return new Object();
//     //TODO da sostituire con il read del cdettaglio dell'evento a calendario
//   }

//   bool deleteCalendarEvent(EventModel e) {
//     return false;
//   }

//   bool editCalendarEvent(EventModel e) {
//     return false;
//   }
// }
