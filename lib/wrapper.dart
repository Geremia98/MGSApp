import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/theme.dart';

import 'services/firebase/auth.dart';
import 'models/user_firestore.dart';
import 'models/user_model.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({
    super.key,
  });

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuthService authService = FirebaseAuthService();
  final UserFirestore userFirestore = UserFirestore();
  late Future<UserModel?> getUserModel;

  late Stream<User?>? streamUserStatus;

  @override
  void initState() {
    super.initState();
    streamUserStatus = authService.listenAuthStatus();
    getUserModel = userFirestore.loadUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => StreamBuilder(
              stream: streamUserStatus,
              builder: (BuildContext context, AsyncSnapshot<User?> snap) {
                if (snap.connectionState != ConnectionState.active) {
                  return const ThemeService(
                    routePage: ThemeRoutePage.loading,
                  );
                }

                if (!snap.hasData || snap.data == null) {
                  return const ThemeService(
                    routePage: ThemeRoutePage.auth,
                  );
                }

                UserModel.uid = snap.data!.uid;

                return FutureBuilder(
                    future: getUserModel,
                    builder:
                        (BuildContext context, AsyncSnapshot<UserModel?> snap) {

                      if (snap.connectionState == ConnectionState.none) {
                        return const ThemeService(
                          routePage: ThemeRoutePage.home,
                        );
                      }
                      if (snap.connectionState != ConnectionState.done) {
                        return const ThemeService(
                          routePage: ThemeRoutePage.loading,
                        );
                      }
                      if (!snap.hasData || snap.data == null) {
                        return const ThemeService(
                          routePage: ThemeRoutePage.home,
                        );
                      }
                      return const ThemeService(
                        routePage: ThemeRoutePage.home,
                      );
                    });
              }),
          settings: settings,
        );
      },
    );
  }
}
