import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/button.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.appConfig,
    this.title,
  });

  final IconData icon;
  final void Function() onTap;
  final AppConfig appConfig;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final width = AppConfig(context).getWidth() * (title == null ? 15 : 100);

    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: appConfig.getHeight() * 3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // pulsante a sinistra
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(appConfig.getWidth() * 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: getCustomBorder(
                    appConfig: appConfig,
                    width: 0.3,
                  ),
                ),
                child: Icon(
                  size: appConfig.isTablet() ? 50 : 30,
                  icon,
                ),
              ),
            ),
          ),

          // testo centrato
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: title != null
                ? Text(
                    title!,
                    key: ValueKey(title),
                    style: TextStyle(
                      color: appConfig.getTheme().secondaryHeaderColor,
                      fontSize: appConfig.isTablet() ? 30 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}
