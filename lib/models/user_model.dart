import 'package:firebase_auth/firebase_auth.dart';

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


  UserModel.fromFirestore(User user, Map<String, dynamic> data) {
    uid = user.uid;
    email = user.email ?? '';
    profilePic = data.containsKey(firestoreUsersProfilePictureHQField)
        ? ImageModel(
        downloadUrl: data[firestoreUsersProfilePictureHQField] as String)
        : null;
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
  }
}