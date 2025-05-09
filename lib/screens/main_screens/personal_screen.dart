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
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  PersonalScreenState createState() => PersonalScreenState();
}

class PersonalScreenState extends State<PersonalScreen> {
  RegistrationController controller = RegistrationController();
  late bool _isModifyOptionEnable;
  late Set<bool> _selectedBoss;
  late Set<UserGender> _selectedUserGender;

  @override
  void initState() {
    controller.setName(UserModel.name);
    controller.setSurname(UserModel.surname);
    controller.setGender(UserModel.gender);
    controller.setBirthday(UserModel.birth);

    controller.setCountry(UserModel.country);
    controller.setIspettoria(UserModel.ispettoria);
    controller.setGroup(UserModel.group);

    _selectedBoss = {controller.bossCode.isNotEmpty};
    _selectedUserGender = {controller.gender};
    _isModifyOptionEnable = false;
    print(controller.birthDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: appConfig.getWidth() * 5,
          vertical: appConfig.getHeight() * 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      onTap: () {
                        setState(() {
                          _isModifyOptionEnable = true;
                        });
                      },
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
                    appConfig.getWidth() * paddingForPersonalPageLables,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildMyTextFormField(
              appConfig,
              textCapitalization: TextCapitalization.sentences,
              hintText: 'Inserisci il nome',
              labelText: 'Nome: ',
              maxLength: 30,
              initialValue: UserModel.name,
              enabled: _isModifyOptionEnable,
            ),
            buildMyTextFormField(
              appConfig,
              textCapitalization: TextCapitalization.sentences,
              hintText: 'Inserisci il cognome',
              labelText: 'Cognome: ',
              maxLength: 30,
              initialValue: UserModel.surname,
              enabled: _isModifyOptionEnable,
            ),
            buildMyTextFormField(
              appConfig,
              textCapitalization: TextCapitalization.sentences,
              hintText: 'Inserisci il numero di telefono',
              labelText: 'Cellulare: ',
              maxLength: 30,
              initialValue: '3881113429',
              enabled: _isModifyOptionEnable,
            ),
            MySegmentedButton(
                leftString: 'Maschio',
                rightString: 'Femmina',
                selected: _selectedUserGender,
                onValueChange: (value) {
                  setState(() {
                    _selectedUserGender = value;
                  });
                  print(_selectedUserGender.toString());
                },
                title: 'Sesso: ',
                leftValue: UserGender.male,
                rightValue: UserGender.female,
                isEnable: _isModifyOptionEnable
            ),
            SizedBox(height: appConfig.getHeight()*0.5,),
            MyDatePicker(
              title: 'Data di nascita: ',
              birthday: controller.birthDate,
              isEnable: _isModifyOptionEnable,
              onPressed: () async {
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
            ),
            Divider(
              indent: appConfig.getWidth() * 15,
              endIndent: appConfig.getWidth() * 15,
              height: appConfig.getHeight() * 2,
              color: appConfig.getTheme().primaryColor,
              thickness: personaPageProfilePicBorderThickness,
            ),
            SelectorForPersonalScreen(
                isEnable: _isModifyOptionEnable,
                constantDropDownCountryList,
                controller.country,
                onValueChange: (String value) =>
                    controller.setCountry(value),
                title: 'Paese: '
            ),
            SelectorForPersonalScreen(
                isEnable: _isModifyOptionEnable,
                constantDropDownIspettoriaList,
                controller.ispettoria,
                onValueChange: (String value) =>
                    {controller.setIspettoria(value)},
                title: 'Ispettoria: '
            ),
            SelectorForPersonalScreen(
                isEnable: _isModifyOptionEnable,
                constantDropDownGroupList,
                controller.group,
                onValueChange: (String value) => controller.setGroup(value),
                title: 'Gruppo: '
            ),
            MySegmentedButton(
                isEnable: _isModifyOptionEnable,
                leftString: 'Si',
                rightString: 'No',
                leftValue: true,
                rightValue: false,
                selected: _selectedBoss,
                onValueChange: (value) {
                  setState(() {
                    _selectedBoss = value;
                  });
                  print(_selectedBoss.toString());
                },
                title: 'Boss? '
            ),
            buildMyTextFormField(
              appConfig,
              textCapitalization: TextCapitalization.sentences,
              hintText: 'XXXXXXXXXX',
              labelText: 'Codice dei Boss ',
              maxLength: 30,
              initialValue: '',
              enabled: _isModifyOptionEnable,
            ),
              
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
