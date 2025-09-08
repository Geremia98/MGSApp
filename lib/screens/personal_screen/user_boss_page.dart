import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';
import 'package:mgs_app2/widgets/selector.dart';
import 'package:mgs_app2/widgets/text_field.dart';

import '../../services/functions/firebase_function_caller.dart';
import '../../services/functions/function_response.dart';
import '../../services/functions/response_type.dart';
import '../../utilities/constants_dimensions.dart';
import '../../utilities/constants_strings.dart';
import '../../widgets/buttons.dart';
import '../../widgets/snackbar.dart';

class UserBossPage extends StatefulWidget {
  const UserBossPage({super.key});

  @override
  State<UserBossPage> createState() => _UserBossPageState();
}

class _UserBossPageState extends State<UserBossPage> {
  bool isEnabled = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    return Scaffold(
      key: scaffoldKey,
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
                title: 'Diventa Boss',
              ),
              SizedBox(
                height: appConfig.getHeight() * 5,
              ),
              Center(
                child: Text(
                  'Se hai ricevuto o richiesto un codice per diventare il boss inseriscilo qui sotto.',
                  textAlign: TextAlign.center,
                  style: textStyleTitle(context)
                ),
              ),
              SizedBox(
                height: appConfig.getHeight() * 5,
              ),
              CodeInputField(
                length: 6,
                hasTitle: false,
                onCompleted: (String p1) async {

                  print(p1);

                  setState(() {
                    isEnabled = false;
                  });

                  FirebaseFunctionCaller caller =
                  FirebaseFunctionCaller();

                  FunctionResponse response =
                  await caller.isBossCodeValid(p1);

                  print("qua");

                  if (response.getType() == ResponseType.error) {
                    final SnackBarStyle snackBar = SnackBarStyle(
                      context,
                      scaffoldKey,
                    );

                    snackBar.showSnackBar(response.getErrorMessage());
                    setState(() {
                      isEnabled = true;
                    });
                    return;
                  }

                  final UserFirestore userFirestore = UserFirestore();

                  await userFirestore.setBossCode(code: p1);

                  UserModel.bossCode = p1;
                  Navigator.pop(context);
                },
                isEnabled: isEnabled,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
