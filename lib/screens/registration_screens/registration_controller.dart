import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/services/picker.dart';
import 'package:mgs_app2/widgets/snackbar.dart';

import '../../wrapper.dart';

class RegistrationController {

  String name = '';
  String surname = '';
  UserGender gender = UserGender.male;
  DateTime? birthDate;
  ImageModel? profilePic;

  String country = 'IT';
  String ispettoria = 'Triveneto';
  String group = 'Sesto';
  String bossCode = '';

  String email = '';
  String password = '';
  String confirmPassword = '';

  void setName(String? name) {
    this.name = name ?? '';
  }

  void setSurname(String? surname) {
    this.surname = surname ?? '';
  }

  void setGender(UserGender gender) {
    this.gender = gender;
  }

  void setBirthday(DateTime? date) {
    birthDate = date;
  }

  void setProfilePicture(ImageModel? image) {
    profilePic = image;
  }

  void setBossCode(String? bossCode) {
    this.bossCode = bossCode ?? '';
  }

  void setIspettoria(String? ispettoria) {
    this.ispettoria = ispettoria ?? '';
  }

  void setGroup(String? group) {
    this.group = group ?? '';
  }

  void setCountry(String? country) {
    this.country = country ?? '';
  }

  String? setEmail(String? email) {

    if (email == null || !isEmailStringValid(email)) {
      //TODO change error messages
      return 'Email is not valid';
    }

    this.email = email.trim();
    return null;
  }

  bool isEmailStringValid(String email) {
    if (email.isEmpty) {
      return false;
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      return false;
    }


    return true;
  }

  String? setPassword(String? pass) {

    password = pass ?? '';

    if (password.isEmpty) {
      print("non valida");

      return 'Password is not valid';
    }

    return null;
  }

  String? setConfirmPassword(String? pass){

    confirmPassword = pass ?? '';


    if (confirmPassword.isEmpty) {
      return 'Password is not valid';
    }

    if (password != confirmPassword) {
      return 'Password doens\'t match';

    }

    return null;
  }

  Future<void> register(GlobalKey<FormState> formKey, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final FirebaseAuthService authService = FirebaseAuthService();


    print('name: $name, surname: $surname, birth: $birthDate, gender: $gender');
    print('email: $email, password: $password');


    final dynamic result = await authService.registerWithEmailAndPassword(email, password);

    if (result is String) {
      _onSignInFail(context, result, scaffoldKey);
      return;
    }

    final UserFirestore userFirestore = UserFirestore();
    final ImagePickerService pickerService = ImagePickerService();

    UserModel.uid = (result as User).uid;
    UserModel.gender = UserGender.male;
    UserModel.email = email;
    UserModel.name = name;
    UserModel.surname = surname;
    UserModel.birth = birthDate;
    UserModel.profilePic = await pickerService.storeImage(profilePic);
    UserModel.group = group;
    UserModel.ispettoria = ispettoria;
    UserModel.country = country;
    UserModel.bossCode = bossCode;
    
    

    bool firestoreResult = await userFirestore.registerUser();


    if (!firestoreResult) {
      _onSignInFail(context, "Errore durante la registrazione", scaffoldKey);
      return;

    }

    _navigateToWrapper(context);

  }

  Future<void> signIn(GlobalKey<FormState> formKey, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {

    if (!formKey.currentState!.validate()) {
      return;
    }

    print(email);

    final FirebaseAuthService authService = FirebaseAuthService();


    final dynamic result =
    await authService.signInWithEmailAndPassword(email, password);

    if (result is User) {
      _navigateToWrapper(context);
      return;
    }

    if (result is String) {
      _onSignInFail(context, result, scaffoldKey);
      return;
    }

    _onSignInFail(context, '', scaffoldKey);
  }

  void _onSignInFail(BuildContext context, String error, GlobalKey<ScaffoldState> scaffoldKey) {

    final SnackBarStyle snackBar = SnackBarStyle(context, scaffoldKey);

    snackBar.showSnackBar(error);
  }

  void _navigateToWrapper(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Wrapper()),
    );
  }

}