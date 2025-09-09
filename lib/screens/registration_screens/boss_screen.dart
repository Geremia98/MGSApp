import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/registration_screens/registration_screen4.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/snackbar.dart';

import '../../utilities/constants_dimensions.dart';
import '../../widgets/back_button_app_bar.dart';
import '../../widgets/font.dart';
import '../../widgets/personal_page_widgets/my_squared_icon_button.dart';
import '../../widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import '../../widgets/registration_screens_widgets/my_segmented_button.dart';
import '../../widgets/selector.dart';
import '../../widgets/text_field.dart';
import '../../widgets/title.dart';
import 'bank_data_registration_screen.dart';

class BossRegistrationScreen extends StatefulWidget {
  final RegistrationController controller;
  final FirebaseFunctionCaller? functionCaller;

  const BossRegistrationScreen({
    required this.controller,
    this.functionCaller,
    super.key,
  });

  @override
  State<BossRegistrationScreen> createState() => _BossRegistrationScreenState();
}

class _BossRegistrationScreenState extends State<BossRegistrationScreen> {
  late RegistrationController controller;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isEnabled = true;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

    isEnabled = controller.bossCode.isEmpty;
  }

  bool get canProceed {
    // Can proceed if:
    // 1. Not claiming to be boss (isBoss = false), OR
    // 2. Claiming to be boss AND has provided boss code
    return !controller.isBoss || (controller.isBoss && controller.bossCode.isNotEmpty);
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
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
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
                    Center(
                      child: CircleAvatar(
                          radius: appConfig.getWidth() *
                              (appConfig.isTablet() ? 15 : 22),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 221, 109),
                          child: Image.asset(
                            'assets/images/sammy-registration1.png',
                            height: 190,
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
                              'Sei tu il boss?',
                              textAlign: TextAlign.start,
                              style: textStyleTitle(context),
                            ),
                          ),
                          SizedBox(
                            height: appConfig.isTablet() ? 30 : 20,
                          ),
                          Center(
                            child: Text(
                              'Se hai ricevuto o richiesto un codice per diventare il boss inseriscilo qui sotto.',
                              textAlign: TextAlign.center,
                              style: textStyleSubtitle(context),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: appConfig.isTablet() ? 50 : 30,
                          ),
                          Center(
                            child: MyCustomSegmentedButton<bool>(
                              leftText: 'No',
                              rightText: 'Sì',
                              height: appConfig.isTablet() ?  55 : heightTextFormFieldWithoutError,
                              width: appConfig.isTablet() ? 350 : 200,
                              selected: controller.isBoss,
                              onValueChange: (isBoss) {
                                setState(() {
                                  controller.isBoss = isBoss;
                                  // Clear boss code when switching to "No"
                                  if (!isBoss) {
                                    controller.bossCode = '';
                                  }
                                });
                              },
                              //title: 'Sesso',
                              leftValue: false,
                              rightValue: true,
                              isEnabled: isEnabled,
                            ),
                          ),
                          SizedBox(
                            height: appConfig.isTablet() ? 80 : 20,
                          ),

                          if (controller.isBoss)
                            CodeInputField(
                              length: 6,
                              hasTitle: false,
                              initialValue: controller.bossCode,
                              onCompleted: (String p1) async {
                                print(p1);

                                setState(() {
                                  isEnabled = false;
                                });

                          FirebaseFunctionCaller caller =
                              widget.functionCaller ?? FirebaseFunctionCaller();

                          FunctionResponse response =
                              await caller.isBossCodeValid(p1);

                          print("qua");

                          if (response.getType() == ResponseType.error) {
                            final SnackBarStyle snackBar = SnackBarStyle(
                              context,
                              scaffoldKey,
                            );

                                  snackBar
                                      .showSnackBar(response.getErrorMessage());
                                  setState(() {
                                    isEnabled = true;
                                  });
                                  return;
                                }

                                controller.bossCode = p1;
                                // Trigger rebuild to update button state
                                setState(() {});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BankDataRegistrationScreen(
                                            controller: controller,
                                          )),
                                );
                              },
                              isEnabled: isEnabled,
                            ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: MySquaredIconButton(
                      activeColor: appConfig.getTheme().primaryColor,
                      disabledColor: appConfig.getTheme().disabledColor,
                      icon: Icons.arrow_forward_rounded,
                      isEnable: canProceed,
                      onTap: () {
                        // Only proceed if button should be enabled
                        if (!canProceed) return;
                        
                        if (controller.isBoss &&
                            controller.bossCode.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BankDataRegistrationScreen(
                                      controller: controller,
                                    )),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen4(
                                    controller: controller,
                                  )),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
