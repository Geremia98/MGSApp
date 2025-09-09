import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/selector.dart';

import '../../utilities/constants_dimensions.dart';
import '../../utilities/constants_strings.dart';
import '../../widgets/buttons.dart';

class UserGroupPage extends StatefulWidget {
  const UserGroupPage({super.key});

  @override
  State<UserGroupPage> createState() => _UserGroupPageState();
}
class _UserGroupPageState extends State<UserGroupPage> {
  bool isInEditMode = false;

  late ValueNotifier<String> countryNotifier;
  late ValueNotifier<String> ispettoriaNotifier;
  late ValueNotifier<String> groupNotifier;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    countryNotifier = ValueNotifier(UserModel.country);
    ispettoriaNotifier = ValueNotifier(UserModel.ispettoria);
    groupNotifier = ValueNotifier(UserModel.group);
  }

  @override
  void dispose() {
    countryNotifier.dispose();
    ispettoriaNotifier.dispose();
    groupNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: appConfig.getWidth() * horizontalPadding,
          vertical: appConfig.getHeight() * verticalPadding,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: appConfig.getHeight() * paddingUnderTheMainUppperBar,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GoBackButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context),
                appConfig: appConfig,
                title: 'Gruppo account',
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: !appConfig.isTablet()
                      ? 0
                      : appConfig.getWidth() * 10,
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable: countryNotifier,
                      builder: (context, value, _) {
                        return SelectorStyle(
                          isEnable: isInEditMode,
                          constantDropDownCountryList,
                          value,
                          onValueChange: (String newValue) =>
                          countryNotifier.value = newValue,
                          title: 'Paese: ',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<String>(
                      valueListenable: ispettoriaNotifier,
                      builder: (context, value, _) {
                        return SelectorStyle(
                          isEnable: isInEditMode,
                          constantDropDownIspettoriaList,
                          value,
                          onValueChange: (String newValue) =>
                          ispettoriaNotifier.value = newValue,
                          title: 'Ispettoria: ',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<String>(
                      valueListenable: groupNotifier,
                      builder: (context, value, _) {
                        return SelectorStyle(
                          isEnable: isInEditMode,
                          constantDropDownGroupList,
                          value,
                          onValueChange: (String newValue) =>
                          groupNotifier.value = newValue,
                          title: 'Gruppo: ',
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              if (!isInEditMode)
                Center(
                  child: ButtonText(
                    text: 'Modifica',
                    onTap: () {
                      setState(() => isInEditMode = true);
                    },
                  ),
                ),
              if (isInEditMode)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: appConfig.isTablet()
                        ? appConfig.getWidth() * 10
                        : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonText(
                        text: 'Annulla',
                        isEnabled: !isLoading,
                        onTap: () {
                          setState(() {
                            isInEditMode = false;

                            // reset valori
                            countryNotifier.value = UserModel.country;
                            ispettoriaNotifier.value = UserModel.ispettoria;
                            groupNotifier.value = UserModel.group;
                          });
                        },
                        color: appConfig.getTheme().scaffoldBackgroundColor,
                        textColor: Colors.grey,
                        fixedWidth: 170,
                      ),
                      ButtonText(
                        text: 'Conferma',
                        isLoading: isLoading,
                        onTap: () async {
                          if (isLoading) return;

                          setState(() => isLoading = true);

                          final UserFirestore userFirestore = UserFirestore();

                          await userFirestore.updateUserGroup(
                            group: groupNotifier.value,
                            ispettoria: ispettoriaNotifier.value,
                            country: countryNotifier.value,
                          );

                          setState(() {
                            isInEditMode = false;
                            isLoading = false;

                            // aggiorna UserModel
                            UserModel.country = countryNotifier.value;
                            UserModel.ispettoria = ispettoriaNotifier.value;
                            UserModel.group = groupNotifier.value;
                          });
                        },
                        fixedWidth: 170,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

