import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/registration_screens/registration_screen2.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import '../../widgets/font.dart';

class OptionalRegistrationScreen2 extends StatelessWidget {
  final RegistrationController controller;

  const OptionalRegistrationScreen2({
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
                        height: appConfig.getHeight() * 2.5,
                      ),
                      Center(
                        child: Text(
                          'In questi casi gravi, l\'unica cosa da fare è affidarsi alla Parola di Dio...',
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
                            '\'\'Io non guardo ciò che guarda l\'uomo.\nL\'uomo guarda l\'apparenza,\nDio guarda il cuore,,',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: appConfig.getWidth()*4,
                              fontWeight: FontWeight.w500,
                              color:
                                  appConfig.getTheme().secondaryHeaderColor,
                            ),
                          ),
                          SizedBox(height: 10),
                  SizedBox(
                    width: appConfig.getWidth() * 100,
                    child: Text(
                      '1 Sam 16,7',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: appConfig.getWidth()*3.5,
                        fontWeight: FontWeight.bold,
                        color: appConfig.getTheme().secondaryHeaderColor,
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
