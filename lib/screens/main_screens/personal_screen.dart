import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_big_async_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';
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
    controller.setBossCode(UserModel.bossCode);

    _selectedBoss = {UserModel.bossCode.isNotEmpty};
    _selectedUserGender = {UserModel.gender};
    _isModifyOptionEnable = false;
    super.initState();
    print('Init state chiamato');
  }

  void updateUserInfo() {
    UserModel.name = controller.name;
    UserModel.surname = controller.surname;
    UserModel.gender = _selectedUserGender.first;
    UserModel.birth = controller.birthDate;
    UserModel.country = controller.country;
    UserModel.ispettoria = controller.ispettoria;
    UserModel.group = controller.group;
    UserModel.bossCode = controller.bossCode;
  }

  void ricostruisciWidgetConValoriIniziali(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const PersonalScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: appConfig.getWidth() * horizontalPadding,
          vertical: appConfig.getHeight() * verticalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: appConfig.getHeight() * paddingUnderTheMainUppperBar),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GoBackButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        appConfig: appConfig,
                      ),
                      MySquaredIconButton(
                        activeColor: appConfig.getTheme().primaryColor,
                        disabledColor: appConfig.getTheme().splashColor,
                        icon: Icons.edit_rounded,
                        isEnable: !_isModifyOptionEnable,
                        onTap: () {
                          setState(() {
                            _isModifyOptionEnable = !_isModifyOptionEnable;
                          });
                        },
                      ),
                    ],
                  ),
                  MyProfilePicture(
                    appConfig: appConfig,
                    profileImage: 'assets/images/male.jpg',
                    borderRadius: personalePageProfilePicBorderRadius,
                    borderThickness: personaPageProfilePicBorderThickness,
                    dimension: personalPageProfilePicDimension,
                  ),
                  Column(
                    children: [
                      MySquaredIconButton(
                        activeColor: Theme.of(context)
                            .extension<CustomColors>()!
                            .enabledCheckSquaredButton,
                        disabledColor: Theme.of(context)
                            .extension<CustomColors>()!
                            .disabledCheckSquaredButton,
                        icon: Icons.check_rounded,
                        isEnable: _isModifyOptionEnable,
                        onTap: () {
                          setState(() {
                            updateUserInfo();
                            _isModifyOptionEnable = !_isModifyOptionEnable;
                          });
                        },
                      ),
                      MySquaredIconButton(
                        activeColor: Theme.of(context)
                            .extension<CustomColors>()!
                            .enabledUndoSquaredButton,
                        disabledColor: Theme.of(context)
                            .extension<CustomColors>()!
                            .disabledUndoSquaredButton,
                        icon: Icons.close_rounded,
                        isEnable: _isModifyOptionEnable,
                        onTap: () {
                          ricostruisciWidgetConValoriIniziali(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appConfig.getWidth() * additionalPaddingForTheForm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  buildMyTextFormField(
                    appConfig,
                    textCapitalization: TextCapitalization.sentences,
                    hintText: 'Inserisci il nome',
                    labelText: 'Nome: ',
                    initialValue: controller.name,
                    enabled: _isModifyOptionEnable,
                    onChanged: (value) {
                      controller.setName(value);
                    },
                  ),
                  buildMyTextFormField(
                    appConfig,
                    textCapitalization: TextCapitalization.sentences,
                    hintText: 'Inserisci il cognome',
                    labelText: 'Cognome: ',
                    initialValue: controller.surname,
                    enabled: _isModifyOptionEnable,
                    onChanged: (value) {
                      controller.setSurname(value);
                    },
                  ),
                  buildMyTextFormField(
                    appConfig,
                    textCapitalization: TextCapitalization.sentences,
                    hintText: 'Inserisci il numero di telefono',
                    labelText: 'Cellulare: ',
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
                    },
                    title: 'Sesso: ',
                    leftValue: UserGender.male,
                    rightValue: UserGender.female,
                    isEnable: _isModifyOptionEnable,
                  ),
                  SizedBox(
                    height: appConfig.getHeight() * 0.5,
                  ),
                  MyDatePicker(
                    title: 'Data di nascita: ',
                    birthday: controller.birthDate,
                    isEnable: _isModifyOptionEnable,
                    onPressed: () async {
                      final DateTime? dateNascita = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1960),
                        lastDate: DateTime(2014),
                      );
                      if (dateNascita != null) {
                        setState(() {
                          controller.setBirthday(dateNascita);
                        });
                      }
                    },
                  ),
                  controller.country.isEmpty ? SizedBox() : SelectorForPersonalScreen(
                    isEnable: _isModifyOptionEnable,
                    constantDropDownCountryList,
                    controller.country,
                    onValueChange: (String value) =>
                        controller.setCountry(value),
                    title: 'Paese: ',
                  ),
                  controller.ispettoria.isEmpty ? SizedBox() : SelectorForPersonalScreen(
                    isEnable: _isModifyOptionEnable,
                    constantDropDownIspettoriaList,
                    controller.ispettoria,
                    onValueChange: (String value) =>
                        {controller.setIspettoria(value)},
                    title: 'Ispettoria: ',
                  ),
                  controller.group.isEmpty ? SizedBox() : SelectorForPersonalScreen(
                    isEnable: _isModifyOptionEnable,
                    constantDropDownGroupList,
                    controller.group,
                    onValueChange: (String value) =>
                        controller.setGroup(value),
                    title: 'Gruppo: ',
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
                    },
                    title: 'Boss? ',
                  ),
                  controller.bossCode.isNotEmpty || _selectedBoss.first == true
                      ? buildMyTextFormField(
                          obscureText: true,
                          appConfig,
                          onChanged: (value) {
                            controller.setBossCode(value);
                          },
                          textCapitalization: TextCapitalization.sentences,
                          hintText: '',
                          labelText: 'Codice del Boss: ',
                          initialValue: controller.bossCode,
                          enabled: _isModifyOptionEnable,
                        )
                      : const SizedBox(),
                      MyBigAsyncButton(
                        appConfig: appConfig, 
                        onPressedAsync: () async {},
                        buttonText: 'Cambia la password',
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
