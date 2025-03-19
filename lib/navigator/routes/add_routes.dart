import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/add_event/add_event_screen.dart';
import 'package:mgs_app2/screens/other_screens/creation_event_screen.dart';

class TabNavigatorRoutesAdd {
  static const String root = '/';
  static const String creation = '/creation';
}

class AddRoutes {
  Map<String, WidgetBuilder> getRouteBuilders(
    BuildContext context,
  ) {
    return {
      TabNavigatorRoutesAdd.root: (context) => AddEventScreen(
          ),
    };
  }
}
