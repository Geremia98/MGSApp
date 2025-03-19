
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mgs_app2/navigator/widgets/bottom_navigator.dart';
import 'package:mgs_app2/navigator/widgets/navigator_tab.dart';

import '../utilities/app_config.dart';
import 'app_routes.dart';

enum NavigatorTab { home, event, add, profile }

const IconData navigatorHomeIcon = LineIcons.home;
const IconData navigatorAddIcon = LineIcons.plusSquare;
const IconData navigatorProfileIcon = LineIcons.user;
const IconData navigatorEventIcon = LineIcons.box;

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  late NavigatorTab _currentTab;
  late List<NavigatorTabWidget> _tabs;
  late Map<NavigatorTab, GlobalKey<NavigatorState>> _navigatorKeys;



  @override
  void initState() {
    super.initState();
    _currentTab = NavigatorTab.home;

    _tabs = [
      NavigatorTabWidget(
        iconData: navigatorHomeIcon,
        onTap: onTabChange,
        navigatorTab: NavigatorTab.home,
        currentTab: _currentTab,
      ),
      NavigatorTabWidget(
        iconData: navigatorEventIcon,
        onTap: onTabChange,
        navigatorTab: NavigatorTab.event,
        currentTab: _currentTab,
      ),
      NavigatorTabWidget(
        iconData: navigatorAddIcon,
        onTap: onTabChange,
        navigatorTab: NavigatorTab.add,
        currentTab: _currentTab,
      ),
      NavigatorTabWidget(
        iconData: navigatorProfileIcon,
        onTap: onTabChange,
        navigatorTab: NavigatorTab.profile,
        currentTab: _currentTab,
      ),
    ];

    _navigatorKeys = {
      NavigatorTab.home : GlobalKey<NavigatorState>(),
      NavigatorTab.add : GlobalKey<NavigatorState>(),
      NavigatorTab.event : GlobalKey<NavigatorState>(),
      NavigatorTab.profile : GlobalKey<NavigatorState>(),
    };
  }

  @override
  Widget build(BuildContext context) {

    final AppConfig appConfig = AppConfig(context);
    return Scaffold(
      backgroundColor: appConfig.getTheme().scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildOffstageNavigator(NavigatorTab.home),
          _buildOffstageNavigator(NavigatorTab.event),
          _buildOffstageNavigator(NavigatorTab.add),
          _buildOffstageNavigator(NavigatorTab.profile),
        ],
      ),
      bottomNavigationBar: BottomNavigator(
        tabs: _tabs,
        currentTab: _currentTab,
      ),
    );
  }

  Widget _buildOffstageNavigator(NavigatorTab tab) {

    if (_navigatorKeys[tab] == null) {
      return Container();
    }

    return Offstage(
      offstage: _currentTab != tab,
      child: AppRoutes(
        navigatorKey: _navigatorKeys[tab]!,
        page: tab,
      ),
    );
  }

  void onTabChange(NavigatorTab tab) {

    if (needsPopToFirstRoute(tab)) {
      _navigatorKeys[tab]!.currentState!.popUntil((route) => route.isFirst);
      return;
    }

    setState(() {
      _currentTab = tab;
    });
  }

  bool needsPopToFirstRoute(NavigatorTab tab) => _currentTab == tab;


}
