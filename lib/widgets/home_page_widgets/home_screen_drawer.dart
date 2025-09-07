import 'package:flutter/material.dart';
import 'package:mgs_app2/main.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/add_event/add_event_screen.dart';
import 'package:mgs_app2/screens/main_screens/all_events_screen.dart';
import 'package:mgs_app2/screens/main_screens/faq_screen.dart';
import 'package:mgs_app2/screens/report_bug/report_bug_category_screen.dart';
import 'package:mgs_app2/screens/main_screens/personal_screen.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/font.dart';
import 'package:mgs_app2/wrapper.dart';

import '../../models/event_firestore.dart';
import '../../screens/manage_events/manage_events_screen.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
    required this.height,
    required this.width,
    required this.onEventCreation,
    required this.onEventsChange,
    required this.appConfig,
  });

  final void Function(EventModel?) onEventCreation;
  final VoidCallback onEventsChange;
  final double height;
  final double width;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: appConfig.getTheme().scaffoldBackgroundColor,
      width: appConfig.isTablet() ? 500 : width * 0.7,
      child: Container(
        padding: EdgeInsets.only(
            top: height * 0.1, left: width * 0.08, right: width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.arrow_back_rounded,
              title: 'Menù',
              isTitle: true,
              onTap: () => Navigator.pop(
                context,
              ),
            ),
            Divider(
              height: height * 0.06,
              thickness: 1,
              color: appConfig.getTheme().highlightColor,
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.person_3_rounded,
              title: 'Profilo',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalScreen()),
              ),
            ),
            if (UserModel.bossCode.isNotEmpty)
              ItemForMenu(
                  appConfig: appConfig,
                  height: height,
                  width: width,
                  icon: Icons.add,
                  title: 'Crea evento',
                  onTap: () async {
                    Object? value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEventScreen(),
                      ),
                    );

                    if (value is EventModel) {
                      onEventCreation(value);
                    }
                  }),
            if (UserModel.bossCode.isNotEmpty)
              ItemForMenu(
                  appConfig: appConfig,
                  height: height,
                  width: width,
                  icon: Icons.dashboard,
                  title: 'Gestisci eventi',
                  onTap: () async {
                    Object? value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllEventsScreen(
                          futureEvents: EventFirestore()
                              .retrievePersonalEvents(justCreatedByMe: true),
                          titolo: 'Gestisci eventi',
                          isManage: true,
                        ),
                      ),
                    );

                    if (value is bool && value == true) {
                      onEventsChange();
                    }
                  }),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.bug_report_rounded,
              title: 'Segnala un bug',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReportBugCategoryScreen()),
              ),
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.question_mark,
              title: 'FAQ',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              ),
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: BrightnessManager().brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.sunny,
              title: BrightnessManager().brightness == Brightness.light
    ? 'Tema scuro'
        : 'Tema chiaro',
              onTap: () => {
                BrightnessManager().toggleBrightness()
                //provider.toggleTheme()
              },
            ),
            Divider(
              height: height * 0.06,
              thickness: 1,
              color: appConfig.getTheme().highlightColor,
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.logout_rounded,
              title: 'Esci',
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
    );
  }

  void logout(context) async {
    final FirebaseAuthService authService = FirebaseAuthService();
    await authService.signOut(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Wrapper(),
      ),
    );
  }
}

class ItemForMenu extends StatelessWidget {
  const ItemForMenu({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.appConfig,
    this.isTitle = false,
  });

  final double height;
  final double width;
  final IconData icon;
  final String title;
  final void Function() onTap;
  final bool isTitle;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: width * 0.05, left: width * 0.01),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(width * 0.012),
                decoration: BoxDecoration(
                  // Colore di sfondo
                  borderRadius:
                      BorderRadius.circular(10), // Bordi arrotondati
                  border: getCustomBorder(
                    appConfig: appConfig,
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  size: appConfig.isTablet() ? 34 : 24,
                  icon, // Dimensione dell'icona
                ),
              ),
            ),
          ),
          Text(
            title,
            style: isTitle
                ? textStyleTitle(context)
                : appConfig.isTablet()
                    ? textStyleSubtitle(context).copyWith(
                        fontSize: responsiveFontSize(
                          context,
                          fontSizeBig,
                        ),
                      )
                    : textStyleSubtitle(context),
          ),
        ],
      ),
    );
  }
}
