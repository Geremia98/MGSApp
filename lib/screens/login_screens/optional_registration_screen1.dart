import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/optional_registration_screen2.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/screens/login_screens/registration_screen2.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/appbar.dart';

import '../../widgets/font.dart';

class OptionalRegistrationScreen1 extends StatelessWidget {

  final RegistrationController controller;

  const OptionalRegistrationScreen1(
    {
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
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
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Center(
                        child: Text(
                          '${controller.name}, devi superarla questa\ncosa dell\'età, su...',
                          textAlign: TextAlign.right,
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
                      Column(
                        children: [
                          Center(
                            child: Text(
                              '(Che poi... potrebbe andare peggio: pensa a chi è pelato!)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: fontSizeMedium,
                                fontWeight: FontWeight.w500,
                                color:
                                    appConfig.getTheme().secondaryHeaderColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          FilledButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OptionalRegistrationScreen2(
                                          controller: controller,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  appConfig.getTheme().secondaryHeaderColor,
                              disabledBackgroundColor:
                                  Colors.grey.withOpacity(0.2),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.05, right: width * 0.05),
                              child: Text(
                                'In realtà lo sono...',
                                style: TextStyle(
                                  fontSize: fontSizeBig,
                                  fontWeight: FontWeight.w700,
                                  color: appConfig
                                      .getTheme()
                                      .scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                          Text('Hai ragione',
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
