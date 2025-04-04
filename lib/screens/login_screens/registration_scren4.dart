import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';

import '../../widgets/appbar.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(
        context,
        hasLeading: true,
      ),
      body: SafeArea(
        child: Container(
          height: appConfig.getHeight() * 100,
          padding: EdgeInsets.only(right: width * 0.1, left: width * 0.1),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                        radius: width * 0.2,
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
                        fontSize: fontSizeMedium,
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
                        buildTextField(
                          appConfig,
                          hintText: "Email",
                          initialValue: controller.email,
                          validator: (value) => controller.setEmail(value),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildTextField(
                          appConfig,
                          hintText: "Password",
                          initialValue: controller.password,
                          obscureText: true,
                          validator: (value) => controller.setPassword(value),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildTextField(
                          appConfig,
                          hintText: "Conferma password",
                          initialValue: controller.confirmPassword,
                          obscureText: true,
                          validator: (value) =>
                              controller.setConfirmPassword(value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: SizedBox(
                  width: appConfig.getWidth() * 80,
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        appConfig.getTheme().primaryColor,
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () =>
                            controller.register(formKey, context, scaffoldKey),
                    child: _isLoading
                        ? Center(
                            child: Container(
                              margin: EdgeInsets.all(height * 0.01),
                              child: CircularProgressIndicator(
                                color:
                                    appConfig.getTheme().secondaryHeaderColor,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Registrati',
                              style: TextStyle(
                                fontSize: fontSizeButton,
                                fontWeight: FontWeight.w700,
                                color: appConfig
                                    .getTheme()
                                    .scaffoldBackgroundColor,
                              ),
                            ),
                          ),
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
