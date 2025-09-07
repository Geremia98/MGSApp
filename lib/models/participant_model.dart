import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_model.dart';

import '../services/firebase/firestore/firestore_users_fields.dart';

class ParticipantModel {
  final String uid;
  final String name;
  final String surname;
  final UserGender gender;
  final DateTime? birth;
  final ImageModel? image;

  ParticipantModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.gender,
    this.birth,
    this.image,
  });

  factory ParticipantModel.fromFirestore(
    String uid,
    Map<String, dynamic> data,
      ImageModel? image,
  ) {
    return ParticipantModel(
      uid: uid,
      name: data.containsKey(firestoreUsersNameField)
          ? data[firestoreUsersNameField]
          : '',
      surname: data.containsKey(firestoreUsersSurnameField)
          ? data[firestoreUsersSurnameField]
          : '',
      gender: data.containsKey(firestoreUsersGenderField)
          ? UserGender.values.firstWhere(
              (type) => type.name == data[firestoreUsersGenderField],
              orElse: () => UserGender.male,
            )
          : UserGender.male,
      birth: data.containsKey(firestoreUsersBirthField)
          ? (data[firestoreUsersBirthField] as Timestamp).toDate()
          : null,
      image: image,
    );
  }
}
