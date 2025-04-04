import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/screens/login_screens/registration_scren4.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/selector.dart';
import 'package:mgs_app2/widgets/text_field.dart';
import 'dart:ui' as ui;

import '../../utilities/constants_strings.dart';
import '../../widgets/appbar.dart';
import '../../widgets/font.dart';

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
  late Set<bool> _selected;

  TextEditingController textFieldValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isDisabled = false;
    controller = widget.controller;

    _selected = {controller.bossCode.isNotEmpty};
  }

  void isNextStepAvailable() {
    if (controller.country.isNotEmpty &&
        controller.ispettoria.isNotEmpty &&
        controller.group.isNotEmpty &&
        (_selected.first == false || controller.bossCode.isNotEmpty)) {
      setState(() {
        _isDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                          radius: width * 0.18,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 221, 109),
                          child: Image.asset(
                            'assets/images/sammy-registration1.png',
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '... a quale gruppo\n   appartieni?',
                        textAlign: TextAlign.start,
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
                        '(No, non quello sanguigno)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeMedium,
                          fontWeight: FontWeight.w500,
                          color: appConfig.getTheme().secondaryHeaderColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SelectorStyle(
                      constantDropDownCountryList,
                      controller.country,
                      onValueChange: (String value) =>
                          controller.setCountry(value),
                      title: 'Paese:',
                    ),
                    SizedBox(height: 20),
                    SelectorStyle(
                      constantDropDownIspettoriaList,
                      controller.ispettoria,
                      onValueChange: (String value) =>
                          controller.setIspettoria(value),
                      title: 'Ispettoria:',
                    ),
                    SizedBox(height: 20),
                    SelectorStyle(
                      constantDropDownGroupList,
                      controller.group,
                      onValueChange: (String value) =>
                          controller.setGroup(value),
                      title: 'Gruppo:',
                    ),
                    /*CustomRowRegistration3(
                        height: height,
                        width: width,
                        hint: 'Mare Nostrum',
                        lista: constantDropDownCountryList,
                        titolo: 'Paese: '),
                    CustomRowRegistration3(
                      height: height,
                      width: width,
                      lista: constantDropDownIspettoriaList,
                      hint: 'Golfo di Napoli',
                      titolo: 'Ispettoria: ',
                    ),
                    CustomRowRegistration3(
                      height: height,
                      width: width,
                      lista: constantDropDownGroupList,
                      titolo: 'Gruppo: ',
                      hint: 'Atlantide',
                    ),*/
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Text(
                          'Sei il boss:  ',
                          style: TextStyle(
                            fontSize: fontSizeBig,
                            color: appConfig.getTheme().secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        SegmentedButton<bool>(
                          segments: const <ButtonSegment<bool>>[
                            ButtonSegment(value: true, label: Text('Sì')),
                            ButtonSegment(value: false, label: Text('No'))
                          ],
                          selected: _selected,
                          onSelectionChanged: (value) {
                            setState(() {
                              _selected = value;
                            });
                          },
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: ThemeData().hoverColor)),
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
                    _selected.first == true
                        ? Column(
                            children: [
                              SizedBox(height: 20),
                              buildTextField(
                                appConfig,
                                hintText: 'Codice Boss',
                                onChanged: (value) => {
                                  setState(() {
                                    controller.setBossCode(value);
                                  }),
                                },
                              ),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FilledButton(
                  onPressed: _isDisabled
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen4(
                                controller: controller,
                              ),
                            ),
                          ),
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

class CustomRowRegistration3 extends StatelessWidget {
  const CustomRowRegistration3({
    super.key,
    required this.height,
    required this.width,
    required this.lista,
    required this.titolo,
    required this.hint,
  });

  final double height;
  final double width;
  final List<String> lista;
  final String titolo;
  final String hint;

  @override
  Widget build(BuildContext context) {
    String country;

    return Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.013),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.003),
              child: Text(
                titolo,
                style: TextStyle(fontSize: width * 0.05),
              ),
            ),
            DropdownMenu(
              width: width * 0.65,
              onSelected: (value) {
                if (value != null) {
                  country = value;
                }
              },
              inputDecorationTheme: InputDecorationTheme(
                  isCollapsed: true,
                  constraints:
                      BoxConstraints.tight(Size(width * 0.8, height * 0.05)),
                  contentPadding: EdgeInsets.only(left: width * 0.05)),
              hintText: hint,
              enableSearch: true,
              dropdownMenuEntries: lista.map((location) {
                return DropdownMenuEntry(value: location, label: location);
              }).toList(),
            ),
          ],
        ));
  }
}

Widget backdropFilterExample(BuildContext context, Widget child) {
  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      child,
      BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 8.0,
          sigmaY: 8.0,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      )
    ],
  );
}
