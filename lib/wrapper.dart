import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:mgs_app2/theme.dart';

import 'services/firebase/auth.dart';
import 'models/user_firestore.dart';
import 'models/user_model.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({
    super.key,
    this.userStreamOverride,
    this.userFutureOverride,
    this.translatorOverride,
  });

  final Stream<fb.User?>? userStreamOverride;
  final Future<UserModel?>? userFutureOverride;
  final TranslatorLike? translatorOverride; 

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  FirebaseAuthService? _authService;
  UserFirestore? _userFirestore;

  late Future<UserModel?> getUserModel;
  late Stream<fb.User?>? streamUserStatus;

  @override
  void initState() {
    super.initState();

    if (widget.userStreamOverride != null) {
      streamUserStatus = widget.userStreamOverride;
    } else {
      _authService = FirebaseAuthService();
      streamUserStatus = _authService!.listenAuthStatus();
    }

    if (widget.userFutureOverride != null) {
      getUserModel = widget.userFutureOverride!;
    } else {
      _userFirestore = UserFirestore();
      getUserModel = _userFirestore!.loadUserModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => StreamBuilder<fb.User?>(
            stream: streamUserStatus,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return ThemeService(
                  routePage: ThemeRoutePage.loading,
                  translator: widget.translatorOverride,
                );
              }
              if (!snap.hasData || snap.data == null) {
                return ThemeService(
                  routePage: ThemeRoutePage.auth,
                  translator: widget.translatorOverride,
                );
              }

              UserModel.uid = snap.data!.uid;

              return FutureBuilder<UserModel?>(
                future: getUserModel,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return ThemeService(
                      routePage: ThemeRoutePage.loading,
                      translator: widget.translatorOverride,
                    );
                  }
                  return ThemeService(
                    routePage: ThemeRoutePage.home,
                    translator: widget.translatorOverride,
                  );
                },
              );
            },
          ),
          settings: settings,
        );
      },
    );
  }
}
