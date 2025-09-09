import 'package:mgs_app2/screens/login_screens/forgot_password_screen.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/registration_screens/registration_screen1.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/font.dart';
import 'package:mgs_app2/widgets/text_field.dart';
import 'package:mgs_app2/widgets/title.dart'
    hide textStyleSubtitle, textStyleTitle;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool _isLoading;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistrationController controller = RegistrationController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //Auth auth = Auth(firebaseAuth: FirebaseAuth.instance);
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: appConfig.isTablet() ? width * 0.2 : width * 0.1),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height * 0.8,
                  maxHeight: height * 0.85,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      CircleAvatar(
                          radius:
                              appConfig.isTablet() ? width * 0.15 : width * 0.2,
                          backgroundColor:
                              const Color.fromARGB(255, 162, 186, 228),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset(
                              'assets/images/sammy-registration.png',
                              height: 190,
                            ),
                          )),
                      Column(
                        children: [
                          SizedBox(
                            height: appConfig.isTablet() ? 50 : 20,
                          ),
                          Center(
                            child: Text(
                              'LOGIN',
                              style: textStyleTitle(context),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Accedi al tuo account',
                              style: textStyleSubtitle(context),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: appConfig.isTablet() ? 50 : 20,
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
                              validator: (value) =>
                                  controller.setPassword(value),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            )
                          },
                          child: Text(
                            'Password dimenticata?',
                            style: textStyleSubtitle(context).copyWith(
                                color: appConfig.getTheme().primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: appConfig.isTablet() ? 30 : 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonText(
                            fixedWidth: appConfig.isTablet() ? 350 : -1,
                            text: 'Entra',
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await controller.signIn(formKey, context, scaffoldKey);
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Non hai ancora un account?',
                            style: textStyleSubtitle(context).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RegistrationScreen1(
                                    controller: RegistrationController(),
                                  ),
                                ),
                              )
                            },
                            child: Text('Registrati',
                                style: textStyleSubtitle(context).copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  decorationColor:
                                      appConfig.getTheme().secondaryHeaderColor,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
