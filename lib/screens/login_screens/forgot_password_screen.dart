import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/services/firebase/exceptions_translator.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/snackbar.dart';
import 'package:mgs_app2/widgets/text_field.dart';

import '../../widgets/back_button_app_bar.dart';
import '../../widgets/font.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String email = '';

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: appConfig.getTheme().scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: appConfig.getWidth() * 5),
          child: SizedBox(
            height: appConfig.getHeight() * 100,
            width: appConfig.getWidth() * 100,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  BackButtonAppBar(
                    iconData: Icons.arrow_back_rounded,
                    appConfig: appConfig,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: appConfig.getHeight() * 5,
                  ),
                  Center(
                    child: Text(
                      'Password dimenticata',
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Inserisci la tua email di registrazione. Verrà inviata una mail per la reimpostazione della password.',
                      style: TextStyle(
                        fontSize: fontSizeSubtitle,
                        fontWeight: FontWeight.w500,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: appConfig.getWidth() * 5),
                    child: buildTextField(
                      appConfig,
                      hintText: 'Email',
                      onChanged: onEmailChange,
                      validator: onEmailChange,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ButtonText(
                    text: 'Invia',
                    onTap: resetPassword,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {

    if (!formKey.currentState!.validate()) {
      return;
    }


    FirebaseAuthService authService = FirebaseAuthService();

    setState(() {
      isLoading = true;
    });

    final SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);

    final dynamic result = await authService.sendPasswordResetEmail(email);

    setState(() {
      isLoading = false;
    });

    if (result is FirebaseAuthException) {
      FirebaseExceptionsTranslator translator = FirebaseExceptionsTranslator();

      translator.getAuthMessage(result);

      snackBarStyle.showSnackBar(translator.getAuthMessage(result));

      return;
    }

    if (result == true) {
      snackBarStyle.showSnackBar('Email per il reset della password inviata!');

      Navigator.of(context).pop();
      return;
    }

    if (result is String) {
      snackBarStyle.showSnackBar(result);
    }
  }

  String? onEmailChange(String? email) {
    if (email == null || !isEmailStringValid(email)) {
      email = '';
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
}
