import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_big_async_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';

import '../../widgets/font.dart';

class RegistrationScreen4 extends StatefulWidget {
  final RegistrationController controller;

  const RegistrationScreen4({
    required this.controller,
    super.key,
  });

  @override
  State<RegistrationScreen4> createState() => _RegistrationScreen4State();
}

class _RegistrationScreen4State extends State<RegistrationScreen4> {
  late RegistrationController controller;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool diffPassword = false;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          height: appConfig.getHeight() * 100,
          padding: EdgeInsets.only(
              right: appConfig.getWidth() * 8,
              left: appConfig.getWidth() * 8,
              top: appConfig.getHeight() * 0.7),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BackButtonAppBar(
                    iconData: Icons.arrow_back_rounded,
                    appConfig: appConfig,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: appConfig.getHeight() * 3,
                  ),
                  Center(
                    child: CircleAvatar(
                        radius: appConfig.getWidth() * 25,
                        backgroundColor:
                            const Color.fromARGB(255, 162, 186, 228),
                        child: Image.asset(
                          'assets/images/sammy-registration.png',
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Ultimo step ...\nmail e password',
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
                      '(Yep, le tue credenziali)',
                      style: TextStyle(
                        fontSize: appConfig.getWidth() * 4,
                        fontWeight: FontWeight.w500,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildMyTextFormField(appConfig,
                            validator: (value) => controller.setEmail(value),
                            initialValue: controller.email,
                            hintText: 'Email',
                            helperText: true),
                        buildMyTextFormField(
                          appConfig,
                          initialValue: controller.password,
                          hintText: 'Password',
                          obscureText: true,
                          helperText: true,
                          validator: (value) => controller.setPassword(value),
                        ),
                        buildMyTextFormField(appConfig,
                            initialValue: controller.confirmPassword,
                            hintText: 'Conferma password',
                            obscureText: true,
                            validator: (value) =>
                                controller.setConfirmPassword(value),
                            helperText: true),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: SizedBox(
                    width: appConfig.getWidth() * 83,
                    child: MyBigAsyncButton(
                        appConfig: appConfig,
                        buttonText: 'Registrati',
                        onPressedAsync: () async {
                          await controller.register(formKey, context, scaffoldKey);
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
