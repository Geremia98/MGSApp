import 'package:mgs_app2/screens/login_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/screens/login_screens/registration_screen2.dart';
import 'package:mgs_app2/utilities/app_config.dart';

import '../../widgets/appbar.dart';
import '../../widgets/font.dart';

class OptionalRegistrationScreen2 extends StatelessWidget {
  final RegistrationController controller;

  const OptionalRegistrationScreen2({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final AppConfig appConfig = AppConfig(context);
    return Scaffold(
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
                        radius: width * 0.18,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 221, 109),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Image.asset(
                            'assets/images/sammy-registration1.png',
                            height: 190,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'In questi casi gravi, l\'unica cosa da fare è affidarsi alla Parola di Dio ...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      '\'\' Io non guardo ciò che guarda l\'uomo. L\'uomo guarda l\'apparenza, Dio guarda il cuore ,,',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSizeMedium,
                        fontWeight: FontWeight.w600,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: appConfig.getWidth() * 100,
                    child: Text(
                      '1 Sam 16,7',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: fontSizeSmall,
                        fontWeight: FontWeight.bold,
                        color: appConfig.getTheme().secondaryHeaderColor,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen2(
                              controller: controller,
                            )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appConfig.getTheme().primaryColor,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.05, right: width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Consoliamoci così',
                              style: TextStyle(
                                fontSize: fontSizeBig,
                                color: appConfig
                                    .getTheme()
                                    .scaffoldBackgroundColor,
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 17,
                            color: appConfig.getTheme().scaffoldBackgroundColor,
                          ),
                        ],
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
