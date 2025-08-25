import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/services/firebase/firestore/firestore_users_fields.dart';

import '../services/firebase/auth.dart';
import '../services/firebase/references.dart';

class UserFirestore {
  final FirebaseReferencesService _referencesService =
      FirebaseReferencesService.getInstance();
  late CollectionReference _userCR;

  UserFirestore() {
    _userCR = _referencesService.usersCR;
  }

  Future<bool> registerUser() async {
    final FirebaseAuthService authService = FirebaseAuthService();
    final User? user = authService.getCurrentUser();

    if (user == null) {
      return false;
    }

    try {
      await _userCR.doc(user.uid).set({
        firestoreUsersNameField: UserModel.name,
        firestoreUsersSurnameField: UserModel.surname,
        firestoreUsersBirthField: UserModel.birth,
        firestoreUsersGenderField: UserModel.gender.name,
        firestoreUsersGroupField: UserModel.group,
        firestoreUsersIspettoriaField: UserModel.ispettoria,
        firestoreUsersCountryField: UserModel.country,
        firestoreUsersBossCodeField: UserModel.bossCode,
        firestoreUsersMyEventsListField : UserModel.myEventsList,
        firestoreBankCurrencyField: UserModel.bossCode.isNotEmpty ? UserModel.bankCurrency : null,
        firestoreBakHolderNameField: UserModel.bossCode.isNotEmpty ? UserModel.holderName : null,
        firestoreBankIbanField: UserModel.bossCode.isNotEmpty ? UserModel.iban : null,
      });

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('error while registering user: $error');
      }

      return false;
    }
  }

  Future<UserModel?> loadUserModel() async {
    final FirebaseAuthService authService = FirebaseAuthService();
    final User? user = authService.getCurrentUser();

    if (user == null) {
      return null;
    }

    try {
      final DocumentSnapshot snap = await _userCR.doc(user.uid).get();

      if (!snap.exists || snap.data() == null) {
        return null;
      }

      final Map<String, dynamic> data = snap.data() as Map<String, dynamic>;


      UserModel userModel = UserModel.fromFirestore(user, data);

      final FirebaseStorageService storageService = FirebaseStorageService();

      UserModel.profilePic = await storageService.getUserProfileImage(UserModel.uid);

      return userModel;
    } catch (error) {
      if (kDebugMode) {
        print('error while retrieving user model data: $error');
      }
      return null;
    }
  }
}
