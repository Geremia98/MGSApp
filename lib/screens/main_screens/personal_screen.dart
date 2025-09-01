import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/login_screens/change_email_screen.dart';
import 'package:mgs_app2/screens/login_screens/change_password_screen.dart';
import 'package:mgs_app2/screens/main_screens/faq_screen.dart';
import 'package:mgs_app2/screens/personal_screen/user_boss_page.dart';
import 'package:mgs_app2/screens/personal_screen/user_group_page.dart';
import 'package:mgs_app2/screens/personal_screen/user_info_page.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/screens/report_bug/report_bug_category_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_big_async_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/selector_for_personal_screen.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/firebase/auth.dart';
import '../../widgets/font.dart';
import '../../wrapper.dart';

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
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();

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
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _packageInfo = info;
      });
    });
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
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppConfig(context).getHeight() * 100,
          width: AppConfig(context).getWidth() * 100,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: appConfig.getWidth() * horizontalPadding,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          appConfig.getHeight() * paddingUnderTheMainUppperBar),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GoBackButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        appConfig: appConfig,
                        title: 'Profilo',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyProfilePicture(
                            appConfig: appConfig,
                            borderRadius: 100,
                            borderThickness: 0,
                            dimension: 100,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Ciao,  ',
                                      style: textStyleEventCardTitle(context)
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text:
                                          '${UserModel.name} ${UserModel.surname}',
                                      style: textStyleEventCardTitle(context),
                                    ),
                                  ],
                                ),
                              ),
                              if (UserModel.bossCode.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.verified_outlined,
                                    size: 17,
                                    color: appConfig
                                        .getTheme()
                                        .secondaryHeaderColor,
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            height: appConfig.getHeight() * 5,
                          ),
                          _buildRowFor(
                            Icons.person_2_outlined,
                            'Anagrafica account',
                            appConfig.getTheme().secondaryHeaderColor,
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserInfoPage()),
                              );

                              setState(() {});
                            },
                          ),
                          _buildRowFor(
                            Icons.home_outlined,
                            'Gruppo account',
                            appConfig.getTheme().secondaryHeaderColor,
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserGroupPage()),
                              );

                              setState(() {});
                            },
                          ),
                          if (UserModel.bossCode.isEmpty)
                            _buildRowFor(
                              Icons.verified_outlined,
                              'Diventa Boss',
                              appConfig.getTheme().secondaryHeaderColor,
                              () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserBossPage()),
                                );

                                setState(() {});
                              },
                            ),
                          _buildRowFor(
                            Icons.email_outlined,
                            'Modifica email',
                            appConfig.getTheme().secondaryHeaderColor,
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangeEmailScreen()),
                              );
                            },
                          ),
                          _buildRowFor(
                            Icons.lock_outline_rounded,
                            'Modifica password',
                            appConfig.getTheme().secondaryHeaderColor,
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordScreen()),
                              );
                            },
                          ),
                          SizedBox(
                            height: appConfig.getHeight() * 5,
                          ),
                          _buildRowFor(
                            Icons.bug_report_outlined,
                            'Segnala bug',
                            appConfig.getTheme().secondaryHeaderColor,
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ReportBugCategoryScreen()),
                              );
                            },
                          ),
                          _buildRowFor(
                            Icons.question_mark_outlined,
                            'FAQ',
                            appConfig.getTheme().secondaryHeaderColor,
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FAQScreen()),
                              );
                            },
                          ),
                          _buildRowFor(
                            Icons.logout,
                            'Esci',
                            appConfig.getTheme().secondaryHeaderColor,
                            () async {
                              final FirebaseAuthService authService =
                                  FirebaseAuthService();
                              await authService.signOut(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Wrapper(),
                                ),
                              );
                            },
                            // logoutPanel,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: _buildBottomAppVersion(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowFor(
      IconData iconData, String text, Color color, void Function()? onTap) {
    final AppConfig appConfig = AppConfig(context);

    return Container(
      color: Colors.transparent,
      width: appConfig.getWidth() * 100,
      child: Material(
        color: appConfig.getTheme().scaffoldBackgroundColor,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.grey.withOpacity(0.1),
          focusColor: Colors.grey.withOpacity(0.1),
          highlightColor: Colors.grey.withOpacity(0.1),
          hoverColor: Colors.grey.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: appConfig.getHeight(), top: appConfig.getHeight()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          iconData,
                          color: appConfig.getTheme().secondaryHeaderColor,
                          size: 22,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: appConfig.getWidth() * 50,
                          child: Text(
                            text,
                            maxLines: 1,
                            style: textStyleTextField(context),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.navigate_next,
                        color: text == 'Esci'
                            ? appConfig.getTheme().scaffoldBackgroundColor
                            : appConfig.getTheme().secondaryHeaderColor,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAppVersion() {
    final AppConfig appConfig = AppConfig(context);

    return SizedBox(
      height: appConfig.getHeight() * 15,
      width: appConfig.getWidth() * 100,
      child: Padding(
        padding: EdgeInsets.only(top: appConfig.getHeight() * 10),
        child: Text(
          "v${_packageInfo?.version} (${_packageInfo?.buildNumber})",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
