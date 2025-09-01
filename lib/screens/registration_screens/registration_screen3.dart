import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/registration_screens/bank_data_registration_screen.dart';
import 'package:mgs_app2/screens/registration_screens/boss_screen.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/registration_screens/registration_scren4.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/selector_for_personal_screen.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';
import 'package:mgs_app2/widgets/selector.dart';

import '../../utilities/constants_strings.dart';
import '../../widgets/font.dart';
import '../../widgets/title.dart';

class RegistrationScreen3 extends StatefulWidget {
  final RegistrationController controller;

  const RegistrationScreen3({
    required this.controller,
    super.key,
  });

  @override
  State<RegistrationScreen3> createState() => _RegistrationScreen3State();
}

class _RegistrationScreen3State extends State<RegistrationScreen3> {
  late RegistrationController controller;
  late bool _isDisabled;

  TextEditingController textFieldValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isDisabled = true;
    controller = widget.controller;
    isNextStepAvailable();


  }

  void isNextStepAvailable() {
    if (controller.country.isNotEmpty &&
            controller.ispettoria.isNotEmpty &&
            controller.group.isNotEmpty) {
      setState(() {
        _isDisabled = false;
      });
    } else {
      setState(() {
        _isDisabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
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
                          radius: appConfig.getWidth() * 24,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 221, 109),
                          child: Image.asset(
                            'assets/images/sammy-registration1.png',
                            height: 190,
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        'A quale gruppo\n   appartieni?',
                        textAlign: TextAlign.start,
                        style: textStyleTitle(context)
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        '(No, non quello sanguigno)',
                        textAlign: TextAlign.center,
                        style: textStyleSubtitle(context)
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SelectorStyle(
                      isEnable: true,
                      constantDropDownCountryList,
                      controller.country,
                      onValueChange: (String value) =>
                          controller.setCountry(value),
                      title: 'Paese: ',
                    ),
                    SizedBox(height: 20),
                    SelectorStyle(
                      isEnable: true,
                      constantDropDownIspettoriaList,
                      controller.ispettoria,
                      onValueChange: (String value) =>
                          {controller.setIspettoria(value)},
                      title: 'Ispettoria: ',
                    ),
                    SizedBox(height: 20),
                    SelectorStyle(
                      isEnable: true,
                      constantDropDownGroupList,
                      controller.group,
                      onValueChange: (String value) =>
                          controller.setGroup(value),
                      title: 'Gruppo: ',
                    ),
                    /*SizedBox(height: 20),
                    MyCustomSegmentedButton(
                      isEnabled: true,
                      leftText: 'Si',
                      rightText: 'No',
                      leftValue: true,
                      rightValue: false,
                      selected: _selectedBoss,
                      onValueChange: (value) {
                        setState(() {
                          _selectedBoss = {value as bool};
                          isNextStepAvailable();
                        });
                      },
                      //title: 'Boss? ',
                    ),
                    controller.bossCode.isNotEmpty ||
                            _selectedBoss.first == true
                        ? buildMyTextFormField(
                            obscureText: true,
                            appConfig,
                            onChanged: (value) {
                              controller.setBossCode(value);
                              isNextStepAvailable();
                            },
                            textCapitalization: TextCapitalization.sentences,
                            hintText: 'XXXXXX',
                            labelText: 'Codice del Boss: ',
                            initialValue: controller.bossCode,
                            enabled: true,
                          )
                        : const SizedBox(),*/
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
                      isEnable: !_isDisabled,
                      onTap: () {
                       /* if (_selectedBoss.first == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BankDataRegistrationScreen(
                                      controller: controller,
                                    )),
                          );
                          return;
                        }*/

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BossRegistrationScreen(
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
