import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/snackbar.dart';
import 'package:mgs_app2/widgets/text_field.dart';

import '../../utilities/constants_dimensions.dart';
import '../../widgets/back_button_app_bar.dart';
import '../../widgets/buttons.dart';
import '../../widgets/font.dart';

class ChangePasswordScreen extends StatefulWidget {
  final FirebaseAuthService? authService;

  const ChangePasswordScreen({super.key, this.authService});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String pass = '';

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: appConfig.getWidth() * horizontalPadding,
          vertical: appConfig.getHeight() * verticalPadding,
        ),
        child: SizedBox(
          height: appConfig.getHeight() * 100,
          width: appConfig.getWidth() * 100,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GoBackButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  appConfig: appConfig,
                  title: 'Modifica password',
                ),
                SizedBox(
                  height: appConfig.getHeight() * 5,
                ),
                Center(
                  child: Text(
                    'Inserisci la tua nuova password. È possibile che, per motivi di sicurezza, venga richiesto di rieffettuare il login prima di poterla modificare.',
                    textAlign: TextAlign.center,
                    style: textStyleTitle(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: appConfig.getHeight() * 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          appConfig.isTablet() ? appConfig.getWidth() * 10 : 0),
                  child: buildTextField(
                    appConfig,
                    hintText: 'Password',
                    onChanged: onPassChange,
                    validator: onPassChange,
                  ),
                ),
                const SizedBox(
                  height: 40,
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
    );
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    FirebaseAuthService authService =
        widget.authService ?? FirebaseAuthService();

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
