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

  late String country;
  late String ispettoria;
  late String group;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    country = UserModel.country;
    ispettoria = UserModel.ispettoria;
    group = UserModel.group;
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
              bottom: appConfig.getHeight() * paddingUnderTheMainUppperBar),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GoBackButton(
                icon: Icons.arrow_back_rounded,
                onTap: () {
                  Navigator.pop(context);
                },
                appConfig: appConfig,
                title: 'Gruppo account',
              ),
              SizedBox(
                height: appConfig.getHeight() * 5,
              ),
            const SizedBox(
              height: 30,
            ),
            SelectorStyle(
              isEnable: isInEditMode,
              constantDropDownCountryList,
              country,
              onValueChange: (String value) =>
                  country = value,
              title: 'Paese: ',
            ),
            SizedBox(height: 20),
            SelectorStyle(
              isEnable: isInEditMode,
              constantDropDownIspettoriaList,
              ispettoria,
              onValueChange: (String value) =>
              ispettoria = value,
              title: 'Ispettoria: ',
            ),
            SizedBox(height: 20),
            SelectorStyle(
              isEnable: isInEditMode,
              constantDropDownGroupList,
              group,
              onValueChange: (String value) =>
              group = value,
              title: 'Gruppo: ',
            ),

              SizedBox(height: 60),
              if (!isInEditMode)
                Center(
                  child: ButtonText(
                      text: 'Modifica',
                      onTap: () {
                        setState(() {
                          isInEditMode = true;
                        });
                      }),
                ),
              if (isInEditMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonText(
                      text: 'Annulla',
                      isEnabled: !isLoading,
                      onTap: () {
                        setState(() {
                          isInEditMode = false;
                          country = UserModel.country;
                          ispettoria = UserModel.ispettoria;
                          group = UserModel.group;
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

                        if (isLoading) {
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        final UserFirestore userFirestore = UserFirestore();

                        await userFirestore.updateUserGroup(group: group, ispettoria: ispettoria, country: country);

                        setState(() {
                          isInEditMode = false;
                          isLoading = false;
                          UserModel.country = country;
                          UserModel.ispettoria = ispettoria;
                          UserModel.group = group;
                        });
                      },
                      fixedWidth: 170,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
