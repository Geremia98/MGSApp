import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/snackbar.dart';
import 'package:mgs_app2/widgets/text_field.dart';

import '../../widgets/back_button_app_bar.dart';
import '../../widgets/font.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String pass = '';

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
                      'Reimposta password',
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
                      'Inserisci la tua nuova password. E\' possibile, per motivi di sicurezza, venga richiesto di rieffettuare il login prima di poterla modificare ',
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
                      hintText: 'Password',
                      onChanged: onPassChange,
                      validator: onPassChange,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ButtonText(
                    text: 'Modifica',
                    onTap: changePassword,
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

  Future<void> changePassword() async {

    if (!formKey.currentState!.validate()) {
      return;
    }

    FirebaseAuthService authService = FirebaseAuthService();

    setState(() {
      isLoading = true;
    });

    final SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);

    final String? result = await authService.resetPassword(pass);

    setState(() {
      isLoading = false;
    });

    if (result is String) {

      snackBarStyle.showSnackBar(result);
      Navigator.of(context).pop();

      return;
    }

    Navigator.of(context).pop();

  }

  String? onPassChange(String? pass) {
    if (pass == null || pass.length < 6) {
      return 'Password non valida (minimo 6 caratteri)';
    }

    this.pass = pass;
    return null;
  }

}
