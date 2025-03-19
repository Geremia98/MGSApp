import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_config.dart';
import '../app_navigator.dart';

class NavigatorTabWidget extends StatelessWidget {
  final IconData iconData;
  final void Function(NavigatorTab tab) onTap;
  final NavigatorTab navigatorTab;
  final NavigatorTab currentTab;

  const NavigatorTabWidget({
    required this.iconData,
    required this.onTap,
    required this.navigatorTab,
    required this.currentTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    //TODO if currentTab == navigatorTab can change color or dimension

    return GestureDetector(
      onTap: () => onTap(navigatorTab),
      child: Container(
      width: getNavigatorTabWidth(appConfig),
      height: 50,
        child: Icon(
          iconData,
          size: 24,
          color: appConfig.getTheme().secondaryHeaderColor,
        ),
      ),
    );
  }

  double getNavigatorTabWidth(AppConfig appConfig) =>
      (appConfig.getWidth() * 100 - 20) / NavigatorTab.values.length;
}
