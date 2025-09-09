import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';
import 'package:mgs_app2/widgets/selector.dart';
import 'package:mgs_app2/widgets/text_field.dart';

import '../../utilities/constants_dimensions.dart';
import '../../widgets/buttons.dart';

class UserInfoPage extends StatefulWidget {
  final UserFirestore? userFirestore;

  const UserInfoPage({super.key, this.userFirestore});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool isInEditMode = false;

  late String name;
  late String surname;
  late DateTime? birth;
  late UserGender gender;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    name = UserModel.name;
    surname = UserModel.surname;
    birth = UserModel.birth;
    gender = UserModel.gender;
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
        child: Padding(
          padding: EdgeInsets.only(
              bottom: appConfig.getHeight() * paddingUnderTheMainUppperBar),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GoBackButton(
                icon: Icons.arrow_back_rounded,
                onTap: () {
                  Navigator.pop(context);
                },
                appConfig: appConfig,
                title: 'Anagrafica account',
              ),
              SizedBox(
                height: appConfig.getHeight() * 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: !appConfig.isTablet() ? 0 : appConfig.getWidth() * 10,
                ),
                child: Column(
                  children: [
                    buildTextField(appConfig,
                        labelText: 'Nome',
                        initialValue: name,
                        enabled: isInEditMode, onChanged: (value) {
                      name = value ?? '';
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    buildTextField(appConfig,
                        labelText: 'Cognome',
                        initialValue: surname,
                        enabled: isInEditMode, onChanged: (value) {
                      surname = value ?? '';
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    MyCustomSegmentedButton<UserGender>(
                      leftText: 'Maschio',
                      rightText: 'Femmina',
                      title: 'Sesso',
                      height: appConfig.isTablet() ?  55 : 48,
                      width: appConfig.isTablet() ? 350 : 200,
                      selected: gender,
                      onValueChange: (UserGender gender) {
                        this.gender = gender;
                      },
                      leftValue: UserGender.male,
                      rightValue: UserGender.female,
                      isEnabled: isInEditMode,
                    ),
                    SizedBox(height: 20),
                    MyDatePicker(
                      title: 'Data di nascita',
                      height: appConfig.isTablet() ?  55 : 48,
                      width: appConfig.isTablet() ? 350 : 200,
                      birthday: birth,
                      isEnable: isInEditMode,
                      onPressed: () async {
                        final DateTime? dateNascita = await showDatePicker(
                          context: context,
                          initialDate: birth ?? DateTime(2000),
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2014),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogTheme: DialogThemeData(
                                  backgroundColor: appConfig
                                      .getTheme()
                                      .scaffoldBackgroundColor,
                                  titleTextStyle: TextStyle(
                                    color: appConfig
                                        .getTheme()
                                        .secondaryHeaderColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentTextStyle: TextStyle(
                                    color: appConfig
                                        .getTheme()
                                        .secondaryHeaderColor,
                                    fontSize: 16,
                                  ),
                                ),
                                colorScheme: ColorScheme.light(
                                  primary: appConfig.getTheme().highlightColor,
                                  onPrimary:
                                      appConfig.getTheme().secondaryHeaderColor,
                                  onSurface:
                                      appConfig.getTheme().secondaryHeaderColor,
                                  surface: appConfig
                                      .getTheme()
                                      .scaffoldBackgroundColor,
                                ),
                                inputDecorationTheme: InputDecorationTheme(
                                  labelStyle: TextStyle(
                                      color: appConfig
                                          .getTheme()
                                          .secondaryHeaderColor),
                                  hintStyle: TextStyle(
                                      color: appConfig
                                          .getTheme()
                                          .secondaryHeaderColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: appConfig
                                            .getTheme()
                                            .secondaryHeaderColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: appConfig
                                            .getTheme()
                                            .secondaryHeaderColor),
                                  ),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: appConfig
                                        .getTheme()
                                        .secondaryHeaderColor,
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
                            if (!isAtLeast14YearsOld(dateNascita)) {
                              return;
                            }
                            birth = dateNascita;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              if (!isInEditMode)
                Center(
                  child: ButtonText(
                      text: 'Modifica',
                      onTap: () {
                        setState(() {
                          isInEditMode = true;
                        });
                      }),
                ),
              if (isInEditMode)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: appConfig.isTablet() ? appConfig.getWidth() * 10 : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonText(
                        text: 'Annulla',
                        isEnabled: !isLoading,
                        onTap: () {
                          setState(() {
                            isInEditMode = false;
                            name = UserModel.name;
                            surname = UserModel.surname;
                            birth = UserModel.birth;
                            gender = UserModel.gender;
                          });
                        },
                        color: appConfig.getTheme().scaffoldBackgroundColor,
                        textColor: Colors.grey,
                        fixedWidth: 170,
                      ),
                      ButtonText(
                        text: 'Conferma',
                        isLoading: isLoading,
                        onTap: () async {
                          if (isLoading) {
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          final UserFirestore userFirestore =
                              widget.userFirestore ?? UserFirestore();

                          await userFirestore.updateUserInfo(
                              name: name,
                              surname: surname,
                              birth: birth ?? DateTime(2000),
                              gender: gender);

                          setState(() {
                            isInEditMode = false;
                            isLoading = false;
                            UserModel.name = name;
                            UserModel.surname = surname;
                            UserModel.birth = birth;
                            UserModel.gender = gender;
                          });
                        },
                        fixedWidth: 170,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  bool isAtLeast14YearsOld(DateTime birthDate) {
    final today = DateTime.now();
    final age = today.year - birthDate.year;

    // Controlla se il compleanno è già passato quest’anno
    final hasHadBirthdayThisYear = (today.month > birthDate.month) ||
        (today.month == birthDate.month && today.day >= birthDate.day);

    final actualAge = hasHadBirthdayThisYear ? age : age - 1;

    return actualAge >= 14;
  }
}
