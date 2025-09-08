import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_big_async_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/widgets/title.dart';

import '../../widgets/font.dart';
import '../../widgets/text_field.dart';

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
                        radius: appConfig.getWidth() *
                            (appConfig.isTablet() ? 15 : 22),
                        backgroundColor:
                            const Color.fromARGB(255, 162, 186, 228),
                        child: Image.asset(
                          'assets/images/sammy-registration.png',
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: appConfig.isTablet()
                            ? appConfig.getWidth() * 10
                            : 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: appConfig.getHeight() * 2.5,
                        ),
                        Center(
                          child: Text(
                            'Ultimo step ...\nemail e password',
                            style: textStyleTitle(context),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          height: appConfig.isTablet() ? 30 : 20,
                        ),
                        Center(
                          child: Text(
                            '(Yep, le tue credenziali)',
                            style: textStyleSubtitle(context),
                          ),
                        ),
                        SizedBox(
                          height: appConfig.isTablet() ? 80 : 50,
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              buildTextField(
                                appConfig,
                                validator: (value) =>
                                    controller.setEmail(value),
                                initialValue: controller.email,
                                hintText: 'Email',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                appConfig,
                                initialValue: controller.password,
                                hintText: 'Password',
                                obscureText: true,
                                validator: (value) =>
                                    controller.setPassword(value),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                appConfig,
                                initialValue: controller.confirmPassword,
                                hintText: 'Conferma password',
                                obscureText: true,
                                validator: (value) =>
                                    controller.setConfirmPassword(value),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: appConfig.getWidth() * 83,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width:
                            appConfig.isTablet() ? 400 : appConfig.getWidth() * 83,
                        height: appConfig.isTablet() ? 60 : 45,
                        child: MyBigAsyncButton(
                          appConfig: appConfig,
                          buttonText: 'Registrati',
                          onPressedAsync: () async {
                            await controller.register(
                                formKey, context, scaffoldKey);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
