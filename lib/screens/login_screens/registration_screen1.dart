import 'package:mgs_app2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/optional_registration_screen1.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/screens/login_screens/registration_screen2.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/widgets/font.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';

class RegistrationScreen1 extends StatefulWidget {
  final RegistrationController controller;

  const RegistrationScreen1({required this.controller, super.key});

  @override
  State<RegistrationScreen1> createState() => _RegistrationScreen1State();
}

class _RegistrationScreen1State extends State<RegistrationScreen1> {
  late RegistrationController controller;

  int _feelAge = 0;
  late bool _isDisabled;
  late Set<UserGender> _selected;

  TextEditingController textFieldValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller;

    _selected = {controller.gender};

    _isDisabled = true;
  }

  void calculateWetherEnablingTheButton() {
    if (controller.name.isNotEmpty &&
        controller.surname.isNotEmpty &&
        (_feelAge > 0) &&
        controller.birthDate != null) {
      setState(() {
        _isDisabled = false;
      });
    } else {
      setState(() {
        _isDisabled = true;
      });
    }
    print('Sono entrato nel calcolo');
    print('Valore del parametro _isDisabled: ' + _isDisabled.toString());
  }

  bool isEternoGiovane() {
    return DateTime.now().year - controller.birthDate!.year - 2 > _feelAge;
  }

  void updateSexSelection(Set<UserGender> newSelection) {
    setState(() {
      _selected = newSelection;
      newSelection.first == UserGender.male;
    });

    controller.setGender(newSelection.first);
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
                            'Prima dicci\n   un po\' di te...',
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
                            '(Le tue informazioni sensibili andranno vendute al miglior offerente)',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: appConfig.getWidth() * 4,
                              fontWeight: FontWeight.w500,
                              color: appConfig.getTheme().secondaryHeaderColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    buildMyTextFormField(
                      appConfig,
                      initialValue: controller.name,
                      hintText: 'Nome',
                      onChanged: (value) {
                        controller.setName(value);
                        calculateWetherEnablingTheButton();
                      },
                    ),
                    buildMyTextFormField(
                      appConfig,
                      initialValue: controller.surname,
                      hintText: 'Cognome',
                      onChanged: (value) {
                        controller.setSurname(value);
                        calculateWetherEnablingTheButton();
                      },
                    ),
                    SizedBox(height: 10),
                    MySegmentedButton(
                        leftString: 'Maschio',
                        rightString: 'Femmina',
                        selected: _selected,
                        onValueChange: updateSexSelection,
                        title: 'Sesso: ',
                        leftValue: UserGender.male,
                        rightValue: UserGender.female,
                        isEnable: true),
                    MyDatePicker(
                      title: 'Nato il: ',
                      birthday: controller.birthDate,
                      isEnable: true,
                      onPressed: () async {
                        final DateTime? dateNascita = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2014),
                        );
                        if (dateNascita != null) {
                          setState(() {
                            controller.setBirthday(dateNascita);
                            calculateWetherEnablingTheButton();
                          });
                        }
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          '(Ma nel cuore so di avere',
                          style: TextStyle(
                            fontSize: fontSizeBig,
                            color: appConfig.getTheme().secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: buildMyTextFormField(
                            appConfig,
                            hintText: 'XX',
                            textPadding: 10,
                            maxLength: 11,
                            onChanged: (value) {
                              _feelAge =
                                  value!.isNotEmpty ? int.parse(value) : 0;
                              calculateWetherEnablingTheButton();
                            },
                          ),
                        ),
                        Text(
                          'anni)',
                          style: TextStyle(
                            fontSize: fontSizeBig,
                            color: appConfig.getTheme().secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
                      isEnable: !_isDisabled,
                      onTap: () {
                        isEternoGiovane()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OptionalRegistrationScreen1(
                                          controller: controller,
                                        )),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen2(
                                          controller: controller,
                                        )),
                              );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
