import 'package:flutter/material.dart';
import 'package:mgs_app2/main.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/add_event/add_event_screen.dart';
import 'package:mgs_app2/screens/main_screens/faq_screen.dart';
import 'package:mgs_app2/screens/report_bug/report_bug_category_screen.dart';
import 'package:mgs_app2/screens/main_screens/personal_screen.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/wrapper.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
    required this.height,
    required this.width,
    required this.onEventCreation,
    required this.appConfig,
  });

  final void Function(EventModel?) onEventCreation;
  final double height;
  final double width;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: appConfig.getTheme().scaffoldBackgroundColor,
      width: width * 0.7,
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
              thickness: width * 0.001,
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.person_3_rounded,
              title: 'Info personali',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalScreen()),
              ),
            ),
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
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.bug_report_rounded,
              title: 'Report a bug',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportBugCategoryScreen()),
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
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      right: width * 0.05,
                      left: width * 0.01,
                      top: height * 0.01,
                      bottom: height * 0.01),
                  child: GestureDetector(
                    onTap: () => {
                      BrightnessManager().toggleBrightness()
                      //provider.toggleTheme()
                    },
                    child: Container(
                      padding: EdgeInsets.all(width * 0.012),
                      decoration: BoxDecoration(
                        // Colore di sfondo
                        borderRadius: BorderRadius.circular(
                            width * 0.02), // Bordi arrotondati
                        border: getCustomBorder(
                          appConfig: appConfig,
                          width: width * 0.0005,
                        ),
                      ),
                      child: Icon(
                        size: width * 0.06,
                        BrightnessManager().brightness == Brightness.light
                            ? Icons.dark_mode
                            : Icons.sunny, // Dimensione dell'icona
                      ),
                    ),
                  ),
                ),
                Text(
                  BrightnessManager().brightness == Brightness.light
                      ? 'Tema scuro'
                      : 'Tema chiaro', //provider.isLight ? 'Night Mode' : 'Day Mode',
                  style: TextStyle(
                    fontSize: width * 0.04,
                  ),
                ),
              ],
            ),
            Divider(
              height: height * 0.06,
              thickness: width * 0.001,
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.logout_rounded,
              title: 'Log out',
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
                      BorderRadius.circular(width * 0.02), // Bordi arrotondati
                  border: getCustomBorder(
                    appConfig: appConfig,
                    width: width * 0.0005,
                  ),
                ),
                child: Icon(
                  size: width * 0.06,
                  icon, // Dimensione dell'icona
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isTitle ? width * 0.05 : width * 0.04,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}