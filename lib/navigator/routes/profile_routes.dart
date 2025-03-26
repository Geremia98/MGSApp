import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/screens/other_screens/home_screen.dart';
class TabNavigatorRoutesProfile {
  static const String root = '/';
}

class ProfileRoutes {
  Map<String, WidgetBuilder> getRouteBuilders(
    BuildContext context,
  ) {
    return {
      TabNavigatorRoutesProfile.root: (context) => HomeScreen()
    };
  }
}
