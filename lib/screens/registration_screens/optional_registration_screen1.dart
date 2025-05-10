import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/registration_screens/optional_registration_screen2.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/registration_screens/registration_screen2.dart';
import 'package:mgs_app2/utilities/app_config.dart';

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

    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: appConfig.getHeight() * 100,
          padding: EdgeInsets.only(right: appConfig.getWidth() * 10, left: appConfig.getWidth() * 10, top: appConfig.getHeight()*5 ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                        radius: appConfig.getWidth() * 22,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 221, 109),
                        child: Image.asset(
                          'assets/images/sammy-registration1.png',
                          height: 190,
                        )),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: appConfig.getHeight() * 4,
                      ),
                      Center(
                        child: Text(
                          '${controller.name},\ndevi superarla questa\ncosa dell\'età, su...',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: appConfig.getWidth()*7,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: appConfig.getTheme().secondaryHeaderColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: [
                          Text(
                            'Che poi potrebbe andare peggio.\nPensa a chi è pelato...',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: appConfig.getWidth()*4,
                              fontWeight: FontWeight.w500,
                              color:
                                  appConfig.getTheme().secondaryHeaderColor,
                            ),
                          ),
                          SizedBox(height: 30),
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
                                  left: appConfig.getWidth() * 5, right: appConfig.getWidth() * 5),
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
                          left: appConfig.getWidth() * 5, right: appConfig.getWidth() * 5),
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
