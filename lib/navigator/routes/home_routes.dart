
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/other_screens/home_screen.dart';

class TabNavigatorRoutesHome {
  static const String root = '/';
}

class HomeRoutes {

  Map<String, WidgetBuilder> getRouteBuilders(
      BuildContext context,
      ) {
    return {
      TabNavigatorRoutesHome.root: (context) => HomeScreen(
      ),
    };
  }

}