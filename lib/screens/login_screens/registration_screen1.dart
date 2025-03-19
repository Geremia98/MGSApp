import 'package:line_icons/line_icons.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/login_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/optional_registration_screen1.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/screens/login_screens/registration_screen2.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/theme_data.dart';
import 'package:mgs_app2/utilities/utils.dart';
import 'package:mgs_app2/widgets/appbar.dart';
import 'package:mgs_app2/widgets/font.dart';

import '../../widgets/text_field.dart';

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
  late bool _isEternoGiovane;
  late Set<UserGender> _selected;

  TextEditingController textFieldValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller;

    _selected = {controller.gender};

    _isDisabled = true;
    _isEternoGiovane = false;
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

    if (controller.birthDate == null) {
      return false;
    }

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      appBar: buildAppBar(
        context,
        hasLeading: true,
        icon: LineIcons.times,
      ),
      body: SafeArea(
        child: Container(
          height: appConfig.getHeight() * 100,
          padding: EdgeInsets.only(right: width * 0.1, left: width * 0.1),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
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
                              fontSize: fontSizeMedium,
                              fontWeight: FontWeight.w500,
                              color: appConfig.getTheme().secondaryHeaderColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    buildTextField(
                      appConfig,
                      initialValue: controller.name,
                      hintText: "Nome",
                      onChanged: (value) {
                        controller.setName(value);
                        calculateWetherEnablingTheButton();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildTextField(
                      appConfig,
                      hintText: "Cognome",
                      initialValue: controller.surname,
                      onChanged: (value) {
                        controller.setSurname(value);
                        calculateWetherEnablingTheButton();
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Sesso:  ',
                          style: TextStyle(
                            fontSize: fontSizeBig,
                            color: appConfig.getTheme().secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        SegmentedButton<UserGender>(
                          segments: const <ButtonSegment<UserGender>>[
                            ButtonSegment(
                                value: UserGender.male, label: Text('Maschio')),
                            ButtonSegment(
                                value: UserGender.female,
                                label: Text('Femmina'))
                          ],
                          selected: _selected,
                          onSelectionChanged: updateSexSelection,
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: MyTheme.getCiSonoButtonColor(
                                    context: context))),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return appConfig.getTheme().primaryColor;
                                }
                                return Colors.grey.withOpacity(0.2);
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return appConfig
                                      .getTheme()
                                      .scaffoldBackgroundColor; // Color when selected
                                }
                                return appConfig
                                    .getTheme()
                                    .secondaryHeaderColor; // Default text color
                              },
                            ),
                            textStyle:
                                MaterialStateProperty.resolveWith<TextStyle>(
                                    (Set<MaterialState> states) {
                              return TextStyle(
                                fontSize: fontSizeBig,
                                fontWeight: FontWeight.w600,
                                color: appConfig
                                    .getTheme()
                                    .scaffoldBackgroundColor,
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Nato il:  ',
                          style: TextStyle(
                            fontSize: fontSizeBig,
                            color: appConfig.getTheme().secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          formatDateFromDateTime(controller.birthDate),
                          style: TextStyle(
                            fontSize: fontSizeBig,
                            color: appConfig.getTheme().secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 18),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? dateNascita = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1960),
                                lastDate: DateTime(2014));
                            if (dateNascita != null) {
                              setState(() {
                                controller.setBirthday(dateNascita);
                                calculateWetherEnablingTheButton();
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                    width * 0.05), // Bordi arrotondati
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                )),
                            child: Icon(
                              Icons.mode_edit_rounded,
                              // Icona simile a quella mostrata
                              size: 16,
                              color: appConfig
                                  .getTheme()
                                  .secondaryHeaderColor, // Dimensione dell'icona
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
                          constraints: BoxConstraints(maxWidth: 30),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            child: TextFormField(
                              controller: textFieldValue,
                              textAlign: TextAlign.center,
                              style: textStyleTextField(appConfig.getContext())
                                  .copyWith(
                                color:
                                    appConfig.getTheme().secondaryHeaderColor,
                                fontWeight: FontWeight.w600,
                                fontSize: fontSizeBig,
                              ),
                              decoration: InputDecoration(
                                hintText: 'XX',
                                hintStyle: TextStyle(
                                  color: appConfig.getTheme().primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: fontSizeBig,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              cursorColor: appConfig.getTheme().primaryColor,
                              onChanged: (value) {
                                _feelAge = value.isNotEmpty
                                    ? int.parse(textFieldValue.text)
                                    : 0;
                                calculateWetherEnablingTheButton();
                              },
                            ),
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
                child: FilledButton(
                  onPressed: _isDisabled
                      ? null
                      : () {
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
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: appConfig.getTheme().scaffoldBackgroundColor,
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
