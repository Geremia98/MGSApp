//boss si/no

//Se è boss mettere un positioned,
//come un pallino o una piccola label sulla foto profilo

import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/login_screens/registration_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/selector_for_personal_screen.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/utilities/utils.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  PersonalScreenState createState() => PersonalScreenState();
}

class PersonalScreenState extends State<PersonalScreen> {
  RegistrationController controller = RegistrationController();
  late bool _isDisabled;
  late Set<UserGender> _selected;

  @override
  void initState() {
    controller.setName(UserModel.name);
    controller.setSurname(UserModel.surname);
    controller.setGender(UserModel.gender);
    controller.setBirthday(UserModel.birth);

    controller.setCountry(UserModel.country);
    controller.setIspettoria(UserModel.ispettoria);
    controller.setGroup(UserModel.group);

    _selected = {controller.gender};
    _isDisabled = true;
    super.initState();
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
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: appConfig.getWidth() * 5,
          vertical: appConfig.getHeight() * 7,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: appConfig.getHeight() * 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GoBackButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      appConfig: appConfig),
                  MyProfilePicture(
                      appConfig: appConfig,
                      profileImage: 'assets/images/male.jpg',
                      borderRadius: personalePageProfilePicBorderRadius,
                      borderThickness: personaPageProfilePicBorderThickness,
                      dimension: personalPageProfilePicDimension),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: appConfig.getHeight() * 0.8),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(appConfig.getWidth() * 1.5),
                        decoration: BoxDecoration(
                            color: appConfig.getTheme().primaryColor,
                            borderRadius: BorderRadius.circular(
                                appConfig.getWidth() * 2), // Bordi arrotondati
                            border: Border.all(
                                color: appConfig
                                    .getTheme()
                                    .scaffoldBackgroundColor)),
                        child: Icon(
                          size: appConfig.getWidth() * 6.5,
                          Icons.edit_rounded,
                          color: appConfig
                              .getTheme()
                              .scaffoldBackgroundColor, // Dimensione dell'icona
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    appConfig.getWidth() * paddingForCreationEventHorizontal,
              ),
              child: buildMyTextFormField(
                appConfig,
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Inserisci il nome',
                labelText: 'Nome: ',
                maxLength: 30,
                initialValue: UserModel.name,
                enabled: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    appConfig.getWidth() * paddingForCreationEventHorizontal,
              ),
              child: buildMyTextFormField(
                appConfig,
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Inserisci il cognome',
                labelText: 'Cognome: ',
                maxLength: 30,
                initialValue: UserModel.surname,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    appConfig.getWidth() * paddingForCreationEventHorizontal,
              ),
              child: buildMyTextFormField(
                appConfig,
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Inserisci il numero di telefono',
                labelText: 'Cellulare: ',
                maxLength: 30,
                initialValue: '3881113429',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: appConfig.getHeight() * 0.5,
                horizontal:
                    appConfig.getWidth() * paddingForCreationEventHorizontal,
              ),
              child: Row(
                children: [
                  Text(
                    'Sesso:  ',
                    style: TextStyle(
                      color: appConfig.getTheme().secondaryHeaderColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  SegmentedButton<UserGender>(
                    segments: const <ButtonSegment<UserGender>>[
                      ButtonSegment(
                        value: UserGender.male,
                        label: Text('Maschio'),
                      ),
                      ButtonSegment(
                          value: UserGender.female, label: Text('Femmina'))
                    ],
                    selected: _selected,
                    onSelectionChanged: updateSexSelection,
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: ThemeData().hoverColor)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return appConfig.getTheme().primaryColor;
                          }
                          return Colors.grey.withOpacity(0.2);
                        },
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                          (Set<MaterialState> states) {
                        return TextStyle(
                          fontWeight: FontWeight.w600,
                          color: appConfig.getTheme().scaffoldBackgroundColor,
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: appConfig.getHeight() * 0.5,
                horizontal:
                    appConfig.getWidth() * paddingForCreationEventHorizontal,
              ),
              child: Row(
                children: [
                  Text(
                    'Nato il:  ',
                    style: TextStyle(
                      color: appConfig.getTheme().secondaryHeaderColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    formatDateFromDateTime(controller.birthDate),
                    style: TextStyle(
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
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                              appConfig.getWidth() * 5), // Bordi arrotondati
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
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: appConfig.getHeight() * 1.5),
              child: Divider(
                indent: appConfig.getWidth() * 15,
                endIndent: appConfig.getWidth() * 15,
                height: appConfig.getHeight() * 2,
                color: appConfig.getTheme().primaryColor,
                thickness: personaPageProfilePicBorderThickness,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      appConfig.getWidth() * paddingForCreationEventHorizontal,
                ),
                child: SelectorForPersonalScreen(
                    constantDropDownCountryList, controller.country,
                    onValueChange: (String value) =>
                        controller.setCountry(value),
                    title: 'Paese: ')),
            SizedBox(height: 15),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      appConfig.getWidth() * paddingForCreationEventHorizontal,
                ),
                child: SelectorForPersonalScreen(
                    constantDropDownIspettoriaList, controller.ispettoria,
                    onValueChange: (String value) =>
                        controller.setIspettoria(value),
                    title: 'Ispettoria: ')),
            SizedBox(height: 15),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      appConfig.getWidth() * paddingForCreationEventHorizontal,
                ),
                child: SelectorForPersonalScreen(
                    constantDropDownGroupList, controller.group,
                    onValueChange: (String value) => controller.setGroup(value),
                    title: 'Gruppo: ')),
          ],
        ),
      ),
    );
  }
}
