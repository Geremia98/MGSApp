import 'package:firebase_auth/firebase_auth.dart';
import 'package:mgs_app2/models/event_model.dart';

import '../services/firebase/firestore/firestore_users_fields.dart';
import 'image_model.dart';

enum UserGender {
  male,
  female,
}

class UserModel {
  static String uid = '';
  static UserGender gender = UserGender.male;
  static String email = '';
  static String name = '';
  static String surname = '';
  static DateTime? birth;
  static ImageModel? profilePic;
  static String group = '';
  static String ispettoria = '';
  static String country = '';
  static String bossCode = '';
  static List<EventModel> myEventsList = [];

  static String iban = '';
  static String holderName = '';
  static String bankCurrency = '';

  UserModel.fromFirestore(User user, Map<String, dynamic> data) {
    uid = user.uid;
    email = user.email ?? '';
    bossCode = data.containsKey(firestoreUsersBossCodeField)
        ? data[firestoreUsersBossCodeField] as String
        : '';
    name = data.containsKey(firestoreUsersNameField)
        ? data[firestoreUsersNameField] as String
        : '';
    surname = data.containsKey(firestoreUsersSurnameField)
        ? data[firestoreUsersSurnameField] as String
        : '';
    group = data.containsKey(firestoreUsersGroupField)
        ? data[firestoreUsersGroupField] as String
        : '';
    ispettoria = data.containsKey(firestoreUsersIspettoriaField)
        ? data[firestoreUsersIspettoriaField] as String
        : '';
    country = data.containsKey(firestoreUsersCountryField)
        ? data[firestoreUsersCountryField] as String
        : '';
    gender = data.containsKey(firestoreUsersGenderField)
        ? UserGender.values.firstWhere(
            (type) => type.name == data[firestoreUsersGenderField],
            orElse: () => UserGender.male,
          )
        : UserGender.male;
    myEventsList = data.containsKey(firestoreUsersMyEventsListField)
        ? (data[firestoreUsersMyEventsListField] as List).whereType<EventModel>().toList()
        : [];
    bankCurrency = data.containsKey(firestoreBankCurrencyField)
        ? data[firestoreBankCurrencyField] as String
        : '';
    holderName = data.containsKey(firestoreBakHolderNameField)
        ? data[firestoreBakHolderNameField] as String
        : '';
    iban = data.containsKey(firestoreBankIbanField)
        ? data[firestoreBankIbanField] as String
        : '';
  }
}
