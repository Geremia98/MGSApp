import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_config.dart';
import '../app_navigator.dart';
import 'navigator_tab.dart';

class BottomNavigator extends StatelessWidget {
  final  List<NavigatorTabWidget> tabs;
  final NavigatorTab currentTab;

  const BottomNavigator({
    required this.tabs,
    required this.currentTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Container(
      decoration: BoxDecoration(
        color: appConfig.getTheme().scaffoldBackgroundColor,
        //boxShadow: boxShadowNavigator,
        border: const Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.1,
          ),
        ),
      ),
      height: 80,
      width: appConfig.getWidth() * 90,
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: tabs,
      ),
    );
  }

}
