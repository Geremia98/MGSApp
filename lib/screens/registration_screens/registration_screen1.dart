import 'package:mgs_app2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/registration_screens/optional_registration_screen1.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/registration_screens/registration_screen2.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/widgets/font.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';
import 'package:mgs_app2/widgets/text_field.dart';
import 'package:mgs_app2/widgets/title.dart';

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
                            style: textStyleTitle(context),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            '(Le tue informazioni sensibili andranno vendute al miglior offerente)',
                            textAlign: TextAlign.start,
                            style: textStyleSubtitle(context),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
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
                    SizedBox(
                      height: 20,
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
                    SizedBox(height: 20),
                    MyCustomSegmentedButton<UserGender>(
                      leftText: 'Maschio',
                      rightText: 'Femmina',
                      selected: controller.gender,
                      onValueChange: (UserGender gender) {
                        controller.gender = gender;
                      },
                      //title: 'Sesso',
                      leftValue: UserGender.male,
                      rightValue: UserGender.female,
                      isEnabled: true,
                    ),
                    SizedBox(height: 20),
                    MyDatePicker(
                      title: '',
                      birthday: controller.birthDate,
                      isEnable: true,
                      onPressed: () async {
                        final DateTime? dateNascita = await showDatePicker(
                          context: context,
                          initialDate: controller.birthDate ?? DateTime(2000),
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2014),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogTheme: DialogThemeData(
                                  backgroundColor: appConfig.getTheme().scaffoldBackgroundColor,
                                  titleTextStyle: TextStyle(
                                    color: appConfig.getTheme().secondaryHeaderColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentTextStyle: TextStyle(
                                    color: appConfig.getTheme().secondaryHeaderColor,
                                    fontSize: 16,
                                  ),
                                ),
                                colorScheme: ColorScheme.light(
                                  primary: appConfig.getTheme().highlightColor,
                                  onPrimary: appConfig.getTheme().secondaryHeaderColor,
                                  onSurface: appConfig.getTheme().secondaryHeaderColor,
                                  surface: appConfig.getTheme().scaffoldBackgroundColor,
                                ),
                                inputDecorationTheme: InputDecorationTheme(
                                  labelStyle: TextStyle(color: appConfig.getTheme().secondaryHeaderColor),
                                  hintStyle: TextStyle(color: appConfig.getTheme().secondaryHeaderColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: appConfig.getTheme().secondaryHeaderColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: appConfig.getTheme().secondaryHeaderColor),
                                  ),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: appConfig.getTheme().secondaryHeaderColor,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        // Aggiorna lo stato qui, DOPO la selezione
                        if (dateNascita != null) {
                          setState(() {
                            controller.setBirthday(dateNascita);
                            calculateWetherEnablingTheButton();
                          });
                        }
                      },
                    ),

                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          '(Ma nel cuore so di avere',
                          style: textStyleSubtitle(context),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 50,
                          child: buildMyTextFormField(
                            centerText: true,
                            appConfig,
                            hintText: 'XX',
                            textPadding: 2,
                            maxLength: 3,
                            onChanged: (value) {
                              _feelAge =
                                  value!.isNotEmpty ? int.parse(value) : 0;
                              calculateWetherEnablingTheButton();
                            },
                          ),
                        ),
                        Text(
                          'anni)',
                          style: textStyleSubtitle(context),
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
