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

class ChangeEmailScreen extends StatefulWidget {
  final FirebaseAuthService? authService;

  const ChangeEmailScreen({super.key, this.authService});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String email = '';

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
                  title: 'Modifica email',
                ),
                SizedBox(
                  height: appConfig.getHeight() * 5,
                ),
                Center(
                  child: Text(
                      'Inserisci la tua nuova email. Verrà inviata una mail di conferma per completare la richiesta.',
                      textAlign: TextAlign.center,
                      style: textStyleTitle(context).copyWith(fontWeight: FontWeight.w600,)),
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
                    hintText: 'Email',
                    onChanged: onEmailChange,
                    validator: onEmailChange,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ButtonText(
                  text: 'Modifica',
                  onTap: changeEmail,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeEmail() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    FirebaseAuthService authService =
        widget.authService ?? FirebaseAuthService();

    setState(() {
      isLoading = true;
    });

    final SnackBarStyle snackBarStyle = SnackBarStyle(context, scaffoldKey);

    final String? result = await authService.resetEmail(email);

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
