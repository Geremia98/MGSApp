import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_screen.dart';
import 'package:mgs_app2/screens/other_screens/faq_screen.dart';
import 'package:mgs_app2/screens/other_screens/personal_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/utilities/theme_colors.dart';

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Drawer(
      width: width * 0.7,
      child: Container(
        color: appConfig.getTheme().scaffoldBackgroundColor,
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
              title: menuList[0],
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
              title: menuList[1],
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
              title: menuList[2],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEventScreen(),
                ),
              ),
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.bug_report_rounded,
              title: menuList[3],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              ),
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.question_mark,
              title: menuList[4],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              ),
            ),
            ItemForMenu(
              appConfig: appConfig,
              height: height,
              width: width,
              icon: Icons.dark_mode,
              title: menuList[5],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalScreen()),
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
              icon: Icons.logout_rounded,
              title: menuList[6],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalScreen()),
              ),
            ),
          ],
        ),
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