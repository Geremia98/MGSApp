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
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/home_page_widgets/home_screen_drawer.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/firebase/auth.dart';
import '../../widgets/font.dart';
import '../../wrapper.dart';

class PersonalScreen extends StatefulWidget {
  final FirebaseAuthService? authService;
  final PackageInfo? packageInfo;

  const PersonalScreen({super.key, this.authService, this.packageInfo});

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

    if (widget.packageInfo != null) {
      _packageInfo = widget.packageInfo;
    } else {
      PackageInfo.fromPlatform().then((info) {
        setState(() {
          _packageInfo = info;
        });
      });
    }
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
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyProfilePicture(
                            appConfig: appConfig,
                            borderRadius: 20,
                            borderThickness: 0.3,
                            dimension: appConfig.isTablet() ? 200 : 100,
                          ),
                          SizedBox(
                            height: appConfig.isTablet() ? 30 : 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${UserModel.name} ${UserModel.surname}',
                                      style: textStyleTitle(context),
                                    ),
                                  ],
                                ),
                              ),
                              if (UserModel.bossCode.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(left: appConfig.isTablet() ? 10 : 5),
                                  child: Icon(
                                    Icons.verified_outlined,
                                    size: appConfig.isTablet() ? 26 : 17,
                                    color: appConfig
                                        .getTheme()
                                        .secondaryHeaderColor,
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            height: appConfig.isTablet() ? appConfig.getHeight() * 10 : appConfig.getHeight() * 5,
                          ),
                          
                        ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*80,
              width: appConfig.getWidth()*100,
              icon: Icons.person_3_rounded,
              title: 'Anagrafica account',
              onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserInfoPage()),
                              );

                              setState(() {});
                            },
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*80,
              width: appConfig.getWidth()*100,
              icon: Icons.home_rounded,
              title: 'Gruppo account',
              onTap: () async {
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
                          ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*80,
              width: appConfig.getWidth()*100,
              icon: Icons.verified_outlined,
              title: 'Diventa Boss',
              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserBossPage()),
                                );

                                setState(() {});
                              },
            ),
                            ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*80,
              width: appConfig.getWidth()*100,
              icon: Icons.email_rounded,
              title: 'Modifica email',
              onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangeEmailScreen()),
                              );
                            },
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*50,
              width: appConfig.getWidth()*100,
              icon: Icons.lock,
              title: 'Modifica password',
              onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordScreen()),
                              );
                            },
            ),
                          SizedBox(
                            height: appConfig.getHeight() * 3,
                          ),
                          ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*80,
              width: appConfig.getWidth()*100,
              icon: Icons.bug_report_rounded,
              title: 'Segnala un bug',
              onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ReportBugCategoryScreen()),
                              );
                            },
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*80,
              width: appConfig.getWidth()*100,
              icon: Icons.question_mark_rounded,
              title: 'FAQ',
              onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FAQScreen()),
                              );
                            },
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: appConfig.getHeight()*80,
              width: appConfig.getWidth()*100,
              icon: Icons.logout_rounded,
              title: 'Esci',
              onTap: () async {
                              final FirebaseAuthService authService =
                                  widget.authService ?? FirebaseAuthService();
                              await authService.signOut(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Wrapper(),
                                ),
                              );
                            },
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
      width: appConfig.isTablet() ? appConfig.getWidth() * 80 : appConfig.getWidth() * 100,
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
                          size: appConfig.isTablet() ? 32 : 22,
                        ),
                        SizedBox(
                          width: appConfig.isTablet() ? 30 : 15,
                        ),
                        Container(
                          width: appConfig.getWidth() * 50,
                          child: Text(
                            text,
                            maxLines: 1,
                            style: appConfig.isTablet()
                                ? textStyleTextField(context).copyWith(
                                    fontSize: responsiveFontSize(
                                      context,
                                      fontSizeBig,
                                    ),
                                  )
                                : textStyleTextField(context),
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
                        size: appConfig.isTablet() ? 28 : 18,
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
            fontSize: appConfig.isTablet() ? 20 : 13,
          ),
        ),
      ),
    );
  }
}
