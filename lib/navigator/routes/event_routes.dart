import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/other_screens/event_screen.dart';


class TabNavigatorRoutesEvent {
  static const String root = '/';
  static const String user = '/user';

}

class EventRoutes {

  Map<String, WidgetBuilder> getRouteBuilders(
      BuildContext context,
      ) {
    return {
      TabNavigatorRoutesEvent.root: (context) => EventScreen(
      ),
    };

  }

}