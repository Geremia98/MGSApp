import 'package:flutter/material.dart';
import 'package:mgs_app2/navigator/routes/add_routes.dart';
import 'package:mgs_app2/navigator/routes/event_routes.dart';
import 'package:mgs_app2/navigator/routes/home_routes.dart';
import 'package:mgs_app2/navigator/routes/profile_routes.dart';

import 'app_navigator.dart';

class AppRoutes extends StatefulWidget {
  final NavigatorTab page;
  final GlobalKey<NavigatorState> navigatorKey;


  const AppRoutes({
    required this.page,
    required this.navigatorKey,
    super.key,
  });

  @override
  State<AppRoutes> createState() => _AppRoutesState();

}

class _AppRoutesState extends State<AppRoutes> {

  late HeroController _heroController;
  late NavigatorTab page;
  late GlobalKey<NavigatorState> navigatorKey;

  @override
  void initState() {
    super.initState();

    page = widget.page;
    navigatorKey = widget.navigatorKey;
    _heroController = HeroController(createRectTween: _createRectTween);

  }

  @override
  Widget build(BuildContext context) {
    switch (page) {
      case NavigatorTab.home:
        return _buildNavigator(
          HomeRoutes().getRouteBuilders(context),
          TabNavigatorRoutesHome.root,
        );
      case NavigatorTab.profile:
        return _buildNavigator(
          ProfileRoutes().getRouteBuilders(context),
          TabNavigatorRoutesProfile.root,
        );
      case NavigatorTab.event:
        return _buildNavigator(
          EventRoutes().getRouteBuilders(context),
          TabNavigatorRoutesEvent.root,
        );
      case NavigatorTab.add:
        return _buildNavigator(
          AddRoutes().getRouteBuilders(context),
          TabNavigatorRoutesAdd.root,
        );
    }
  }

  Widget _buildNavigator(
      Map<String, WidgetBuilder> routeBuilders, String initialRute) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRute,
      observers: [_heroController],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }

  RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }
}
