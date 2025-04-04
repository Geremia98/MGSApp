import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/screens/login_screens/registration_screen1.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/font.dart';
import 'package:mgs_app2/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistrationController controller = RegistrationController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
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
                          radius: width * 0.2,
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
                            height: height * 0.01,
                          ),
                          Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: fontSizeTitle,
                                fontWeight: FontWeight.bold,
                                color: appConfig.getTheme().primaryColor,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Accedi al tuo account',
                              style: TextStyle(
                                  fontSize: fontSizeBig,
                                  fontWeight: FontWeight.w500,
                                  color: appConfig
                                      .getTheme()
                                      .secondaryHeaderColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
                      SizedBox(height: 20),
                      FilledButton(
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
                            : () => controller.signIn(
                                formKey, context, scaffoldKey),
                        child: _isLoading
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.all(height * 0.01),
                                  child: CircularProgressIndicator(
                                    color: appConfig
                                        .getTheme()
                                        .secondaryHeaderColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Entra',
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
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.025),
                        child: Center(
                            child: Text(
                          'o continua con',
                          style: TextStyle(
                            fontSize: fontSizeMedium,
                            fontWeight: FontWeight.w400,
                            color: appConfig.getTheme().secondaryHeaderColor,
                          ),
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  debugPrint(
                                      'Premuto il pulsante GoogleSignIn');
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: ThemeData().hoverColor,
                                  padding: const EdgeInsets.all(10),
                                  fixedSize: const Size.fromHeight(55),
                                ),
                                child: Image.asset('assets/images/google.png'),
                              ),
                            ),
                            SizedBox(width: width * 0.2),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  debugPrint('Premuto il pulsante AppleSignIn');
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: ThemeData().hoverColor,
                                  padding: EdgeInsets.all(10),
                                  fixedSize: Size.fromHeight(55),
                                ),
                                child: Image.asset(
                                  'assets/images/apple.png',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.035,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Non hai ancora un account?',
                            style: TextStyle(
                              fontSize: fontSizeBig,
                              color: appConfig.getTheme().secondaryHeaderColor,
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
                            child: Text(
                              'Registrati',
                              style: TextStyle(
                                fontSize: fontSizeBig,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                color: appConfig.getTheme().primaryColor,
                                decorationColor:
                                    appConfig.getTheme().primaryColor,
                              ),
                            ),
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
